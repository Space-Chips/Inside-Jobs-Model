#!/usr/bin/env bash
set -euo pipefail

export RESOLUTION_BUCKETS="${RESOLUTION_BUCKETS:-512x512x25}"
export PRECOMPUTED_ROOT="${PRECOMPUTED_ROOT:-${WORKSPACE_DIR:-$HOME/workspace}/data/.precomputed_5090}"

"${WORKSPACE_DIR:-$HOME/workspace}/scripts/preprocess.sh"
