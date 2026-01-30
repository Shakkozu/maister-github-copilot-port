---
name: ai-sdlc:initiative:resume
description: Resume an interrupted or failed initiative workflow from where it left off
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:initiative-orchestrator" NOW. Pass the task path and all arguments. Do not read files, explore code, or enter plan mode first.

# Initiative Workflow: Resume

Resume an interrupted initiative from where it left off.

## Usage

```bash
/ai-sdlc:initiative:resume [initiative-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point (planning, task-creation, dependency-resolution, task-execution, verification, finalization)
- `--reset-attempts`: Reset auto-fix attempt counters
- `--clear-failures`: Clear failed task list and re-evaluate

## Examples

```bash
/ai-sdlc:initiative:resume .ai-sdlc/docs/project/initiatives/2025-11-14-auth-system
/ai-sdlc:initiative:resume --from=task-execution
/ai-sdlc:initiative:resume --clear-failures --reset-attempts
```

## See Also

- Workflow details: `skills/initiative-orchestrator/skill.md`
- Check progress: `/ai-sdlc:initiative:status [path]`
- Initiative output: `.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name/`
