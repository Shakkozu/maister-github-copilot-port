---
name: documentation:new
description: Start a documentation creation workflow with content planning, screenshot generation, and publication
---

# Documentation Workflow: New

Start comprehensive documentation creation from planning through publication with screenshot automation.

## Usage

```bash
/ai-sdlc:documentation:new [description] [--yolo] [--from=PHASE] [--type=TYPE]
```

### Arguments

- **description** (optional): What to document
  - Example: "User guide for account management"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `planning`, `content`, `review`, `publication`
  - Default: `planning`
- `--type=TYPE`: Documentation type (auto-detected if omitted)
  - Values: `user-guide`, `tutorial`, `reference`, `faq`, `api-docs`

## Examples

```bash
# User guide (interactive)
/ai-sdlc:documentation:new "User guide for project management"

# Tutorial
/ai-sdlc:documentation:new "Tutorial for building your first dashboard"

# FAQ
/ai-sdlc:documentation:new "FAQ for authentication" --type=faq

# YOLO mode (fast)
/ai-sdlc:documentation:new "Quick start guide" --yolo

# Resume from phase
/ai-sdlc:documentation:new --from=content
```

## What This Does

**Invoke the documentation-orchestrator skill** which guides through 4 phases:

**Phase 0: Documentation Planning** → `documentation-planner` agent
- Classify doc type and target audience
- Determine tone (friendly, technical, formal)
- Create content outline with sections
- Identify required screenshots

**Phase 1: Content Creation** → `user-docs-generator` agent
- Generate documentation following outline
- Capture screenshots via Playwright
- Write step-by-step instructions
- Include examples and tips

**Phase 2: Review & Validation** → `documentation-reviewer` agent
- Calculate readability metrics (Flesch scores)
- Verify completeness and screenshots
- Check for broken links
- Generate PASS/FAIL verdict

**Phase 3: Publication**
- Format for target platform
- Generate table of contents
- Integrate with existing docs

## Documentation Types

| Type | Audience | Tone | Readability Target |
|------|----------|------|-------------------|
| User Guide | End users | Friendly | Grade <8 |
| Tutorial | Learners | Educational | Grade <10 |
| Reference | Developers | Technical | Grade <12 |
| FAQ | End users | Direct | Grade <8 |
| API Docs | Developers | Structured | Grade <10 |

## Outputs

Task directory: `.ai-sdlc/tasks/documentation/YYYY-MM-DD-name/`

- `planning/documentation-outline.md` - Content outline
- `documentation/[doc-name].md` - Generated documentation
- `documentation/screenshots/` - Captured screenshots
- `verification/documentation-review.md` - Review report

## Execution Modes

**Interactive** (default): Pauses after each phase. Review content before publication.

**YOLO** (`--yolo`): Runs continuously. Best for straightforward documentation.

## Auto-Recovery

- **Planning**: Retry if doc type unclear (max 2)
- **Content**: Retry failed screenshots (max 3)
- **Review**: Returns to content if fails (read-only)
- **Publication**: Fix formatting (max 1)

## Prerequisites

- **For screenshots**: Playwright configured, app running
- **For API docs**: API endpoints accessible

## Resume

If interrupted:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide
```

---

**Invoke**: documentation-orchestrator skill
