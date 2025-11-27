---
name: documentation-orchestrator
description: Orchestrates end-user documentation creation workflows with content planning, screenshot generation, and publication. Plans documentation structure, generates content with screenshots, validates readability and completeness, and publishes to appropriate location.
---

# Documentation Orchestrator

Systematic documentation creation workflow from planning to published, user-ready documentation.

## When to Use This Skill

Use when:
- Need to document new features for users
- Creating user guides, tutorials, or FAQ sections
- Updating existing documentation with screenshots
- Want systematic documentation workflow with quality validation
- Building API documentation or reference guides

## Core Principles

1. **User-First**: Write for the least technical user in your audience
2. **Show and Tell**: Combine screenshots with text descriptions for visual learners
3. **Clear and Simple**: Avoid jargon, use everyday language, short sentences
4. **Example-Driven**: Use realistic examples with real-looking data, not placeholders
5. **Maintainable**: Structure documentation for easy updates when features change

## Progress Tracking

Use `TodoWrite` to show real-time progress to the user. Create todos at workflow start, update at each phase transition.

**Phase Todos**:

| Phase | content | activeForm |
|-------|---------|------------|
| 0 | "Plan documentation structure" | "Planning documentation structure" |
| 1 | "Create content with screenshots" | "Creating content with screenshots" |
| 2 | "Review and validate" | "Reviewing and validating" |
| 3 | "Publish and integrate" | "Publishing and integrating" |

**Rules**:
- Create all phase todos at workflow start (pending)
- Mark current phase `in_progress` before execution
- Mark phase `completed` immediately after success
- State file remains source of truth for resume logic

---

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

Documentation Request: [description]
Mode: [Interactive/YOLO]

Workflow Phases:
0. [ ] Documentation Planning → documentation-planner subagent
1. [ ] Content Creation with Screenshots → user-docs-generator subagent
2. [ ] Review & Validation → documentation-reviewer subagent
3. [ ] Publication & Integration → main orchestrator

State file: [task-path]/orchestrator-state.yml

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Documentation Planning...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Documentation Planning).

---

## Execution Modes

**Interactive** (default): Pause after each phase for review
**YOLO**: Continuous execution without pauses

## Workflow Overview

4-phase workflow (0-3):

1. **Phase 0**: Documentation Planning & Audience Analysis → Delegate to `documentation-planner`
2. **Phase 1**: Content Creation with Screenshots → Delegate to `user-docs-generator` (existing)
3. **Phase 2**: Review & Validation → Delegate to `documentation-reviewer`
4. **Phase 3**: Publication & Integration → Orchestrator (main)

---

## Phase Execution

### Phase 0: Documentation Planning & Audience Analysis

**Delegate to**: `documentation-planner` subagent

**Invoke documentation-planner via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:documentation-planner"
- description: "Plan documentation structure"
- prompt: |
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

**Update State**:
```yaml
orchestrator_state:
  current_phase: 1
  last_completed_phase: 0
  phases_completed: [0]
  documentation_context:
    doc_type: "user-guide"  # or tutorial, reference, faq, api-docs
    target_audience: "end-users"  # or developers, admins, power-users
    tone: "friendly"  # or technical, formal
    readability_target:
      ease: 60  # Flesch Reading Ease
      grade: 8  # Grade level
    screenshot_count: 15
    review_passed: false
```

---

### Phase 1: Content Creation with Screenshots

**Delegate to**: `user-docs-generator` subagent

**Invoke user-docs-generator via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:user-docs-generator"
- description: "Create content with screenshots"
- prompt: |
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
- `documentation/user-guide.md` (or appropriate filename based on type)
- `documentation/screenshots/*.png`

**Success**: All sections written, screenshots captured, examples included, tone appropriate

**Update State**:
```yaml
orchestrator_state:
  current_phase: 2
  last_completed_phase: 1
  phases_completed: [0, 1]
  documentation_context:
    content_created: true
    screenshot_files: [list from filesystem]
    word_count: [calculated]
```

