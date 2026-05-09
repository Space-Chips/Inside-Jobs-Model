#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
LTX_TRAINER_DIR="${LTX_TRAINER_DIR:-$WORKSPACE_DIR/LTX-2/packages/ltx-trainer}"
DATASET_FILE="${DATASET_FILE:-$WORKSPACE_DIR/data/insidejob_train.jsonl}"
MODEL_PATH="${MODEL_PATH:-$WORKSPACE_DIR/models/ltx23/model.safetensors}"
TEXT_ENCODER_PATH="${TEXT_ENCODER_PATH:-$WORKSPACE_DIR/models/gemma}"
PRECOMPUTED_ROOT="${PRECOMPUTED_ROOT:-$WORKSPACE_DIR/data/.precomputed}"
RESOLUTION_BUCKETS="${RESOLUTION_BUCKETS:-832x480x49}"
TRIGGER_WORD="${TRIGGER_WORD:-netflixinsidejob}"
PREPROCESS_EXTRA_ARGS="${PREPROCESS_EXTRA_ARGS:-}"
export PYTORCH_CUDA_ALLOC_CONF="${PYTORCH_CUDA_ALLOC_CONF:-expandable_segments:True}"

if [ ! -f "$DATASET_FILE" ]; then
  echo "Missing dataset manifest: $DATASET_FILE" >&2
  exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
  echo "Missing model checkpoint: $MODEL_PATH" >&2
  echo "Set MODEL_PATH=/path/to/model.safetensors or place it at the default path." >&2
  exit 1
fi

if [ ! -d "$TEXT_ENCODER_PATH" ]; then
  echo "Missing text encoder directory: $TEXT_ENCODER_PATH" >&2
  echo "Set TEXT_ENCODER_PATH=/path/to/gemma or place it at the default path." >&2
  exit 1
fi

cd "$LTX_TRAINER_DIR"

uv run python scripts/process_dataset.py "$DATASET_FILE" \
  --resolution-buckets "$RESOLUTION_BUCKETS" \
  --model-path "$MODEL_PATH" \
  --text-encoder-path "$TEXT_ENCODER_PATH" \
  --output-dir "$PRECOMPUTED_ROOT" \
  --batch-size 1 \
  --lora-trigger "$TRIGGER_WORD" \
  $PREPROCESS_EXTRA_ARGS
