# Documentation Orchestrator Implementation Plan

## Overview

**Purpose**: Orchestrate end-user documentation creation workflows with content planning, screenshot generation, and publication.

**Task Type**: Documentation (4 stages)
**Classification Keywords**: "document", "docs", "write guide", "FAQ", "user manual"

**Total Files to Create**: 9 files
**Estimated Time**: 2-3 hours

**Note**: This orchestrator leverages the existing `user-docs-generator` subagent for content creation.

---

## Workflow Phases (4 phases)

1. **Phase 0: Documentation Planning & Audience Analysis**
   - Identify documentation type (user guide, API docs, tutorial, FAQ)
   - Analyze target audience (end users, developers, admins)
   - Determine content structure and sections
   - Identify required screenshots and examples
   - Create documentation outline

2. **Phase 1: Content Creation with Screenshots**
   - Generate documentation content (leverage existing `user-docs-generator`)
   - Capture screenshots using Playwright
   - Write step-by-step instructions
   - Include examples with realistic data
   - Add tips, warnings, and best practices

3. **Phase 2: Review & Validation**
   - Validate completeness (all sections covered)
   - Check readability (Flesch reading ease, grade level)
   - Verify screenshot clarity and relevance
   - Validate links and references
   - Check for technical jargon (flag for simplification)

4. **Phase 3: Publication & Integration**
   - Format for target platform (Markdown, HTML, PDF)
   - Generate table of contents
   - Add navigation links
   - Integrate with existing documentation structure
   - Update documentation index

---

## Files to Create

### Subagents (2 files)

#### 1. `agents/documentation-planner.md` (~600 lines)

**Purpose**: Plan documentation structure and content outline

**Capabilities**:
- Classify documentation type (user guide, tutorial, reference, FAQ, API docs)
- Identify target audience (end user, admin, developer, power user)
- Determine appropriate tone and complexity level
- Create content outline with sections
- Identify required screenshots and examples
- Estimate documentation scope (pages, screenshots, time)

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `planning/documentation-outline.md` with structure and requirements

**Key Sections**:
- Agent metadata (YAML frontmatter)
- Purpose and responsibilities
- 7-phase workflow (Classify type → Identify audience → Determine tone → Create outline → Identify screenshots → Estimate scope → Generate plan)
- Documentation type classification (5 types: user guide, tutorial, reference, FAQ, API docs)
- Audience analysis framework
- Tone guidelines per audience (friendly, technical, formal)
- Outline structure patterns per doc type
- Content planning best practices

---

#### 2. `agents/documentation-reviewer.md` (~650 lines)

**Purpose**: Validate documentation completeness and readability

**Capabilities**:
- Check completeness (all sections from outline present)
- Calculate readability metrics (Flesch Reading Ease, Flesch-Kincaid Grade Level)
- Validate screenshots (exist, clear, referenced in text)
- Check for broken links and references
- Flag technical jargon and suggest simplification
- Verify examples are clear and realistic
- Generate review report with issues and recommendations

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `verification/documentation-review.md` with PASS/FAIL verdict

**Key Sections**:
- Agent metadata
- 8-phase workflow (Check completeness → Calculate readability → Validate screenshots → Check links → Flag jargon → Verify examples → Assess clarity → Generate report)
- Readability metrics calculation (Flesch formulas)
- Completeness checklist (sections, screenshots, examples)
- Jargon detection patterns
- Link validation approach
- Clarity assessment criteria
- Review report structure with verdict (PASS if readable and complete, FAIL if issues)

---

### References (4 files)

#### 3. `skills/documentation-orchestrator/references/documentation-types.md` (~550 lines)

**Purpose**: Documentation types and their characteristics

**Content**:
- **User Guide**
  - Purpose: Help users accomplish tasks
  - Structure: Overview → Prerequisites → Step-by-step instructions → Troubleshooting
  - Tone: Friendly, encouraging, non-technical
  - Audience: End users (non-technical)
  - Examples: "How to create an account", "Managing your profile"

