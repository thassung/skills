#!/usr/bin/env bash
# Copy the repo hooks into .git/hooks.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
for h in "$root"/scripts/hooks/*; do
  cp "$h" "$root/.git/hooks/$(basename "$h")"
  chmod +x "$root/.git/hooks/$(basename "$h")"
  echo "installed $(basename "$h")"
done
