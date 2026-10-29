# claude-env

Curated Claude Code skills from multiple upstreams, with guidelines and provenance tracking.

## Structure

```
CLAUDE.md            Agent guidelines (deployed to ~/.claude/)
scripts/             Setup and maintenance scripts
docs/                Cheatsheet and reference docs
manifest.json        Upstream provenance tracking
skills/
  mattpocock/        27 skills from mattpocock/skills v1.3.1
  pstack/            17 skills + 24 principles from cursor/plugins (pstack)
  osmani/            4 skills from addyosmani/agent-skills
  thananon/          5 pre-existing skills
  custom/            3 custom skills (incl. the working-mode switch)
```

## Skills (56, plus 24 principles)

| Source | Skills | Count |
|---|---|---|
| mattpocock/skills v1.3.1 | ask-matt*, code-review, codebase-design, diagnosing-bugs, domain-modeling, grill-me, grill-with-docs, grilling, handoff, implement, implement-spec, improve-codebase-architecture, pr, prototype, research, retro*, setup-matt-pocock-skills, tdd, teach, to-questionnaire, to-spec, to-tickets, triage, wait-what, wayfinder, wizard, writing-for-agents* | 27 |
| cursor/plugins (pstack) | arena*, benchmark-checklist*, blast-radius*, bro, correct*, create-formal-verification-skill, create-verification-skill*, interrogate*, maintain-formal-verification-skill, maintain-verification-skill*, recall*, sharpen, show-me-your-work*, statechart*, swarm*, technical-writing, unslop | 17 |
| addyosmani/agent-skills | ci-cd-and-automation*, constraint-driven-development*, observability-and-instrumentation*, shipping-and-launch* | 4 |
| thananon | debug-mantra, diagram-design*, management-talk*, post-mortem*, scrutinize* | 5 |
| custom | feature-tracker*, mode, wrap-up* | 3 |

\* = modified from upstream (see each skill's CHANGELOG.md). pstack skills that came from Cursor were adapted to Claude Code: model routing, Agent tool options, and `.cursor/` paths.

**Working modes** (`skills/custom/mode`): code changes run in **surgical** mode (fixes and small changes: Karpathy's smallest-diff rules plus the scout rule) or **rebuild** mode (new features and revamps: the pstack principles as written). Claude picks one per task and announces it. `/mode surgical` or `/mode rebuild` forces one for the session, and `/mode default` clears it. See [docs/cheatsheet.md](docs/cheatsheet.md#modes-and-principles) for which principle belongs to which mode.

**Principles** (`skills/pstack/principle-*`): one rule per skill, all user-invoked. `CLAUDE.md` indexes the shared ones and the mode skills name the mode-specific ones; Claude reads the full rule on demand.

**statechart** runs on Linux, macOS, or WSL only: its scripts spawn `/bin/sh` and signal Unix process groups, so native Windows (Git Bash included) fails. It needs Node 22.18+ (22.x line) or 23.6+, Bun 1.1.5+, or Deno 2+, plus `mise`, which installs Java and TLC on first run.

### Invocation modes

A skill is user-invoked when its `SKILL.md` frontmatter has `disable-model-invocation: true`. Without that line, Claude can also trigger it automatically.

**Model-invoked** (Claude auto-detects when to use):
benchmark-checklist, blast-radius, code-review, codebase-design, correct, debug-mantra, diagnosing-bugs, domain-modeling, feature-tracker, grilling, mode, post-mortem, pr, prototype, research, scrutinize, show-me-your-work, tdd, wizard, wrap-up

**User-invoked** (`/command` only, zero context cost at rest):
arena, ask-matt, bro, ci-cd-and-automation, constraint-driven-development, create-formal-verification-skill, create-verification-skill, diagram-design, grill-me, grill-with-docs, handoff, implement, implement-spec, improve-codebase-architecture, interrogate, maintain-formal-verification-skill, maintain-verification-skill, management-talk, observability-and-instrumentation, recall, retro, setup-matt-pocock-skills, sharpen, shipping-and-launch, statechart, swarm, teach, technical-writing, to-questionnaire, to-spec, to-tickets, triage, unslop, wait-what, wayfinder, writing-for-agents, plus all 24 `principle-*` skills

## Setup on a new machine

```powershell
git clone https://github.com/thassung/skills.git <your-path>
cd <your-path>
powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
```

Use `-Force` to overwrite existing skills/config. Use `-DryRun` to preview.

The setup script flattens the source-group folders — `skills/mattpocock/ask-matt/` deploys to `~/.claude/skills/ask-matt/`. It records what it deployed in `~/.claude/skills/.claude-env-deployed`, and on the next run it removes skills that have left the repo. Skills you installed by other means are never touched.

If you edit this repo, install the pre-commit hook once. It runs `scripts/validate.sh` and blocks commits that fail:

```bash
bash scripts/install-hooks.sh
```

## Recommended Plugins

The setup script deploys skills and guidelines. Plugins are account-level and installed separately — see [docs/plugins.md](docs/plugins.md) for the full list.

**Core:** context-mode (context window protection)
**Optional:** frontend-design, asana, miro

## Updating from upstream

```bash
./scripts/update-upstream.sh              # check all upstreams
./scripts/update-upstream.sh mattpocock   # check one upstream
./scripts/validate.sh                     # validate repo structure
./scripts/validate.sh --live              # also check ~/.claude matches the repo
```

`validate.sh` checks that every skill has frontmatter and a manifest entry. It also checks that no skill tries to load a user-invoked skill (it must read the file by path instead), that the README invocation lists match the frontmatter, and that every principle pointer in `CLAUDE.md` and the mode files resolves.

## License

MIT. See [LICENSE](LICENSE).

Upstream skills retain their original MIT licenses:
- [mattpocock/skills](https://github.com/mattpocock/skills) — MIT, Matt Pocock 2026
- [cursor/plugins](https://github.com/cursor/plugins) — MIT, Lauren Tan 2026
- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — MIT, Addy Osmani 2025
