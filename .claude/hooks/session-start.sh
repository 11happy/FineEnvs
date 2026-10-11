#!/bin/bash
# Installs what CI needs so tests and lint run in Claude Code cloud sessions.
# Mirrors .github/workflows/*.yml. Idempotent: uv and pip skip what is already there.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# Root-level checks: index.yml, smoldataenvs.yml, multi-harness-rl.yml, plus ruff for lint.
python3 -m pip install --quiet --break-system-packages \
  pyyaml pytest==9.1.1 httpx ruff

# 01 LaTeX OCR (latex-ocr.yml): env project + dashboard requirements.
uv sync --quiet --frozen --python 3.11 --extra dev --project 01-latex-ocr/envs/latex_ocr
# Dashboard deps run in an ephemeral env (as in CI); this just warms the uv cache.
uv run --quiet --with-requirements 01-latex-ocr/dashboard/requirements.txt --with pytest \
  python -c "import trackio"

# 00 Wordle (wordle.yml): six framework flavors, each with its own venv.
for flavor in gem skyrl_gym openenv nemo_gym ors verifiers; do
  uv sync --quiet --frozen --python 3.12 --extra dev \
    --project "00-environments-101/envs/wordle/$flavor"
done
