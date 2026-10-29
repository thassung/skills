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
