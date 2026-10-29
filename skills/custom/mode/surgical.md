# Surgical mode

The design is right; the task fixes or adjusts it. Change as little as solves the problem, and leave the code you touched a little cleaner than you found it.

These rules are Karpathy's, plus the parts of five pstack principles that fit a small diff: laziness-protocol, subtract-before-you-add, sequence-verifiable-units, build-the-lever, and minimize-reader-load.

## Rules

- **Minimize the diff.** Make the smallest change that solves the problem. Every changed line traces to the request.
- **Scout rule, scoped to your diff.** Inside the functions and blocks you are already changing, fix the naming, dead code, and duplication you would otherwise work around. If the cleanup grows past a few lines, make it its own commit. Outside your diff, mention problems; don't fix them. Collapse no layers outside your diff. Match existing style, even if you'd do it differently.
- **Green before the next step.** Each unit ends in a passing check. Never build on a red one.
- **Fix the fault, not the symptom.** Reproduce first, then trace to the first wrong decision and fix every instance of that pattern (principle-fix-root-causes). After two failed fixes that share a premise, test the premise before a third (principle-attack-the-premise).
- **Levers only for repetition.** Script an edit only when it repeats or its result must be rerun to be trusted. A one-off fix stays by hand.
- Remove imports, variables, and functions that your change made unused.

## Escalate

Stop and tell the user when the fix needs the design to change: the bug is the design itself, or the fix would add one more branch to a conditional that keeps growing. Recommend `/mode rebuild` and give the reason. Don't switch silently.
