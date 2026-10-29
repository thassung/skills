---
name: wrap-up
description: Session wrap-up checklist. Offers review skills, syncs feature-tracker, delegates to /pr, and suggests /retro. Use when the user says "wrap up", "wrap-up", "session checklist", or "ready to ship".
---

# Wrap-up

Five steps in order. Steps 1, 4, and 5 are **rule-based — ask with zero analysis before doing anything**.

---

## Step 1 — Skill menu

Ask before touching any files or reading any code:

> Before wrapping up, want to run any of these first?
> Reply with numbers, or `none` to skip.
>
> 1. `/scrutinize` — adversarial review (fresh-context doubt)
> 2. `/security-review` — security audit
> 3. `/management-talk` — stakeholder narrative
> 4. `/shipping-and-launch` — staged rollout checklist (if deploying)

Wait for the answer. Invoke each chosen skill and return here after it finishes.

---

## Step 2 — Tracker sync

Based on what happened in this session (not a full audit — use session context):

- Read the feature's `tech-debt.md` only (not `_shared/`). Report every entry whose `Status:` line is `open` or `blocked` by name.
- Check whether `map.md`, `stage.md` and `state.md` reflect this session's work. If a page is out of date, update it now and bump its `Updated YYYY-MM-DD.` line.
- Any domain docs (`CONTEXT.md`, `docs/adr/*.md`, written via `/grill-with-docs` or `/domain-modeling`) written into a temporary worktree this session: archive them as feature-tracker's REFERENCE.md describes.

Do **not** create files that don't exist. Only update files that are stale based on session context.

If no feature-tracker is active, skip this step.

---

## Step 3 — Blast-radius check

If the session made significant changes (new module, changed auth/permissions, modified shared interfaces, data migration), ask:

> This session touched [summary of significant areas]. Want a `/blast-radius` check before the PR?

If yes, invoke blast-radius and return here. If the changes are small or isolated, skip silently.

---

## Step 4 — PR

Ask (zero analysis):

> Ready to draft the PR? I'll use `/pr`.

If yes, invoke `/pr`. It handles the summary, evidence section, and merge danger assessment.

---

## Step 5 — Suggest retro

Ask (zero analysis):

> Want to run `/retro` to mine this session for environment improvements?

If yes, tell the user to type `/retro`; it is user-invoked, so you cannot start it yourself. If no, wrap up is complete.
