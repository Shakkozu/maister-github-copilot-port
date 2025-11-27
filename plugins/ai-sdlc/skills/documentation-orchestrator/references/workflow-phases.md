# Workflow Phases Reference

4-phase documentation creation workflow with dependencies, state transitions, and execution patterns.

## Workflow Overview

```
Phase 0: Documentation Planning & Audience Analysis
    ↓
Phase 1: Content Creation with Screenshots
    ↓
Phase 2: Review & Validation
    ↓ (PASS required)
Phase 3: Publication & Integration
```

**Total Phases**: 4 (0-3)
**Execution Modes**: Interactive (pause between phases) or YOLO (continuous)
**Auto-Recovery**: Variable (Phase 0-1: max 2-3 attempts, Phase 2: 0 attempts, Phase 3: 1 attempt)

---

## Phase 0: Documentation Planning & Audience Analysis

**Agent**: `documentation-planner` (read-only subagent)

**Input**: Documentation request description

**Process**:
1. Classify documentation type (user guide, tutorial, reference, FAQ, API docs)
2. Identify target audience (end users, administrators, developers, power users)
3. Determine appropriate tone and complexity level
4. Analyze existing documentation structure (if any)
5. Create content outline with sections
6. Identify required screenshots and examples
7. Estimate documentation scope (pages, screenshots, estimated time)

**Output**: `planning/documentation-outline.md` with:
- Classified documentation type with rationale
- Target audience profile
- Tone guidelines (friendly/technical/formal)
- Content structure with sections
- Screenshot requirements (list of what to capture)
- Example requirements (what data to show)
- Readability targets (Flesch Ease, Grade Level)
- Estimated scope (pages, screenshots, time)

**Success Criteria**:
- ✅ Documentation type classified (user guide, tutorial, reference, FAQ, or API docs)
- ✅ Target audience identified with characteristics
- ✅ Tone and complexity level determined
- ✅ Complete outline with 4-8 main sections
- ✅ Screenshot list with descriptions (5-20 screenshots typically)
- ✅ Readability targets set based on audience

**Auto-Fix**: Max 2 attempts
- Prompt user if documentation type ambiguous
- Use conservative defaults if audience unclear
- Generate generic outline structure if specific requirements unclear

**Failure Handling**: If classification fails after 2 attempts, HALT and ask user to clarify:
- What type of documentation is needed?
- Who is the target audience?
- What is the main goal (teach, reference, troubleshoot)?

**State Updates**:
```yaml
documentation_context:
  doc_type: "user-guide"
  target_audience: "end-users"
  tone: "friendly"
  readability_target:
    ease: 70
    grade: 8
  screenshot_count: 12
```

---

## Phase 1: Content Creation with Screenshots

**Agent**: `user-docs-generator` (existing subagent)

**Input**: `planning/documentation-outline.md` from Phase 0

**Process**:
1. Load documentation outline and requirements
2. Generate documentation content following outline structure
3. Write step-by-step instructions in appropriate tone
4. Launch Playwright browser (if screenshots required)
5. Capture screenshots for each identified visual step
6. Insert screenshot references in documentation
7. Add realistic examples (not placeholder data)
8. Include tips, warnings, and best practices
9. Add troubleshooting section
10. Verify all sections from outline covered

**Output**:
- `documentation/user-guide.md` (or appropriate filename based on type)
- `documentation/screenshots/*.png` (all captured screenshots)
- Screenshots referenced in documentation with descriptive alt text

**Success Criteria**:
- ✅ All sections from outline present in documentation
- ✅ All required screenshots captured (per screenshot list)
- ✅ Screenshots properly referenced with alt text
- ✅ Examples included with realistic data
- ✅ Step-by-step instructions clear and complete
- ✅ Appropriate tone maintained throughout
- ✅ Troubleshooting section included

