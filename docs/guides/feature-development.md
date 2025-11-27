# Feature Development Workflow

Complete guide to developing new features using the AI SDLC plugin's feature orchestrator.

## Overview

The feature development workflow is a comprehensive 6-7 phase process designed for building completely new capabilities in your application. It guides you from initial requirements gathering through specification, planning, implementation, verification, and optional E2E testing and user documentation.

**When to use this workflow:**
- Adding completely new capability that doesn't exist yet
- Building features from scratch
- Need comprehensive workflow coverage
- Want automated verification and testing

**When NOT to use this workflow:**
- Improving existing features → Use [Enhancement Workflow](enhancement-workflow.md)
- Fixing bugs → Use [Bug Fixing Workflow](bug-fixing.md)
- Refactoring code → Use [Refactoring Workflow](refactoring.md)

## Quick Start

```bash
# Interactive mode (recommended for first time)
/ai-sdlc:feature:new "Add user profile page with avatar upload"

# YOLO mode (continuous execution)
/ai-sdlc:feature:new "Add export to PDF" --yolo

# With E2E testing and user docs
/ai-sdlc:feature:new "Build admin dashboard" --e2e --user-docs
```

## Workflow Phases

### Phase 0.5: Dependency Check (If Part of Initiative)

**Duration**: < 1 minute
**Runs when**: Task has `initiative_id` in metadata.yml

If this feature is part of a larger initiative, the workflow first checks that all dependency tasks are completed.

**What happens:**
1. Reads task metadata.yml for `initiative_id` and `dependencies`
2. Checks status of each dependency task
3. If any dependency is not complete: **BLOCKS** execution
4. If all dependencies complete: Continues to Phase 1

**If blocked:**
```
❌ Task blocked by dependencies:
- .ai-sdlc/tasks/new-features/2025-11-14-basic-login (status: in_progress)

Dependencies must complete first.
Check initiative status: /ai-sdlc:initiative:status [initiative-path]
```

**Action**: Complete dependency tasks first, or remove dependencies from metadata.yml

---

### Phase 1: Specification Creation

**Duration**: 25-35 minutes
**Skill**: specification-creator
**Interactive**: Pauses after completion for review

**Purpose**: Create a comprehensive specification documenting WHAT to build.

**What you'll do:**
- Answer questions about the feature
- Provide requirements and acceptance criteria
- Share design mockups or references (if available)
- Define target users and use cases

**Questions you might be asked:**
```
Q: Who are the target users for this feature?
Q: What problem does this feature solve?
Q: What should the feature do? (List main capabilities)
Q: What are the acceptance criteria?
Q: Are there any design mockups or wireframes?
Q: What are the edge cases and error scenarios?
Q: Are there any non-functional requirements (performance, security)?
```

**Outputs:**
```
.ai-sdlc/tasks/new-features/YYYY-MM-DD-feature-name/
├── metadata.yml                    # Task metadata
├── analysis/
│   ├── requirements.md            # Gathered requirements
│   └── visuals/                   # Design mockups (if provided)
└── implementation/
    └── spec.md                    # WHAT to build
```

**spec.md structure:**
```markdown
# Feature Name

## Overview
[Brief description]

## Target Users
[Who will use this]

## Requirements
### Functional Requirements
- [Requirement 1]
- [Requirement 2]

### Non-Functional Requirements
- [Performance, security, etc.]

## User Stories
1. As a [user type], I want to [action] so that [benefit]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Technical Considerations
[API integrations, database schema, etc.]

## Edge Cases
[Error scenarios, boundary conditions]
```

**Auto-recovery:**
- Max 2 attempts if verification fails
- Automatically addresses over-engineering
- Re-generates spec if incomplete

**Review checklist:**
- ✅ All requirements clearly documented
- ✅ User stories are specific and testable
- ✅ Acceptance criteria are measurable
- ✅ Technical considerations addressed
- ✅ Edge cases identified

---

### Phase 2: Implementation Planning

**Duration**: 20-30 minutes
**Skill**: implementation-planner
**Interactive**: Pauses after completion for review

