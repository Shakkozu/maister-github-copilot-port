---
name: ai-sdlc:research:resume
description: Resume an interrupted or failed research workflow from where it left off
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:research-orchestrator" NOW. Pass the task path and all arguments. Do not read files, explore code, or enter plan mode first.

# Research Workflow: Resume

Resume an interrupted research workflow from where it left off.

## Usage

```bash
/ai-sdlc:research:resume [task-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point (initialization, planning, gathering, synthesis, outputs, verification, integration)
- `--reset-attempts`: Reset auto-fix attempt counters

## Examples

```bash
/ai-sdlc:research:resume .ai-sdlc/tasks/research/2025-11-14-auth-research
/ai-sdlc:research:resume --from=synthesis
/ai-sdlc:research:resume --reset-attempts
```

## See Also

- Workflow details: `skills/research-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/research/YYYY-MM-DD-name/`
