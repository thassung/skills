# Karpathy Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Write Files with Real Newlines

**File content is prose, not an escaped string.**

When writing or editing any file (especially Markdown), use actual line breaks. Never emit literal `\n` escape sequences — they produce a single garbled line that diffs badly and renders wrong.

Don't hand-wrap prose into a fixed column. Write **one line per paragraph and per list item**, and let the editor soft-wrap it. Break a line only where the rendered output needs a break (between paragraphs, between list items, before a heading) — never just because a line got "too long". Long lines overflowing is correct.

## 6. Diagrams Are Mermaid

**When a document needs a diagram, write it as a ```mermaid code block.**

Not ASCII art, not a generated image, not another diagram DSL. Mermaid renders on GitHub and in most Markdown viewers, and diffs as text.

## 7. Prove It Works

**Verify against the real artifact — run the feature, read the actual value, inspect the diff.**

"It compiles" and "tests pass" are not proof. Before claiming done:
- Run the feature and observe the actual output.
- Check the real state (database row, API response, rendered UI), not a proxy.
- If you can't verify directly, say what you couldn't check.

## 8. Blast-Radius Awareness

**Before shipping, consider what else this change could break beyond the diff.**

When uncertain, prove safety by running the affected code paths. The diff shows what you changed; blast-radius thinking shows what your change touches.

## 9. Encode Mistakes Structurally

**When a mistake repeats, fix the architecture so it can't happen — don't just add another test.**

Priority: architecture (make it impossible) → types (make it unwritable) → lint rules (make it fail CI) → tests (catch it at runtime) → docs (hope someone reads them).

## Project Setup

When starting work in a new project, consider running `/constraint-driven-development` to define the quality bar (coverage, latency, accessibility, security thresholds) before writing code.

## Model Dispatch

When dispatching subagents for parallel work:
- **Haiku**: file location, simple lookups, mechanical transforms
- **Sonnet**: clear tickets with well-defined scope
- **Opus**: ambiguous tickets, architectural decisions, cross-cutting changes
