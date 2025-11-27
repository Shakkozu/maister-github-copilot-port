# Workflow Phases Reference

This document provides detailed execution guidance for each phase of the feature orchestrator workflow.

## Phase Execution Template

Each phase follows this standard pattern:

1. **Pre-Phase**: Check state, validate prerequisites, announce phase
2. **Execute**: Invoke skill/agent, capture output
3. **Analyze**: Extract status, check for failures
4. **Auto-Fix**: Attempt recovery if failures detected
5. **Post-Phase**: Update state, report results, pause (if interactive)

## Phase 1: Specification Creation

### Prerequisites
- None (first phase)
- Or existing task path if resuming

### Execution
```
Invoke: specification-creator skill

The skill will:
1. Initialize task structure
2. Research requirements via Q&A
3. Check visual assets
4. Search for reusable components
5. Write spec.md
6. Verify specification quality
```

### Success Criteria
- ✅ spec.md created and complete
- ✅ planning/requirements.md with Q&A results
- ✅ verification/spec-verification.md with passing status
- ✅ metadata.yml initialized

### Common Failures
- Spec verification fails (over-engineering detected)
- Requirements unclear or incomplete
- Visual assets missing when expected

### Auto-Fix Approach
1. Read verification report issues
2. Re-invoke specification-creator with:
   ```
   Previous spec had verification issues:
   - [Issue 1]: [Description]
   - [Issue 2]: [Description]

   Keep existing requirements.md
   Revise spec.md to address issues
   ```
3. Max 2 attempts
4. If still failing: Halt, report to user

### State Updates
```yaml
completed_phases:
  - specification
phase_results:
  specification:
    status: success
    output_files:
      - spec.md
      - planning/requirements.md
      - verification/spec-verification.md
auto_fix_attempts:
  specification: 0  # or 1, 2 if fixes attempted
```

## Phase 2: Implementation Planning

### Prerequisites
- ✅ spec.md exists and is complete
- ✅ Phase 1 in completed_phases OR starting from --from=plan

### Execution
```
Invoke: implementation-planner skill

Input: spec.md
Output: implementation-plan.md

The skill will:
1. Analyze spec and requirements
2. Determine task groups (1-6 based on complexity)
3. Create implementation steps
4. Set dependencies
5. Define acceptance criteria
```

### Success Criteria
- ✅ implementation-plan.md created
- ✅ All task groups have test-driven steps
- ✅ Dependencies correctly set
- ✅ Acceptance criteria defined
- ✅ Expected test count calculated

### Common Failures
- Plan incomplete (missing steps)
- Dependencies incorrect or circular
- Task groups don't match spec requirements

### Auto-Fix Approach
1. Analyze plan issues
2. Re-invoke implementation-planner with:
   ```
   Previous plan had issues:
   [Issue description]

   Regenerate with constraints:
   - Ensure all spec requirements covered
   - Verify dependencies: [correct order]
   - Include [missing elements]
   ```
3. Max 2 attempts
4. If still failing: Halt, report to user

### State Updates
```yaml
completed_phases:
  - specification
  - planning
phase_results:
  planning:
    status: success
    output_files:
      - implementation-plan.md
    task_groups: 4
    total_steps: 18
    expected_tests: 16-34
auto_fix_attempts:
  planning: 0
```

## Phase 3: Implementation

### Prerequisites
- ✅ spec.md exists
- ✅ implementation-plan.md exists and complete
- ✅ Phase 2 in completed_phases OR starting from --from=implement

### Execution
```
Invoke: implementer skill

Input:
- implementation-plan.md
- spec.md
- .ai-sdlc/docs/INDEX.md (for standards)

The skill will:
1. Analyze implementation plan
2. Select execution mode (direct/plan-execute/orchestrated)
3. Execute steps with continuous standards discovery
4. Apply test-driven approach
5. Verify incrementally per task group
6. Create work-log.md
```

### Success Criteria
- ✅ All steps in implementation-plan.md marked [x] complete
- ✅ implementation/work-log.md comprehensive
- ✅ All feature-specific tests passing
- ✅ Standards applied throughout
- ✅ Code changes implemented

### Common Failures
- **Step failures**: Specific implementation step fails
- **Test failures**: Tests fail during incremental verification
- **Standards missing**: Required standards not applied
- **Code errors**: Syntax, logic, or runtime errors

### Auto-Fix Approach

**For step failures**:
1. Read error message
2. Re-invoke implementer:
   ```
   Step [X.Y] failed: [error]

   Retry with:
   - [Fix suggestion based on error]

   Continue from step [X.Y]
   ```
3. Max 2 attempts per step
4. Max 5 overall implementation retries

**For test failures**:
1. Analyze test output
2. Apply common fixes:
   - Missing imports
   - Syntax errors
   - Incorrect assertions
   - Missing test data
3. Re-run tests
4. Max 3 attempts per task group

