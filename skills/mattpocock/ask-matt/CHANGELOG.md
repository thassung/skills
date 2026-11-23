# ask-matt — Changelog

## v1.2.0 — 2026-11-23

- Added `/orchestrator` as a third way to work tickets after `/to-tickets`, next to `/implement` and `/implement-spec`, and noted its review cadence in the closing paragraph.

## v1.1.0 — 2026-11-18

- Added "Anything not named above": the router reads every deployed `~/.claude/skills/*/SKILL.md` frontmatter, user-invoked ones included, so it can recommend skills the map doesn't name (pstack, osmani, thananon, custom). `scripts/validate.py` checks the section stays.

## v1.0.0 — 2026-10-28

- Added a "Pick a mode" section: maps flows to `/mode surgical` and `/mode rebuild`, documents `/mode default`, and tells the router to name and offer the fitting mode when it routes.
