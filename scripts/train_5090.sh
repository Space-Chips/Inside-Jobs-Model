#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
LTX_TRAINER_DIR="${LTX_TRAINER_DIR:-$WORKSPACE_DIR/LTX-2/packages/ltx-trainer}"
export PRECOMPUTED_ROOT="${PRECOMPUTED_ROOT:-$WORKSPACE_DIR/data/.precomputed_5090}"
CONFIG_PATH="$("$WORKSPACE_DIR/scripts/render_config.sh" 5090)"

cd "$LTX_TRAINER_DIR"
uv run python scripts/train.py "$CONFIG_PATH"