---

### Phase 2: Review & Validation

**Delegate to**: `documentation-reviewer` subagent

**Invoke documentation-reviewer via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:documentation-reviewer"
- description: "Review and validate"
- prompt: |
    You are the documentation-reviewer agent. Validate documentation
    completeness and readability.

Task directory: [task-path]

Inputs:
- planning/documentation-outline.md (expected structure)
- documentation/[doc-filename].md (content to review)
- documentation_context.target_audience (readability targets)

Please:
1. Check completeness (all sections from outline present)
2. Calculate readability metrics:
   - Flesch Reading Ease (target based on audience)
   - Flesch-Kincaid Grade Level (target based on audience)
3. Validate screenshots:
   - All referenced screenshots exist
   - Screenshots clear and relevant
   - Alt text present for accessibility
4. Check for broken internal links and references
5. Flag technical jargon (recommend simplification)
6. Verify examples are clear and realistic (not placeholders)
7. Assess overall clarity and usefulness
8. Generate review report with PASS/FAIL verdict

Save to: verification/documentation-review.md

Use only Read, Grep, Glob, and Bash tools. Do NOT modify content.

Verdict Criteria:
- PASS: All sections present, readability targets met, screenshots valid, no broken links
- PASS with Issues: Minor issues (jargon, slight readability miss), but usable
- FAIL: Missing sections, poor readability (<50 ease), broken links, missing screenshots
```

**Outputs**: `verification/documentation-review.md` with verdict

**Success**: Review complete, verdict determined

**Update State**:
```yaml
orchestrator_state:
  current_phase: 3 (if PASS) or halt (if FAIL)
  last_completed_phase: 2
  phases_completed: [0, 1, 2]
  documentation_context:
    review_passed: true  # or false
    readability_score:
      ease: 65  # Actual Flesch Reading Ease
      grade: 7  # Actual grade level
    issues_found: [list]
    verdict: "PASS"  # or "PASS with Issues" or "FAIL"
