---
name: ai-sdlc:enhancement:resume
description: Resume an interrupted or failed enhancement workflow (alias for /ai-sdlc:development:resume)
---

# Resume Enhancement Workflow

Alias for `/ai-sdlc:development:resume`. Resumes an interrupted enhancement workflow.

MANDATORY: Using Skill tool load development-orchestrator skill in resume mode.

## Usage

```bash
/ai-sdlc:enhancement:resume [task-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point
- `--reset-attempts`: Reset auto-fix attempt counters

## Examples

```bash
/ai-sdlc:enhancement:resume
/ai-sdlc:enhancement:resume .ai-sdlc/tasks/enhancements/2025-01-15-add-sorting/
```

## See Also

- Unified command: `/ai-sdlc:development:resume`
- Workflow details: `skills/development-orchestrator/SKILL.md`
