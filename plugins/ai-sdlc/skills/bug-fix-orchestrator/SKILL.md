---
name: bug-fix-orchestrator
description: Orchestrates the complete bug fixing workflow with MANDATORY TDD Red→Green discipline enforcement. Ensures systematic root cause analysis, reproduction data capture, proper fix implementation, and thorough validation. Supports interactive mode (pause between phases) and YOLO mode (continuous execution with TDD gates enforced). Use when fixing bugs to ensure test-driven development and prevent recurring issues.
---

# Bug Fix Orchestrator

This skill orchestrates the complete bug fixing workflow, ensuring systematic analysis, TDD-driven implementation, and thorough verification.

## When to Use This Skill

Use this skill when:
- A bug has been reported and needs systematic fixing
- You need guided workflow from analysis through testing
- You want TDD Red→Green discipline enforced
- You need state management for multi-phase bug fixes
- You want auto-recovery from common implementation failures

**DO NOT use for:**
- New features (use `feature-orchestrator`)
- Enhancements to existing features (use `enhancement-orchestrator`)
- Pure refactoring without behavior changes (use `refactoring-orchestrator`)

## Core Principles

1. **Root Cause Analysis First**: Always understand the underlying cause before implementing fixes
2. **TDD Red→Green Workflow**: Tests must FAIL before fix, PASS after fix (MANDATORY gates - cannot proceed without validation)
3. **Reproduction Data Capture**: Exact data CRITICAL for writing tests that actually reproduce the bug
4. **Standards Compliance**: Follow project coding standards during fixes
5. **Comprehensive Testing**: Verify fix works and doesn't introduce regressions
6. **Systematic Documentation**: Record bug, analysis, fix, and validation for future reference
7. **Complete Workflow**: Guide through all 4 phases systematically - no skipping phases

## Progress Tracking

Use `TodoWrite` to show real-time progress to the user. Create todos at workflow start, update at each phase transition.

**Phase Todos**:

| Phase | content | activeForm |
|-------|---------|------------|
| 1 | "Analyze bug and capture reproduction data" | "Analyzing bug and capturing reproduction data" |
| 2 | "Implement fix with TDD Red→Green" | "Implementing fix with TDD Red→Green" |
| 3 | "Run tests and verify fix" | "Running tests and verifying fix" |
| 4 | "Document and finalize" | "Documenting and finalizing" |

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
  {"content": "Analyze bug and capture reproduction data", "status": "pending", "activeForm": "Analyzing bug and capturing reproduction data"},
  {"content": "Implement fix with TDD Red→Green", "status": "pending", "activeForm": "Implementing fix with TDD Red→Green"},
  {"content": "Run tests and verify fix", "status": "pending", "activeForm": "Running tests and verifying fix"},
  {"content": "Document and finalize", "status": "pending", "activeForm": "Documenting and finalizing"}
]
```

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Bug Fix Orchestrator Started

Bug: [bug description]
Mode: [Interactive/YOLO]

Workflow Phases:
1. [ ] Bug Analysis & Reproduction → capture reproduction data
2. [ ] TDD Red→Green Implementation → write failing test, fix, verify pass
3. [ ] Test Verification → run full test suite, verify fix
4. [ ] Documentation & Finalization

State file: [task-path]/orchestrator-state.yml

TDD Gates (MANDATORY - cannot skip):
- Test must FAIL before fix implementation
- Test must PASS after fix implementation

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously. TDD gates still enforced.

Starting Phase 1: Bug Analysis & Reproduction...
```

### Step 3: Only Then Proceed to Phase 1

After completing Steps 1 and 2, proceed to Phase 1 (Bug Analysis & Reproduction).

---

## Execution Modes

### Interactive Mode (Default)
- Pauses after each major phase for review
- Shows analysis results and prompts for continuation
- Validates TDD gates with user confirmation
- Allows phase restart if needed
- Best for: Complex bugs, careful review, learning

### YOLO Mode
- Runs all phases continuously without pausing
- Auto-recovery from common failures
- Reports progress but doesn't wait for approval
- TDD gates still enforced (non-negotiable)
- Best for: Simple bugs, experienced users, fast fixes

## Workflow Phases

### Phase 1: Bug Analysis & Reproduction

**Purpose**: Understand bug, reproduce it, identify root cause

**Prerequisites** (MANDATORY):
- ✅ Bug description provided (from user or issue tracker)
- ✅ Task directory created in `.ai-sdlc/tasks/bug-fixes/[dated-name]/`

**If prerequisites missing**:
- HALT workflow
- Request bug description from user
- Create task directory before proceeding
- CANNOT proceed to analysis without bug context

**Actions**:
1. Capture bug information (description, steps, expected vs actual behavior)
2. Identify affected components, files, and functions
3. Create minimal test case reproducing the issue
4. **CRITICAL**: Capture exact reproduction data (inputs, configuration, state) to `planning/bug-analysis/reproduction-data.md`
5. Analyze root cause through code tracing
6. Document analysis with file:line references

**Outputs**:
- `planning/bug-analysis/bug-report.md` - Bug description and symptoms
- `planning/bug-analysis/reproduction-steps.md` - Exact steps to reproduce
- `planning/bug-analysis/reproduction-data.md` - **CRITICAL for writing tests**
- `planning/bug-analysis/root-cause-analysis.md` - Root cause with code locations

**Auto-Fix Strategy**:
- If bug files not found: Expand search patterns, prompt user (max 2 attempts)
- If unable to reproduce: Request more details from user

### Phase 2: Fix Implementation (TDD Red→Green)

**Purpose**: Implement fix following test-driven development

**Standards Reminder**: Review `.ai-sdlc/docs/INDEX.md` for relevant standards (error handling, validation, coding style) before implementing the fix.

**Prerequisites** (MANDATORY):
- ✅ Phase 1 complete (bug analysis & reproduction)
- ✅ `planning/bug-analysis/reproduction-data.md` exists and contains exact reproduction data
- ✅ `planning/bug-analysis/root-cause-analysis.md` exists with identified root cause
- ✅ `bug_context.reproduction_confirmed == true` in orchestrator-state.yml
- ✅ `bug_context.root_cause_identified == true` in orchestrator-state.yml