**Auto-Fix**: Max 3 attempts
- Retry failed screenshot captures (Playwright issues)
- Fix markdown formatting errors
- Regenerate sections with poor readability
- Adjust tone if inconsistent with requirements

**Failure Handling**:
- If Playwright unavailable: Document without screenshots, flag for manual addition
- If application unreachable: Create text-only documentation with placeholder notes
- If section generation fails: Use outline headers, flag incomplete sections
- If max attempts exhausted: HALT, provide detailed error report

**Prerequisites Validation**:
- Playwright installed and configured
- Application running and accessible
- Feature implemented (if documenting new feature)

**Integration with Existing Subagent**:
- Leverages existing `user-docs-generator` capabilities
- Passes outline, tone guidelines, and screenshot requirements
- Orchestrator provides structured input, subagent generates content

**State Updates**:
```yaml
current_phase: phase-1
attempts_this_phase: 0
documentation_context:
  content_file: "documentation/user-guide.md"
  screenshots_captured: 12
  sections_completed: 8
```

---

## Phase 2: Review & Validation

**Agent**: `documentation-reviewer` (read-only subagent)

**Input**:
- `documentation/user-guide.md` (or appropriate file)
- `planning/documentation-outline.md` (for comparison)
- `documentation/screenshots/` (screenshot files)

**Process**:
1. Load outline and generated documentation
2. **Check Completeness**: Verify all sections from outline present
3. **Calculate Readability Metrics**:
   - Flesch Reading Ease score
   - Flesch-Kincaid Grade Level
   - Compare against targets from Phase 0
4. **Validate Screenshots**:
   - All required screenshots exist
   - Screenshots referenced in text
   - Alt text present and descriptive
5. **Check Links and References**:
   - Internal links (to other sections)
   - External links (if any)
   - Screenshot references
6. **Flag Technical Jargon**:
   - Identify unexplained technical terms
   - Check if jargon appropriate for audience
7. **Verify Examples**:
   - Examples present in relevant sections
   - Examples realistic (not placeholder data)
8. **Assess Overall Clarity**:
   - Logical flow and organization
   - Consistency in tone
   - Sufficient detail for target audience
9. Generate comprehensive review report with verdict

**Output**: `verification/documentation-review.md` with:
- Completeness assessment (sections present/missing)
- Readability metrics (actual vs target)
- Screenshot validation results
- Link/reference check results
- Jargon analysis with flagged terms
- Example quality assessment
- Overall clarity score
- Issues categorized by severity (Critical/Major/Minor)
- PASS/FAIL verdict with detailed rationale

**Success Criteria (PASS verdict)**:
- ✅ All required sections present (100% completeness)
- ✅ Readability meets or exceeds targets (Flesch Ease within 10 points of target)
- ✅ All required screenshots exist and referenced
- ✅ No broken links or missing references
- ✅ Jargon either avoided or explained
- ✅ Examples clear and realistic
- ✅ No critical issues found

**Failure Criteria (FAIL verdict)**:
- ❌ Missing critical sections (>1 major section missing)
- ❌ Readability significantly below target (>15 points below Flesch target)
- ❌ Missing >20% of required screenshots
- ❌ Multiple broken links/references
- ❌ Unexplained jargon throughout
- ❌ Placeholder examples (foo@bar.com)
- ❌ Critical issues affecting user understanding

**Auto-Fix**: Max 0 attempts (read-only reporting only)
- This phase reports issues but does not modify documentation
- User or orchestrator must return to Phase 1 to fix issues

**Failure Handling**:
- If FAIL verdict: Generate detailed issue list with fix recommendations
- Cannot proceed to Phase 3 if verdict = FAIL
- User options:
  1. Return to Phase 1 (regenerate content with fixes)
  2. Manually edit documentation to address issues
  3. Override verdict (not recommended, for minor issues only)

