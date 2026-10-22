#!/usr/bin/env bash
# Validate the claude-env repo structure.
# Checks: every skill has SKILL.md, manifest entries match disk, no orphans.

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$REPO_ROOT/manifest.json"
errors=0

echo "Validating claude-env..."

if [ ! -f "$MANIFEST" ]; then
  echo "FAIL: manifest.json not found"
  exit 1
fi

# Check every skill on disk has a SKILL.md
disk_skills=()
for group in "$REPO_ROOT"/skills/*/; do
  for skill_dir in "$group"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    disk_skills+=("$skill_name")
    if [ ! -f "$skill_dir/SKILL.md" ]; then
      echo "FAIL: $skill_name has no SKILL.md"
      errors=$((errors + 1))
    fi
  done
done

# Extract skill names from manifest using python (cross-platform)
manifest_skills=$(cd "$REPO_ROOT" && python -c "
import json
with open('manifest.json') as f:
    m = json.load(f)
for s in m.get('skills', {}):
    print(s)
" 2>/dev/null | tr -d '\r' || echo "")

if [ -z "$manifest_skills" ]; then
  echo "WARN: Could not parse manifest (python not available or parse error)"
else
  # Check manifest skills exist on disk
  while IFS= read -r skill; do
    [ -z "$skill" ] && continue
    found=0
    for ds in "${disk_skills[@]}"; do
      if [ "$ds" = "$skill" ]; then
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      echo "FAIL: manifest lists '$skill' but not found on disk"
      errors=$((errors + 1))
    fi
  done <<< "$manifest_skills"

  # Check for skills on disk not in manifest
  for ds in "${disk_skills[@]}"; do
    if ! echo "$manifest_skills" | grep -qx "$ds"; then
      echo "WARN: '$ds' on disk but not in manifest"
    fi
  done
fi

# Check SKILL.md frontmatter has name field
for group in "$REPO_ROOT"/skills/*/; do
  for skill_dir in "$group"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue
    if ! head -5 "$skill_file" | grep -q "^name:"; then
      echo "WARN: $skill_name SKILL.md missing 'name:' in frontmatter"
    fi
  done
done

echo ""
if [ "$errors" -eq 0 ]; then
  echo "OK: ${#disk_skills[@]} skills validated, all checks passed"
else
  echo "FAIL: $errors error(s) found"
  exit 1
fi
