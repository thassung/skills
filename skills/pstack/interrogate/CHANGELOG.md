# interrogate — Changelog

## v1.2.0 — 2026-10-29

- Points at `~/.claude/skills/arena/SKILL.md` by path for the phases it reuses; `arena` is user-invoked and cannot be loaded as a skill.

## v1.0.0 — 2026-10-28

Vendored from cursor/plugins pstack @ c742dd6.

- Inlined the one-sentence `in-your-own-words` restatement instead of depending on that skill.
- Dropped the `interrogate reviewers` model-rule line (Cursor-only); adversaries use the arena model defaults.
- `generalPurpose` → `general-purpose`.
