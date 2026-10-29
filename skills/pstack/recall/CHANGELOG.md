# recall — Changelog

## v1.2.0 — 2026-10-29

- The brief follows `~/.claude/skills/unslop/SKILL.md` by path; `unslop` is user-invoked and cannot be loaded as a skill.

## v1.0.0 — 2026-10-28

Vendored from cursor/plugins pstack @ c742dd6.

- Transcript path and format changed from Cursor (`~/.cursor/projects/<slug>/agent-transcripts/`) to Claude Code (`~/.claude/projects/<slug>/<session-uuid>.jsonl`).
- Shared-record sweep spawns its own per-source investigators instead of delegating to the `why` skill (not vendored).
- Dropped routing to `session-pickup` and `automate-me` (not vendored); pointed single-chat resume at `claude --resume`.
- Subagent model choice points at the Model Dispatch section of CLAUDE.md instead of `poteto-mode`.
