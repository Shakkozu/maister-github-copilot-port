---
name: ai-sdlc:performance:new
description: Start a performance optimization workflow with profiling, benchmarking, and load testing
---

**ACTION REQUIRED**: This command delegates to a different skill. The `<command-name>` tag refers to THIS command, not the target. Call the Skill tool with skill="ai-sdlc:performance-orchestrator" NOW. Pass all arguments. Do not read files, explore code, or execute workflow steps yourself.

# Performance Optimization Workflow: New

Start comprehensive performance optimization from profiling through production-ready deployment.

## Usage

```bash
/ai-sdlc:performance:new [description] [--yolo] [--from=PHASE]
```

### Options

- `--yolo`: Continuous execution without pauses
- `--from=PHASE`: Start from phase (baseline, analysis, implementation, verification, load-testing)

## Examples

```bash
/ai-sdlc:performance:new "Dashboard page loading slowly"
/ai-sdlc:performance:new "API response time >1 second" --yolo
/ai-sdlc:performance:new --from=implementation
```

## See Also

- Workflow details: `skills/performance-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/performance/YYYY-MM-DD-name/`