**Verdict Criteria**:
```
PASS:
- Completeness: 100%
- Readability: Within acceptable range
- Screenshots: 100% present
- Links: No broken references
- Quality: No critical issues

FAIL:
- Missing sections OR
- Poor readability OR
- Significant screenshot gaps OR
- Broken references OR
- Critical quality issues
```

**State Updates**:
```yaml
current_phase: phase-2
documentation_context:
  review_passed: true/false
  readability_scores:
    flesch_ease: 72
    grade_level: 7
  completeness_percent: 100
  issues_found: 3
  critical_issues: 0
```

---

## Phase 3: Publication & Integration

**Agent**: Main orchestrator

**Input**:
- `documentation/user-guide.md` (reviewed content)
- `verification/documentation-review.md` (PASS verdict required)
- `documentation/screenshots/` (screenshot files)

**Process**:
1. **Verify Prerequisites**: Check Phase 2 PASS verdict (gate check)
2. **Determine Publication Location**:
   - Project docs directory (e.g., `/docs/user-guides/`)
   - AI SDLC task documentation (`.ai-sdlc/tasks/documentation/`)
   - External documentation system (if configured)
3. **Format for Target Platform**:
   - Markdown (default)
   - HTML conversion (if needed)
   - PDF generation (if requested)
4. **Generate Table of Contents**:
   - Extract headings from documentation
   - Create navigable TOC with links
   - Add to top of document
5. **Add Navigation Links**:
   - Previous/Next links (if part of documentation series)
   - Related documentation links
   - Back to index link
6. **Integrate with Documentation Structure**:
   - Copy documentation file to publication location
   - Copy screenshots to appropriate directory
   - Update documentation index/registry
7. **Update Documentation Index**:
   - Add new documentation to index file
   - Update search metadata (if applicable)
   - Link from related documentation
8. **Create Publication Summary**:
   - Document location
   - Audience and purpose
   - Last updated date
   - Maintenance notes

**Output**:
- Published documentation at target location (e.g., `/docs/user-guides/account-management.md`)
- Screenshots in public directory (e.g., `/docs/user-guides/screenshots/`)
- Updated documentation index
- Publication summary in task directory

**Success Criteria**:
- ✅ Documentation copied to publication location
- ✅ Screenshots accessible at correct paths
- ✅ Table of contents generated and functional
- ✅ Navigation links working
- ✅ Documentation index updated
- ✅ All links in published version functional

**Auto-Fix**: Max 1 attempt
- Fix broken relative paths (adjust for publication location)
- Regenerate TOC if formatting issues
- Retry file copy operations if I/O errors

**Failure Handling**:
- If publication location doesn't exist: Create directory structure
- If index file missing: Create new index with this documentation
- If permission errors: Report issue, suggest manual copy
- If max attempts exhausted: HALT, provide manual publication instructions

**Review Gate Enforcement**:
```
if documentation_context.review_passed != true:
  ERROR: Cannot proceed to publication

  Phase 2 review verdict: FAIL

  Issues preventing publication:
  - Readability below target (Flesch Ease: 45, target: 70)
  - Missing 2 critical sections: Prerequisites, Troubleshooting
  - 3 broken screenshot references

  Actions required:
  1. Return to Phase 1 to regenerate content, OR
  2. Manually edit documentation to fix issues, OR
  3. Abort workflow and restart

  Recommendation: Return to Phase 1 with specific fixes
```

**State Updates**:
```yaml
current_phase: phase-3
workflow_status: completed
documentation_context:
  published_location: "/docs/user-guides/account-management.md"
  publication_date: "2024-11-17"
  toc_generated: true
  index_updated: true
```

---

## Phase Dependencies

**Prerequisite Requirements**:

**Phase 1** requires:
- Phase 0 complete
- `planning/documentation-outline.md` exists
- Playwright available (if screenshots required)
- Application running (if screenshots required)

**Phase 2** requires:
- Phase 1 complete
- `documentation/user-guide.md` (or equivalent) exists
- `documentation/screenshots/` directory exists (if screenshots used)