**For missing standards**:
1. Re-check INDEX.md
2. Identify missing standards
3. Re-invoke implementer:
   ```
   Standards check failed: Missing [standard-name]

   Apply:
   - [Standard requirement 1]
   - [Standard requirement 2]

   Update affected files
   ```
4. Max 2 attempts

### State Updates
```yaml
completed_phases:
  - specification
  - planning
  - implementation
phase_results:
  implementation:
    status: success
    output_files:
      - implementation-plan.md (updated)
      - implementation/work-log.md
    execution_mode: plan-execute
    standards_applied:
      - global/naming-conventions.md
      - frontend/components.md
auto_fix_attempts:
  implementation: 2  # if fixes were needed
```

## Phase 4: Verification

### Prerequisites
- ✅ spec.md exists
- ✅ implementation-plan.md exists with all steps complete
- ✅ implementation/work-log.md exists
- ✅ Phase 3 in completed_phases OR starting from --from=verify

### Execution
```
Invoke: implementation-verifier skill

The skill will:
1. Verify implementation plan completion
2. Run full test suite (entire project)
3. Check standards compliance
4. Validate documentation
5. Optional: Code review (prompted)
6. Optional: Production readiness (prompted)
7. Create verification report
```

### Success Criteria
- ✅ verification/implementation-verification.md created
- ✅ Status: Passed or Passed with Issues
- ✅ Test pass rate >90%
- ✅ Standards mostly/fully compliant
- ✅ Documentation adequate/complete

### Common Failures
- **Test failures**: Test suite has failures
- **Standards non-compliance**: Required standards not followed
- **Documentation incomplete**: Missing work-log or incomplete plan
- **Implementation incomplete**: Steps marked incomplete

### Auto-Fix Approach

**For test failures**:
1. Read verification report
2. Categorize failures:
   - Feature-related → fix in implementer
   - Regressions → analyze and fix
   - Pre-existing → document, don't block
3. If feature-related:
   ```
   Invoke implementer with fix instructions:

   Verification found test failures:
   - [Test 1]: [Failure reason]
   - [Test 2]: [Failure reason]

   Fix and re-run verification
   ```
4. Max 2 attempts

**For missing standards**:
- Verification is read-only
- Document in report
- Don't attempt auto-fix
- Report to user

**For incomplete documentation**:
1. Generate minimal docs:
   - Complete work-log.md summary
   - Mark remaining steps in implementation-plan.md
2. Re-run verification
3. Max 1 attempt

### State Updates
```yaml
completed_phases:
  - specification
  - planning
  - implementation
  - verification
phase_results:
  verification:
    status: passed_with_issues  # or passed, failed
    output_files:
      - verification/implementation-verification.md
    test_results:
      total: 156
      passing: 151
      failing: 5
      pass_rate: 96.8
    standards_compliance: mostly_compliant
    overall_status: passed_with_issues
auto_fix_attempts:
  verification: 1
```

## Phase 5: E2E Testing (Optional)

### Prerequisites
- ✅ Phase 4 (Verification) complete
- ✅ User opted in (interactive prompt or --e2e flag)
- ✅ playwright-mcp server available
- ✅ Application running

### Execution
```
Invoke: e2e-test-verifier agent via Task tool

subagent_type: "e2e-test-verifier"
prompt: "Run E2E verification for [task-path]"

The agent will:
1. Validate Playwright availability
2. Check application is running
3. Execute browser tests from spec user stories
4. Capture screenshots
5. Create E2E verification report
```

### Success Criteria
- ✅ verification/e2e-verification-report.md created
- ✅ verification/screenshots/ with evidence
- ✅ All test scenarios passing
- ✅ No critical discrepancies

### Common Failures
- **Application not running**: Can't connect to app
- **UI tests fail**: Functionality broken or UI issues
- **Screenshot capture fails**: Playwright issues

### Auto-Fix Approach

**For application not running**:
1. Prompt user to start application
2. Wait for confirmation
3. Retry E2E tests
4. Max 1 attempt

**For UI test failures**:
1. Extract failing scenarios
2. Invoke implementer with UI fixes:
   ```
   E2E test failed: [scenario name]

   Issue: [description]
   Screenshot: verification/screenshots/[file]

   Fix:
   - [UI fix 1]
   - [UI fix 2]

   Re-run E2E tests
   ```
3. Max 2 attempts

**For screenshot failures**:
- Generate docs without screenshots
- Note limitation in report
- Don't block on this

### State Updates
```yaml
completed_phases:
  - specification
  - planning
  - implementation
  - verification
  - e2e_testing
phase_results:
  e2e_testing:
    status: success
    output_files:
      - verification/e2e-verification-report.md
      - verification/screenshots/*
    test_scenarios: 8
    passed: 7
    failed: 1
auto_fix_attempts:
  e2e_testing: 1
```

