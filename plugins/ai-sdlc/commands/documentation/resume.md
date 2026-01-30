---
name: ai-sdlc:documentation:resume
description: Resume an interrupted or failed documentation workflow from where it left off
---

**ACTION REQUIRED**: This command delegates to a different skill. The `<command-name>` tag refers to THIS command, not the target. Call the Skill tool with skill="ai-sdlc:documentation-orchestrator" NOW. Pass the task path and all arguments. Do not read files, explore code, or execute workflow steps yourself.

# Documentation Workflow: Resume

Resume an interrupted documentation workflow from where it left off.

## Usage

```bash
/ai-sdlc:documentation:resume [task-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point (planning, content, review, publication)
- `--reset-attempts`: Reset auto-fix attempt counters

## Examples

```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide
/ai-sdlc:documentation:resume --from=content
/ai-sdlc:documentation:resume --reset-attempts
```

## See Also

- Workflow details: `skills/documentation-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/documentation/YYYY-MM-DD-name/`
