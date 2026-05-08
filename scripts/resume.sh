#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
LTX_TRAINER_DIR="${LTX_TRAINER_DIR:-$WORKSPACE_DIR/LTX-2/packages/ltx-trainer}"
PROFILE="${1:-test}"
CONFIG_PATH="$("$WORKSPACE_DIR/scripts/render_config.sh" "$PROFILE")"
RUN_DIR="${OUTPUT_DIR:-$WORKSPACE_DIR/runs/insidejob_${PROFILE}}"

export MODEL_PATH="${MODEL_PATH:-$WORKSPACE_DIR/models/ltx23/model.safetensors}"
export TEXT_ENCODER_PATH="${TEXT_ENCODER_PATH:-$WORKSPACE_DIR/models/gemma}"
export PRECOMPUTED_ROOT="${PRECOMPUTED_ROOT:-$WORKSPACE_DIR/data/.precomputed}"
export OUTPUT_DIR="$RUN_DIR"

if [ -d "$RUN_DIR/checkpoints" ]; then
  export MODEL_LOAD_CHECKPOINT="$RUN_DIR/checkpoints"
fi

cd "$LTX_TRAINER_DIR"
uv run python scripts/train.py "$CONFIG_PATH"