- **Tutorial**
  - Purpose: Teach through hands-on practice
  - Structure: Learning objectives → Prerequisites → Steps with explanations → Practice exercises → Summary
  - Tone: Educational, patient, detailed
  - Audience: Users wanting to learn (beginner to intermediate)
  - Examples: "Your first API integration", "Building a dashboard"

- **Reference Documentation**
  - Purpose: Provide complete technical details
  - Structure: API/function listing → Parameters → Return values → Examples → Edge cases
  - Tone: Technical, precise, comprehensive
  - Audience: Developers, power users
  - Examples: "API Reference", "Configuration options"

- **FAQ (Frequently Asked Questions)**
  - Purpose: Answer common questions quickly
  - Structure: Question → Short answer → Link to detailed guide (if applicable)
  - Tone: Concise, helpful, direct
  - Audience: All users
  - Examples: "How do I reset my password?", "Why can't I upload files?"

- **API Documentation**
  - Purpose: Document API endpoints and usage
  - Structure: Endpoint → HTTP method → Parameters → Request/response examples → Error codes
  - Tone: Technical, precise, structured
  - Audience: Developers
  - Examples: "POST /api/users", "Authentication endpoints"

- **Type Selection Guide** (when to use which type)

---

#### 4. `skills/documentation-orchestrator/references/writing-guidelines.md` (~600 lines)

**Purpose**: Writing style, tone, and clarity guidelines

**Content**:
- **Writing for Non-Technical Users**
  - Use simple, everyday language (avoid jargon)
  - Explain "why" not just "how"
  - Use active voice ("Click the button" not "The button should be clicked")
  - Second person ("you" not "the user")
  - Short sentences (15-20 words max)
  - Short paragraphs (3-4 sentences)

- **Tone Guidelines**
  - Friendly and encouraging (not condescending)
  - Helpful and supportive (not frustrated)
  - Clear and confident (not uncertain)
  - Concise but complete (not terse)

- **Structure Guidelines**
  - Logical flow (overview → steps → verification → next steps)
  - Numbered steps for procedures
  - Bullet points for lists
  - Headers for navigation
  - Summary/TLDR at top for long docs

- **Readability Metrics**
  - Flesch Reading Ease: 60-70 = Standard, 70-80 = Easy, 80-90 = Very Easy
  - Flesch-Kincaid Grade Level: 6-8 = General public, 9-10 = High school
  - Target: Reading Ease > 60, Grade Level < 10 for user-facing docs

- **Clarity Techniques**
  - Use analogies and comparisons
  - Provide examples with realistic data
  - Show expected results ("What you should see")
  - Add visual indicators (✅ ⚠️ 💡 ❌)
  - Include screenshots for visual learners

- **Common Mistakes to Avoid**
  - Assuming prior knowledge
  - Using technical jargon without explanation
  - Passive voice ("It is recommended" → "We recommend")
  - Ambiguous pronouns ("it", "this", "that")
  - Missing context or prerequisites

---

#### 5. `skills/documentation-orchestrator/references/screenshot-strategies.md` (~500 lines)

**Purpose**: Screenshot capture strategies and best practices

**Content**:
- **What to Screenshot**
  - Initial state (before action)
  - Action being performed (button click, form fill)
  - Result state (after action, success message)
  - Error states (validation errors, warnings)
  - Navigation elements (menus, tabs, breadcrumbs)

- **Screenshot Composition**
  - Focus on relevant area (not entire screen unless needed)
  - Include enough context (navigation visible)
  - Highlight important elements (arrows, boxes, circles)
  - Use consistent style (same browser, theme)
  - Clean up test data (use realistic, professional examples)

- **Naming Convention**
  - Descriptive names: `01-login-page.png`, `02-enter-credentials.png`, `03-dashboard.png`
  - Sequential numbering for step-by-step guides
  - Feature prefix for related screenshots: `profile-edit-form.png`, `profile-success.png`

