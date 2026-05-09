#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
PROFILE="${1:-test}"
MODEL_PATH="${MODEL_PATH:-$WORKSPACE_DIR/models/ltx23/model.safetensors}"
TEXT_ENCODER_PATH="${TEXT_ENCODER_PATH:-$WORKSPACE_DIR/models/gemma}"
DATASET_FILE="${DATASET_FILE:-$WORKSPACE_DIR/data/insidejob_train.jsonl}"
if [ -z "${PRECOMPUTED_ROOT+x}" ]; then
  if [ "$PROFILE" = "5090" ]; then
    PRECOMPUTED_ROOT="$WORKSPACE_DIR/data/.precomputed_5090"
  else
    PRECOMPUTED_ROOT="$WORKSPACE_DIR/data/.precomputed"
  fi
fi
LTX_TRAINER_DIR="${LTX_TRAINER_DIR:-$WORKSPACE_DIR/LTX-2/packages/ltx-trainer}"

fail=0

check_file() {
  if [ -f "$1" ]; then
    echo "OK file: $1"
  else
    echo "MISSING file: $1"
    fail=1
  fi
}

check_dir() {
  if [ -d "$1" ]; then
    echo "OK dir:  $1"
  else
    echo "MISSING dir:  $1"
    fail=1
  fi
}

check_dir "$WORKSPACE_DIR"
check_dir "$LTX_TRAINER_DIR"
check_file "$DATASET_FILE"
check_file "$MODEL_PATH"
check_dir "$TEXT_ENCODER_PATH"

if command -v git-lfs >/dev/null 2>&1; then
  echo "OK tool: git-lfs"
else
  echo "MISSING tool: git-lfs"
  fail=1
fi

CONFIG_PATH="$("$WORKSPACE_DIR/scripts/render_config.sh" "$PROFILE")"
check_file "$CONFIG_PATH"

if [ -d "$PRECOMPUTED_ROOT/latents" ] && [ -d "$PRECOMPUTED_ROOT/conditions" ]; then
  echo "OK precomputed data: $PRECOMPUTED_ROOT"
else
  echo "MISSING precomputed data: $PRECOMPUTED_ROOT"
  if [ "$PROFILE" = "5090" ]; then
    echo "Run: $WORKSPACE_DIR/scripts/preprocess_5090.sh"
  else
    echo "Run: $WORKSPACE_DIR/scripts/preprocess.sh"
  fi
  fail=1
fi

exit "$fail"
