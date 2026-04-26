#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="$HOME/workspace/runs/insidejob_run01"
PROJECT_DIR="$HOME/workspace"
STEP_DIR="$PROJECT_DIR/checkpoints/step"
FINAL_DIR="$PROJECT_DIR/checkpoints/final"
STATE_FILE="$PROJECT_DIR/.last_pushed_checkpoint"

mkdir -p "$STEP_DIR" "$FINAL_DIR"
touch "$STATE_FILE"

copy_checkpoint() {
  local src="$1"
  local base
  base="$(basename "$src")"

  if [[ "$base" == *final* ]]; then
    cp -f "$src" "$FINAL_DIR/$base"
  else
    cp -f "$src" "$STEP_DIR/$base"
  fi
}

cd "$PROJECT_DIR"

while true; do
  LATEST="$(find "$RUN_DIR" -type f \( -name '*.safetensors' -o -name '*.pt' -o -name '*.bin' \) | sort | tail -n 1 || true)"

  if [ -n "${LATEST}" ]; then
    LAST_PUSHED="$(cat "$STATE_FILE" || true)"
    if [ "$LATEST" != "$LAST_PUSHED" ]; then
      echo "Syncing checkpoint: $LATEST"
      copy_checkpoint "$LATEST"
      "$HOME/workspace/scripts/push_checkpoints.sh"
      echo "$LATEST" > "$STATE_FILE"
    fi
  fi

  sleep 60
done
