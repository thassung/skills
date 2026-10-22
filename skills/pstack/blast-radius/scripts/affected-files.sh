#!/usr/bin/env bash
# Find files affected by the current diff (staged + unstaged).
# Lists changed files and their reverse dependencies (importers).
# Usage: ./scripts/affected-files.sh [base-ref]

set -euo pipefail

base="${1:-HEAD}"
changed=$(git diff --name-only "$base" 2>/dev/null; git diff --cached --name-only 2>/dev/null)
changed=$(echo "$changed" | sort -u)

if [ -z "$changed" ]; then
  echo "No changed files."
  exit 0
fi

echo "=== Changed files ==="
echo "$changed"
echo ""

echo "=== Reverse dependencies (files importing changed files) ==="
while IFS= read -r file; do
  [ -z "$file" ] && continue
  basename_no_ext=$(basename "$file" | sed 's/\.[^.]*$//')
  importers=$(grep -rl "$basename_no_ext" --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' --include='*.py' --include='*.go' . 2>/dev/null | grep -v "$file" | head -20 || true)
  if [ -n "$importers" ]; then
    echo "$file imported by:"
    echo "$importers" | sed 's/^/  /'
  fi
done <<< "$changed"
