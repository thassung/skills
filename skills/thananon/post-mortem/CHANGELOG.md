# post-mortem — Changelog

## v1.2.0 — 2026-10-22

- Reverted to model-invoked. Claude should auto-detect when a debug session lands a fix and offer to write the post-mortem.

## v1.1.0 — 2026-10-22

- Changed to user-invoked (added `disable-model-invocation: true`). Incident analysis — user decides when to write the post-mortem.