**Phase 3** requires:
- Phase 2 complete
- `verification/documentation-review.md` exists
- Review verdict = PASS (critical gate)
- Target publication location accessible

**Cannot Skip Phases**: Must proceed sequentially (0 → 1 → 2 → 3)

**Critical Gate**: Phase 2 PASS verdict required before Phase 3

---

## State Transitions

**Valid Transitions**:
```
-1 (Start) → 0 → 1 → 2 → 3 (Complete)
                    ↓
                 HALT (if review FAIL)
                    ↓
              Return to Phase 1 (fix issues)
                    ↓
                Phase 2 (re-review)
                    ↓
                Phase 3 (publish if PASS)
```

**Invalid Transitions**:
- ❌ Cannot skip phases (e.g., 0 → 2)
- ❌ Cannot proceed to Phase 3 if Phase 2 verdict = FAIL
- ❌ Cannot proceed if prerequisite outputs missing

**Conditional Loop**:
- If Phase 2 = FAIL → Return to Phase 1 (fix issues)
- Phase 1 → Phase 2 (re-review)
- Repeat until PASS or user aborts

---

## Execution Modes

### Interactive Mode (Default)

**Behavior**: Pause after each phase, prompt user to continue

**User Prompts**:
- After Phase 0: "Documentation outline created. Review outline before generating content?"
- After Phase 1: "Content and screenshots generated. Run validation review?"
- After Phase 2 (PASS): "Review passed. Publish documentation?"
- After Phase 2 (FAIL): "Review failed with issues. Return to content creation to fix?"

**User Actions**:
- **Continue**: Proceed to next phase
- **Review**: Examine output files before continuing
- **Edit**: Make manual edits, then continue
- **Abort**: Stop workflow, save state

**Benefits**:
- Control over process
- Opportunity to review/edit
- Catch issues early

### YOLO Mode

**Behavior**: Continuous execution without pauses

**Command**: `/ai-sdlc:documentation:new [description] --yolo`

**Stops Only If**:
- Phase fails after auto-fix attempts exhausted
- Phase 2 review verdict = FAIL (critical gate)
- Playwright unavailable (if screenshots required)
- Application unreachable (if screenshots required)

**Resume After Failure**:
- Fix issues (manual or orchestrator)
- `/ai-sdlc:documentation:resume [task-path]`

**Benefits**:
- Fast execution
- Minimal user interaction
- Good for well-defined documentation requests

---

## Error Recovery

### Phase 0: Limited Auto-Fix

**Max Attempts**: 2

**Strategy**:
- Use default documentation type if unclear (user guide)
- Use conservative audience if unspecified (end users)
- Generate generic outline if requirements vague

**If Unresolved**: HALT, prompt user for clarification:
- Documentation type?
- Target audience?
- Main goal (teach/reference/troubleshoot)?

### Phase 1: Moderate Auto-Fix

**Max Attempts**: 3

**Strategy**:
- Retry Playwright screenshot capture (network/timing issues)
- Fix markdown formatting errors automatically
- Regenerate poorly written sections
- Adjust tone if inconsistent

**Common Fixes**:
- Screenshot timeout → Increase wait time, retry
- Markdown syntax error → Fix formatting, regenerate
- Tone inconsistency → Rewrite section with correct tone
- Missing examples → Generate examples, insert

**If Unresolved**:
- Screenshots: Document without images, flag for manual addition
- Sections: Use outline headers, flag incomplete
- HALT if critical content generation fails

### Phase 2: Report Only (No Auto-Fix)

**Max Attempts**: 0 (read-only verification)

**Strategy**:
- Report all issues with evidence
- Categorize by severity (Critical/Major/Minor)
- Provide specific fix recommendations
- Don't modify documentation

**Why No Auto-Fix?**:
- Verification is quality gate, not fix phase
- Issues should be addressed in Phase 1 (proper regeneration)
- Automatic fixes might mask deeper issues

