# Recommended Plugins

Plugins are account-level — install them once via the Claude Code CLI or app. They persist across projects and sessions.

## Core

### context-mode

Context window protection. Intercepts large fetches, indexes content out-of-context, and exposes `ctx_search` / `ctx_execute` / `ctx_batch_execute` for querying indexed material without filling the conversation window. Also auto-captures session events as searchable memory.

```bash
claude plugin add context-mode
```

### anthropic-skills

Anthropic's built-in skills bundle: deep-research, docs, xlsx/pptx/pdf handling, Google Workspace integration, schedule, and more. Ships with Claude Code but may need explicit enablement.

## Optional

### frontend-design

Design guidance for frontend/UI work. Useful if you do frontend development.

```bash
claude plugin add frontend-design
```

### asana

Asana integration for task management. Requires OAuth authorization per session.

```bash
claude plugin add asana
```

### miro

Miro board integration. Requires OAuth authorization per session.

```bash
claude plugin add miro
```

## Not recommended

### context7

Library documentation server — fetches up-to-date API docs for frameworks. Low value when context-mode already handles on-demand doc fetching. Requires OAuth that must be re-authorized.

### claude-mem

Memory plugin. Superseded by context-mode's session memory and Claude Code's built-in memory system.

### superpowers

Barely used. No clear value-add over built-in capabilities.