- **Playwright Screenshot Strategies**
  - Full page screenshots for overviews (`fullPage: true`)
  - Element screenshots for specific components
  - Viewport screenshots for standard captures
  - Wait for network idle before capturing
  - Wait for animations to complete

- **Screenshot Organization**
  - Store in `documentation/screenshots/` directory
  - Subdirectories per guide if many screenshots
  - Reference in Markdown: `![Description](screenshots/filename.png)`

- **Accessibility Considerations**
  - Alt text for every screenshot (describe what it shows)
  - Don't rely solely on screenshots (describe in text too)
  - High contrast for readability
  - Sufficient size for clarity

- **Screenshot Maintenance**
  - Update screenshots when UI changes
  - Version screenshots if supporting multiple versions
  - Document screenshot capture date

---

#### 6. `skills/documentation-orchestrator/references/workflow-phases.md` (~600 lines)

**Purpose**: 4-phase workflow with dependencies and execution patterns

**Content**:
- **Phase 0: Documentation Planning & Audience Analysis**
  - Agent: `documentation-planner`
  - Input: Documentation request description
  - Process: Classify type → Identify audience → Determine tone → Create outline → Identify screenshots → Generate plan
  - Output: `planning/documentation-outline.md`
  - Success criteria: Doc type classified, audience identified, outline complete with screenshot list
  - Auto-fix: Max 2 attempts (prompt user if doc type unclear)

- **Phase 1: Content Creation with Screenshots**
  - Agent: `user-docs-generator` (existing subagent)
  - Input: Documentation outline
  - Process: Generate content → Capture screenshots using Playwright → Write instructions → Add examples → Include tips
  - Output: `documentation/user-guide.md` (or appropriate filename), `documentation/screenshots/`
  - Success criteria: All sections written, screenshots captured, examples included
  - Auto-fix: Max 3 attempts (retry failed screenshots, fix formatting)

- **Phase 2: Review & Validation**
  - Agent: `documentation-reviewer`
  - Input: Documentation content + outline
  - Process: Check completeness → Calculate readability → Validate screenshots → Check links → Flag jargon → Generate report
  - Output: `verification/documentation-review.md`
  - Success criteria: Completeness ✅, readability ✅ (>60 ease, <10 grade), screenshots ✅, links ✅
  - Auto-fix: Max 0 attempts (read-only, reports only)

- **Phase 3: Publication & Integration**
  - Agent: Main orchestrator
  - Input: Documentation content + review report (PASS required)
  - Process: Format for platform → Generate TOC → Add navigation → Integrate with docs structure → Update index
  - Output: Published documentation in appropriate location
  - Success criteria: Documentation published, TOC generated, navigation working, index updated
  - Auto-fix: Max 1 attempt (fix formatting issues, regenerate TOC)

- **Phase Dependencies**: 0 → 1 → 2 → 3 (sequential, cannot skip, Phase 3 requires Phase 2 PASS)
- **Execution Modes**: Interactive (pause between phases) and YOLO (continuous)
- **State Management**: `orchestrator-state.yml` tracks progress, doc type, audience

---

### Main Skill File

#### 7. `skills/documentation-orchestrator/SKILL.md` (~850 lines)

**Purpose**: Main orchestrator with phase execution instructions

**Content Structure**:
- **Skill metadata** (YAML frontmatter)
  ```yaml
  ---
  name: documentation-orchestrator
  description: Orchestrates end-user documentation creation workflows with content planning, screenshot generation, and publication
  ---
  ```

- **When to Use This Skill**
  - Need to document new feature for users
  - Creating user guide, tutorial, or FAQ
  - Updating existing documentation with screenshots
  - Want systematic documentation workflow

- **Core Principles**
  - User-first (write for least technical user)
  - Show and tell (screenshots + text descriptions)
  - Clear and simple (avoid jargon, short sentences)
  - Example-driven (realistic examples, not placeholders)
  - Maintainable (easy to update when features change)

- **Execution Modes** (Interactive vs YOLO)

