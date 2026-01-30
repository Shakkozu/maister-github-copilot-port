---
name: ai-sdlc:enhancement:new
description: Start a new enhancement workflow (alias for /ai-sdlc:development:new --type=enhancement)
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:development-orchestrator" and args="--type=enhancement" NOW. Pass all arguments. Do not read files, explore code, or enter plan mode first.

# Enhancement Workflow

Alias for `/ai-sdlc:development:new --type=enhancement`. Starts an enhancement workflow for improving existing features.

## Usage

```bash
/ai-sdlc:enhancement:new [description] [--yolo] [--from=PHASE] [--e2e] [--user-docs]
```

### Options

- `--yolo`: Continuous execution without pauses
- `--from=PHASE`: Start from phase (`analysis`, `gap`, `spec`, `plan`, `implement`, `verify`)
- `--e2e`: Enable E2E testing
- `--user-docs`: Enable user documentation generation

## Examples

```bash
/ai-sdlc:enhancement:new "Add sorting to user table"
/ai-sdlc:enhancement:new "Add tooltips" --yolo
```

## See Also

- Unified command: `/ai-sdlc:development:new --type=enhancement`
- Workflow details: `skills/development-orchestrator/SKILL.md`
- Task output: `.ai-sdlc/tasks/enhancements/YYYY-MM-DD-name/`
