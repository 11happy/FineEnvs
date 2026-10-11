#!/bin/bash
# Installs what CI needs so tests and lint run in Claude Code sessions, cloud or local.
# Mirrors .github/workflows/*.yml. Idempotent: uv skips what is already installed,
# and downloads Python 3.11/3.12 if the machine lacks them.
set -euo pipefail

cd "$CLAUDE_PROJECT_DIR"

if ! command -v uv >/dev/null 2>&1; then
  echo "session-start: uv not found, skipping setup (install: https://docs.astral.sh/uv/)" >&2
  exit 0
fi

# Cloud only: the hf CLI (a Mac already has it from brew). It authenticates from the
# HF_TOKEN set in the cloud environment's variables; gh needs nothing, the session's
# GitHub proxy already authenticates `gh api` REST calls.
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
  uv tool install --quiet huggingface_hub
fi

# Root-level checks (index.yml, smoldataenvs.yml, multi-harness-rl.yml) plus ruff for lint,
# in a repo-root venv that goes first on PATH for the session.
uv venv --quiet --allow-existing --python 3.12 .venv
uv pip install --quiet --python .venv pyyaml pytest==9.1.1 httpx ruff==0.17.0
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$CLAUDE_PROJECT_DIR/.venv/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

# 01 LaTeX OCR (latex-ocr.yml): env project, then warm the cache for the dashboard tests,
# which CI runs in an ephemeral env.
uv sync --quiet --frozen --python 3.11 --extra dev --project 01-latex-ocr/envs/latex_ocr
uv run --quiet --no-project --python 3.11 \
  --with-requirements 01-latex-ocr/dashboard/requirements.txt --with pytest \
  python -c "import trackio"

# 00 Wordle (wordle.yml): six framework flavors, each with its own venv.
for flavor in gem skyrl_gym openenv nemo_gym ors verifiers; do
  uv sync --quiet --frozen --python 3.12 --extra dev \
    --project "00-environments-101/envs/wordle/$flavor"
done