- **Workflow Phases** (detailed step-by-step for each phase)
  - Phase 0: Documentation Planning & Audience Analysis
  - Phase 1: Content Creation with Screenshots (leverages user-docs-generator)
  - Phase 2: Review & Validation
  - Phase 3: Publication & Integration

- **Orchestrator Workflow Execution**
  - Initialization (parse args, determine doc type, initialize state)
  - Phase execution loop (for each phase)
  - Integration with existing user-docs-generator subagent (Phase 1)
  - Finalization (generate summary, update metadata, publish)

- **State Management** (`orchestrator-state.yml` format with doc context)
  ```yaml
  documentation_context:
    doc_type: "user-guide"  # user-guide, tutorial, reference, faq, api-docs
    target_audience: "end-users"  # end-users, developers, admins, power-users
    tone: "friendly"  # friendly, technical, formal
    readability_target:
      ease: 60  # Flesch Reading Ease target
      grade: 8  # Grade level target
    screenshot_count: 15
    review_passed: false  # MUST be true before Phase 3
  ```

- **Auto-Recovery Features** (per phase with max attempts)

- **Integration Points**
  - Existing `user-docs-generator` subagent (Phase 1)
  - Playwright for screenshots (via user-docs-generator)
  - Documentation structure in `.ai-sdlc/docs/` or project docs/

- **Important Guidelines** (documentation best practices, readability targets, screenshot quality)

- **Reference Files** (list of references/ directory contents)

- **Example Workflows** (4-5 examples: user guide creation, tutorial, FAQ, API docs update)

- **Validation Checklist** (before publication)

- **Success Criteria** (10 criteria including readability, completeness, screenshots)

---

### Command Files (2 files)

#### 8. `commands/documentation/new.md` (~400 lines)

**Purpose**: Command documentation for starting new documentation workflow

**Content**:
- Command frontmatter (YAML)
  ```yaml
  ---
  name: documentation:new
  description: Start a documentation creation workflow with content planning, screenshot generation, and publication
  category: Documentation Workflows
  ---
  ```

- **Command Usage**
  ```bash
  /ai-sdlc:documentation:new [description] [--yolo] [--from=phase] [--type=TYPE]
  ```

- **Arguments and Options**
  - description: What to document
  - --yolo: Continuous execution
  - --from=PHASE: Start from specific phase
  - --type=TYPE: Documentation type (user-guide, tutorial, reference, faq, api-docs)

- **Examples** (5-6 examples)
  - Example 1: User guide creation
  - Example 2: Tutorial creation
  - Example 3: FAQ documentation
  - Example 4: API reference update
  - Example 5: YOLO mode (fast documentation)
  - Example 6: Resume from middle phase

- **What You Are Doing** (invoke documentation-orchestrator skill)

- **Workflow Phases** (brief description of each phase and outputs)

- **Execution Modes** (Interactive vs YOLO behavior)

- **Auto-Recovery Features** (per phase)

- **State Management** (orchestrator-state.yml location, documentation context)

- **Prerequisites**
  - Playwright installed and configured (for screenshots)
  - Application running (for screenshot capture)
  - Feature implemented (if documenting new feature)

- **When to Use This vs Manual Documentation**

- **Resume After Interruption** (pointer to resume command)

- **Tips** (for different doc types, target audiences, screenshot quality)

- **Next Steps After Completion** (publish to website, share with users, gather feedback)

- **Troubleshooting** (common issues and solutions)

- **Related Commands** (link to resume command)

- **Invoke** (call documentation-orchestrator skill)

---

#### 9. `commands/documentation/resume.md` (~450 lines)

**Purpose**: Command documentation for resuming interrupted documentation workflow

**Content**:
- Command frontmatter (YAML)

- **Command Usage**
  ```bash
  /ai-sdlc:documentation:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]
  ```

- **Arguments and Options**

- **Examples** (4-5 resume scenarios)
  - Simple resume (use state)
  - Resume from specific phase
  - Resume after manual edits
  - Resume after review failure
  - Retry screenshot capture

