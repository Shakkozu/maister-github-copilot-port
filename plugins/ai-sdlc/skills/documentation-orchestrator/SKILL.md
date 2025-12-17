---
name: documentation-orchestrator
description: Orchestrates end-user documentation creation workflows with content planning, screenshot generation, and publication. Plans documentation structure, generates content with screenshots, validates readability and completeness, and publishes to appropriate location.
---

# Documentation Orchestrator

Systematic documentation creation workflow from planning to published, user-ready documentation.

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Plan documentation structure", "status": "pending", "activeForm": "Planning documentation structure"},
  {"content": "Create content with screenshots", "status": "pending", "activeForm": "Creating content with screenshots"},
  {"content": "Review and validate", "status": "pending", "activeForm": "Reviewing and validating"},
  {"content": "Publish and integrate", "status": "pending", "activeForm": "Publishing and integrating"}
]
```

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Documentation Orchestrator Started

Task: [documentation request description]
Mode: [Interactive/YOLO]
Directory: [task-path]

Workflow phases:
[Todos list with status]

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Plan documentation structure...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Documentation Planning & Audience Analysis).

---

## When to Use This Skill

Use when:
- Need to document new features for users
- Creating user guides, tutorials, or FAQ sections
- Updating existing documentation with screenshots
- Want systematic documentation workflow with quality validation
- Building API documentation or reference guides

## Core Principles

1. **User-First**: Write for the least technical user in your audience
2. **Show and Tell**: Combine screenshots with text descriptions
3. **Clear and Simple**: Avoid jargon, use everyday language
4. **Example-Driven**: Use realistic examples, not placeholders
5. **Maintainable**: Structure for easy updates when features change

---

## Framework Patterns

This orchestrator follows shared patterns. See:

- **Phase Execution**: `../orchestrator-framework/references/phase-execution-pattern.md`
- **State Management**: `../orchestrator-framework/references/state-management.md`
- **Interactive Mode**: `../orchestrator-framework/references/interactive-mode.md`
- **Initialization**: `../orchestrator-framework/references/initialization-pattern.md`

---

## Phase Configuration

| Phase | content | activeForm | Agent/Skill |
|-------|---------|------------|-------------|
| 0 | "Plan documentation structure" | "Planning documentation structure" | documentation-planner |
| 1 | "Create content with screenshots" | "Creating content with screenshots" | user-docs-generator |
| 2 | "Review and validate" | "Reviewing and validating" | documentation-reviewer |
| 3 | "Publish and integrate" | "Publishing and integrating" | orchestrator |

**Workflow Overview**: 4 phases (0-3)

**CRITICAL TodoWrite Usage**:
1. At workflow start: Create todos for ALL phases using the Phase Configuration table above (all status=pending)
2. Before each phase: Update that phase to status=in_progress
3. After each phase: Update that phase to status=completed

---

## Workflow Phases

### Phase 0: Documentation Planning & Audience Analysis

**Delegate to**: `documentation-planner` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:documentation-planner"
description: "Plan documentation structure"
prompt: |
  You are the documentation-planner agent. Analyze documentation requirements
  and create structured content outline.

  Documentation Request: [user description]
  Task directory: [task-path]

  Please:
  1. Classify documentation type (user guide, tutorial, reference, FAQ, API docs)
  2. Identify target audience (end users, developers, admins, power users)
  3. Determine appropriate tone and complexity level
  4. Create detailed content outline with sections
  5. Identify required screenshots and visual examples
  6. Estimate documentation scope (pages, screenshots, time)
  7. Generate comprehensive documentation plan

  Save to: planning/documentation-outline.md
  Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `planning/documentation-outline.md`

**Success**: Doc type classified, audience identified, outline complete with screenshot requirements

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 1.

---

### Phase 1: Content Creation with Screenshots

**Delegate to**: `user-docs-generator` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:user-docs-generator"
description: "Create content with screenshots"
prompt: |
  You are the user-docs-generator agent. Generate documentation content
  with screenshots using the structured outline.

  Task directory: [task-path]
  Input: planning/documentation-outline.md

  Please:
  1. Read documentation outline and requirements
  2. Identify user-facing workflows from outline
  3. Generate content following outline structure
  4. Capture clear screenshots using Playwright for each step
  5. Write step-by-step instructions in appropriate tone
  6. Include realistic examples with proper data
  7. Add tips, warnings, and best practices
  8. Create comprehensive user documentation

  Save to: documentation/[doc-filename].md
  Screenshots: documentation/screenshots/
  Use Read, Write, Bash, and Playwright tools for screenshot capture.
```

**Outputs**:
- `documentation/user-guide.md` (or appropriate filename)
- `documentation/screenshots/*.png`