```

**Gate**: Cannot proceed to Phase 3 if verdict = FAIL

**On FAIL**:
- Update state with `review_passed: false`
- Report issues to user with recommendations
- HALT orchestrator
- User can fix issues and resume from Phase 1 or Phase 2

---

### Phase 3: Publication & Integration

**Execution**: Main orchestrator (direct)

**Prerequisites**: Phase 2 verdict = PASS or PASS with Issues

**Process**:

**Step 1: Format for Target Platform**

Determine publication target:
- Project documentation: `.ai-sdlc/docs/` or `docs/`
- User manual: `docs/user-guide/`
- API docs: `docs/api/`
- FAQ: `docs/faq/`

Apply formatting standards:
- Markdown for web publishing
- Ensure consistent heading levels
- Validate image paths are relative
- Apply syntax highlighting for code blocks

**Step 2: Generate Table of Contents**

```markdown
# Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Getting Started](#getting-started)
   - [Step 1: Create Account](#step-1-create-account)
   - [Step 2: Configure Settings](#step-2-configure-settings)
4. [Advanced Features](#advanced-features)
5. [Troubleshooting](#troubleshooting)
6. [FAQ](#faq)
```

Add TOC at beginning of document (after title)

**Step 3: Add Navigation Links**

Add navigation helpers:
```markdown
[← Previous: Setup Guide](setup.md) | [Next: Advanced Features →](advanced.md)
```

Add "Back to top" links for long documents

**Step 4: Integrate with Docs Structure**

Update documentation index files:
- Add entry to main docs index
- Update related documentation cross-references
- Add to navigation menu if applicable

Example: Update `docs/README.md`:
```markdown
## User Guides
- [Getting Started](user-guide/getting-started.md) ⬅️ NEW
- [Feature Overview](user-guide/features.md)
```

**Step 5: Copy to Publication Location**

```bash
# Create target directory if needed
mkdir -p docs/user-guide/

# Copy documentation
cp documentation/user-guide.md docs/user-guide/getting-started.md

# Copy screenshots
mkdir -p docs/user-guide/screenshots/
cp documentation/screenshots/* docs/user-guide/screenshots/

# Update image paths in published doc if needed
sed -i 's|documentation/screenshots/|screenshots/|g' docs/user-guide/getting-started.md
```

**Step 6: Validate Publication**

- Verify all files copied successfully
- Check image paths work in published location
- Validate links work from published location
- Ensure TOC anchors work

**Step 7: Generate Publication Summary**

Create `verification/publication-summary.md`:
```markdown
# Publication Summary

## Published Location
- **File**: docs/user-guide/getting-started.md
- **Screenshots**: docs/user-guide/screenshots/ (15 files)
- **Format**: Markdown

## Integration
- ✅ Added to docs/README.md
- ✅ Table of contents generated
- ✅ Navigation links added
- ✅ Image paths updated for published location

## Quality Metrics
- **Readability**: Flesch Ease = 65 (target: 60)
- **Word Count**: 2,450 words
- **Screenshots**: 15 images
- **Sections**: 8 complete

## Validation
- ✅ All images display correctly
- ✅ All internal links work
- ✅ TOC anchors work
- ✅ Navigation links functional

## Next Steps
1. Review published documentation at docs/user-guide/getting-started.md
2. Share with stakeholders for feedback
3. Consider publishing to documentation website
4. Gather user feedback for improvements
```

**Outputs**:
- Published documentation in target location
- Updated documentation index
- `verification/publication-summary.md`

**Success**: Documentation published, integrated, validated

**Update State**:
```yaml
orchestrator_state:
  current_phase: 3
  last_completed_phase: 3
  phases_completed: [0, 1, 2, 3]
  workflow_status: completed
  publication:
    location: "docs/user-guide/getting-started.md"
    format: "markdown"
    integrated: true
    validated: true
```

---

## State Management

**State File**: `.ai-sdlc/tasks/documentation/[dated-name]/orchestrator-state.yml`

```yaml
orchestrator:
  mode: interactive  # or yolo
  started_phase: 0
  current_phase: 2
  completed_phases: [0, 1]
  failed_phases: []

  auto_fix_attempts:
    phase-0: 0
    phase-1: 0
    phase-2: 0
    phase-3: 0

  documentation_context:
    doc_type: "user-guide"  # user-guide, tutorial, reference, faq, api-docs
    target_audience: "end-users"  # end-users, developers, admins, power-users
    tone: "friendly"  # friendly, technical, formal
    readability_target:
      ease: 60  # Flesch Reading Ease target
      grade: 8  # Grade level target
    screenshot_count: 15
    content_created: true
    review_passed: false  # MUST be true before Phase 3
    readability_score:
      ease: null  # Set in Phase 2
      grade: null  # Set in Phase 2
    issues_found: []
    verdict: null  # Set in Phase 2

  options:
    skip_screenshots: false
    custom_publication_path: null

  created: 2025-11-17T10:00:00Z
  updated: 2025-11-17T14:30:00Z
  task_path: .ai-sdlc/tasks/documentation/2025-11-17-user-guide
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| **Phase 0** | 2 | Prompt user if doc type unclear, use conservative estimates |
| **Phase 1** | 3 | Retry failed screenshots, fix formatting issues, adjust tone |
| **Phase 2** | 0 | Read-only, report only (no auto-fix) |
| **Phase 3** | 1 | Fix formatting issues, regenerate TOC, retry copy operations |

**Note**: Phase 2 is a quality gate. If review fails, user must fix issues in Phase 1 content before proceeding.

---

## Integration Points

**Existing Subagent**:
- Leverages `user-docs-generator` for Phase 1 (content and screenshots)
- No need to reimplement screenshot capture and content generation

**Playwright Integration**:
- Screenshots captured via user-docs-generator using Playwright MCP
- Requires application running for screenshot capture
- Supports full page, element, and viewport screenshots

**Documentation Structure**:
- Integrates with `.ai-sdlc/docs/` structure or project `docs/` directory
- Updates documentation indexes automatically
- Maintains cross-references and navigation

**Readability Validation**:
- Flesch Reading Ease: 60-80 for end users, 50-60 for developers
- Grade Level: <10 for general audience, <12 for technical
- Automated scoring ensures accessibility

---

## Reference Files

See `references/` directory:
- `documentation-types.md` - Five documentation types with structure patterns (user guide, tutorial, reference, FAQ, API docs)
- `writing-guidelines.md` - Writing style, tone, clarity techniques, readability metrics
- `screenshot-strategies.md` - Screenshot capture best practices, Playwright strategies, organization
- `workflow-phases.md` - Detailed 4-phase workflow with dependencies and execution patterns

---

## Related Skills

**Subagents**:
- `documentation-planner` - Documentation planning and outline creation
- `user-docs-generator` - Content generation with screenshots (existing)
- `documentation-reviewer` - Readability and completeness validation

**Optional Integration**:
- Can publish to external documentation platforms
- Can integrate with CI/CD for automated publishing

---

## Command Integration

Invoked via:
- `/ai-sdlc:documentation:new [description] [--yolo] [--type=TYPE]`
- `/ai-sdlc:documentation:resume [task-path]`

See `commands/documentation/new.md` and `commands/documentation/resume.md` for command specifications.

---

## Important Guidelines

### Readability Targets

Different audiences require different readability levels:

| Audience | Flesch Reading Ease | Grade Level | Tone |
|----------|---------------------|-------------|------|
| End Users (non-technical) | 60-80 (Standard to Easy) | 6-8 | Friendly, encouraging |
| Developers | 50-60 (Fairly Difficult) | 9-10 | Technical but clear |
| Power Users/Admins | 50-70 (Variable) | 8-10 | Professional, detailed |

**Phase 2 validation enforces these targets based on detected audience.**

### Screenshot Quality

Screenshots should:
- Show enough context (navigation visible)
- Focus on relevant area (not excessive whitespace)
- Use realistic data (professional examples)
- Be consistent in style (same browser, theme)
- Include annotations if helpful (arrows, highlights)

### Documentation Types

**User Guide** (most common):
- Purpose: Help users accomplish tasks
- Structure: Overview → Prerequisites → Steps → Troubleshooting
- Tone: Friendly, non-technical
- Example: "How to create an account"

**Tutorial**:
- Purpose: Teach through hands-on practice
- Structure: Learning objectives → Steps with explanations → Practice → Summary
- Tone: Educational, patient
- Example: "Your first API integration"

**Reference**:
- Purpose: Complete technical details
- Structure: API/function listing → Parameters → Examples → Edge cases
- Tone: Technical, precise
- Example: "API Reference"

**FAQ**:
- Purpose: Answer common questions
- Structure: Question → Answer → Link to detailed guide
- Tone: Concise, helpful
- Example: "How do I reset my password?"

**API Docs**:
- Purpose: Document endpoints and usage
- Structure: Endpoint → Method → Parameters → Request/response → Errors
- Tone: Technical, structured
- Example: "POST /api/users"

---

## Success Criteria

Workflow successful when:

✅ Documentation type classified and target audience identified
✅ Complete content outline created with all sections planned
✅ All content written in appropriate tone for target audience
✅ All required screenshots captured and properly referenced
✅ Readability metrics met (Flesch Ease, Grade Level targets)
✅ All sections from outline present in final documentation
✅ No broken links or references
✅ Technical jargon explained or simplified
✅ Examples clear and realistic (not placeholders)
✅ Documentation published and integrated with docs structure

Documentation orchestration provides complete, user-first, screenshot-rich workflow from documentation request to published, validated, accessible user documentation.
