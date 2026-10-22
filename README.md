# claude-env

Personal Claude Code environment — skills, config, hooks, and guidelines packaged for version control and deployment.

## Structure

```
CLAUDE.md            Karpathy Guidelines (deployed to ~/.claude/)
settings.json        Claude Code settings
hooks/               Hook scripts
scripts/             Setup and maintenance scripts
docs/                Cheatsheet and reference docs
manifest.json        Upstream provenance tracking
skills/
  mattpocock/        27 skills from mattpocock/skills v1.3.1
  pstack/            4 skills from cursor/plugins (pstack)
  osmani/            4 skills from addyosmani/agent-skills
  thananon/          5 pre-existing skills
  custom/            2 custom skills
```

## Skills (42)

| Source | Skills | Count |
|---|---|---|
| mattpocock/skills v1.3.1 | ask-matt, code-review, codebase-design, diagnosing-bugs, domain-modeling, grill-me, grill-with-docs, grilling, handoff, implement, implement-spec, improve-codebase-architecture, pr, prototype, research, retro*, tdd, teach, to-questionnaire, to-spec, to-tickets, triage, wait-what, wayfinder, wizard, writing-for-agents* | 27 |
| cursor/plugins (pstack) | blast-radius*, correct*, show-me-your-work*, unslop | 4 |
| addyosmani/agent-skills | ci-cd-and-automation*, constraint-driven-development*, observability-and-instrumentation*, shipping-and-launch* | 4 |
| thananon | debug-mantra, diagram-design*, management-talk*, post-mortem*, scrutinize* | 5 |
| custom | feature-tracker*, wrap-up* | 2 |

\* = modified from upstream (see each skill's CHANGELOG.md)

### Invocation modes

**Model-invoked** (Claude auto-detects when to use):
blast-radius, code-review, codebase-design, correct, debug-mantra, diagnosing-bugs, domain-modeling, feature-tracker, grilling, improve-codebase-architecture, pr, prototype, research, scrutinize, show-me-your-work, tdd, wizard, wrap-up

**User-invoked** (`/command` only, zero context cost at rest):
ask-matt, ci-cd-and-automation, constraint-driven-development, diagram-design, grill-me, grill-with-docs, handoff, implement, implement-spec, management-talk, observability-and-instrumentation, post-mortem, retro, setup-matt-pocock-skills, shipping-and-launch, teach, to-questionnaire, to-spec, to-tickets, triage, unslop, wait-what, wayfinder, writing-for-agents

## Setup on a new machine

```powershell
git clone https://github.com/thassung/skills.git <your-path>
cd <your-path>
powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
```

Use `-Force` to overwrite existing skills/config. Use `-DryRun` to preview.

The setup script flattens the source-group folders — `skills/mattpocock/ask-matt/` deploys to `~/.claude/skills/ask-matt/`.

## Updating from upstream

```bash
./scripts/update-upstream.sh              # check all upstreams
./scripts/update-upstream.sh mattpocock   # check one upstream
./scripts/validate.sh                     # validate repo structure
```

## License

MIT. See [LICENSE](LICENSE).

Upstream skills retain their original MIT licenses:
- [mattpocock/skills](https://github.com/mattpocock/skills) — MIT, Matt Pocock 2026
- [cursor/plugins](https://github.com/cursor/plugins) — MIT, Lauren Tan 2026
- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — MIT, Addy Osmani 2025