**User Action Required**: If FAIL
- Return to Phase 1 with specific fixes
- OR manually edit documentation
- OR review and decide if issues acceptable (override)

### Phase 3: Minimal Auto-Fix

**Max Attempts**: 1

**Strategy**:
- Fix broken relative paths (publication location different)
- Regenerate TOC if formatting issues
- Retry I/O operations (file copy/write)
- Create missing directories

**If Unresolved**: HALT, provide manual publication instructions:
- Where to copy documentation file
- Where to copy screenshots
- How to update index
- What links to add

---

## State Management

**State File**: `orchestrator-state.yml` in task directory

**State Structure**:
```yaml
workflow_status: in_progress  # in_progress | completed | failed
current_phase: phase-1
execution_mode: interactive  # interactive | yolo
attempts_this_phase: 1
max_attempts: 3

documentation_context:
  doc_type: "user-guide"  # user-guide | tutorial | reference | faq | api-docs
  target_audience: "end-users"  # end-users | admins | developers | power-users
  tone: "friendly"  # friendly | technical | formal
  readability_target:
    ease: 70  # Flesch Reading Ease target
    grade: 8  # Grade Level target
  screenshot_count: 12
  content_file: "documentation/user-guide.md"
  screenshots_captured: 12
  review_passed: false  # MUST be true before Phase 3
  published_location: null

phase_results:
  phase-0:
    status: completed
    output_file: "planning/documentation-outline.md"
  phase-1:
    status: completed
    output_file: "documentation/user-guide.md"
    screenshots_directory: "documentation/screenshots"
  phase-2:
    status: completed
    output_file: "verification/documentation-review.md"
    verdict: "PASS"
  phase-3:
    status: not_started
```

**State Updates**: After each phase completes/fails

**Resume Capability**: Can resume from any phase using state

---

## Workflow Completion

### Success Path

```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ (PASS) → Phase 3 ✅

Final State:
- workflow_status: completed
- All phases completed successfully
- Documentation published and accessible
- Index updated
- Ready for user consumption
```

### Failure Paths

**Failure in Phase 2** (Review FAIL):
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ❌ (FAIL verdict)
                        ↓
                Return to Phase 1 (fix issues)
                        ↓
                Phase 2 ✅ (PASS)
                        ↓
                Phase 3 ✅

Final State:
- workflow_status: completed (after fixes)
- Review gate enforced (PASS required)
- Documentation quality ensured
```

**Failure in Phase 1** (Content Generation):
```
Phase 0 ✅ → Phase 1 ❌ (Playwright unavailable)

Final State:
- workflow_status: failed
- failed_phase: phase-1
- Require manual screenshot capture OR
- Skip screenshots, proceed with text-only documentation
```

**Failure in Phase 3** (Publication):
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ❌ (Permission error)

Final State:
- workflow_status: completed_with_issues
- Documentation ready but not published
- Manual publication required
- Instructions provided
```

---

## Integration Points

### Existing Subagent Integration

**Phase 1 leverages `user-docs-generator`**:
- Orchestrator provides structured input (outline, tone, targets)
- Subagent generates content and screenshots
- Orchestrator validates output completeness

**Benefits**:
- Reuses proven content generation logic
- Consistent screenshot capture approach
- No duplication of subagent code

### Playwright Integration

**Phase 1 screenshot capture**:
- Launches Playwright browser
- Navigates to application pages
- Captures screenshots per requirements
- Handled by `user-docs-generator` subagent

**Prerequisites**:
- Playwright MCP server configured
- Application running and accessible
- Network connectivity

### Documentation Structure Integration

**Phase 3 publication**:
- Integrates with existing project docs structure
- Updates documentation index/registry
- Creates cross-references to related docs
- Maintains consistent navigation

---

This 4-phase workflow ensures systematic, high-quality documentation creation with clear gates, validation, and integration into project documentation structure.
