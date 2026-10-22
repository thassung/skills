#!/usr/bin/env bash
# Scan feature-tracker directories for open/blocked items.
# Usage: ./scripts/check-status.sh [tracker-root]

set -euo pipefail

tracker_root="${1:-.}"
open=0
blocked=0
done_count=0

for f in "$tracker_root"/*.md; do
  [ -f "$f" ] || continue
  status=$(grep -oP 'Status:\s*\K.*' "$f" 2>/dev/null | tail -1 | tr '[:upper:]' '[:lower:]')
  case "$status" in
    *blocked*|*stalled*)
      echo "BLOCKED: $(basename "$f")"
      blocked=$((blocked + 1))
      ;;
    *done*|*complete*|*shipped*)
      done_count=$((done_count + 1))
      ;;
    *)
      echo "OPEN: $(basename "$f") [${status:-no status}]"
      open=$((open + 1))
      ;;
  esac
done

echo ""
echo "Summary: $open open, $blocked blocked, $done_count done"
