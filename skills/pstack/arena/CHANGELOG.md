# arena — Changelog

## v1.0.0 — 2026-10-28

Vendored from cursor/plugins pstack @ c742dd6.

- Runners default to four, one each on haiku, sonnet, opus, and fable (the Agent tool's `model`), unless the user specifies; replaces Cursor's `pstack-models.mdc` rule and Grok defaults.
- Cross-judge can no longer come from another model family (only Claude models are available); the skill now says so and leans on rubric scores.
- Candidate isolation uses the Agent tool's `isolation: "worktree"`.
