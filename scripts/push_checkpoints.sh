#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/workspace"

git pull --rebase origin main || true

git add configs scripts notes checkpoints logs .gitattributes .gitignore README.md

if git diff --cached --quiet; then
  echo "No new checkpoint changes to push."
  exit 0
fi

STAMP="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"
git commit -m "Checkpoint backup ${STAMP}" || true
git push origin main
