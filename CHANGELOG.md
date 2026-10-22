# Changelog

## v1.1.0 — 2026-10-22

### Added
- 3 new skills: ci-cd-and-automation (osmani), observability-and-instrumentation (osmani), unslop (pstack)
- Folder structure: skills organized by source (mattpocock/, pstack/, osmani/, thananon/, custom/)
- Per-skill CHANGELOG.md for modified skills
- LICENSE, .gitignore, CHANGELOG.md at root
- Helper scripts: update-upstream.sh, validate.sh, check-staleness.sh, affected-files.sh, check-status.sh
- Retro: route learnings to skill file edits

### Changed
- Dotfiles moved from dotfiles/ to repo root
- Invocation modes fixed per design:
  - blast-radius, correct, show-me-your-work → model-invoked (auto quality gates)
  - constraint-driven-development, shipping-and-launch → user-invoked (project setup)
  - ci-cd-and-automation, observability-and-instrumentation → user-invoked (reference)
  - management-talk, post-mortem, diagram-design, writing-for-agents → user-invoked (situational)
- setup.ps1 updated for new folder structure + encoding fix
- manifest.json updated with new skills and modifications

### Fixed
- setup.ps1 em-dash encoding bug

## v1.0.0 — 2026-10-21

### Added
- Initial environment: 39 skills from 4 upstreams + custom
- Vendor-copy with provenance manifest (manifest.json)
- Setup script (scripts/setup.ps1)
- Cheatsheet (docs/cheatsheet.md)
- scrutinize: merged with DDD fresh-context doubt mechanic (6-step flow)
- wrap-up: updated menu, delegates to /pr, suggests /retro, blast-radius check
- CLAUDE.md: Karpathy Guidelines + prove-it-works, blast-radius, encode-structurally
