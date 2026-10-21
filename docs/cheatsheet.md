# Skill Cheatsheet

## Main Flow: idea → ship

```
/grill-with-docs → /prototype? → /to-spec → /to-tickets
    → /implement (per ticket) OR /implement-spec (whole spec)
    → /code-review → /pr → /wrap-up → /retro
```

## On-Ramps

| Situation | Flow |
|---|---|
| Bug | `/diagnosing-bugs` → `/implement` |
| Triage | `/triage` → `/implement` |
| Foggy effort | `/wayfinder` → `/to-spec` → ... |

## Quality Gates (model-invoked, automatic)

| Skill | When | Source |
|---|---|---|
| `blast-radius` | After big changes — proves safety beyond the diff | pstack |
| `correct` | After repeated mistakes — encodes lessons in structure | pstack |
| `show-me-your-work` | During long autonomous runs — decision trail | pstack |

## Team Process (user-invoked)

| Skill | When | Source |
|---|---|---|
| `/constraint-driven-development` | New project — define quality bar | osmani |
| `/shipping-and-launch` | Deploy — staged rollout with gates | osmani |

## Codebase Health

```
/improve-codebase-architecture → generates ideas → main flow
```

## Standalone

```
/grill-me  /research  /prototype  /wizard  /teach
/to-questionnaire  /wait-what
```

## Vocabulary

```
/domain-modeling  /codebase-design
```

## Session Lifecycle

| Skill | Purpose |
|---|---|
| `/wrap-up` | Close-out: review menu → tracker sync → blast-radius → /pr → /retro |
| `/retro` | Mine session for environment improvements |

## Cross-Session State

```
/feature-tracker — durable per-feature Markdown tracker
```

## External

```
/scrutinize    — adversarial review with fresh-context doubt
/post-mortem   — incident analysis
/debug-mantra  — debugging methodology
/management-talk — stakeholder narrative
/diagram-design — architecture diagrams
```

## Setup

```
/setup-matt-pocock-skills — one-time env config for new machine
```
