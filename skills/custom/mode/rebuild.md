# Rebuild mode

The design has to change. Build what you would have built if the new requirement had been there from day one.

Every pstack principle applies here as written. Where a rule below and a principle file seem to differ, the principle file is the authority. Before you start, read these in full: `~/.claude/skills/principle-redesign-from-first-principles/SKILL.md`, `principle-subtract-before-you-add`, `principle-outcome-oriented-execution`, `principle-laziness-protocol`, and `principle-sequence-verifiable-units`.

## Rules

- **Redesign, don't bolt on.** Read every affected file. Ask what you would build from scratch with this requirement, then propagate it through every reference: types, tests, docs, examples. Think about the whole redesign, then deliver it incrementally.
- **Each increment is the smallest change toward the redesign.** The whole design may be large; every step toward it stays minimal, with one source of truth per decision (principle-laziness-protocol).
- **Subtract first.** Remove dead code, redundant guards, and stale layers before you build on top.
- **Data shape first.** Name the core types and data structures before writing logic. Encode the domain in a structure (state machine, typed model, table) instead of scattered conditionals (principle-foundational-thinking, principle-model-the-domain).
- **Every unit ends green.** Verify each change before starting the next (principle-sequence-verifiable-units). What may stay broken is declared up front and limited to legacy paths and old callers mid-migration. Keep checks on everything you are actively touching, and finish with full static and runtime verification (principle-outcome-oriented-execution).
- **Migrate and delete in one wave.** Move every caller to the new API and delete the old one. Keep a compatibility shim only when external users depend on the old API. Delete tests that only pin the old internals (principle-migrate-callers-then-delete-legacy-apis).
- **Collapse what costs more than it saves.** One-caller wrappers, pass-through layers, and needless mutable state go (principle-minimize-reader-load).
- **Compare before committing to a novel design.** With no precedent in the codebase, build 2-3 competing prototypes, or run `/arena`, and compare them side by side (principle-exhaust-the-design-space).
- **Build the lever.** Use a codemod, generator, or script for any non-trivial edit, and run it yourself rather than hand-applying. The tool is the artifact a reviewer reruns (principle-build-the-lever).
- **Experience first.** On scope tradeoffs, fewer polished features beat more rough ones (principle-experience-first).