**Purpose**: Break the feature into task groups and implementation steps (HOW to build).

**What happens:**
1. Reads spec.md to understand requirements
2. Identifies task groups by specialty (Database, API, Frontend, Testing)
3. Creates 2-8 implementation steps per group
4. Sets dependencies between groups
5. Defines acceptance criteria for each group

**Outputs:**
```
implementation/implementation-plan.md
```

**implementation-plan.md structure:**
```markdown
# Implementation Plan

## Task Groups

### Task Group 1: Database Schema
**Dependencies**: None
**Steps:**
1.1 Create users table migration
1.2 Add avatar_url column
1.3 Test: Verify schema created

**Acceptance Criteria:**
- [ ] Migration runs successfully
- [ ] Schema matches specification

**Tests**: 2-3 tests

---

### Task Group 2: API Endpoints
**Dependencies**: Task Group 1 (Database Schema)
**Steps:**
2.1 Create POST /api/users/avatar endpoint
2.2 Implement file upload validation
2.3 Test: Upload valid/invalid files

**Tests**: 4-6 tests

---

### Task Group 3: Frontend Components
**Dependencies**: Task Group 2 (API Endpoints)
**Steps:**
3.1 Create AvatarUpload component
3.2 Add image preview
3.3 Implement upload progress
3.4 Test: Component renders and uploads

**Tests**: 5-7 tests

---

## Estimated Complexity
- Total Steps: 9
- Total Tests: 11-16
- Estimated Time: 2-3 hours
```

**Review checklist:**
- ✅ All spec requirements covered
- ✅ Task groups ordered correctly
- ✅ Dependencies make sense
- ✅ Test coverage adequate (2-8 tests per group)
- ✅ Steps are specific and actionable

---

### Phase 3: Implementation

**Duration**: 1-4 hours (varies by complexity)
**Skill**: implementer
**Interactive**: Pauses after completion for review

**Purpose**: Execute the implementation plan with continuous standards discovery.

**What happens:**

1. **Initialize**
   - Load implementation-plan.md
   - Check `.ai-sdlc/docs/INDEX.md` for standards
   - Select execution mode (direct/plan-execute/orchestrated)

2. **For each task group:**
   - Check specialty-specific standards (e.g., frontend standards for UI work)
   - **For each step:**
     - ✅ Write tests first (TDD)
     - ✅ Implement functionality
     - ✅ Run tests for this group
     - ✅ Update work-log.md
   - Mark group complete

3. **Finalize**
   - Final standards compliance check
   - Update implementation-plan.md (all steps marked complete)
   - Create comprehensive work log

**Execution modes:**

| Mode | When Used | How It Works |
|------|-----------|--------------|
| **Direct** | 1-3 steps total | Main agent executes all steps directly |
| **Plan-Execute** | 4-8 steps | Subagent creates change plan, main agent applies changes |
| **Orchestrated** | 9+ steps | Break into task groups, delegate planning per group |

**Continuous Standards Discovery:**

Standards from `.ai-sdlc/docs/INDEX.md` are checked at multiple points:
- ✅ Initial (Phase start)
- ✅ Before each task group
- ✅ Before each step
- ✅ Before applying changes
- ✅ Final (Phase end)

**Outputs:**
```
implementation/
├── implementation-plan.md    # All steps marked complete
└── work-log.md              # Chronological activity log

[Code changes throughout codebase]
```

**work-log.md example:**
```markdown
# Work Log

## Task Group 1: Database Schema
**Started**: 2025-11-17 10:30:00

### Step 1.1: Create users table migration
**Time**: 10:32:00 - 10:45:00
**Standards Applied**:
- Database naming conventions (standards/backend/database-conventions.md)
- Migration patterns (standards/backend/migrations.md)

**Actions**:
- Created migration file: db/migrations/20251117_add_avatar_to_users.sql
- Added avatar_url VARCHAR(500) column
- Added updated_at trigger

**Tests**:
- ✅ test_migration_adds_avatar_column
- ✅ test_avatar_url_accepts_valid_urls
- ✅ test_migration_is_reversible

**Status**: ✅ Complete
```

