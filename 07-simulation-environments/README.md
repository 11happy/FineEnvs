# Simulation environments

Real work turned into RL environments. Each one takes a job, rebuilds it from the records it leaves behind, and
grades the agent deterministically against an answer that can be proven best.

This folder is a catalog. Some environments live here and others stay in their authors' repos. Every entry credits
its authors and comes with an eval card in the same format, so the
[Simulation RL Environments](https://huggingface.co/spaces/FineEnvs/simulation-rl-environments) article can show
each environment's eval the same way. To talk ideas, use [discussion #36](https://github.com/adithya-s-k/FineEnvs/discussions/36).

## The catalog

| Environment | The job | By | Framework | Eval |
|---|---|---|---|---|
| [PortSimEnv v1](portsim-v1/) | Re-plan a broken week of container-ship dockings at a Port of Barcelona quay. One plan, graded once against the CP-SAT optimum. | [Adithya S Kolavi](https://github.com/adithya-s-k) (Hugging Face); AgentEnv port by [Edgar Arakelyan](https://github.com/earakely-scale) (Scale AI) | OpenEnv, AgentEnv | 50 weeks, 6 models: [board](portsim-v1/results/rollouts/dock-eval50/board.md), [3D replays](https://huggingface.co/spaces/FineEnvs/PortSimEnv-Eval) |
| [PortSimEnv v2–v5](portsim-live/) | The same quay, played watch by watch: live news (v2), pilots and tugs (v3), real wind and forecasts (v4), shipping lines that answer back (v5). | [Edgar Arakelyan](https://github.com/earakely-scale) (Scale AI) | AgentEnv | 4 × 15 weeks, 12 models: [eval cards](portsim-live/results/), [board](portsim-live/results/board.md), [3D replays](https://huggingface.co/spaces/earakely-scale/PortSimEnv-AgentEnv) |

**Elsewhere.** These are in their authors' repos for now:

| Environment | The job | By | Framework | Eval |
|---|---|---|---|---|
| [RailSimEnv](https://github.com/bp-high/RLSimEnvs) | Dispatch trains on the single-track Groningen–Leeuwarden line through real 2025 disruptions, graded against a CP-SAT optimum. | [Bhavish Pahwa](https://github.com/bp-high) | OpenEnv | 45 hard tasks, 4 models: [Space](https://huggingface.co/spaces/bpHigh/RailSimEnv) |

## Add your environment

There are two ways in:

- **Code here.** Open a PR that adds a folder like [portsim-live](portsim-live/): `envs/<env>/core/` for the logic,
  plus one folder per framework. [CONTRIBUTING](../CONTRIBUTING.md) has the layout.
- **Link only.** Your code, data and Hub repos stay where they are. The folder just points to them.

Either way, the folder holds three things:

1. **`project.yaml`.** Title, tagline, `authors` (name, GitHub handle, affiliation), your Hub repos and frameworks.
   Copy [portsim-live/project.yaml](portsim-live/project.yaml). Then run `python3 tools/build_index.py` so the root
   README lists the environment with your name on it.
2. **`README.md`.** The job, the data and its licences, how it's graded, and links to your code, Space and data.
3. **`results/eval*.json`.** One eval card per environment or version. It covers which tasks were played and how they
   were picked, the harness, what a score of 1.0 means, anything the grade excuses, the baselines, and every model's
   mean reward with its 95% interval. [portsim-live/results/eval-v4.json](portsim-live/results/eval-v4.json) is a
   worked example.

Your data and Hub artifacts stay in your namespace, and the
[Simulation RL Envs collection](https://huggingface.co/collections/FineEnvs/simulation-rl-envs-6ac4eca150bd4b91790e2540)
links to them.
