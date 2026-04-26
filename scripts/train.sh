#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/workspace/LTX-2"
source .venv/bin/activate

uv run python scripts/train.py "$HOME/workspace/configs/ltx23_lora_insidejob.yaml"
