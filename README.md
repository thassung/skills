# claude-env

Personal Claude Code environment — skills, config, hooks, and guidelines packaged for version control and deployment.

## Structure

```
skills/          All skills (flat), deployed to ~/.claude/skills/
dotfiles/        Config files deployed to ~/.claude/
  hooks/         Hook scripts
docs/            Cheatsheet and reference docs
scripts/         Setup and maintenance scripts
manifest.json    Upstream provenance tracking
```

## Skills (39)

| Source | Skills | Count |
|---|---|---|
| mattpocock/skills v1.3.1 | ask-matt, code-review, codebase-design, diagnosing-bugs, domain-modeling, grill-me, grill-with-docs, grilling, handoff, implement, implement-spec, improve-codebase-architecture, pr, prototype, research, retro, setup-matt-pocock-skills, tdd, teach, to-questionnaire, to-spec, to-tickets, triage, wait-what, wayfinder, wizard, writing-for-agents | 27 |
| cursor/plugins (pstack) | blast-radius, correct, show-me-your-work | 3 |
| addyosmani/agent-skills | constraint-driven-development, shipping-and-launch | 2 |
| thananon | debug-mantra, diagram-design, management-talk, post-mortem, scrutinize* | 5 |
| custom | feature-tracker, wrap-up* | 2 |

\* = modified from upstream

## Setup on a new machine

```powershell
git clone https://github.com/thassung/claude-env.git D:\claude-env
cd D:\claude-env
git checkout skills
powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
```

Use `-Force` to overwrite existing skills/config. Use `-DryRun` to preview.

## Updating from upstream

1. Check `manifest.json` for the current upstream commit/tag
2. Clone or fetch the upstream repo at the new version
3. For each skill:
   - If `modified: false` — diff upstream old vs new, replace if desired
   - If `modified: true` — diff upstream old vs your version to see your changes, then apply that gap to the upstream new version
4. Update `manifest.json` with the new commit/ref
5. Commit

## License

Skills from upstream repos retain their original MIT licenses. See each upstream repo for attribution:
- [mattpocock/skills](https://github.com/mattpocock/skills) — MIT, Matt Pocock 2026
- [cursor/plugins](https://github.com/cursor/plugins) — MIT, Lauren Tan 2026
- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — MIT, Addy Osmani 2025

Custom skills and configuration are personal work.