**If prerequisites missing**:
```
❌ Cannot proceed to fix implementation - missing prerequisites!

Required:
- [✅/❌] Reproduction data captured
- [✅/❌] Root cause identified
- [✅/❌] Phase 1 complete

CANNOT proceed without reproduction data - tests will use generic data and fail to reproduce bug.

Options:
1. Complete Phase 1 (Bug Analysis & Reproduction)
2. Provide missing files manually
3. Exit workflow

Choice: _
```

**Actions**:
1. Review relevant standards from `.ai-sdlc/docs/standards/`
2. Plan minimal fix addressing root cause
3. **TDD Red Phase**: Write regression test using EXACT reproduction data from Phase 1
4. **VALIDATE test FAILS** (mandatory gate - cannot proceed if test passes)
5. Document test failure in `implementation/regression-tests/test-failure-log.md`
6. Implement targeted fix following project standards
7. **TDD Green Phase**: Verify test now PASSES
8. Document test success in test-failure-log.md
9. Review implementation for side effects and standards compliance

**Outputs**:
- Implemented code changes
- `implementation/regression-tests/test-failure-log.md` - TDD Red→Green validation
- `implementation/regression-tests/tdd-exception.md` - TDD exception documentation (if TDD not feasible)
- `implementation/work-log.md` - Activity log

**TDD Gates** (Strongly Recommended, Exception Path Available):
- 🔴 **Red Gate**: Test SHOULD fail before fix implementation (validates test reproduces bug)
- 🟢 **Green Gate**: Test SHOULD pass after fix implementation (validates fix works)
- ⚠️ **Exception Path**: If TDD not feasible, document why and provide alternative validation approach

**Auto-Fix Strategy**:
- Fix syntax errors, missing imports (max 3 attempts)
- If test doesn't fail: STOP and diagnose (test doesn't reproduce bug)
- If test still fails after fix: Analyze and retry (max 3 attempts)

### Phase 3: Testing & Verification

**Purpose**: Comprehensive testing to ensure fix works and no regressions

**Prerequisites** (MANDATORY):
- ✅ Phase 2 complete (fix implementation)
- ✅ **EITHER**: TDD gates validated **OR** TDD exception documented
  - **TDD Path**: `bug_context.tdd_red_validated == true` AND `bug_context.tdd_green_validated == true`
  - **Exception Path**: `bug_context.tdd_exception_documented == true` with `implementation/regression-tests/tdd-exception.md`
- ✅ `implementation/work-log.md` exists with fix implementation details

**If prerequisites missing**:
```
❌ Cannot proceed to testing - Neither TDD validation nor exception documented!

TDD Gate Status:
- [✅/❌] Red Gate: Test failed before fix
- [✅/❌] Green Gate: Test passes after fix
- [✅/❌] TDD Exception: Documented with alternative validation

You must EITHER:
  A) Complete TDD Red→Green validation (recommended), OR
  B) Document why TDD not feasible and provide alternative validation

**Strongly Recommended**: Try TDD first. Only use exception path if truly impossible.

Options:
1. Complete Phase 2 (Fix Implementation with TDD validation)
2. Validate TDD gates manually
3. Document TDD exception (if TDD truly not feasible)
4. Exit workflow

Choice: _
```

**Actions**:
1. Regression test already validated (Red→Green complete)
2. Add edge case tests (2-8 total, vary ONE aspect of reproduction data at a time)
3. Run full test suite to catch regressions
4. Manual verification if applicable
5. Check code coverage for fixed paths
6. Create fix verification report

**Outputs**:
- Complete test suite results
- `verification/fix-verification.md` - Comprehensive verification report

**Auto-Fix Strategy**:
- Re-run failed tests and analyze (max 2 attempts)
- Fix edge case test issues automatically

### Phase 3a: Reality Check (Run Automatically)
**Agent**: `reality-assessor` (subagent)

**Purpose**: Validate fix actually resolves the reported issue end-to-end

**Triggered When**: Always after Phase 3 (Testing & Verification) and TDD validation - runs automatically in both Interactive and YOLO modes

**Actions**:
1. Invoke reality-assessor via Task tool with task directory path
2. Validate fix addresses the root cause (not just symptoms)
3. Test that fix works in realistic conditions (not just test environment)
4. Verify fix doesn't introduce new issues or regressions
5. Check reproduction scenario no longer occurs

**Outputs**:
- `verification/reality-check.md` - Reality assessment with GO/NO-GO recommendation

**Critical Failure Handling**:
- If reality-check returns NO-GO in YOLO mode: Pause workflow
- In interactive mode: Show results and prompt user decision

### Phase 4: Documentation & Completion

**Purpose**: Document fix and prepare for commit

**Prerequisites** (MANDATORY):
- ✅ Phase 3 complete (testing & verification)
- ✅ `verification/fix-verification.md` exists with comprehensive verification report
- ✅ Full test suite passing (or >90% with documented failures)
- ✅ No critical regression failures

**If prerequisites missing**:
```
❌ Cannot proceed to documentation - testing not complete!

Required:
- [✅/❌] Verification report exists
- [✅/❌] Full test suite run
- [✅/❌] No critical regressions

CANNOT proceed with failing tests - must fix regressions before documenting.

Options:
1. Complete Phase 3 (Testing & Verification)
2. Fix failing tests
3. Exit workflow

Choice: _
```

**Actions**:
1. Update code documentation and comments
2. Create fix summary (bug, root cause, fix, files changed, tests)
3. Cleanup debug code and temporary changes
4. Update metadata.yml with completion status
5. Generate commit message template
6. Provide next steps guidance

**Outputs**:
- Updated code comments
- Fix summary report
- Commit message template
- Updated `metadata.yml`

**Auto-Fix Strategy**:
- Auto-generate missing documentation (max 1 attempt)
- Auto-cleanup obvious debug code

---

## Orchestrator Workflow Execution

### Initialization

**STEP 1: Parse Command Arguments**

Extract from invocation:
- Bug description (if provided)
- Execution mode: `--yolo` flag or default interactive
- Entry point: `--from=phase` (analysis, implementation, testing, documentation)
- Task path: If resuming existing task

**STEP 2: Determine Starting Phase**

