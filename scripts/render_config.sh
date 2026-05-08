#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-test}"
WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
MODEL_PATH="${MODEL_PATH:-$WORKSPACE_DIR/models/ltx23/model.safetensors}"
TEXT_ENCODER_PATH="${TEXT_ENCODER_PATH:-$WORKSPACE_DIR/models/gemma}"
PRECOMPUTED_ROOT="${PRECOMPUTED_ROOT:-$WORKSPACE_DIR/data/.precomputed}"
OUTPUT_DIR="${OUTPUT_DIR:-$WORKSPACE_DIR/runs/insidejob_${PROFILE}}"
LOAD_CHECKPOINT="${MODEL_LOAD_CHECKPOINT:-null}"

case "$PROFILE" in
  test|full) ;;
  *)
    echo "Usage: $0 [test|full]" >&2
    exit 2
    ;;
esac

TEMPLATE="$WORKSPACE_DIR/configs/ltx23_lora_insidejob_${PROFILE}.template.yaml"
OUT="$WORKSPACE_DIR/configs/ltx23_lora_insidejob_${PROFILE}.yaml"

if [ ! -f "$TEMPLATE" ]; then
  echo "Missing template: $TEMPLATE" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")" "$OUTPUT_DIR"

sed \
  -e "s|__MODEL_PATH__|$MODEL_PATH|g" \
  -e "s|__TEXT_ENCODER_PATH__|$TEXT_ENCODER_PATH|g" \
  -e "s|__PRECOMPUTED_ROOT__|$PRECOMPUTED_ROOT|g" \
  -e "s|__OUTPUT_DIR__|$OUTPUT_DIR|g" \
  -e "s|__LOAD_CHECKPOINT__|$LOAD_CHECKPOINT|g" \
  "$TEMPLATE" > "$OUT"

echo "$OUT"
