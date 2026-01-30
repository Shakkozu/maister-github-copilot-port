---
name: ai-sdlc:documentation:new
description: Start a documentation creation workflow with content planning, screenshot generation, and publication
---

**ACTION REQUIRED**: This command delegates to a different skill. The `<command-name>` tag refers to THIS command, not the target. Call the Skill tool with skill="ai-sdlc:documentation-orchestrator" NOW. Pass all arguments. Do not read files, explore code, or execute workflow steps yourself.

# Documentation Workflow: New

Start comprehensive documentation creation from planning through publication with screenshot automation.

## Usage

```bash
/ai-sdlc:documentation:new [description] [--yolo] [--from=PHASE] [--type=TYPE]
```

### Options

- `--yolo`: Continuous execution without pauses
- `--from=PHASE`: Start from phase (planning, content, review, publication)
- `--type=TYPE`: Documentation type (user-guide, tutorial, reference, faq, api-docs)

## Examples

```bash
/ai-sdlc:documentation:new "User guide for project management"
/ai-sdlc:documentation:new "Quick start guide" --yolo
/ai-sdlc:documentation:new "FAQ for authentication" --type=faq
```

## See Also

- Workflow details: `skills/documentation-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/documentation/YYYY-MM-DD-name/`
