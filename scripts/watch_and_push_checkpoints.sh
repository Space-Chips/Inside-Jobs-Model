#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace}"
PROFILE="${1:-test}"
RUN_DIR="${RUN_DIR:-$WORKSPACE_DIR/runs/insidejob_${PROFILE}}"
PROJECT_DIR="$WORKSPACE_DIR"
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
  LATEST="$(find "$RUN_DIR/checkpoints" -type f \( -name '*.safetensors' -o -name '*.pt' -o -name '*.bin' \) 2>/dev/null | sort | tail -n 1 || true)"

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
