# scrutinize — Changelog

## v1.1.0 — 2026-10-21

Merged with DDD (osmani) fresh-context doubt mechanic. Rewrote from 2-step to 6-step adversarial review:

1. Intent — should this exist?
2. Trace — walk code paths
3. Extract — strip reasoning, isolate artifact + contract
4. Doubt — spawn fresh-context adversarial subagent (from DDD)
5. Reconcile — CONFIRMED/PLAUSIBLE/SPECULATIVE x blocker/major/nit
6. Report — file:line, evidence, suggested change, verdict

Max 2 cycles. Uses ReportFindings tool.
