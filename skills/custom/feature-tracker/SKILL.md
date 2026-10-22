---
name: feature-tracker
description: Durable per-feature Markdown tracker — map, state, stage, decisions, tech-debt, and runbook pages that outlive any single session. Use when working on a named feature or branch that spans sessions, repos, or environments, even if the user doesn't say "tracker"; when asked what was decided, deployed, or deferred; when writing a runbook; or when switching feature branches. Read its pages before proposing a step on a tracked feature; update them after any action that changes verifiable state.
---

# Feature Tracker

Real feature work spans many sessions. No single conversation holds the whole picture, and the dangerous failure is acting on a stale or assumed one. **Tracker pages are the source of truth; the conversation is not.**

Every page is a plain `.md` file. Page formats, status words, the ticket format, diagrams, runbook patterns, domain-doc links, and honesty rules live in [REFERENCE.md](REFERENCE.md).

## Where the tracker lives

Trackers live outside any repo, in a workspace folder that holds one directory per feature. Resolve `<trackers-root>` in this order and stop at the first hit:

1. A project issue-tracker convention doc (for example `docs/agents/issue-tracker.md` in the workspace above the repo) that names where feature directories go.
2. A `.feature-tracker-root` marker file, walking up from CWD; its directory is the root.
3. An existing `.scratch/` directory in the repo's parent (the workspace), then in the repo itself.
4. An existing `docs/feature-trackers/` directory, walking up from CWD (older trackers).

If none resolve, ask the user, proposing `<repo-parent>/.scratch/`.

A feature is keyed by a stable **slug** (branch last segment: `nsung/0507/multi-tenancy-1` → `multi-tenancy-1`). When ambiguous, ask.

## Pages

```
<trackers-root>/
├── _shared/
│   ├── tech-debt.md     debt that outlives any one feature
│   └── decisions.md     cross-feature decisions; index of ADRs
└── <slug>/
    ├── map.md           the feature's status page and hub; wayfinder map
    ├── state.md         evidence-backed state per environment and repo
    ├── stage.md         phases done, active, next
    ├── decisions.md     feature-scoped decisions; links to ADRs
    ├── tech-debt.md     feature-scoped debt, open and resolved
    ├── runbook.md       ordered, re-runnable setup steps
    ├── spec.md          /to-spec artifact (optional)
    └── issues/NN-<slug>.md   one ticket per file (optional)
```

## Core workflow

1. **Read before you plan.** Before proposing any plan or step, read `map.md` and every page it lists, plus `_shared/tech-debt.md` and `_shared/decisions.md`. Also read the repo's `CONTEXT.md` and `docs/adr/` when present. When a page contradicts new information, surface the contradiction and let the user settle it.

2. **Update after you act.** After any action that changes verifiable state, update the relevant page in the **same turn** and bump its `Updated YYYY-MM-DD.` line. Output you have not seen is `unverified`, never `verified`.

3. **Runbook = the how.** Capture every setup step in `runbook.md` with the exact command, working directory, and gotchas beside the step. Parameterise with `{{PLACEHOLDERS}}`.

4. **Scope debt and decisions.** Still relevant after merge → `_shared/`; feature-only → `<slug>/`; unsure → `_shared/`. ADR-worthy decisions belong in `docs/adr/`; the decisions page *links* them by number and keeps only the one-line what.

5. **Tech-debt lifecycle.** Open debt carries `Status: open` or `Status: blocked`. On resolution set `Status: resolved YYYY-MM-DD` and **keep the entry**: the page answers "what survived?" at a glance. Decisions accumulate the same way.

## Tickets and investigation maps

Planning skills (`/to-spec`, `/to-tickets`, `/wayfinder`, `/triage`) publish into this tracker unless the project's issue-tracker config points elsewhere:

- **Spec** → `<slug>/spec.md`.
- **Tickets** → one file per ticket at `<slug>/issues/NN-<slug>.md`, numbered from `01` in dependency order (blockers first).
- **Wayfinder map** → `<slug>/map.md` itself. Its Notes, Decisions so far, and Fog sections are already in the template, and investigation tickets go in the same `issues/` directory.

Each ticket opens with `Type:`, `Mode:`, `Status:`, and `Blocked by:` lines; the format and vocabularies are in REFERENCE.md → "Tickets".

## Initialising a feature

```
pwsh -File scripts/init_feature.ps1 -Root <trackers-root> -Slug <slug> `
     -Title "Feature Title" -Branch "<branch>" [-Repos "A,B"]
```

Idempotent: existing files are left untouched, and `_shared/` is created if missing. To scaffold by hand, copy the `assets/*-template.md` files as REFERENCE.md → "Scaffolding by hand" describes.

A tracker written before the Markdown switch keeps its `.html` pages. Read them as the source of truth and edit them in place, matching the markup already on the page; convert one to Markdown only when the user asks (REFERENCE.md → "Converting an HTML tracker").
