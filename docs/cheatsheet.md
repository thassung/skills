# Skill Cheatsheet

## Main Flow: idea to ship

```
/sharpen? -> /grill-with-docs -> /prototype? -> /to-spec -> /to-tickets
    -> /implement (per ticket) OR /implement-spec (whole spec)
    -> /code-review -> /pr -> /wrap-up -> /retro
```

## On-Ramps

| Situation | Flow |
|---|---|
| Picking work back up | `/recall` -> main flow |
| Vague or shallow task | `/sharpen` -> main flow |
| Bug | `/diagnosing-bugs` -> `/implement` -> `post-mortem` (surgical mode) |
| Triage | `/triage` -> `/implement` |
| Foggy effort | `/wayfinder` -> `/to-spec` -> ... (rebuild mode) |

## Quality Gates (model-invoked, automatic)

| Skill | When |
|---|---|
| `blast-radius` | After big changes -- proves safety beyond the diff |
| `correct` | After repeated mistakes -- encodes lessons in structure |
| `show-me-your-work` | During long autonomous runs -- decision trail |
| `benchmark-checklist` | Before reporting or acting on a measured perf number |
| `post-mortem` | After a debug session lands a fix -- the engineering record |

## Parallel and Adversarial (user-invoked)

Default fan-out is four subagents, one each on haiku, sonnet, opus, and fable, unless you name models or a count.

| Skill | When |
|---|---|
| `/swarm` | Coverage, races, or exploration -- N workers, one report |
| `/arena` | Design or code bakeoff -- pick a base, graft the best of the rest |
| `/interrogate` | Adversaries try to break a change; only findings proven by a run survive |
| `/scrutinize` | Single-reviewer adversarial review with fresh-context doubt |

## Verification (user-invoked)

| Skill | When |
|---|---|
| `/create-verification-skill` | Project has no scripted way to drive the real app (UI, CLI, service) |
| `/maintain-verification-skill` | Periodic audit that the verify skill and feature map still match the app |
| `/create-formal-verification-skill` | Prove an invariant or model-check a race where tests reach least |
| `/maintain-formal-verification-skill` | Code changed under formal verification -- realign model, rerun |
| `/statechart` | Check a TLA+ state model and draw it; shows the bug as a path. Linux, macOS, or WSL only; needs `mise` |

## Team Process (user-invoked)

| Skill | When |
|---|---|
| `/constraint-driven-development` | New project -- define quality bar |
| `/shipping-and-launch` | Deploy -- staged rollout with gates |
| `/ci-cd-and-automation` | Set up CI/CD pipelines and quality gates |
| `/observability-and-instrumentation` | Add logging, metrics, tracing |

## Codebase Health

```
/improve-codebase-architecture -> generates ideas -> main flow
```

## Writing

| Skill | When |
|---|---|
| `/technical-writing` | Docs, RFCs, READMEs, PR descriptions, commit messages |
| `/unslop` | Cut AI tells from any writing |
| `/writing-for-agents` | Writing skills, CLAUDE.md, or anything an agent reads |
| `/management-talk` | Stakeholder narrative |
| `/diagram-design` | Architecture diagrams |
| `/bro` | Restate the last message in plain language |

## Standalone

```
/grill-me  /research  /prototype  /wizard  /teach
/to-questionnaire  /wait-what  /debug-mantra
```

## Vocabulary

```
/domain-modeling  /codebase-design
```

## Session Lifecycle

| Skill | Purpose |
|---|---|
| `/recall` | Rebuild recent working context from transcripts, git, and PRs |
| `/handoff` | Hand the session to a fresh one |
| `/wrap-up` | Close-out: review menu -> tracker sync -> blast-radius -> /pr -> /retro |
| `/retro` | Mine session for environment improvements (incl. skill file edits) |

## Cross-Session State

```
/feature-tracker -- durable per-feature Markdown tracker
```

## Modes and Principles

Every code change runs in one of two modes. Claude picks one per task with the `mode` skill and opens its reply with `Mode: <mode> — <reason>`.

| Command | Effect |
|---|---|
| `/mode surgical` | Force surgical for the rest of the conversation: hotfixes, bugfixes, small changes to behavior that mostly works |
| `/mode rebuild` | Force rebuild for the rest of the conversation: new features, new versions of a feature, revamps, migrations |
| `/mode default` | Clear a forced mode; Claude picks per task again (when unsure it starts surgical and escalates) |
| `/mode` | Show the mode in effect and the choices |

After a long session gets compacted, a forced mode may need re-typing. `/ask-matt` names the fitting mode when it routes you to a flow.

### What loads when

| Material | Loaded |
|---|---|
| `CLAUDE.md`: shared rules, the mode router, the index of shared principles | Every session (6.3 KB) |
| `mode` skill router | When a mode is picked or forced (1.2 KB) |
| `surgical.md` or `rebuild.md` | Only the chosen one (surgical 1.7 KB, rebuild 2.6 KB) |
| Five rebuild principle files: redesign, subtract, outcome-oriented, laziness, sequence | When rebuild starts (5.0 KB) |
| Any other `principle-*` file | Only when its trigger fits, or you type `/principle-<name>` |

### Which principle belongs where

Rebuild applies every pstack principle as written. Surgical is the specialized mode: Karpathy's rules plus the compatible part of five principles.

| Principle | Rebuild | Surgical |
|---|---|---|
| laziness-protocol | full | Consolidate decisions; minimize the diff |
| subtract-before-you-add | full | Only inside your diff, as the scout rule |
| sequence-verifiable-units | full | full |
| build-the-lever | full | Only for repeated edits or results that must be rerun |
| minimize-reader-load | full | When reading or reviewing; collapse no layers outside your diff |
| redesign-from-first-principles, outcome-oriented-execution, migrate-callers-then-delete-legacy-apis, exhaust-the-design-space, experience-first, model-the-domain, foundational-thinking | full | not applied; if the task needs them, escalate to rebuild |
| fix-root-causes, attack-the-premise | full | full (leaned on hardest in bugfixes) |
| never-block-on-the-human (§1), prove-it-works (§4), encode-lessons-in-structure (§6) | full | full |
| boundary-discipline, type-system-discipline, make-operations-idempotent, separate-before-serializing-shared-state, test-behavior-not-implementation, explain-the-number, guard-the-context-window | full | full (indexed in `CLAUDE.md`) |

The Karpathy rules: Think Before Coding, Simplicity First (YAGNI, DRY, KISS), Goal-Driven Execution, Prove It Works, Blast Radius, and Encode Mistakes are shared. Surgical Changes and the smallest-diff rule live in `surgical.md`.

In surgical mode, where a principle file disagrees with `CLAUDE.md` or `surgical.md`, those win. In rebuild mode the principle files are the authority. The principle files stay verbatim from upstream.

## Setup

```
/setup-matt-pocock-skills -- one-time env config for new machine
```