## Phase 6: User Documentation (Optional)

### Prerequisites
- ✅ Phase 4 (Verification) complete
- ✅ Phase 5 complete or skipped
- ✅ User opted in (interactive prompt or --user-docs flag)
- ✅ playwright-mcp server available
- ✅ Application running

### Execution
```
Invoke: user-docs-generator agent via Task tool

subagent_type: "user-docs-generator"
prompt: "Generate user documentation for [task-path]"

The agent will:
1. Analyze spec for user workflows
2. Use Playwright to capture screenshots
3. Write non-technical user guide
4. Include troubleshooting
```

### Success Criteria
- ✅ documentation/user-guide.md created
- ✅ documentation/screenshots/ with step images
- ✅ Clear, non-technical language
- ✅ Complete user workflows documented

### Common Failures
- **Application not running**: Can't capture screenshots
- **Screenshot capture fails**: Playwright issues
- **Documentation incomplete**: Missing key workflows

### Auto-Fix Approach

**For application not running**:
1. Prompt user to start app
2. Wait for confirmation
3. Retry doc generation
4. Max 1 attempt

**For screenshot failures**:
- Generate docs without screenshots
- Use text descriptions only
- Note limitation
- Don't block

**For incomplete docs**:
- Docs are optional
- Best-effort generation
- Don't retry extensively

### State Updates
```yaml
completed_phases:
  - specification
  - planning
  - implementation
  - verification
  - e2e_testing
  - user_documentation
phase_results:
  user_documentation:
    status: success
    output_files:
      - documentation/user-guide.md
      - documentation/screenshots/*
auto_fix_attempts:
  user_docs: 0
```

## Phase 7: Finalization

### Prerequisites
- ✅ All previous phases complete (or explicitly skipped)

### Execution
1. Generate workflow summary
2. Update metadata.yml status to "completed"
3. Update roadmap if exists
4. Create commit message template
5. Output final summary to user

### Success Criteria
- ✅ workflow-summary.md created
- ✅ metadata.yml updated
- ✅ Roadmap updated (if exists)
- ✅ User has clear next steps

### No Failures
Finalization always succeeds (best-effort).

### State Updates
```yaml
completed_phases:
  - specification
  - planning
  - implementation
  - verification
  - e2e_testing (if run)
  - user_documentation (if run)
  - finalization
completed: 2025-10-26T16:45:00Z
```

---

## Phase Transition Logic

### Between Phases
1. Update state current_phase
2. Save state file
3. If interactive mode: Pause and prompt
4. If YOLO mode: Continue immediately

### On Failure
1. Increment auto_fix_attempts
2. Check max attempts threshold
3. If below max: Execute auto-fix strategy
4. If at max: Add to failed_phases, halt or skip

### On Success
1. Add to completed_phases
2. Store phase_results
3. Reset auto_fix_attempts for next phase
4. Proceed to next phase

---

## Interactive Mode Prompts

### After Each Phase
```
✅ Phase [N] Complete: [Phase Name]

Results:
- [Key result 1]
- [Key result 2]
- [Key result 3]

Status: [Success/Success with warnings]

[If warnings]
⚠️ Warnings:
- [Warning 1]
- [Warning 2]

Options:
1. Continue to next phase
2. Review outputs in detail
3. Restart this phase
4. Stop workflow (can resume later)

Your choice [1-4]: _
```

### For Optional Phases
```
[Icon] [Phase Name] Available

[Description of what this phase does]

Recommended if:
- [Condition 1]
- [Condition 2]

Run [phase name]? [Y/n]: _
```

---

## YOLO Mode Output

### During Phases
```
[Phase N/M] [Phase Name]... ✅ [duration]
  → [Key action performed]
  → [Result summary]
```

### For Optional Phases
```
Checking if [phase name] applicable...
✅ [Reason] - Auto-running [phase name]
  OR
⏭️ [Reason] - Skipping [phase name]
```

---

## Error Messages

### Prerequisites Missing
```
❌ Cannot start Phase [N]: [Phase Name]

Missing prerequisites:
- [Prerequisite 1]: ❌ Not found at [path]
- [Prerequisite 2]: ❌ Not complete

To continue:
1. Complete previous phases
2. Start from an earlier phase with --from
3. Manually create missing files

Current state: Phase [M] complete, next should be Phase [M+1]
```

### Max Attempts Exceeded
```
❌ Phase [N] Failed After [X] Attempts

Last error:
[Error description]

Auto-fix strategies attempted:
- [Strategy 1]: Failed
- [Strategy 2]: Failed

Options:
1. Fix manually and resume: /ai-sdlc:feature:resume [path]
2. Skip phase (not recommended)
3. Restart from previous phase

State saved to: [orchestrator-state.yml]
```

---

This reference provides the detailed execution logic for each workflow phase, including success criteria, failure handling, and auto-fix strategies.