**If task path provided** (resuming):
1. Read `orchestrator-state.yml` if exists
2. Check `completed_phases`
3. Determine next phase to execute
4. Validate prerequisites for that phase

**If new bug fix**:
1. Start from specified phase (`--from`) or Phase 1 (default)
2. If starting mid-workflow, validate required files exist:
   - Starting from implementation: Requires bug analysis complete
   - Starting from testing: Requires fix implemented + TDD gates validated
   - Starting from documentation: Requires tests passing

**If prerequisites missing**:
```
❌ Cannot start from [phase] - missing prerequisites!

Required files:
- [file1]: ❌ Missing
- [file2]: ❌ Missing

Options:
1. Start from beginning (Phase 1: Bug Analysis)
2. Provide/create missing files manually
3. Specify different entry point with --from

Which option would you like?
```

**STEP 3: Initialize State Management**

Create/update `orchestrator-state.yml`:

```yaml
orchestrator:
  mode: interactive  # or yolo
  started_phase: analysis
  current_phase: analysis
  completed_phases: []
  failed_phases: []
  auto_fix_attempts:
    analysis: 0
    implementation: 0
    testing: 0
    documentation: 0
  bug_context:
    severity: null  # Set during analysis: critical, high, medium, low
    reproduction_confirmed: false
    root_cause_identified: false
    tdd_red_validated: false  # Must be true before implementing fix (or exception documented)
    tdd_green_validated: false  # Must be true after fix (or exception documented)
    tdd_exception_documented: false  # True if TDD not feasible and documented
    tdd_exception_type: null  # legacy_code, integration_bug, race_condition, environment_specific, ui_bug, data_corruption, performance, third_party
    tdd_exception_reason: null  # Detailed explanation why TDD not applicable
    alternative_validation: null  # How bug will be verified instead
  options:
    skip_manual_verification: false
  created: 2025-10-27T12:00:00Z
  updated: 2025-10-27T12:00:00Z
  task_path: .ai-sdlc/tasks/bug-fixes/2025-10-27-bug-name
```

**STEP 4: Output Initialization Summary**

```
🚀 Bug Fix Orchestrator Started

Bug: [bug description]
Mode: [Interactive/YOLO]
Starting Phase: [phase name]

Workflow Phases:
1. [x] Bug Analysis & Reproduction - [Starting here / Already complete / Pending]
2. [ ] Fix Implementation (TDD Red→Green)
3. [ ] Testing & Verification
4. [ ] Documentation & Completion

State file: [path]/orchestrator-state.yml

[Interactive mode message]
You'll be prompted for review after each phase.

[YOLO mode message]
All phases will run continuously with TDD gates enforced. 🎢

Press Enter to begin...
```

### Phase Execution Loop

**FOR each phase in workflow:**

**STEP 1: Check if Phase Already Completed**

Read `orchestrator-state.yml`:

```
IF phase in completed_phases:
  Skip to next phase
ELSE IF phase in failed_phases AND auto_fix_attempts[phase] >= max_attempts:
  HALT workflow
  Display error message
  EXIT
ELSE:
  Proceed with execution
```

**STEP 2: Validate Prerequisites (MANDATORY)**

**Before executing ANY phase, validate prerequisites:**

```
IF current_phase == "implementation":
  IF bug_context.reproduction_confirmed == false:
    BLOCK execution
    Display: "❌ Cannot proceed - reproduction data not captured"
    EXIT workflow
  IF bug_context.root_cause_identified == false:
    BLOCK execution
    Display: "❌ Cannot proceed - root cause not identified"
    EXIT workflow

IF current_phase == "testing":
  IF bug_context.tdd_exception_documented == true:
    Display: "⚠️ TDD exception documented - proceeding with alternative validation"
    Display: "Exception type: [bug_context.tdd_exception_type]"
    Display: "Alternative validation: [bug_context.alternative_validation]"
    # Allow proceeding with warning
  ELSE IF bug_context.tdd_red_validated == false OR bug_context.tdd_green_validated == false:
    BLOCK execution
    Display: "❌ Cannot proceed - TDD gates not validated and no exception documented"
    Display: ""
    Display: "TDD Gate Status:"
    Display: "- Red Gate (test failed before fix): [✅/❌]"
    Display: "- Green Gate (test passed after fix): [✅/❌]"
    Display: ""
    Display: "You must EITHER:"
    Display: "  A) Complete TDD Red→Green validation (strongly recommended)"
    Display: "  B) Document TDD exception if truly not feasible"
    Display: ""
    Display: "To document exception, create implementation/regression-tests/tdd-exception.md"
    EXIT workflow

IF current_phase == "documentation":
  IF "testing" NOT in completed_phases:
    BLOCK execution
    Display: "❌ Cannot proceed - testing phase not complete"
    EXIT workflow
```

**Key Principle**: Never proceed with phase execution if prerequisites not met. BLOCK and HALT workflow.

**STEP 3: Update State to Current Phase**

```yaml
orchestrator:
  current_phase: [phase-name]
  updated: [current-timestamp]
```

**STEP 4: Pre-Phase Announcement**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase [N]: [Phase Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Phase description]

Starting...
```

**STEP 5: Execute Phase**

Each phase executes its specific logic (see Workflow Phases section above).

**STEP 6: Analyze Phase Results**

Extract status from phase output:
- ✅ Success
- ⚠️ Success with warnings
- ❌ Failure

If ❌ Failure detected:
- Increment `auto_fix_attempts.[phase]` in state
- Check if max attempts reached
- Execute auto-fix strategy (see Auto-Recovery section below)

**STEP 7: Update State After Phase**

If success:
```yaml
orchestrator:
  completed_phases:
    - [phase-name]
  bug_context:  # Update based on phase
    severity: [from analysis]
    reproduction_confirmed: [from analysis]
    root_cause_identified: [from analysis]
    tdd_red_validated: [from implementation]
    tdd_green_validated: [from implementation]
  updated: [timestamp]
```

If failure (after auto-fix attempts):
```yaml
orchestrator:
  failed_phases:
    - phase: [phase-name]
      attempts: [count]
      error: [error description]
  updated: [timestamp]