- **What You Are Doing** (resume workflow steps)
  - Step 1: Locate and validate task
  - Step 2: Read and validate state (including documentation context)
  - Step 3: Determine resume point (check review passed before Phase 3)
  - Step 4: Validate prerequisites
  - Step 5: Apply state modifications
  - Step 6: Continue workflow

- **Use Cases** (4-5 common scenarios)
  - Computer restarted mid-documentation
  - Auto-fix exhausted, manual edits applied
  - Want to re-capture screenshots
  - Review failed (readability too low)
  - Application updated, need new screenshots

- **Common Scenarios** (troubleshooting)
  - Phase keeps failing
  - Want to restart a phase
  - Screenshots outdated
  - Review failed (readability issues)
  - Prerequisites missing (app not running)

- **Review Failure Gate**
  ```
  If documentation_context.review_passed == false:
    ⚠️ Documentation Review Failed

    Cannot proceed to publication until review passes.

    Issues found:
    - Readability: Flesch Ease = 45 (target: >60)
    - Missing sections: Troubleshooting, Next Steps
    - Broken links: 2 links not found

    Options:
    1. Return to content creation phase to fix issues
    2. Review feedback and manually edit
    3. Abort workflow
  ```

- **State Reconstruction** (experimental, if state file lost)

- **Tips** (safe resume, after manual edits, re-running phases, screenshot updates)

- **Troubleshooting** (state file corrupted, can't determine resume point, Playwright issues)

- **Related Commands** (link to new command)

- **Invoke** (call documentation-orchestrator skill in resume mode)

---

## CLAUDE.md Updates

### Available Skills Section

Add after `security-orchestrator`:

```markdown
### documentation-orchestrator
Orchestrates end-user documentation creation workflows with content planning, screenshot generation (via Playwright), and publication. Plans documentation structure, generates content with screenshots, validates readability and completeness, and publishes to appropriate location.

**What Makes It Different**: User-first approach (write for non-technical users), screenshot automation with Playwright, readability metrics validation (Flesch scores), leverages existing user-docs-generator subagent, supports multiple doc types (user guide, tutorial, reference, FAQ, API docs).

**Key Features**:
- **Documentation Planning**: Classify type, identify audience, create outline
- **Screenshot Automation**: Capture screenshots using Playwright during content creation
- **Readability Validation**: Flesch Reading Ease, Flesch-Kincaid Grade Level
- **Completeness Checking**: Verify all sections present, screenshots referenced
- **Multiple Doc Types**: User guide, tutorial, reference, FAQ, API docs

**4-Phase Workflow**:
1. **Documentation Planning & Audience Analysis**: Classify type, identify audience, create outline
2. **Content Creation with Screenshots**: Generate content, capture screenshots (leverages user-docs-generator)
3. **Review & Validation**: Check completeness, readability, screenshots, links
4. **Publication & Integration**: Format, generate TOC, integrate with docs structure

**Documentation Types**:
- User Guide: Help users accomplish tasks (friendly, step-by-step)
- Tutorial: Teach through hands-on practice (educational, detailed)
- Reference: Complete technical details (technical, comprehensive)
- FAQ: Answer common questions (concise, direct)
- API Docs: Document endpoints and usage (technical, structured)

**Commands**: `/ai-sdlc:documentation:new`, `/ai-sdlc:documentation:resume`

**Use Cases**:
- Documenting new features for users
- Creating user guides and tutorials
- Building FAQ sections
- Updating documentation with screenshots
- Systematic documentation workflow

**Related agents**: `documentation-planner`, `documentation-reviewer`, `user-docs-generator` (existing)

**See**: `skills/documentation-orchestrator/SKILL.md` for workflow phases, `references/` for doc types, writing guidelines, screenshot strategies.
```

### Available Commands Section

Add after `/ai-sdlc:security:resume`:

```markdown
### /ai-sdlc:documentation:new
Orchestrates documentation creation workflow with planning, screenshot generation, and publication. Plans structure, generates content with screenshots using Playwright, validates readability, and publishes.

**Usage**: `/ai-sdlc:documentation:new [description] [--yolo] [--from=phase] [--type=TYPE]`

**Output**: Task directory in `.ai-sdlc/tasks/documentation/` with outline, content, screenshots, review report, and published documentation.

**See**: `skills/documentation-orchestrator/SKILL.md` for workflow phases and capabilities.

### /ai-sdlc:documentation:resume
Resumes interrupted documentation workflow from saved state. Validates review passed before publication. Can override resume point, reset auto-fix attempts.

**Usage**: `/ai-sdlc:documentation:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]`

**See**: `skills/documentation-orchestrator/SKILL.md` for state management details.
```

