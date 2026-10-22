# Feature Tracker — Reference

Formats and conventions for the [feature-tracker](SKILL.md) skill. SKILL.md is the workflow; this is the format.

## Two-layer storage model

| Layer | Lives in | Outlives the feature? | Use for |
|---|---|---|---|
| **Per-feature** | `<trackers-root>/<slug>/` | No | This feature's status, environment state, stage, scoped decisions, scoped debt, runbook, spec, tickets |
| **Shared** | `<trackers-root>/_shared/` | Yes | Debt that still matters after this feature merges; cross-feature decisions and an index of ADRs |

Debt found on one branch usually outlives that branch; that split is the point of the layout. The list of features is the directory listing of `<trackers-root>`.

## Writing the pages

Pages have two readers: a **future session** with none of today's context (the one that matters most) and a human in a Markdown viewer.

- Write one line per paragraph and per list item, with real newlines; a line breaks only where the rendered output breaks.
- Every page opens with its `# Title`, a one-line lede, and `Updated YYYY-MM-DD.`; bump that line whenever the page changes.
- Make each entry self-contained: what, where, when (absolute date), and why it matters. Hostnames, paths, and commands go in backticks.
- Put status in the fixed position each page format defines, using only the status words below, so a session can grep for them (`grep "· unverified ·" state.md`, `grep -E "^Status: (open|blocked)" tech-debt.md`).
- Reference the domain, not line numbers; a file path that may move goes stale.

## Status words

| Where | Line or position | Words |
|---|---|---|
| `state.md` entries | `- YYYY-MM-DD · <word> · text` | `verified` · `unverified` · `blocked` |
| `stage.md` phases, `runbook.md` steps | `- **<word>** …` / `Status: <word>` | `done` · `active` · `next` · `blocked` |
| `tech-debt.md` entries | `Status:` and `Severity:` lines | `open` · `blocked` · `resolved YYYY-MM-DD`; severity `high` · `medium` · `low` |
| tickets | `Status:` line | the project's triage labels when it documents them; else `ready-for-agent` → `claimed` → `resolved`, or `blocked` |

## Page formats

Each `assets/*-template.md` is the scaffold for its page and carries an HTML comment showing the entry format. Copy the format from the template and leave the comment in place.

### map.md — status page and hub

The first page a session reads. It holds the current stage in one line, a table pointing at every other page and at the domain docs, and the wayfinder sections:

