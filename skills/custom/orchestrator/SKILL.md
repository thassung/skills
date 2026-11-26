---
name: orchestrator
description: "Implement a spec's tickets in waves with a model and effort chosen per ticket, review after every ticket and wave, and a bounded review-fix loop at the end. Same inputs and branch model as /implement-spec. Use for /orchestrator."
disable-model-invocation: true
---

This is `/implement-spec` with three additions: a model and effort chosen per ticket, review gates after each ticket and each wave, and a bounded review-fix loop at the end. Inputs, vocabulary, and branch model are the same, so a spec from `/to-spec` and `/to-tickets` works unchanged.

You have been provided a spec with tickets that describe how to implement it. The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work.

The tickets are a **task graph** with blocking relationships, so there is always a **frontier** of tickets ready to be grabbed. Work them in **waves**: a wave is the set of tickets on the frontier when you launch, run in parallel.

Communicate with subagents through **context pointers** (the spec, tickets, research notes, prior commits), and keep briefs sparse. Run **implementer subagents** in the background for concurrency.

## Where the reviews run

`scrutinize` and `code-review` each spawn their own fresh-context subagents, and a subagent cannot spawn subagents. So **you run these skills yourself** through the Skill tool, in the orchestrator's thread. `interrogate` also spawns its own, but only the user can start it (`disable-model-invocation`), so you ask for it (step 9). Never hand one to a subagent: it would run degraded, without the fresh-context step that gives it value. Keep your context small by reading only each review's findings, not its working.

## Steps

1. **Read the graph.** Read the spec and tickets. Record each ticket's blockers and its frontier position. Then check every claim the spec makes about the base branch, in two kinds:
   - **Code claims** ("already on dev", "X maps Y", "Z is passed to W"): grep the base and note the file and line.
   - **Behaviour claims**, about what a user sees (a number, a row, a list, who gets credited): run each on the base through its real entry point (the view or command, on the existing test fixture), in an exploration subagent if it takes setup, and record the actual output. A behaviour claim backed only by a grep is unverified.

   Take a claim that fails to the user before wave 1; an implementer who trusts it finds out by failing runs.

2. **Rate each ticket.** For every ticket choose a `model` and an `effort`, and write the choice and its reason in one line to a decision log (`show-me-your-work` format if you want a trail). Use the Model Dispatch rules in `CLAUDE.md`:
   - `haiku`, low effort: mechanical transforms, renames, pure lookups.
   - `sonnet`, medium effort: a clear ticket with a well-defined scope. This is the default.
   - `opus`, high effort: an ambiguous ticket, an architectural decision, or a cross-cutting change.
   - `fable`: reserve for reviewers, not implementers.

   Rate on what the ticket needs, not on its position in the graph. Mark a ticket **shared-surface** when it changes an interface, schema, config, or anything many files import. That mark decides step 6.

3. **(optional) Explore.** Use an **exploration subagent** for any codebase or external-doc exploration the tickets need. It saves markdown notes in a directory outside the repo that every later subagent can read, so implementers focus on implementation.

4. **Create the integration branch.** If the issue tracker closes work through PRs, or the user asks for one, open a draft PR after the first merge in step 7 (a branch with no commits ahead of main can't open one), marked as closing the spec and tickets.

5. **Launch the wave.** Spawn one **implementer subagent** per frontier ticket, in parallel, each with the `model` and effort from step 2, each in its own worktree on its own branch. Each implementer:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `tdd` to build the ticket;
   - merges the integration branch tip into its own branch before reporting done.

6. **Gate each ticket as it finishes.** Do not wait for the wave. When an implementer reports done:
   1. Run `scrutinize` on its branch diff against the integration branch. The contract is the ticket's text copied verbatim, never your paraphrase, and never the implementer's report. Use `fable` for its reviewer.
   2. If the ticket is **shared-surface**, run `blast-radius` too.
   3. Classify findings as scrutinize does. Anything proven by a run, or CONFIRMED at blocker or major, goes back to the same implementer through `SendMessage`. Re-gate after the fix, at most 2 rounds. After that, escalate to the user.

7. **Merge.** Once a ticket passes its gate, merge it to the integration branch with a **merger subagent**, or yourself when it is a fast-forward (the implementer already merged the tip in). Then read its report and notes, and put every line that asks for the user's call or says something wasn't verified to the user. The ticket isn't resolved until each such line has the user's answer recorded in the ticket's Comments.

8. **Advance the frontier.** After each merge, recompute the frontier and launch any newly unblocked tickets at once. When the current wave has fully merged, run the **wave gate**: `code-review` on the integration branch since the previous wave's tip, with its Spec axis pointed at the spec. Fix what it raises through one implementer, then continue. Skip the wave gate for a wave of one ticket, since `scrutinize` already covered it, and for the last wave, since step 9's first `code-review` covers the same diff; log the skip.

9. **Final gate loop**, once all tickets are merged, at most **5 iterations**:
   1. Run `code-review` and `scrutinize` on the whole integration branch against the spec's base.
   2. On the first iteration only, ask the user to run `/interrogate` on the same scope: only the user can start it. It is expensive and reports without fixing. Don't wait for it; fold its findings into the next iteration when they arrive.
   3. Merge the findings and drop duplicates. A finding is **kept** only if it has a repro: a failing test or command output that shows the wrong behavior. A finding without one is not fixed. List it for the user as unproven and move on. This is what stops a reviewer that is told to find problems from making the loop chase invented ones.
   4. Fix the kept findings in a **single implementer subagent**, repro first: it commits each failing repro as a test, then makes it pass with `tdd`, then runs the full test suite. Merge it through a merger subagent.
      - When a finding is about bad input (null, empty, wrong type, an unexpected character), the brief names `boundary-discipline`: validate the input once, where it enters, and let the code behind it trust that shape. Per-input patches deeper in the code come back as new findings next iteration.
      - When a finding recurs after a fix, the escalation in step 6 also names `attack-the-premise`: the next fix tests the shared premise of the earlier ones, not another instance.
   5. Re-review only the fix diff and the surface it touched, not the whole branch again, with `code-review` and `scrutinize`. A fix diff of a few behaviour-preserving lines gets one fresh-context reviewer whose contract carries both the spec and the standards; log that. A full re-review of an unchanged branch will always turn up something new. Ask for `/interrogate` again only if the fix touched a surface it had flagged.
   6. Stop when an iteration yields no kept findings. Stop and escalate to the user, with the open findings, if iteration 5 still has any, or if a finding recurs after being fixed, or if the suite fails after a fix. Do not ship past the cap.

10. **Finish.** First fetch the base branch. If it moved since the integration branch was cut, merge its tip into a throwaway branch and run the full test suite and the spec's live checks there. The gates all ran against the old base, so this is the only place a teammate's change to the base shows up. A failure goes back through step 9 as a kept finding; done when both pass on the merge, and the PR's Evidence says so. Then, if a draft PR exists, mark it ready for review. Otherwise resolve each ticket the way the issue tracker closes work, and report the integration branch. Include the decision log and the iteration count in the report.

11. **Clean up** all implementer subagent worktrees.

## Differences from /implement-spec

| Area | implement-spec | orchestrator |
|---|---|---|
| Model and effort | Inherited | Chosen per ticket (step 2) |
| Per-ticket review | `tdd` only | `scrutinize`, plus `blast-radius` where it applies |
| Wave review | None | `code-review` after each multi-ticket wave |
| Final review | One `code-review`, one fix pass | Up to 5 iterations of `code-review` and `scrutinize`, with `interrogate` once |
| Everything else | | Unchanged |
