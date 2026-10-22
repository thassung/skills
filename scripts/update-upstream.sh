#!/usr/bin/env bash
# Check for upstream updates and report diffs.
# Usage: ./scripts/update-upstream.sh [upstream-name]
# Example: ./scripts/update-upstream.sh mattpocock

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$REPO_ROOT/manifest.json"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

check_upstream() {
  local name="$1"
  local repo commit ref
  repo=$(jq -r ".upstreams.\"$name\".repo" "$MANIFEST")
  commit=$(jq -r ".upstreams.\"$name\".commit" "$MANIFEST")
  ref=$(jq -r ".upstreams.\"$name\".ref" "$MANIFEST")

  if [ "$repo" = "unknown" ] || [ "$repo" = "null" ]; then
    echo "[$name] No upstream tracked (repo: $repo)"
    return
  fi

  echo "[$name] repo=$repo ref=$ref recorded_commit=$commit"

  local latest
  latest=$(git ls-remote "https://github.com/$repo.git" "$ref" 2>/dev/null | head -1 | cut -f1)
  if [ -z "$latest" ]; then
    latest=$(git ls-remote "https://github.com/$repo.git" "refs/tags/$ref" 2>/dev/null | head -1 | cut -f1)
  fi

  if [ -z "$latest" ]; then
    echo "  Could not resolve remote ref '$ref'"
    return
  fi

  if [ "$latest" = "$commit" ]; then
    echo "  UP TO DATE ($commit)"
  else
    echo "  UPDATE AVAILABLE: $commit -> $latest"

    local skills_list
    skills_list=$(jq -r ".skills | to_entries[] | select(.value.upstream == \"$name\") | .key" "$MANIFEST")
    local modified_count=0
    local unmodified_count=0
    while IFS= read -r skill; do
      local is_modified
      is_modified=$(jq -r ".skills.\"$skill\".modified" "$MANIFEST")
      if [ "$is_modified" = "true" ]; then
        echo "    $skill (MODIFIED - manual merge needed)"
        modified_count=$((modified_count + 1))
      else
        unmodified_count=$((unmodified_count + 1))
      fi
    done <<< "$skills_list"
    echo "  $unmodified_count unmodified (safe to replace), $modified_count modified (need manual merge)"
  fi
  echo ""
}

if [ $# -gt 0 ]; then
  check_upstream "$1"
else
  for name in $(jq -r '.upstreams | keys[]' "$MANIFEST"); do
    check_upstream "$name"
  done
fi
