---
name: ai-sdlc:performance:resume
description: Resume an interrupted or failed performance optimization workflow from where it left off
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:performance-orchestrator" NOW. Pass the task path and all arguments. Do not read files, explore code, or enter plan mode first.

# Performance Optimization Workflow: Resume

Resume an interrupted performance optimization from where it left off.

## Usage

```bash
/ai-sdlc:performance:resume [task-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point (baseline, analysis, implementation, verification, load-testing)
- `--reset-attempts`: Reset auto-fix attempt counters

## Examples

```bash
/ai-sdlc:performance:resume .ai-sdlc/tasks/performance/2025-11-16-dashboard-perf
/ai-sdlc:performance:resume --from=verification
/ai-sdlc:performance:resume --reset-attempts
```

## See Also

- Workflow details: `skills/performance-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/performance/YYYY-MM-DD-name/`