- **Notes** — orientation a newcomer needs: what is built, what is not, where things live.
- **Decisions so far** — a dated log, one line per decision: `- YYYY-MM-DD: gist. Pointer.` The pointer names where the decision lives in full (a `decisions.md` heading, a ticket's `## Answer`, or an ADR). The decision's full text stays in that one place.
- **Fog** — open questions and known unknowns, one line each. Remove a line when a ticket or decision settles it.

### state.md — what has actually been done, where

An **Environments** table (environment, host, one-line status) followed by one `## <repo>` section per repo the feature touches. Keep every repo in this one file so a session sees the full picture in one read; a step that varies per repo in `runbook.md` gets the same `## <repo>` split.

### stage.md — phases

A list of phases in order, each `- **done|active|next|blocked** Phase name — one-line summary (date)`. Exactly one phase is `active` while work is under way.

### decisions.md — feature-scoped decisions

One `### Decision title` per decision, then a paragraph starting with the date: the decision, then `Affects:` what future work must respect. When an ADR owns the decision, add a `Canonical:` line naming repo, ADR number, and title, and keep only the one-line what here. `_shared/decisions.md` uses the same format for decisions that bind every feature.

### tech-debt.md — deferred problems

One `### Debt title` per item, then `Status:` and `Severity:` lines, then a paragraph starting `Found YYYY-MM-DD.` with what is wrong and why it was deferred, then a `Do later:` line with the concrete unblock action and an owner. Resolved items keep their entry with `Status: resolved YYYY-MM-DD` and one line on how it was resolved. `_shared/tech-debt.md` uses the same format; cross-link feature debt that depends on a shared item.

### runbook.md — the how

`runbook.md` is the *how*; `state.md` is the *what has been done where*. A good runbook is re-runnable on a new deployment without find-replacing through prose:

- **Parameters first**, right after the lede: every value that changes per deployment (domains, project IDs, service-account emails, VM names, zones, usernames, image tags) as a `{{DOUBLE_BRACE}}` placeholder with its "Current run" value. Steps reference the placeholders (`/home/{{STACK_USER}}/...`), so only the Parameters list is re-edited per deployment.
- **One `### Step N — headline` per step**, with a `Status: <word> · Depends on: <steps>` line, the prose, and the exact command in a fenced block with its working directory.
- **Gotchas beside the step that hit them**, as a blockquote opening `> **Gotcha — headline.**`: what goes wrong, how to recognise it, the fix. The next operator reads top to bottom and meets each gotcha where it applies.
- A **Dependency map** mermaid diagram between Parameters and Steps, only when the step graph is more than a straight chain.

## Tickets

`issues/NN-<slug>.md`, numbered from `01` in dependency order. The opening lines are fixed so a session can scan the frontier with grep:

| Line | Values |
|---|---|
| `Type:` | `slice` (a `/to-tickets` tracer bullet: a vertical end-to-end slice) · `research` · `prototype` · `grilling` · `task` (the four `/wayfinder` types; a `task` is literal manual work that unblocks a decision) |
| `Mode:` | `hitl` (human-in-the-loop; resolves only through live exchange, e.g. grilling, prototype) · `afk` (agent alone, e.g. research) |
| `Status:` | see "Status words" |
| `Blocked by:` | `NN, NN` or `None`; a ticket is unblocked when every ticket it lists is resolved |

Slice ticket:

```markdown
# 03 — Route WhatsApp webhook to per-tenant Celery queue

Type: slice
Mode: afk
Status: ready-for-agent
Blocked by: 01, 02

**What to build:** end-to-end behaviour from the user's perspective, not a layer-by-layer implementation list.

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

## Comments
```

Wayfinder investigation ticket:

```markdown
# 02 — Which tenant-resolution key does WhatsApp expose?

Type: research
Mode: afk
Status: claimed
Blocked by: None

The question to answer, in one or two lines.

## Answer
```

Claim by setting `Status: claimed` and saving before any work. Resolve by appending the answer under `## Answer`, setting the resolved status, and adding a dated gist with a link to the ticket under Decisions so far in `map.md`. Conversation history appends under `## Comments`.

## Diagrams

Every diagram is a fenced ```` ```mermaid ```` block; it renders natively in GitHub, VS Code preview, and most Markdown viewers, and diffs as text. Add one only when a picture makes the state clearer than prose: an environment map, a routing or CI/CD flow, a runbook dependency chain, a cross-repo call sequence.

A diagram **supplements** the prose: every fact in it also exists in prose on the same page, so the page reads correctly in a viewer that shows the raw source. Leave styling to the renderer and keep colors out of the mermaid source.

````markdown
```mermaid
flowchart LR
  webhook[LINE webhook] --> celery[celery · line queue]
  celery --> lg[langgraph /workflow/chatbot]
```
````

## Linking to CONTEXT.md and ADRs

When a repo keeps domain docs (the `domain-modeling` skill builds them), three artifacts have **one canonical owner each**:

| Artifact | Canonical home | The tracker's job |
|---|---|---|
| Ubiquitous language / glossary | repo `CONTEXT.md` | use its terms; leave their definitions there |
| Durable, hard-to-reverse decisions | repo `docs/adr/NNNN-*.md` | link by number from the decisions pages |
| Feature status, state, stage, runbook, debt, and ephemeral decisions | the tracker | own it fully |

The tracker sits outside the repo, so a clean relative link rarely exists: identify an ADR by repo, number, and title (`Canonical: Salmate ADR-0001 — default-department-routing.`), and add a Markdown link only when the path is stable. If the repo has no domain docs, the tracker records decisions and vocabulary itself; creating `CONTEXT.md` or an ADR is the domain-modeling skill's call, not the tracker's.

## Wrap-up archiving

At wrap-up, move domain docs only when their source is **ephemeral**: written into a worktree or branch that is about to be discarded. Docs in a persistent, committed repo stay there and are linked as usual.

When archiving is needed, move `<repo>/CONTEXT.md` → `<slug>/archive/<repo-name>/CONTEXT.md` and `<repo>/docs/adr/NNNN-*.md` → `<slug>/archive/<repo-name>/adr/`, then add a dated line to `map.md` → Decisions so far naming the branch and the archive path.

## Honesty and execution rules

- Record state as `verified` only with evidence seen in this session; record only decisions and commitments made in the conversation.
- Use absolute dates from the environment context.
- Code often builds via CI/CD and runs on a VM or codespace the session cannot reach. Generate an exact copy-paste script, ask the user to paste the output back, and only then record the resulting state.
- When a page contradicts new information, surface the contradiction and let the user settle it.

## Scaffolding by hand

Prefer `scripts/init_feature.ps1`. By hand:

1. If `<trackers-root>/_shared/` lacks them, copy `assets/decisions-template.md` → `_shared/decisions.md` and `assets/tech-debt-template.md` → `_shared/tech-debt.md`.
2. Create `<trackers-root>/<slug>/` and copy `map-template.md` → `map.md`, `state-template.md` → `state.md`, `stage-template.md` → `stage.md`, `decisions-template.md` → `decisions.md`, `tech-debt-template.md` → `tech-debt.md`, `runbook-template.md` → `runbook.md`.
3. Replace the template placeholders: `{{FEATURE_TITLE}}`, `{{SLUG}}`, `{{BRANCH_NAME}}`, `{{REPOS}}`, `{{REPO_SECTIONS}}` (one `## <repo>` heading per repo), `{{TODAY}}`, `{{PAGE_TITLE}}`, `{{PAGE_LEDE}}`. Runbook parameters such as `{{PARAM_1}}` stay as placeholders.

## Converting an HTML tracker

Only when the user asks. Convert page by page: `index.html` → `map.md`, every other `<page>.html` → `<page>.md`, `_shared/*.html` → `_shared/*.md`, keeping every entry (resolved debt included). Card classes and badges become the status words above: `is-done`/`verified` → `verified` or `done`, `is-pending`/`unverified` → `unverified` or `open`, `is-blocked` → `blocked`, `badge done resolved …` → `Status: resolved …`. Mermaid `<pre class="mermaid">` blocks become fenced mermaid blocks; an inline `<svg>` becomes a mermaid diagram or prose. Delete the `.html` files and `assets/` directory only after the user confirms the Markdown pages.
