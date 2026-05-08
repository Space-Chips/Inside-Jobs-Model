#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
LTX_TRAINER_DIR="${LTX_TRAINER_DIR:-$WORKSPACE_DIR/LTX-2/packages/ltx-trainer}"
CONFIG_PATH="$("$WORKSPACE_DIR/scripts/render_config.sh" test)"

cd "$LTX_TRAINER_DIR"
uv run python scripts/train.py "$CONFIG_PATH"