```

**STEP 8: Post-Phase Review (Interactive Mode Only)**

If interactive mode:
```
✅ Phase [N] Complete: [Phase Name]

Results:
- [Key result 1]
- [Key result 2]

Status: [Success/Success with warnings]

[If Phase 1 complete]
📊 Bug Analysis Summary:
- Severity: [critical/high/medium/low]
- Root cause: [brief description]
- Affected files: [count] files

[If Phase 2 complete]
🔴🟢 TDD Validation:
- Red phase: ✅ Test failed before fix
- Green phase: ✅ Test passes after fix

[If warnings exist]
⚠️ Warnings:
- [Warning 1]
- [Warning 2]

Would you like to:
1. Continue to next phase
2. Review outputs in detail
3. Restart this phase
4. Stop workflow (resume later)

Choice: _
```

Wait for user input.

If YOLO mode:
```
✅ Phase [N] Complete: [Phase Name]
Status: [Success/Success with warnings]
→ Continuing to next phase...
```

Proceed immediately without waiting.

### TDD Gate Enforcement

**CRITICAL**: TDD gates are STRONGLY RECOMMENDED - always try TDD first. Exception path available if truly not feasible.

**Gate 1: TDD Red Phase (Before Implementing Fix)**

```
**ALWAYS attempt TDD validation first:**

