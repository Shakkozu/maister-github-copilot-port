---
name: ai-sdlc:refactoring:new
description: Start a new refactoring workflow with guided orchestration through all phases
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:refactoring-orchestrator" NOW. Pass all arguments. Do not read files, explore code, or enter plan mode first.

# Refactoring Workflow: New

Start safe, incremental refactoring to improve code quality while preserving behavior exactly.

## Usage

```bash
/ai-sdlc:refactoring:new [description] [--yolo] [--from=PHASE]
```

### Options

- `--yolo`: Continuous execution without pauses
- `--from=PHASE`: Start from phase (baseline, planning, snapshot, execution, verification, quality)

## Examples

```bash
/ai-sdlc:refactoring:new "Extract validation logic from UserService"
/ai-sdlc:refactoring:new "Simplify nested conditionals in processOrder" --yolo
/ai-sdlc:refactoring:new "Restructure 800-line UserManager into focused classes"
```

## See Also

- Workflow details: `skills/refactoring-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/refactoring/YYYY-MM-DD-name/`
