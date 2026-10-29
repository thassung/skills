# swarm — Changelog

## v1.0.0 — 2026-10-28

Vendored from cursor/plugins pstack @ c742dd6.

- Workers default to four, one each on haiku, sonnet, opus, and fable, unless the user specifies; replaces `pstack-models.mdc` and Grok.
- Replaced Cursor's `generalPurpose` / `environment: cloud` / `cloud_base_branch` with `general-purpose` plus `isolation: "worktree"`.