IF bug_context.tdd_red_validated == false AND bug_context.tdd_exception_documented == false:

  ❌ TDD Red Gate Not Validated

  Test SHOULD fail before implementing fix to prove it reproduces the bug.

  **Strongly recommended**: Complete TDD validation before proceeding.

  **Use AskUserQuestion** in interactive mode:

  Question: "TDD Red gate requires validation. What would you like to do?"

  Header: "Red Gate Validation"

  Options:
  1. Label: "Run test and validate it fails (RECOMMENDED)"
     Description: "Execute regression test to confirm it fails (proves test reproduces bug). This is the recommended approach."

  2. Label: "Review test code"
     Description: "Review test implementation to ensure it uses exact reproduction data from Phase 1."

  3. Label: "Document TDD exception"
     Description: "TDD not feasible for this bug (legacy code, integration complexity, etc.). Document why and provide alternative validation. Use only if TDD truly impossible."

  4. Label: "Abort workflow"
     Description: "Stop workflow and address TDD validation manually."

  Multi-select: false

  **If user selects "Document TDD exception":**
    Use AskUserQuestion to gather exception details:

    Question: "Why is TDD not feasible for this bug?"

    Header: "TDD Exception"

    Options:
    1. Label: "Legacy code without existing tests"
       Description: "Codebase has no test infrastructure. Adding first tests would require significant setup."

    2. Label: "Integration bug requiring external services"
       Description: "Bug requires database, external APIs, or services not available in test environment."

    3. Label: "Race condition or timing bug"
       Description: "Bug is non-deterministic, timing-dependent, or impossible to reproduce reliably in tests."

    4. Label: "Environment-specific bug"
       Description: "Bug only occurs in production environment and cannot be reproduced locally."

    5. Label: "UI/UX bug without testable criteria"
       Description: "Visual or user experience issue that cannot be validated with automated tests."

    6. Label: "Data corruption requiring specific state"
       Description: "Bug requires corrupted or complex data state that's impractical to recreate in tests."

    7. Label: "Performance bug requiring production load"
       Description: "Bug only manifests under production-scale load that cannot be simulated in tests."

    8. Label: "Third-party API dependency unavailable"
       Description: "Bug involves third-party service that cannot be mocked or doesn't have test environment."

    Multi-select: false

    Then ask: "How will you validate this fix instead of TDD?"
    (Free text input for alternative_validation)

    Create implementation/regression-tests/tdd-exception.md:
    ```markdown
    # TDD Exception Documentation

    ## Exception Type
    [exception_type]

    ## Reason TDD Not Feasible
    [Detailed explanation from user]

    ## Alternative Validation Approach
    [How fix will be verified instead of automated tests]

    Examples:
    - Manual testing in production
    - Production monitoring with alerts
    - Code review with experienced engineer
    - Gradual rollout with canary deployment
    - User acceptance testing

    ## Recommendation for Future
    [If applicable, suggest how to add tests post-fix or improve testability]
    ```

    Set bug_context.tdd_exception_documented = true
    Set bug_context.tdd_exception_type = [selected type]
    Set bug_context.tdd_exception_reason = [user explanation]
    Set bug_context.alternative_validation = [user's alternative approach]

    Display: "⚠️ TDD exception documented. Proceeding with alternative validation."
    Display: "Please ensure alternative validation approach is thorough."

    Continue to fix implementation

  **In YOLO mode:**
  - Auto-run test
  - IF test PASSES (expected: FAIL):
      Display: "⚠️ Red gate failed - test passed before fix. Test does NOT reproduce bug."
      Display: "This usually means test uses generic data or bug cannot be reproduced in tests."
      Display: ""
      Display: "Attempting to document TDD exception..."

      Set bug_context.tdd_exception_documented = true
      Set bug_context.tdd_exception_type = "integration_bug"  # Conservative assumption
      Set bug_context.tdd_exception_reason = "Automated test could not reproduce bug - may require specific environment, data, or integration context"
      Set bug_context.alternative_validation = "Manual verification in appropriate environment, production monitoring"

      Create tdd-exception.md with auto-generated content

      Display: "⚠️ TDD exception auto-documented. Please review and update:"
      Display: "  implementation/regression-tests/tdd-exception.md"
      Display: ""
      Display: "Continuing with fix implementation..."

      Continue to fix implementation

  - IF test FAILS (expected):
      Set bug_context.tdd_red_validated = true
      Continue to fix implementation
```

**Gate 2: TDD Green Phase (After Implementing Fix)**

```
**ALWAYS validate after writing fix code:**

IF bug_context.tdd_green_validated == false AND bug_context.tdd_exception_documented == false:

  ❌ TDD Green Gate Not Validated

  Test SHOULD pass after implementing fix to prove fix works.

  **Strongly recommended**: Complete TDD validation before proceeding.

  **Use AskUserQuestion** in interactive mode:

  Question: "TDD Green gate requires validation. What would you like to do?"

  Header: "Green Gate Validation"

  Options:
  1. Label: "Run test and validate it passes (RECOMMENDED)"
     Description: "Execute regression test to confirm it passes (proves fix works). This is the recommended approach."

  2. Label: "Review fix code"
     Description: "Review fix implementation to ensure it addresses root cause identified in Phase 1."

  3. Label: "Re-implement fix"
     Description: "Fix does not work. Re-implement and try again."

  4. Label: "Document TDD exception"
     Description: "TDD not feasible for this bug. Document why and provide alternative validation. Use only if already documented in Red phase or TDD truly impossible."

  5. Label: "Abort workflow"
     Description: "Stop workflow and address TDD validation manually."

  Multi-select: false

  **If user selects "Document TDD exception":**
    (Same exception gathering flow as Red phase - use AskUserQuestion for exception type and alternative validation)

    Create/update implementation/regression-tests/tdd-exception.md

    Set bug_context.tdd_exception_documented = true
    Set bug_context.tdd_exception_type = [selected type]
    Set bug_context.tdd_exception_reason = [user explanation]
    Set bug_context.alternative_validation = [user's alternative approach]

    Display: "⚠️ TDD exception documented. Proceeding with alternative validation."
    Continue to Phase 3

ELSE IF bug_context.tdd_exception_documented == true:
  Display: "⚠️ TDD exception already documented - skipping Green gate validation"
  Display: "Using alternative validation: [bug_context.alternative_validation]"
  Continue to Phase 3

  **In YOLO mode:**
  - IF tdd_exception_documented == true:
      Display: "⚠️ TDD exception documented - skipping Green gate validation"
      Continue to Phase 3

  - ELSE:
      Auto-run test
      IF test FAILS (expected: PASS):
          Increment auto_fix_attempts[implementation]
          IF auto_fix_attempts[implementation] < 3:
              Auto-analyze failure
              Retry fix implementation
          ELSE:
              Display: "⚠️ Green gate failed after 3 attempts - test still fails after fix."
              Display: "Auto-documenting TDD exception..."

              Set bug_context.tdd_exception_documented = true
              Set bug_context.tdd_exception_type = "integration_bug"
              Set bug_context.tdd_exception_reason = "Automated test could not validate fix - may require specific environment or integration context. Fix applied based on root cause analysis."
              Set bug_context.alternative_validation = "Manual verification in appropriate environment, production monitoring, code review"

              Create/update tdd-exception.md with auto-generated content

              Display: "⚠️ TDD exception auto-documented. Please review and validate fix manually:"
              Display: "  implementation/regression-tests/tdd-exception.md"

              Continue to Phase 3 (with warning)

      IF test PASSES (expected):
          Set bug_context.tdd_green_validated = true
          Continue to Phase 3
```

**Key Principles**:

1. **TDD strongly recommended**: ALWAYS try TDD Red→Green first - it's the gold standard for bug fixes
2. **Exception path available**: If TDD truly not feasible, document why and provide alternative validation
3. **Justification required**: Cannot skip TDD without documented reason and alternative approach
4. **Document validation**: Log Red→Green results in `test-failure-log.md` OR TDD exception in `tdd-exception.md`
5. **Use exact reproduction data**: Tests SHOULD use data from `planning/bug-analysis/reproduction-data.md`
6. **Alternative validation must be thorough**: If skipping TDD, alternative approach must be explicit and rigorous
7. **Warning in verification**: TDD exceptions flagged in verification report for review

### Finalization

**STEP 1: Generate Workflow Summary**

Create comprehensive summary:

```markdown
# Bug Fix Workflow Summary

**Bug**: [bug description]
**Task Path**: [path]
**Mode**: [Interactive/YOLO]
**Duration**: [start time] - [end time] ([duration])

## Bug Analysis

- **Severity**: [critical/high/medium/low]
- **Root Cause**: [description]
- **Affected Files**: [list with file:line references]
- **Impact**: [description]

## Fix Implementation

- **Approach**: [description]
- **TDD Red Phase**: ✅ Test failed before fix
- **TDD Green Phase**: ✅ Test passed after fix
- **Files Modified**: [count] files
- **Standards Applied**: [list]

## Testing Results

- **Regression Test**: ✅ Passes
- **Edge Case Tests**: [count] tests added
- **Full Test Suite**: [P]/[T] passing ([percentage]%)

## Completed Phases

1. ✅ Bug Analysis & Reproduction
   - Status: Success
   - Root cause identified
   - Reproduction confirmed

2. ✅ Fix Implementation (TDD)
   - Status: Success
   - TDD gates validated
   - Fix applied

3. ✅ Testing & Verification
   - Status: Success
   - [P]/[T] tests passing

4. ✅ Documentation & Completion
   - Status: Success
   - Documentation complete

## Overall Status

**Result**: ✅ Bug Fixed | ⚠️ Fixed with Issues | ❌ Failed

**Files Modified**:
- [List files with changes]

**Test Coverage**:
- Regression tests: 1 (proven to reproduce bug)
- Edge case tests: [count]
- Total: [count] tests, [percentage]% passing

## Next Steps

1. Review fix verification report: verification/fix-verification.md
2. Review TDD validation log: implementation/regression-tests/test-failure-log.md
3. Create commit with suggested message below
4. Create pull request
5. Deploy to staging/production

## Suggested Commit Message

\```
fix: [Brief description of bug]

[Description of what was broken and impact]

Root cause: [Explanation]

Fix: [What was changed and why]

Tests: 1 regression test + [N] edge case tests, all passing
TDD: Red→Green validated

Fixes #[issue-number]
\```

## State File

Workflow state saved to:
[orchestrator-state.yml]
```

**STEP 2: Update Task Metadata**

Update `metadata.yml`:

```yaml
name: [bug name]
type: bug-fix
status: completed  # or review if issues exist
priority: [based on severity]
created: [unchanged]
updated: [current-timestamp]
completed: [current-timestamp]
tags:
  - bug
  - [severity level]
estimated_hours: [if was set]
actual_hours: [calculated from created to completed]
```

**STEP 3: Output Final Summary to User**

```
🎉 Bug Fix Complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Bug: [bug description]
Status: [Overall status with icon]
Duration: [duration]

Phases Completed: 4/4
✅ Bug Analysis & Reproduction
✅ Fix Implementation (TDD Red→Green ✅)
✅ Testing & Verification
✅ Documentation & Completion

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Location: [task-path]

📊 Key Metrics:
- Severity: [level]
- Root cause: [brief]
- Files modified: [count]
- Tests: [count] ([percentage]% passing)
- TDD validation: ✅ Red→Green

📄 Reports:
- Bug analysis: planning/bug-analysis/root-cause-analysis.md
- TDD validation: implementation/regression-tests/test-failure-log.md
- Work log: implementation/work-log.md
- Verification: verification/fix-verification.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[If success]
✅ Ready to Commit & Deploy!

Next steps:
1. Review outputs in [task-path]
2. Commit changes (suggested message in workflow summary)
3. Create pull request
4. Deploy to staging/production

[If issues]
⚠️ Complete with Issues

Please review:
- [Issue 1]
- [Issue 2]

Address these issues before deployment.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Workflow summary saved to:
[task-path]/workflow-summary.md

Thank you for using the Bug Fix Orchestrator! 🚀
```

---

## State Management

### State File Format

Location: `.ai-sdlc/tasks/bug-fixes/[dated-name]/orchestrator-state.yml`

```yaml
orchestrator:
  # Execution configuration
  mode: interactive  # or yolo
  started_phase: analysis
  current_phase: implementation

  # Phase tracking
  completed_phases:
    - analysis
  failed_phases: []  # or [{phase: "implementation", attempts: 3, error: "..."}]

  # Auto-fix tracking
  auto_fix_attempts:
    analysis: 0
    implementation: 2
    testing: 0
    documentation: 0

  # Bug-specific context
  bug_context:
    severity: high  # critical, high, medium, low
    reproduction_confirmed: true
    root_cause_identified: true
    tdd_red_validated: false  # MUST be true before implementing fix (or exception documented)
    tdd_green_validated: false  # MUST be true after fix (or exception documented)
    tdd_exception_documented: false  # True if TDD not feasible and documented
    tdd_exception_type: null  # legacy_code, integration_bug, race_condition, environment_specific, ui_bug, data_corruption, performance, third_party
    tdd_exception_reason: null  # Detailed explanation why TDD not applicable
    alternative_validation: null  # How bug will be verified instead
    affected_files:
      - src/auth/login.ts:42
      - src/utils/validation.ts:15

  # Options
  options:
    skip_manual_verification: false

  # Timestamps
  created: 2025-10-27T12:00:00Z
  updated: 2025-10-27T14:30:00Z
  completed: null  # Set when workflow finishes

  # Metadata
  task_path: .ai-sdlc/tasks/bug-fixes/2025-10-27-fix-login-timeout
  bug_description: "Login fails with special characters in password"

  # Phase results (stored for resume)
  phase_results:
    analysis:
      status: success
      root_cause: "Improper input sanitization"
      severity: high
```

### State Operations

**Read State**:
```bash
if [ -f "$TASK_PATH/orchestrator-state.yml" ]; then
  cat "$TASK_PATH/orchestrator-state.yml"
else
  echo "No existing state found"
fi
```

**Update State** (after each phase):
- Edit specific fields using Edit tool
- Or rewrite entire file with updated values

**Resume from State**:
1. Read orchestrator-state.yml
2. Check completed_phases
3. Validate TDD gates (cannot skip if not validated)
4. Determine next phase
5. Validate prerequisites
6. Continue from next phase

### State Reconstruction

If state file is missing or corrupted, attempt reconstruction from existing artifacts:

**Phase Detection** (File-to-Phase Mapping):

```
**Phase 1: Bug Analysis & Reproduction** - COMPLETE if all exist:
- planning/bug-analysis/bug-report.md
- planning/bug-analysis/reproduction-steps.md
- planning/bug-analysis/reproduction-data.md (CRITICAL)
- planning/bug-analysis/root-cause-analysis.md

**Phase 2: Fix Implementation (TDD)** - COMPLETE if all exist:
- implementation/work-log.md
- Fix code changes applied (check git diff or file modification timestamps)
- **EITHER**: TDD validated OR TDD exception documented
  - TDD Path: implementation/regression-tests/test-failure-log.md (with "Red phase: FAIL" and "Green phase: PASS")
  - Exception Path: implementation/regression-tests/tdd-exception.md

TDD Gate Validation Detection:
- Red gate validated: test-failure-log.md contains "Red phase: FAIL" or "🔴 Red phase: ✅ Test failed"
- Green gate validated: test-failure-log.md contains "Green phase: PASS" or "🟢 Green phase: ✅ Test passed"
- TDD exception documented: tdd-exception.md exists

**Phase 3: Testing & Verification** - COMPLETE if exists:
- verification/fix-verification.md

**Phase 4: Documentation & Completion** - COMPLETE if exists:
- metadata.yml with status="completed"
- workflow-summary.md
```

**Reconstruction Algorithm**:

```
1. Check for orchestrator-state.yml:
   IF exists:
     Use existing state (most reliable)
     EXIT reconstruction
   ELSE:
     Proceed with reconstruction

2. Initialize reconstructed state:
   completed_phases = []
   bug_context.tdd_red_validated = false
   bug_context.tdd_green_validated = false
   auto_fix_attempts = {all: 0}

3. Detect completed phases:
   IF all Phase 1 files exist:
     Add "analysis" to completed_phases
     Set bug_context.reproduction_confirmed = true
     Set bug_context.root_cause_identified = true

   # Check for TDD validation OR exception
   IF test-failure-log.md exists:
     Read file content
     IF contains "Red phase: FAIL" OR "🔴 Red phase: ✅":
       Set bug_context.tdd_red_validated = true
     IF contains "Green phase: PASS" OR "🟢 Green phase: ✅":
       Set bug_context.tdd_green_validated = true

   IF tdd-exception.md exists:
     Read file content
     Set bug_context.tdd_exception_documented = true
     Extract exception_type from "## Exception Type" section
     Set bug_context.tdd_exception_type = [extracted type]
     Extract alternative_validation from "## Alternative Validation Approach" section
     Set bug_context.alternative_validation = [extracted approach]

   # Phase 2 complete if EITHER TDD validated OR exception documented
   IF (bug_context.tdd_red_validated == true AND bug_context.tdd_green_validated == true) OR bug_context.tdd_exception_documented == true:
     Add "implementation" to completed_phases

   IF fix-verification.md exists:
     Add "testing" to completed_phases

   IF metadata.yml contains status="completed":
     Add "documentation" to completed_phases

4. Determine current phase:
   IF "documentation" in completed_phases:
     current_phase = null  # Workflow complete
     status = "completed"
   ELSE IF "testing" in completed_phases:
     current_phase = "documentation"
   ELSE IF "implementation" in completed_phases:
     current_phase = "testing"
   ELSE IF "analysis" in completed_phases:
     current_phase = "implementation"
   ELSE:
     current_phase = "analysis"

5. Validate TDD gates for reconstruction:
   IF current_phase == "testing" OR current_phase == "documentation":
     IF bug_context.tdd_exception_documented == true:
       Display: "⚠️ TDD exception detected during reconstruction"
       Display: "Exception type: [bug_context.tdd_exception_type]"
       Display: "Alternative validation: [bug_context.alternative_validation]"
       # Allow proceeding with warning
     ELSE IF bug_context.tdd_red_validated == false OR bug_context.tdd_green_validated == false:
       Display warning:
       "⚠️ State reconstructed but TDD gates not validated and no exception documented"
       "Cannot proceed to [current_phase] without TDD validation OR exception documentation"
       "Please either:"
       "  A) Validate TDD gates manually, OR"
       "  B) Create implementation/regression-tests/tdd-exception.md documenting why TDD not feasible"
       "  C) Restart from Phase 2"
       HALT workflow

6. Create reconstructed state file:
   Write orchestrator-state.yml with:
   - Detected completed_phases
   - TDD gate validation status
   - Current phase
   - Mark as reconstructed with medium confidence

7. Output reconstruction summary:
   Display:
   "📂 State Reconstructed from Artifacts

   Detected Phases:
   [✅/❌] Phase 1: Analysis
   [✅/❌] Phase 2: Implementation
     - TDD Red validated: [✅/❌]
     - TDD Green validated: [✅/❌]
     - TDD Exception documented: [✅/❌]
     [If exception] - Exception type: [type]
     [If exception] - Alternative validation: [approach]
   [✅/❌] Phase 3: Testing
   [✅/❌] Phase 4: Documentation

   Current Phase: [phase name]
   Confidence: Medium

   [If TDD exception]
   ⚠️ TDD exception detected - alternative validation will be used

   Note: Reconstructed state lacks exact auto-fix attempt counts.
   Resume from [current_phase]?"
```

**Reconstruction Limitations**:

Reconstructed state lacks:
- Exact auto-fix attempt counts (resets to 0)
- Bug severity classification (unless in bug-report.md)
- Phase-specific timing and metadata
- Exact failure history
- Original execution mode (defaults to interactive)

**Recommendation**: Always prefer original state file. Use reconstruction as fallback only.

**When to Reconstruct**:
- State file accidentally deleted
- State file corrupted
- Resuming after manual file edits outside orchestrator
- Importing work from another source

---

## Auto-Recovery Features

| Phase | Auto-Fix Capabilities | Max Attempts |
|-------|----------------------|--------------|
| **Phase 1: Analysis** | Expand search for bug files, prompt for reproduction details | 2 |
| **Phase 2: Implementation** | Fix syntax errors, missing imports, test assertion issues | 3 |
| **Phase 3: Testing** | Re-run failed tests, analyze failures, fix edge case tests | 2 |
| **Phase 4: Documentation** | Auto-generate missing docs, cleanup debug code | 1 |

**TDD Gate Failures** (Special Handling):
- If test passes before fix (Red gate fails): STOP and diagnose - test doesn't reproduce bug
- If test fails after fix (Green gate fails): Analyze and retry fix (max 3 attempts)

**Global Failure Handling**:

If any phase exceeds max auto-fix attempts:

```
❌ Auto-fix failed after [N] attempts

Phase: [phase name]
Last error: [error description]

Options:
1. Continue workflow (skip this phase) - NOT RECOMMENDED
2. Fix manually and resume workflow
3. Stop workflow completely

State saved to: [orchestrator-state.yml]

To resume after manual fixes:
Use: /ai-sdlc:bug-fix:resume [task-path]

What would you like to do? _
```

---

## Integration Points

### Documentation System
- Read `.ai-sdlc/docs/INDEX.md` at initialization
- Follow standards from `.ai-sdlc/docs/standards/`
- Apply error handling and validation standards during fixes

### Testing Standards
- Follow test-writing standards from `.ai-sdlc/docs/standards/testing/`
- TDD Red→Green discipline enforced
- Regression tests use exact reproduction data

### Version Control
- Generate clear, descriptive commit messages
- Reference bug reports or issue numbers
- Follow project's commit conventions

---

## Command Integration

This skill is invoked via:

**Primary**: `/ai-sdlc:bug-fix:new [description] [options]`
**Resume**: `/ai-sdlc:bug-fix:resume [task-path]`

See `commands/bug-fix/new.md` and `commands/bug-fix/resume.md` for command specifications.

---

## Error Handling Philosophy

**Graceful Degradation**:
- Attempt auto-fix before failing
- Document issues clearly
- Provide resume capability
- Never lose progress

**User Control**:
- Interactive mode gives control at phase boundaries
- YOLO mode trusts automation but enforces TDD gates
- Can always stop and resume manually
- State preserved across sessions

**Transparency**:
- All state in orchestrator-state.yml
- All outputs in task directory
- Clear status indicators
- Detailed error messages
- TDD gate validation visible

---

## Important Guidelines

### Orchestration Best Practices

1. **Always update state file** after each phase
2. **Respect mode settings** - don't prompt in YOLO mode (except TDD gates)
3. **Validate prerequisites** before each phase
4. **Enforce TDD gates** - non-negotiable, even in YOLO mode
5. **Capture reproduction data** - critical for writing tests that actually work
6. **Document root cause** - prevents recurring issues

### TDD Discipline

**Strongly Recommend**:
- Test SHOULD fail before fix (Red gate)
- Test SHOULD pass after fix (Green gate)
- Use EXACT reproduction data from Phase 1
- Document Red→Green validation in test-failure-log.md

**Allow with Documentation**:
- TDD exception if truly not feasible (legacy code, integration complexity, etc.)
- MUST document why TDD not applicable in tdd-exception.md
- MUST provide alternative validation approach
- Flag in verification report for review

**Don't allow**:
- Skipping TDD without documented justification
- Tests that pass before fix without investigating why
- Generic test data when exact reproduction data available
- Proceeding without EITHER TDD validation OR documented exception

### State Consistency

**Always ensure**:
- State file matches actual phase status
- Completed phases list is accurate
- Failed phases tracked with reasons
- TDD gate validation status accurate
- Auto-fix attempt counters incremented
- Timestamps updated

**State is source of truth** for resume capability.

---

## Reference Files

See `references/` directory for detailed guides:

- **bug-fix-checklist.md**: Comprehensive checklist of all workflow steps (246 lines)

These references provide additional details for specific bug-fixing scenarios.

---

## Example Workflows

### Example 1: Simple Bug Fix, Interactive Mode

```
Command: /ai-sdlc:bug-fix:new "Login fails with special characters"

Output:
🚀 Bug Fix Orchestrator Started
Mode: Interactive
Starting Phase: Bug Analysis

[Phase 1: Analysis]
✅ Analysis Complete
- Severity: High
- Root cause: Improper input sanitization
- Affected: src/auth/login.ts:42
-> Pause, show results, wait for user

[User approves]
[Phase 2: Implementation]
🔴 Running test... FAILED ✅ (Red phase validated)
💻 Implementing fix...
🟢 Running test... PASSED ✅ (Green phase validated)
✅ Implementation Complete
-> Pause, show results, wait for user

[User approves]
[Phase 3: Testing]
✅ Testing Complete
- Regression test: ✅ Passes
- Edge cases: 3 tests added, all passing
- Full suite: 142/142 passing (100%)
-> Pause, show results, wait for user

[User approves]
[Phase 4: Documentation]
✅ Documentation Complete

[Finalization]
🎉 Bug Fixed!
All tests passing ✅
[Summary output]
```

### Example 2: YOLO Mode (Fast Fix)

```
Command: /ai-sdlc:bug-fix:new "Null pointer in profile" --yolo

Output:
🚀 Bug Fix Orchestrator Started
Mode: YOLO 🎢
Starting Phase: Bug Analysis

[Phase 1] Analysis... ✅ (8m)
[Phase 2] Implementation (TDD)...
  🔴 Red phase: ✅ Test failed
  💻 Fix applied
  🟢 Green phase: ✅ Test passed
  ✅ (12m)
[Phase 3] Testing... ✅ (6m, 4 tests, all passing)
[Phase 4] Documentation... ✅ (3m)

🎉 Bug Fixed!
Status: ✅ Success
Duration: 29 minutes
Tests: 4/4 passing (100%)
TDD: Red→Green validated ✅

Ready to commit and deploy!
```

### Example 3: Resume from Failure

```
Command: /ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-27-timeout

Output:
📂 Resuming Bug Fix Workflow

Bug: Login timeout issue
Last phase: Implementation (failed after 3 attempts)
Completed: Analysis

Options:
1. Retry implementation (auto-fix again)
2. Skip to testing (if manually fixed)
3. Restart from analysis
4. Abort workflow

Choice: 2

Validating TDD gates...
🔴 Red phase: ✅ Previously validated
🟢 Green phase: ⚠️ Not validated, validating now...
🟢 Running test... PASSED ✅

[Phase 3: Testing]
✅ Testing Complete
[Continue workflow...]
```

### Example 4: TDD Red Gate Failure

```
Command: /ai-sdlc:bug-fix:new "API timeout bug" --yolo

Output:
[Phase 1] Analysis... ✅
[Phase 2] Implementation (TDD)...
  🔴 Red phase: Running test...
  ❌ TEST PASSED (Expected: FAILED)

⚠️ TDD Red Gate Failed

Test passed before implementing fix.
This means test does NOT reproduce the bug.

Issue: Test using generic data, not reproduction data.

Auto-fix: Regenerating test with exact reproduction data...
  🔴 Running test... FAILED ✅ (Red phase validated)

Continuing with fix implementation...
  💻 Fix applied
  🟢 Running test... PASSED ✅ (Green phase validated)
  ✅ (15m, 1 auto-fix applied)

[Continue phases...]
```

---

## Validation Checklist

Before completing workflow, verify:

✓ All phases executed or explicitly skipped
✓ State file reflects actual completion status
✓ **EITHER**: TDD Red→Green validated **OR** TDD exception documented
  - If TDD path: test failed before fix AND test passes after fix
  - If exception path: tdd-exception.md exists with exception type and alternative validation
  - ⚠️ **If exception used**: Flag in verification report for review
✓ Reproduction data captured (and used in tests if TDD path followed)
✓ Root cause documented with file:line references
✓ All outputs created in expected locations
✓ Metadata.yml updated with completion
✓ Workflow summary generated
✓ User provided with clear next steps
✓ Resume capability preserved if failed
✓ **If TDD exception**: Alternative validation approach clearly documented and thorough

---

## Success Criteria

Workflow is successful when:

1. ✅ All required phases complete without critical failures
2. ✅ **EITHER**: TDD Red→Green validated (test failed before fix, passes after) **OR** TDD exception documented with thorough alternative validation
3. ✅ Reproduction data captured (and used in regression test if TDD path)
4. ✅ Root cause identified and documented
5. ✅ Fix addresses root cause (not symptoms)
6. ✅ All tests passing (or >90% with documented failures)
7. ✅ Standards applied throughout implementation
8. ✅ Complete documentation in task directory
9. ✅ State file reflects completion
10. ✅ User has clear path to commit and deploy
11. ⚠️ **If TDD exception**: Flagged in verification report with review recommendation

Bug fix orchestration provides complete, auditable, resumable workflow from bug report to deployment-ready fix with TDD discipline strongly recommended and pragmatic exception handling when truly necessary.
