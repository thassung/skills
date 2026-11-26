---
name: mode
description: Set the working mode for code changes. surgical for hotfixes, bugfixes, and small changes; rebuild for new features, revamps, and migrations; default to clear a forced mode. Use at the start of any task that changes code, or for /mode.
argument-hint: "[default|surgical|rebuild]"
---

# Mode

Requested mode (blank if none given): $ARGUMENTS

- `surgical`: read `surgical.md` in this skill's folder and follow it.
- `rebuild`: read `rebuild.md` in this skill's folder and follow it.
- `default`: drop any mode the user forced earlier in this conversation. From the next task on, pick the mode per task using the Modes section of `~/.claude/CLAUDE.md`. Reply in one line naming the mode you cleared, or saying none was forced.
- Empty or anything else: reply in one line with the mode in effect (forced, picked for the current task, or none) and the three choices.

Who chose the mode decides how long it holds:

- **The user typed `/mode surgical` or `/mode rebuild`.** The mode is forced. It holds for the rest of the conversation, until `/mode` with another value.
- **You invoked this skill yourself at the start of a task.** The mode holds for that task only. Open your reply with one line: `Mode: <mode> — <reason>`.
- **A spec names the mode.** Work from that spec (`/implement`, `/implement-spec`, `/orchestrator`, `/tdd` on one of its tickets) uses the spec's mode instead of picking one. Say so in the opening line: `Mode: <mode> — from the spec`. A user-forced mode still wins.

## Planning

The mode is decided while the change is planned, not when the code is written. A plan bakes in how much of the design may change, and a ticket can't undo that.

1. **Start surgical** when you begin grilling a feature or writing its spec. Read the Planning section of `surgical.md`.
2. **Ask: can the requirement be met cleanly inside the current design?** Switch to rebuild, saying why, as soon as one of these turns up: a concept or data shape the code doesn't have; a seam or module that doesn't exist yet; one more branch on a conditional that keeps growing; an assumption of the current design that the requirement breaks; a migration. It stays surgical while it fits existing types and modules and you can name the pattern or seam it follows. Propose the mode with that evidence and let the user confirm.
3. **Record it in the spec** as the first line of Implementation Decisions: `Mode: <surgical|rebuild> — <evidence>`. Tickets repeat it on their own `Mode:` line. A `/wayfinder` map whose destination is a code change records it in its Notes the same way; every session working the map takes the mode from there, updates that line when a resolution shows the design has to change, and the spec the map hands off copies it.
4. **If the design turns out wrong mid-build**, the implementer stops and reports; the spec gets revisited. Don't redesign inside one ticket.
