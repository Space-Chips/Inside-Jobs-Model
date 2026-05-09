#!/usr/bin/env bash
set -euo pipefail

export RESOLUTION_BUCKETS="${RESOLUTION_BUCKETS:-512x512x25}"
export PRECOMPUTED_ROOT="${PRECOMPUTED_ROOT:-${WORKSPACE_DIR:-$HOME/workspace}/data/.precomputed_5090}"
export PREPROCESS_EXTRA_ARGS="${PREPROCESS_EXTRA_ARGS:---load-text-encoder-in-8bit --vae-tiling}"
export PYTORCH_CUDA_ALLOC_CONF="${PYTORCH_CUDA_ALLOC_CONF:-expandable_segments:True}"

"${WORKSPACE_DIR:-$HOME/workspace}/scripts/preprocess.sh"
