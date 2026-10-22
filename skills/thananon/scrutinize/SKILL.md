---
name: scrutinize
description: Outsider-perspective adversarial review of a plan, PR, or code change. Questions intent, traces code paths end-to-end, then spawns a fresh-context reviewer to defeat confirmation bias. Combines code-path tracing with DDD's adversarial doubt mechanic. Trigger on /scrutinize and proactively whenever the user asks to review, audit, sanity-check, or get a second opinion.
---

# Scrutinize

Stand outside the change. Question whether it should exist. Trace it end-to-end. Then hand it to a reviewer who hasn't seen your reasoning.

## Operating stance

- **Outsider.** Forget who wrote it and why they think it's right. Read the artifact cold.
- **End-to-end, not diff-local.** The diff is the entry point, not the scope. Follow the call graph through real code paths.
- **Fresh-context doubt.** After your own review, a subagent reviews the artifact WITHOUT access to your reasoning or the conversation history. Confirmation bias hides at the seams between "I traced it" and "therefore it's correct."
- **Actionable, concise, with rationale.** Every finding states *what to change*, *why*, and *what evidence* led you there.

## Workflow

Run these in order. Do not skip ahead.

### 1. Intent — should this exist at all?

- State the goal in one sentence, in your own words. If you cannot, the artifact is underspecified — say so and stop.
- Ask: **is there a simpler, smaller, or more elegant way to achieve the same goal?** Consider:
  - Doing nothing (is the problem real / load-bearing?).
  - Using something that already exists in the codebase instead of adding new surface.
  - A smaller change that solves 90% of the goal with 10% of the risk.
  - Solving it at a different layer (config vs code, framework vs app, build vs runtime).
- If a better alternative exists, name it explicitly with rationale. This is the most valuable thing you can output — surface it before the line-by-line review.

### 2. Trace — walk the actual code path

- For each behavior the change claims, trace the path end-to-end through the real code, not just the lines in the diff:
  - Entry point → call sites → branches taken → state mutated → exit / return / side effect.
  - Include the unchanged code on either side of the diff. Bugs hide at the seams.
- For a plan or design doc: trace the proposed flow against the existing system. Where does it touch reality? What does it assume that isn't true?
- Note every place the trace surprises you. Surprises are signal.

### 3. Extract — isolate the reviewable unit

Strip your reasoning. The fresh-context reviewer needs the **artifact** and the **contract**, not the journey.

- **Code**: the diff or the function — not the whole file.
- **Decision**: the proposal in 3–5 sentences plus the constraints it must satisfy.
- **Assertion**: the claim plus the evidence that supposedly supports it.

The unit must be small enough that a reviewer can hold it in mind in one read. If it's a 500-line PR, decompose first.

**Do NOT include:**
- Your conclusions from steps 1–2
- The conversation history
- The author's reasoning or justifications
- Your severity assessments

If you hand over conclusions, you'll get back validation of your conclusions.

### 4. Doubt — fresh-context adversarial review

Spawn a subagent with this prompt. Do not soften it:

```
Adversarial review. Find what is wrong with this artifact.
Assume the author is overconfident. Look for:
- Unstated assumptions
- Edge cases not handled
- Hidden coupling or shared state
- Ways the contract could be violated
- Existing conventions this might break
- Failure modes under unexpected input

Do NOT validate. Do NOT summarize. Find issues, or state
explicitly that you cannot find any after thorough examination.

ARTIFACT:
<paste extracted artifact>

CONTRACT:
<paste contract/constraints>
```

**Critical rules:**
- Pass ARTIFACT + CONTRACT only. Do NOT pass the CLAIM or your reasoning. Handing the reviewer your conclusion biases it toward agreement.
- The subagent must NOT have access to this conversation's context. Use a fresh agent, not a fork. The whole point is that the reviewer hasn't absorbed the author's justifications.
- If nested subagent spawn is unavailable (e.g., running inside a subagent already), flag the limitation. Do a self-review with explicit mental separation from your prior reasoning. Mark the result as **degraded** — it is not true fresh-context review.

### 5. Reconcile — classify every finding

The reviewer's output is data, not verdict. **You are still the orchestrator.** Re-read the artifact text against each finding before classifying — rubber-stamping the reviewer is the same failure mode as ignoring it.

For each finding, classify using **both** confidence and severity:

**Confidence** (first matching class wins):

| Class | Criterion | Action |
|---|---|---|
| **CONFIRMED** | Evidence visible in the artifact text | Must address |
| **PLAUSIBLE** | Reasonable inference, not directly visible | Address or document the trade-off |
| **SPECULATIVE** | Theory without supporting evidence | Note and move on |

**Severity** (for CONFIRMED and PLAUSIBLE only):

| Level | Definition |
|---|---|
| **Blocker** | Breaks correctness, security, or data integrity |
| **Major** | Wrong behavior under realistic conditions |
| **Nit** | Style, naming, minor improvement |

**Loop condition:** If CONFIRMED blockers remain after reconciling, fix them and loop steps 3–5 once more (max 2 cycles total). If blockers persist after 2 cycles, the artifact may not be ready — escalate to the user, don't grind alone.

**Don't defer to the reviewer.** A fresh reviewer can be wrong because it lacks context. "The reviewer said so" is not a classification. Re-read the artifact, then decide.

### 6. Report

Output one tight section per finding. Order: CONFIRMED blockers → CONFIRMED majors → PLAUSIBLE blockers → everything else.

For each finding:
- **Finding** — one sentence, specific. Cite `file:line`.
- **Confidence** — CONFIRMED / PLAUSIBLE / SPECULATIVE.
- **Severity** — blocker / major / nit.
- **Evidence** — the trace step, reviewer observation, or input that exposes it.
- **Suggested change** — concrete, minimal.

Close with a one-line verdict: **ship / fix-then-ship / rework / reject** — with the single biggest reason.

## Red flags

Watch for these failure modes in yourself:
- Skipping step 4 because "I already traced it thoroughly" — that's confirmation bias talking
- Treating all reviewer findings as valid without re-reading the artifact (rubber-stamping)
- Treating all reviewer findings as noise without re-reading the artifact (dismissing)
- Spawning a fresh-context reviewer for a one-line rename or formatting change
- Looping >2 cycles without escalating to the user
- Passing the CLAIM or your reasoning to the reviewer
- Across 2 cycles, zero reviewer findings classified as actionable — you are validating, not scrutinizing

## Operating rules

- **No rubber-stamps.** "LGTM" is not an output. If you find nothing, say what you traced and what the fresh reviewer checked, so the user can judge coverage.
- **Cite or it didn't happen.** Every claim about the code references a specific path, file, or line. No vague "this might break under load."
- **One simpler-alternative pass is mandatory.** Even on small changes, spend one breath asking if the whole thing is necessary. Skip only if the user says "don't question scope."
- **Don't pad with nits when there's a structural problem.** If steps 1–2 surface a real issue, lead with it; defer nits or drop them.
- **No flattery, no hedging.** State the finding.
- **The fresh-context step is not optional.** If you skip step 4, you're reviewing your own work with your own biases.