**Success**: All sections written, screenshots captured, examples included

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 2.

---

### Phase 2: Review & Validation

**Delegate to**: `documentation-reviewer` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:documentation-reviewer"
description: "Review and validate"
prompt: |
  You are the documentation-reviewer agent. Validate documentation
  completeness and readability.

  Task directory: [task-path]
  Inputs:
  - planning/documentation-outline.md
  - documentation/[doc-filename].md

  Please:
  1. Check completeness (all sections from outline present)
  2. Calculate readability metrics (Flesch Reading Ease, Grade Level)
  3. Validate screenshots exist and are clear
  4. Check for broken links and references
  5. Flag technical jargon (recommend simplification)
  6. Verify examples are clear and realistic
  7. Assess overall clarity and usefulness
  8. Generate review report with PASS/FAIL verdict

  Save to: verification/documentation-review.md
  Use only Read, Grep, Glob, and Bash tools. Do NOT modify content.

  Verdict Criteria:
  - PASS: All sections present, readability targets met, screenshots valid
  - PASS with Issues: Minor issues but usable
  - FAIL: Missing sections, poor readability (<50 ease), broken links
```

**Outputs**: `verification/documentation-review.md` with verdict

**Gate**: Cannot proceed to Phase 3 if verdict = FAIL

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 3.

---

### Phase 3: Publication & Integration

**Execution**: Main orchestrator (direct)

**Prerequisites**: Phase 2 verdict = PASS or PASS with Issues

**Process**:

1. **Format for Target Platform** - Apply markdown standards, validate image paths
2. **Generate Table of Contents** - Create TOC with anchor links
3. **Add Navigation Links** - Previous/next page navigation
4. **Integrate with Docs Structure** - Update documentation index
5. **Copy to Publication Location** - Move to target directory, update paths
6. **Validate Publication** - Verify files, links, and images work
7. **Generate Summary** - Create `verification/publication-summary.md`

**Outputs**:
- Published documentation in target location
- Updated documentation index
- `verification/publication-summary.md`

**Success**: Documentation published, integrated, validated

---

## Domain Context (State Extensions)

Documentation-specific fields in `orchestrator-state.yml`:

```yaml
documentation_context:
  doc_type: "user-guide" | "tutorial" | "reference" | "faq" | "api-docs"
  target_audience: "end-users" | "developers" | "admins" | "power-users"
  tone: "friendly" | "technical" | "formal"
  readability_target:
    ease: [60-80 for users, 50-60 for devs]
    grade: [6-8 for users, 9-10 for devs]
  screenshot_count: [number]
  content_created: false
  review_passed: false
  readability_score:
    ease: [actual score]
    grade: [actual grade]
  verdict: "PASS" | "PASS with Issues" | "FAIL"

options:
  skip_screenshots: false
  custom_publication_path: null

publication:
  location: [path]
  format: "markdown"
  integrated: false
  validated: false
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| 0 | 2 | Prompt user if doc type unclear, use conservative estimates |
| 1 | 3 | Retry failed screenshots, fix formatting, adjust tone |
| 2 | 0 | Read-only, report only (no auto-fix) |
| 3 | 1 | Fix formatting issues, regenerate TOC, retry copy |

---

## Readability Targets

| Audience | Flesch Reading Ease | Grade Level | Tone |
|----------|---------------------|-------------|------|
| End Users (non-technical) | 60-80 | 6-8 | Friendly |
| Developers | 50-60 | 9-10 | Technical |
| Power Users/Admins | 50-70 | 8-10 | Professional |

---

## Documentation Types

| Type | Purpose | Structure |
|------|---------|-----------|
| **User Guide** | Help users accomplish tasks | Overview → Prerequisites → Steps → Troubleshooting |
| **Tutorial** | Teach through hands-on practice | Objectives → Steps → Practice → Summary |
| **Reference** | Complete technical details | Listing → Parameters → Examples → Edge cases |
| **FAQ** | Answer common questions | Question → Answer → Link to details |
| **API Docs** | Document endpoints | Endpoint → Method → Parameters → Response |

---

## Command Integration

Invoked via:
- `/ai-sdlc:documentation:new [description] [--yolo] [--type=TYPE]`
- `/ai-sdlc:documentation:resume [task-path]`

Task directory: `.ai-sdlc/tasks/documentation/YYYY-MM-DD-task-name/`

---

## Success Criteria

Workflow successful when:

- Documentation type classified and audience identified
- Complete content outline with all sections planned
- Content written in appropriate tone for audience
- All screenshots captured and properly referenced
- Readability metrics met (Flesch Ease, Grade Level targets)
- No broken links or references
- Technical jargon explained or simplified
- Documentation published and integrated