### Available Subagents Section

Add after `compliance-auditor`:

```markdown
### documentation-planner
Documentation planning specialist that creates structured content outlines. Classifies doc type (user guide/tutorial/reference/FAQ/API docs), identifies target audience, determines appropriate tone, creates outline with sections, identifies required screenshots. Strictly read-only.

**Workflow**: Classify type → Identify audience → Determine tone → Create outline → Identify screenshots → Estimate scope → Generate plan

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by documentation-orchestrator during Phase 0 (Documentation Planning)

**Output**: `planning/documentation-outline.md` with structure and requirements

**Philosophy**: User-first planning. Understand audience before writing.

### documentation-reviewer
Documentation quality specialist that validates completeness and readability. Checks all sections present, calculates Flesch Reading Ease and Grade Level, validates screenshots exist and are referenced, checks for broken links, flags technical jargon. Generates review report with PASS/FAIL verdict. Strictly read-only.

**Workflow**: Check completeness → Calculate readability → Validate screenshots → Check links → Flag jargon → Verify examples → Assess clarity → Generate report

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by documentation-orchestrator during Phase 2 (Review & Validation)

**Output**: `verification/documentation-review.md` with PASS/FAIL verdict

**Philosophy**: Readability matters. If users can't understand it, it's not good documentation.
```

---

## Implementation Order

1. **Create subagents** (2 files): documentation-planner.md → documentation-reviewer.md
2. **Create references** (4 files): documentation-types.md → writing-guidelines.md → screenshot-strategies.md → workflow-phases.md
3. **Create main skill**: SKILL.md
4. **Create commands** (2 files): new.md → resume.md
5. **Update CLAUDE.md**: Add to Available Skills, Available Commands, Available Subagents sections

---

## Key Design Decisions

**Leverage Existing user-docs-generator**:
- Phase 1 delegates to existing `user-docs-generator` subagent
- No need to reimplement content creation and screenshot capture
- Orchestrator adds planning (Phase 0) and validation (Phase 2) layers

**Readability Metrics Validation**:
- Flesch Reading Ease score (60+ = readable)
- Flesch-Kincaid Grade Level (<10 = general public)
- Automated scoring ensures docs are accessible

**Multi-Doc-Type Support**:
- User Guide: Friendly, step-by-step
- Tutorial: Educational, hands-on
- Reference: Technical, comprehensive
- FAQ: Concise, direct
- API Docs: Structured, technical

**Review Gate Before Publication**:
- Phase 2 must be PASS before Phase 3
- Ensures quality documentation published
- Readability, completeness, screenshots validated

**Screenshot Automation**:
- Playwright captures screenshots during Phase 1
- Leverages existing user-docs-generator capabilities
- Consistent screenshot style and quality

---

## Success Criteria

Workflow successful when:
1. ✅ Documentation type classified and audience identified
2. ✅ Complete outline created with all sections planned
3. ✅ All content written in appropriate tone for audience
4. ✅ All required screenshots captured and referenced
5. ✅ Readability metrics met (Flesch Ease >60, Grade Level <10)
6. ✅ All sections from outline present in final doc
7. ✅ No broken links or references
8. ✅ Technical jargon explained or simplified
9. ✅ Examples clear and realistic
10. ✅ Documentation published and integrated with docs structure

Documentation orchestration provides complete, user-first, screenshot-rich workflow from documentation request to published, validated user documentation.