**Auto-recovery:**
- Fixes syntax errors automatically
- Adds missing imports
- Corrects test assertions
- Applies missing standards
- Max 5 overall retries

**Review checklist:**
- ✅ All implementation steps complete
- ✅ Tests passing for each group
- ✅ Standards applied and documented
- ✅ Work log comprehensive

---

### Phase 4: Verification

**Duration**: 30-50 minutes
**Skill**: implementation-verifier
**Interactive**: Pauses after completion for review

**Purpose**: Verify implementation is complete, tested, and production-ready.

**What happens:**

1. **Verify Implementation Plan Completion**
   - Check all steps marked complete in implementation-plan.md
   - Spot-check code evidence for key steps

2. **Run Full Test Suite**
   - Execute **entire project test suite** (not just feature tests)
   - Report pass/fail rate
   - Document failing tests (don't fix)

3. **Verify Standards Compliance**
   - Review work-log.md for standards application
   - Cross-reference with `.ai-sdlc/docs/INDEX.md`
   - Assess compliance percentage

4. **Check Documentation**
   - Verify implementation-plan.md complete
   - Verify work-log.md comprehensive
   - Check spec alignment

5. **(Optional) Code Review**
   - Invoke code-reviewer skill for automated analysis
   - Check quality, security, performance

6. **(Optional) Production Readiness**
   - Invoke production-readiness-checker skill
   - Verify deployment readiness

7. **Create Verification Report**
   - Comprehensive report with overall status

8. **(Optional) Update Roadmap**
   - Mark completed items in docs/project/roadmap.md

**Outputs:**
```
verification/
└── implementation-verification.md
```

**Verification report structure:**
```markdown
# Implementation Verification Report

## Overall Status: ✅ PASSED

## Summary
- Implementation: 100% complete (9/9 steps)
- Tests: 287/287 passing (100%)
- Standards: Compliant (5/5 standards applied)
- Documentation: Complete

## Implementation Completeness
✅ All steps in implementation-plan.md marked complete
✅ Code evidence verified for key functionality

### Task Groups:
1. Database Schema: ✅ Complete (3/3 steps)
2. API Endpoints: ✅ Complete (3/3 steps)
3. Frontend Components: ✅ Complete (4/4 steps)

## Test Results
✅ **287/287 tests passing (100%)**

### New Tests Added:
- Database: 3 tests
- API: 6 tests
- Frontend: 7 tests
- Total: 16 new tests

## Standards Compliance
✅ **5/5 standards applied**

Applied standards:
- ✅ Database naming conventions (backend/database-conventions.md)
- ✅ API design patterns (backend/api-design.md)
- ✅ Component patterns (frontend/component-patterns.md)
- ✅ Error handling (global/error-handling.md)
- ✅ Testing best practices (testing/unit-testing.md)

## Documentation Completeness
✅ implementation-plan.md: All steps documented and complete
✅ work-log.md: Comprehensive activity log with timestamps
✅ Spec alignment: Implementation matches specification

## Recommendations
- Consider adding error boundary for file uploads
- Document file size limits in user documentation
```

**Overall status criteria:**

| Status | Criteria |
|--------|----------|
| ✅ **Passed** | 100% complete, 95-100% tests passing, standards compliant, docs complete, no critical issues |
| ⚠️ **Passed with Issues** | 90-99% complete, 90-94% tests passing, mostly compliant, adequate docs, warnings only |
| ❌ **Failed** | <90% complete, <90% tests passing, non-compliant, incomplete docs, or critical issues |

**What this phase does NOT do:**
- ❌ Fix failing tests (reports only)
- ❌ Complete incomplete tasks
- ❌ Modify implementation files
- ❌ Apply missing standards

**Review checklist:**
- ✅ Review overall status
- ✅ Check test pass rate
- ✅ Review recommendations
- ✅ Address any critical issues before proceeding

---

### Phase 5: E2E Testing (Optional)

**Duration**: 20-30 minutes
**Skill**: e2e-test-verifier (agent)
**Interactive**: Prompts before running (unless `--e2e` flag used)

**Purpose**: Verify the feature works in a real browser with actual user workflows.

**Prerequisites:**
- `playwright-mcp` server configured
- Application running and accessible
- Feature has UI components

**When to enable:**
- Feature includes user interface
- Need to verify user workflows
- Want screenshots for documentation
- Critical user-facing functionality

**What happens:**

1. **Test User Stories**
   - Executes each user story from spec.md
   - Uses Playwright to interact with actual browser

2. **Validate Acceptance Criteria**
   - Tests each acceptance criterion
   - Captures evidence (screenshots)

3. **Check UI Behavior**
   - Verifies UI elements present
   - Tests interactions (clicks, form fills, navigation)

4. **Check Console Errors**
   - Monitors browser console for JavaScript errors

5. **Create E2E Report**
   - Documents all test results with screenshots

**Outputs:**
```
verification/
├── e2e-verification-report.md
└── screenshots/
    ├── 01-user-profile-page.png
    ├── 02-avatar-upload-button.png
    └── 03-upload-success.png
```

**E2E report example:**
```markdown
# E2E Test Verification Report

## Overall Status: ✅ PASSED

## Test Scenarios

### Scenario 1: User uploads avatar
**User Story**: As a user, I want to upload my avatar so I can personalize my profile

**Steps Tested:**
1. ✅ Navigate to profile page
2. ✅ Click "Upload Avatar" button
3. ✅ Select image file
4. ✅ Verify upload progress shown
5. ✅ Verify avatar displays after upload

**Screenshots:**
- [Profile page initial state](screenshots/01-profile-page.png)
- [Upload dialog](screenshots/02-upload-dialog.png)
- [Avatar displayed](screenshots/03-avatar-success.png)

**Console Messages**: No errors

**Status**: ✅ PASSED

### Scenario 2: Invalid file upload handling
**Steps Tested:**
1. ✅ Attempt to upload file >2MB
2. ✅ Verify error message shown
3. ✅ Attempt to upload PDF file
4. ✅ Verify format error shown

**Status**: ✅ PASSED

## Issues Found
None

## Deployment Recommendation
🟢 **GO** - All E2E tests passed, ready for deployment
```

**Auto-recovery:**
- Prompts to start application if not running
- Fixes UI issues automatically
- Max 2 attempts

**Skip this phase if:**
- No UI components (backend-only feature)
- Internal feature (not user-facing)
- Testing in non-browser environment

---

### Phase 6: User Documentation (Optional)

**Duration**: 25-35 minutes
**Skill**: user-docs-generator (agent)
**Interactive**: Prompts before running (unless `--user-docs` flag used)

**Purpose**: Create user-friendly documentation with screenshots for non-technical users.

**Prerequisites:**
- `playwright-mcp` server configured
- Application running and accessible
- User-facing features to document

**When to enable:**
- Feature is user-facing
- Need end-user documentation
- Want step-by-step guides with screenshots

**What happens:**

1. **Analyze Feature**
   - Reads spec.md for user stories
   - Identifies target users

2. **Capture Screenshots**
   - Uses Playwright to capture clear screenshots
   - Shows each step of user workflow

3. **Write User Guide**
   - Non-technical, friendly language
   - Step-by-step instructions
   - Includes tips and troubleshooting

**Outputs:**
```
documentation/
├── user-guide.md
└── screenshots/
    ├── 01-profile-overview.png
    ├── 02-upload-avatar.png
    └── 03-avatar-preview.png
```

**User guide example:**
```markdown
# How to Upload Your Profile Avatar

## Overview
You can personalize your profile by uploading a custom avatar image. This guide shows you how.

## Who This Is For
All users with an account

## Before You Start
- Have a profile picture ready (JPG or PNG format)
- Image should be under 2MB
- Recommended size: 500x500 pixels

## Steps

### 1. Go to Your Profile Page
Click your name in the top-right corner, then select "Profile".

![Profile menu](screenshots/01-profile-menu.png)

### 2. Click Upload Avatar
On your profile page, click the "Upload Avatar" button.

![Upload button](screenshots/02-upload-button.png)

### 3. Select Your Image
Choose an image from your computer:
- Click "Choose File"
- Navigate to your image
- Click "Open"

### 4. Preview and Confirm
You'll see a preview of your avatar. If it looks good, click "Save".

![Avatar preview](screenshots/03-avatar-preview.png)

✅ **Success!** Your avatar is now visible on your profile.

## Tips
💡 Use a square image for best results
💡 Make sure your face is clearly visible
💡 Avoid images with text

## Troubleshooting

**"File too large" error**
→ Your image is over 2MB. Use an image compressor or choose a smaller image.

**"Invalid format" error**
→ Only JPG and PNG files are supported. Convert your image to one of these formats.

**Avatar appears blurry**
→ Use a higher resolution image (at least 500x500 pixels).

## Related Features
- [Edit Profile Information](edit-profile.md)
- [Privacy Settings](privacy-settings.md)
```

**Skip this phase if:**
- Internal feature (not user-facing)
- API-only feature
- Developer-focused functionality

---

### Phase 7: Finalization

**Duration**: 5-10 minutes
**Always runs**: Yes

**Purpose**: Finalize workflow and provide next steps.

**What happens:**

1. **Update Metadata**
   - Set status to "completed" in metadata.yml
   - Record completion timestamp

2. **Persist Final State**
   - Save orchestrator-state.yml

3. **Generate Summary**
   - Overall results
   - Phase timings
   - Issues encountered
   - Next steps

**Summary example:**
```
🎉 Feature Development Complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Status: ✅ PASSED

Phase Results:
  1. Specification      ✅ 28 min
  2. Planning           ✅ 22 min
  3. Implementation     ✅ 145 min (3 auto-fixes)
  4. Verification       ✅ 38 min
  5. E2E Testing        ✅ 25 min
  6. User Documentation ✅ 30 min

Total Time: 4 hours 48 minutes

Tests: 287/287 passing (100%)
Standards: 5/5 applied
Documentation: Complete

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Task Directory:
.ai-sdlc/tasks/new-features/2025-11-17-user-profile-avatar

Next Steps:
1. ✅ Review verification report
2. ✅ Review code changes
3. ✅ Create git commit
4. ✅ Create pull request
5. ✅ Deploy to staging

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Execution Modes

### Interactive Mode (Default)

**Best for**: Complex features, first-time users, careful review

**Behavior:**
- ✅ Pauses after each phase
- ✅ Prompts for optional phases (E2E, user docs)
- ✅ Shows progress and waits for approval
- ✅ Allows course correction

**Example:**
```bash
/ai-sdlc:feature:new "Add shopping cart"

# After Phase 1
Review spec.md and approve to continue...

# After Phase 4
Run E2E tests? [Yes/No]

# After Phase 5 (if E2E ran)
Generate user documentation? [Yes/No]
```

### YOLO Mode

**Best for**: Simple features, experienced users, fast execution

**Behavior:**
- ✅ Runs all phases continuously
- ✅ Auto-decides on optional phases (based on feature type)
- ✅ Reports progress without waiting
- ✅ Completes entire workflow automatically

**Example:**
```bash
/ai-sdlc:feature:new "Add export to CSV" --yolo

🚀 YOLO Mode Activated! 🎢

[1/6] Specification... ✅ (15m)
[2/6] Planning... ✅ (12m)
[3/6] Implementation... ✅ (95m, 2 auto-fixes)
[4/6] Verification... ✅ (32m)
[5/6] E2E Testing... ⏭️ Skipped (non-UI feature)
[6/6] User Docs... ⏭️ Skipped (internal feature)

🎉 Feature Complete! Status: ✅ PASSED
```

**Auto-decisions in YOLO mode:**
- E2E tests: Enabled if spec mentions UI/frontend
- User docs: Enabled if spec targets end-users

---

## Pause and Resume

### Pausing

Simply stop responding or close Claude Code. State is automatically saved.

### Resuming

```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-11-17-user-profile-avatar
```

**Resume options:**
```bash
# Resume from specific phase
/ai-sdlc:feature:resume [path] --from=implementation

# Reset auto-fix attempts
/ai-sdlc:feature:resume [path] --reset-attempts

# Clear failure history
/ai-sdlc:feature:resume [path] --clear-failures
```

---

## Common Scenarios

### Scenario: Verification Failed

**Situation**: Phase 4 shows ❌ FAILED status

**Actions:**
1. Review verification report
2. Fix critical issues manually
3. Resume workflow:
   ```bash
   /ai-sdlc:feature:resume [path] --from=verification
   ```

### Scenario: Tests Failing

**Situation**: Test suite shows failures

**Actions:**
1. Review which tests failed in verification report
2. Fix failing tests manually
3. Re-run tests:
   ```bash
   npm test  # or your test command
   ```
4. Resume verification:
   ```bash
   /ai-sdlc:feature:resume [path] --from=verification
   ```

### Scenario: Want to Change Specification Mid-Workflow

**Situation**: Realized requirements changed after planning

**Actions:**
1. Edit `implementation/spec.md` manually
2. Resume from planning:
   ```bash
   /ai-sdlc:feature:resume [path] --from=planning
   ```
3. New implementation plan will be generated

### Scenario: E2E Tests Failing

**Situation**: E2E verification shows issues

**Actions:**
1. Review E2E report and screenshots
2. Fix UI issues in code
3. Resume E2E testing:
   ```bash
   /ai-sdlc:feature:resume [path] --from=e2e-testing
   ```

---

## Best Practices

### 1. Be Specific in Feature Description

**Good**: "Add user profile page with avatar upload (max 2MB, JPG/PNG), bio field (500 char max), and social links (Twitter, LinkedIn)"

**Better**: Provide design mockups during specification phase

### 2. Review Each Phase

Don't rush through phases. Take time to review:
- ✅ Specification: Ensure requirements are complete
- ✅ Planning: Verify task groups make sense
- ✅ Implementation: Check code quality
- ✅ Verification: Read the full report

### 3. Use Interactive Mode for Complex Features

YOLO mode is fast but interactive mode gives you control. Use interactive for:
- First time building this type of feature
- Complex features with many unknowns
- Features requiring careful security review

### 4. Enable E2E Testing for UI Features

Always run E2E tests if your feature has UI components. The screenshots are valuable for:
- Verification
- User documentation
- PR reviews
- Bug reports

### 5. Leverage Standards Discovery

The workflow continuously checks `.ai-sdlc/docs/INDEX.md` for standards. Keep your standards updated and they'll be automatically applied.

---

## Troubleshooting

### Error: "Prerequisites missing"

**Solution**: Run from earlier phase
```bash
/ai-sdlc:feature:new --from=spec
```

### Error: "Max attempts exceeded"

**Solution**: Fix manually, then resume
```bash
# Fix the issue
/ai-sdlc:feature:resume [path] --reset-attempts
```

### Phase keeps failing

**Solution**: Check state file for errors
```bash
cat [path]/orchestrator-state.yml
# Look at failures: [] for details
```

### Want to restart a phase

**Solution**: Override resume point
```bash
/ai-sdlc:feature:resume [path] --from=implementation
```

---

## Related Workflows

- **[Enhancement Workflow](enhancement-workflow.md)** - For improving existing features
- **[Bug Fixing Workflow](bug-fixing.md)** - For fixing defects
- **[Refactoring Workflow](refactoring.md)** - For improving code structure

---

## Additional Resources

- [Command Reference](../../commands/feature/new.md) - Detailed command documentation
- [Skill Documentation](../../skills/feature-orchestrator/SKILL.md) - Technical implementation details
- [Architecture Overview](../Architecture.md) - How workflows execute
- [Troubleshooting Guide](../Troubleshooting.md) - Common issues and solutions

---

**Next Steps**: Try creating your first feature with `/ai-sdlc:feature:new [description]`
