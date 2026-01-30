---
name: ai-sdlc:migration:resume
description: Resume an interrupted or failed migration workflow from where it left off
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:migration-orchestrator" NOW. Pass the task path and all arguments. Do not read files, explore code, or enter plan mode first.

# Migration Workflow: Resume

Resume an interrupted migration from where it left off.

## Usage

```bash
/ai-sdlc:migration:resume [task-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point (analysis, target, spec, plan, execute, verify, docs)
- `--reset-attempts`: Reset auto-fix attempt counters

## Examples

```bash
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-20-express-fastify
/ai-sdlc:migration:resume --from=verify
/ai-sdlc:migration:resume --reset-attempts
```

## See Also

- Workflow details: `skills/migration-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/migrations/YYYY-MM-DD-name/`
