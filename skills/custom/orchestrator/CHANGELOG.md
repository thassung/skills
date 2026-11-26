# orchestrator — Changelog

## v1.1.0 — 2026-11-26

- Step 1 splits spec claims into code claims (grep the base) and behaviour claims (run them on the base and record the output). On the dashboard-email branch 1 run, two ticket premises passed a grep check and were still false.
- Step 7 lets the orchestrator fast-forward a ticket itself; step 8 skips the wave gate for the last wave; step 9.5 lets a small behaviour-preserving fix diff take one combined fresh reviewer. Each skip is logged.

## v1.0.0 — 2026-11-21

- New skill. Built on `/implement-spec` (same inputs, integration branch, worktrees, merger subagents, and step-5 user-call rule), adding per-ticket model and effort, per-ticket and per-wave review gates, and a final review-fix loop capped at 5 iterations.
