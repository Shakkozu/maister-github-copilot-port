---
name: ai-sdlc:bug-fix:new
description: Start a comprehensive bug fixing workflow (alias for /ai-sdlc:development:new --type=bug)
---

# Bug Fix Workflow

Alias for `/ai-sdlc:development:new --type=bug`. Starts a bug fix workflow with TDD Red→Green gates.

**Invoke**: development-orchestrator skill with `task_type=bug`

## Usage

```bash
/ai-sdlc:bug-fix:new [description] [--yolo] [--from=PHASE]
```

### Options

- `--yolo`: Continuous execution (TDD gates still enforced)
- `--from=PHASE`: Start from phase (`analysis`, `gap`, `tdd-red`, `spec`, `plan`, `implement`, `tdd-green`, `verify`)

## Examples

```bash
/ai-sdlc:bug-fix:new "Fix login timeout with special characters"
/ai-sdlc:bug-fix:new "Null pointer in profile page" --yolo
```

## See Also

- Unified command: `/ai-sdlc:development:new --type=bug`
- Workflow details: `skills/development-orchestrator/SKILL.md`
- Task output: `.ai-sdlc/tasks/bug-fixes/YYYY-MM-DD-name/`
