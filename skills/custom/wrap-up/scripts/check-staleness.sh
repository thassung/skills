#!/usr/bin/env bash
# Check feature-tracker pages for staleness.
# Finds tracker files with Updated dates older than 7 days.
# Usage: ./scripts/check-staleness.sh [tracker-dir]

set -euo pipefail

tracker_dir="${1:-.}"
stale_days=7
now=$(date +%s)
found=0

for f in "$tracker_dir"/*.md; do
  [ -f "$f" ] || continue
  updated=$(grep -oP 'Updated:\s*\K\d{4}-\d{2}-\d{2}' "$f" 2>/dev/null | tail -1)
  if [ -n "$updated" ]; then
    updated_ts=$(date -d "$updated" +%s 2>/dev/null || echo "0")
    age_days=$(( (now - updated_ts) / 86400 ))
    if [ "$age_days" -gt "$stale_days" ]; then
      status=$(grep -oP 'Status:\s*\K.*' "$f" 2>/dev/null | tail -1)
      echo "STALE ($age_days days): $(basename "$f") [${status:-unknown}]"
      found=$((found + 1))
    fi
  fi
done

if [ "$found" -eq 0 ]; then
  echo "No stale tracker pages found."
fi
