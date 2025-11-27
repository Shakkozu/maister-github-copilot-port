# Auto-Fix Strategies Reference

This document provides detailed auto-recovery patterns for each type of failure the orchestrator may encounter.

## Auto-Fix Philosophy

**Goals**:
- Recover from common, predictable failures automatically
- Minimize user intervention for routine issues
- Preserve progress and state
- Know when to stop trying and ask for help

**Boundaries**:
- DO fix: Syntax errors, missing imports, test assertions, missing standards
- DON'T fix: Architectural issues, complex logic errors, security vulnerabilities, user decisions
- When uncertain: Report and prompt rather than guess

**Attempt Limits**:
- Per-phase maximum attempts (typically 2-3)
- Overall workflow retry limits
- Increment counters in orchestrator-state.yml
- Halt when max exceeded

---

## Phase 1: Specification Failures

### Failure Type: Spec Verification Failed

**Symptoms**:
- verification/spec-verification.md shows ❌ Failed status
- Over-engineering detected
- Missing requirements
- Spec/requirements misalignment
- Visual design not tracked

**Root Causes**:
- Added features not in requirements
- Missing features that were requested
- New components created when existing would work
- Visual assets not incorporated into spec

**Auto-Fix Strategy**:

**Attempt 1**:
1. Read `verification/spec-verification.md` fully
2. Extract all issues from "Issues Found" section
3. Read `planning/requirements.md` for context
4. Re-invoke `specification-creator` with context:

```
Previous specification failed verification with these issues:

Critical Issues:
- [Issue 1 from verification report]
- [Issue 2 from verification report]

Minor Issues:
- [Issue 3 from verification report]

Please revise the specification:
1. Keep planning/requirements.md unchanged (requirements are accurate)
2. Revise spec.md to address all critical issues
3. Ensure all requirements from planning/requirements.md are covered
4. Don't add features not in requirements
5. Reference reusable components where mentioned in requirements

Focus on fixing issues without changing requirements.
```

**Attempt 2** (if Attempt 1 fails):
1. Re-read updated spec.md
2. Manually verify each issue was addressed
3. If specific issue remains, provide more targeted guidance:

```
Verification still failing on:
- [Specific issue that persists]

Specific fix needed:
[Targeted instructions for the remaining issue]

This is attempt 2/2. After this, manual intervention required.
```

**Max Attempts**: 2

**If Still Failing**:
```
❌ Specification Phase Failed After 2 Attempts

Unable to automatically resolve verification issues:
- [Remaining issue 1]
- [Remaining issue 2]

Manual intervention required:
1. Review spec.md in [path]
2. Review verification report: verification/spec-verification.md
3. Address issues manually
4. Resume workflow: /ai-sdlc:feature:resume [path]

Workflow paused. State saved.
```

### Failure Type: Requirements Unclear

**Symptoms**:
- specification-creator reports insufficient information
- Q&A process yields vague answers
- Key decisions unclear

**Auto-Fix Strategy**:
- This typically requires user input
- No automatic fix possible
- Prompt user for clarification
- Don't attempt auto-fix

---

## Phase 2: Planning Failures

### Failure Type: Implementation Plan Incomplete

**Symptoms**:
- implementation-plan.md missing expected sections
- Task groups don't match spec requirements
- Steps unclear or too vague
- Missing test-driven structure

**Root Causes**:
- Spec analysis incomplete
- Task group selection logic missed requirements
- Step generation too high-level

**Auto-Fix Strategy**:

**Attempt 1**:
1. Read implementation-plan.md
2. Read spec.md "Core Requirements" section
3. Identify what's missing
4. Re-invoke `implementation-planner` with constraints:

```
Previous implementation plan was incomplete.

Missing elements:
- [Missing task group or step]
- [Uncovered requirement from spec]

Regenerate implementation plan ensuring:
1. All core requirements from spec.md are covered
2. Each task group follows test-driven pattern (test → implement → verify)
3. Dependencies are logical (database → API → frontend)
4. Expected test count calculated (2-8 per group + max 10)

Spec requirements to ensure coverage:
- [Requirement 1 from spec]
- [Requirement 2 from spec]
```

**Attempt 2**:
1. Compare new plan with spec requirements line-by-line
2. If still missing elements, provide very specific instructions:

```
Implementation plan still missing:
- [Specific missing element]

Add these specific steps:
Task Group [N]:
  - [ ] [Specific step needed]
  - [ ] [Another specific step]

This is attempt 2/2.
```

**Max Attempts**: 2

**If Still Failing**:
```
❌ Planning Phase Failed After 2 Attempts

Implementation plan remains incomplete:
- [Missing element 1]
- [Missing element 2]

Manual intervention required:
1. Review implementation-plan.md
2. Compare with spec.md requirements
3. Add missing task groups/steps manually
4. Resume workflow: /ai-sdlc:feature:resume [path]

Workflow paused. State saved.
```

### Failure Type: Dependencies Incorrect

**Symptoms**:
- Circular dependencies
- Frontend before API
- API before database
- Illogical ordering

**Auto-Fix Strategy**:

**Attempt 1**:
1. Analyze dependency chain
2. Identify correct order
3. Re-invoke `implementation-planner`:

```
Previous plan had incorrect dependencies:
- [Incorrect dependency description]

Correct order should be:
1. [Task Group 1] (no dependencies)
2. [Task Group 2] (depends on 1)
3. [Task Group 3] (depends on 2)

Regenerate with corrected dependencies following:
- Database layer before API layer
- API layer before frontend layer
- All implementation before testing
```

**Max Attempts**: 2

---

## Phase 3: Implementation Failures

### Failure Type: Implementation Step Failed

**Symptoms**:
- Specific step in implementation-plan.md fails
- Error message from implementer
- Code changes not applied

**Root Causes**:
- Syntax errors in generated code
- Missing dependencies/imports
- Incorrect API usage
- File path errors
- Logic errors

**Auto-Fix Strategy**:

**Attempt 1**:
1. Read error message carefully
2. Identify error type:
   - Syntax error → Fix syntax
   - Import error → Add import
   - File not found → Check path
   - Logic error → Analyze and fix

3. For syntax/import errors:
```
Re-invoke implementer:

Step [X.Y] failed with error:
[Error message]

This appears to be a [syntax/import/path] error.

Fix:
- [Specific fix based on error]

Retry step [X.Y] with correction.
```

4. For logic errors:
```
Re-invoke implementer:

Step [X.Y] failed with error:
[Error message]

Analyze the issue:
- Review [file] at [location]
- Check logic for [issue]
- Review spec.md for correct behavior

Apply fix and retry step [X.Y].
```

**Attempt 2**:
1. If same error persists, provide more context:

```
Step [X.Y] still failing with same error.

Additional context:
- Review similar pattern in [existing file]
- Check docs/INDEX.md for [relevant standard]
- Ensure [specific requirement]

This is attempt 2/2 for this step.
```

**Max Attempts Per Step**: 2
**Max Overall Implementation Retries**: 5

**If Step Still Failing**:
```
⚠️ Step [X.Y] failed after 2 attempts

Error: [error message]

Options:
1. Skip step and continue (mark as incomplete) - NOT RECOMMENDED
2. Fix manually and resume
3. Stop workflow

[If overall retries < 5]
Continuing with workflow. Mark this step for manual review.

[If overall retries == 5]
❌ Max implementation retries reached. Halting workflow.
```

### Failure Type: Tests Fail During Incremental Verification

**Symptoms**:
- Tests written in step X.1 fail when run in step X.final
- Test output shows failures
- Implementation appears incorrect

**Root Causes**:
- Tests are correct, implementation is wrong
- Tests have incorrect assertions
- Missing test data or fixtures
- Environment issues

**Auto-Fix Strategy**:

**Attempt 1**:
1. Read test failure output
2. Analyze failure type:
   - Assertion failed → Check implementation or assertion
   - Missing data → Add fixtures
   - Syntax error in test → Fix test
   - Runtime error → Fix implementation

3. For assertion failures:
```
Re-invoke implementer:

Test failure in task group [N]:
Test: [test name]
Error: [failure message]

Analyze:
1. Review implementation in [file]
2. Review test assertion in [test file]
3. Check which is incorrect (implementation or test)

If implementation wrong:
  - Fix implementation to match expected behavior from spec
If test wrong:
  - Fix test assertion to match actual correct behavior

Re-run tests after fix.
```

4. For missing data:
```
Re-invoke implementer:

Test failure: Missing test data
Test: [test name]
Error: [failure message]

Fix:
- Create test fixtures in [location]
- Seed test data: [specific data needed]
- Update test to use fixtures

Re-run tests.
```

**Attempt 2**:
1. If tests still failing, deeper analysis:

```
Tests still failing in task group [N]

Detailed analysis needed:
1. Review spec.md section: [relevant section]
2. Verify implementation matches spec exactly
3. Check test expectations match spec
4. Review similar tests in [existing tests]

This is attempt 2/3 for this task group.
```

**Attempt 3**:
1. Last attempt with explicit instructions:

```
Final attempt for task group [N] tests

Specific issues identified:
- [Issue 1]
- [Issue 2]

Explicit fixes:
- In [file], line [X]: Change [this] to [that]
- In [test file], line [Y]: Change [this] to [that]

This is attempt 3/3.
```

**Max Attempts Per Task Group**: 3

**If Tests Still Failing**:
```
⚠️ Task group [N] tests still failing after 3 attempts

Failing tests:
- [Test 1]: [Error]
- [Test 2]: [Error]

Decision: Continue to next task group
These failures will be caught in Phase 4 (Verification)

Note: Total implementation auto-fix attempts: [count]/5
```

### Failure Type: Standards Not Applied

**Symptoms**:
- work-log.md mentions checking standards but none applied
- Verification later shows standards missing
- Code doesn't follow patterns from INDEX.md

**Auto-Fix Strategy**:

**Attempt 1**:
1. Re-read `.ai-sdlc/docs/INDEX.md`
2. Identify standards that should apply
3. Re-invoke implementer with explicit standards:

```
Re-invoke implementer:

Standards check: Required standards not applied

From docs/INDEX.md, these standards should be applied:
- [Standard 1]: [Requirement summary]
- [Standard 2]: [Requirement summary]

Review and apply to:
- [File 1]: [Specific standard application]
- [File 2]: [Specific standard application]

Update work-log.md to document standards applied.
```

**Attempt 2**:
1. Spot-check code for standards compliance
2. If still missing, very specific instructions:

```
Standards still not applied.

Explicit changes needed:
- [File]: Line [X]: Change [this] to [that] per [standard]
- [File]: Add [element] per [standard]

This is attempt 2/2 for standards.
```

**Max Attempts**: 2

**If Still Not Applied**:
```
⚠️ Standards application incomplete

Missing standards:
- [Standard 1]
- [Standard 2]

Continuing workflow. Verification phase will document this.
Manual review recommended.
```

---

## Phase 4: Verification Failures

### Failure Type: Test Suite Failures

**Symptoms**:
- Full test suite run shows failures
- Pass rate < 90%
- implementation-verification.md shows failed status

**Root Causes**:
- Feature implementation has bugs
- Regressions introduced
- Test environment issues

**Auto-Fix Strategy**:

**Attempt 1**:
1. Read verification report failing tests section
2. Categorize failures:
   - **Feature-related**: Tests for newly implemented feature
   - **Regression**: Tests for existing features that now fail
   - **Pre-existing**: Tests that were already failing

3. For feature-related failures:
```
Re-invoke implementer:

Verification found [N] feature-related test failures:

Test: [Test 1]
Error: [Error message]
Category: [unit/integration/e2e]

Test: [Test 2]
Error: [Error message]
Category: [unit/integration/e2e]

Fix these test failures:
1. Review implementation in [files]
2. Compare with spec.md expectations
3. Fix bugs causing failures

After fixes, verification will re-run full test suite.
```

4. For regressions:
```
Re-invoke implementer:

Verification found [N] regression failures (existing features broken):

Test: [Test 1] - Feature: [feature name]
Error: [Error message]

Analysis: This feature worked before this implementation.

Fix:
1. Review changes that may have affected [feature name]
2. Restore functionality without breaking new feature
3. Consider if changes were intentional

After fixes, re-run verification.
```

5. For pre-existing failures:
```
Note: [N] failures appear pre-existing (not related to this feature)

Document in verification report but don't block workflow.
These should be addressed separately.
```

**Attempt 2**:
1. If failures persist, more targeted fixes:

```
Test failures remain after attempt 1.

Detailed fix needed for:
Test: [Specific test]
File: [Implementation file]
Issue: [Specific issue identified]

Explicit fix:
- [Step-by-step fix instruction]

This is attempt 2/2 for verification failures.
```

**Max Attempts**: 2

**If Tests Still Failing**:
```
❌ Verification failed after 2 auto-fix attempts

Test results:
- Total: [N]
- Passing: [P] ([percentage]%)
- Failing: [F]

Remaining failures:
- [Test 1]: [Error]
- [Test 2]: [Error]

Status: Failed (pass rate < 90%)

Manual intervention required:
1. Review failures in verification report
2. Fix failing tests
3. Re-run verification: /ai-sdlc:feature:resume [path] --from=verify

Workflow halted. State saved.
```

### Failure Type: Standards Compliance Issues

**Symptoms**:
- Verification report shows standards not applied
- work-log.md doesn't document standards
- Code doesn't follow patterns

**Auto-Fix Strategy**:
- Verification is read-only (by design)
- Document in report
- Don't attempt automatic fixes
- Flag for user review

```
⚠️ Standards compliance issues found

Verification detected:
- Missing standard: [standard name]
- Not documented in work-log.md

This is a documentation issue, not blocking.

Recommendation:
- Review docs/INDEX.md for [standard]
- Apply standard to [files]
- Update work-log.md

Continuing workflow with warning status.
```

### Failure Type: Documentation Incomplete

**Symptoms**:
- work-log.md missing or sparse
- implementation-plan.md has unchecked steps
- Spec misalignment detected

**Auto-Fix Strategy**:

**Attempt 1**:
1. Generate minimal missing documentation:

**For sparse work-log.md**:
```
Generate summary entry:

## [Timestamp] - Implementation Summary

**Summary**: Completed implementation of [feature name]

**Steps Completed**: [List task groups]

**Files Modified**:
[List from implementation-plan.md]

**Standards Applied**:
[Extract from INDEX.md check or infer from files]

**Status**: ✅ Implementation complete

Add to implementation/work-log.md
```

**For unchecked steps in implementation-plan.md**:
```
Review each step:
- If file changes exist for step → Mark [x] complete
- If no evidence of completion → Leave [ ] incomplete

Update implementation-plan.md with checked steps.
```

**For spec misalignment**:
```
Compare spec.md Core Requirements with implementation-plan.md:
- Note any missing requirements
- Document in verification report
- Don't attempt to implement (verification is read-only)
```

**Max Attempts**: 1

**If Still Incomplete**:
```
⚠️ Documentation remains incomplete

Issues:
- [Documentation issue 1]
- [Documentation issue 2]

Status: Passed with Issues

Recommendation: Complete documentation manually

Continuing workflow with warning.
```

---

## Phase 5: E2E Testing Failures

### Failure Type: Application Not Running

**Symptoms**:
- E2E tests can't connect to application
- Playwright connection errors
- No response from app URL

**Auto-Fix Strategy**:
- Can't automatically start application
- Prompt user

```
⚠️ E2E Testing: Application Not Running

E2E tests require the application to be running.

Please start your application:
1. [Command to start app, if known from tech-stack.md]
2. Ensure it's accessible at: [URL from spec or default]
3. Press Enter when ready

Waiting for application to start...
[Check connection every 5 seconds]
```

**Max Attempts**: 1 prompt (wait indefinitely or timeout after 5 minutes)

**If Still Not Running**:
```
⏭️ E2E Testing Skipped

Application not running after 5 minutes.

E2E tests skipped. Run manually later:
/ai-sdlc:e2e-verify [task-path]

Continuing workflow without E2E results.
```

### Failure Type: UI Tests Fail

**Symptoms**:
- E2E test scenarios fail
- Screenshots show broken UI or incorrect behavior
- Console errors in verification report

**Auto-Fix Strategy**:

**Attempt 1**:
1. Read E2E verification report
2. Extract failing scenarios with screenshots
3. Re-invoke implementer with UI fixes:

```
Re-invoke implementer:

E2E tests failed. UI issues detected:

Scenario: [Scenario name]
Issue: [Issue description from report]
Screenshot: verification/screenshots/[file]
Console errors: [If any]

Fix UI issues:
1. Review component in [file]
2. Compare with mockup: planning/visuals/[file] (if exists)
3. Fix: [Specific UI fix needed]

After fixes, re-run E2E tests.
```

**Attempt 2**:
1. If failures persist:

```
E2E tests still failing.

Scenario: [Specific scenario]
Detailed issue: [Analysis of what's wrong]

Explicit fix:
- Component: [Component name]
- File: [File path]
- Change: [Specific change needed]

This is attempt 2/2 for E2E fixes.
```

**Max Attempts**: 2

**If Tests Still Failing**:
```
⚠️ E2E tests still failing after 2 attempts

Failing scenarios:
- [Scenario 1]: [Issue]
- [Scenario 2]: [Issue]

Status: E2E verification failed (non-blocking)

Recommendation: Review E2E report and fix manually

Continuing workflow with E2E issues documented.
```

### Failure Type: Screenshot Capture Fails

**Symptoms**:
- Playwright can navigate but screenshots fail
- Report generated but no images

**Auto-Fix Strategy**:
- Generate documentation without screenshots
- Note limitation
- Don't retry extensively

```
⚠️ E2E screenshot capture failed

Issue: [Error message]

Generating report without screenshots (text descriptions only).

This is a non-critical issue. E2E report will be text-based.

Continuing E2E tests.
```

---

## Phase 6: User Documentation Failures

### Failure Type: Application Not Running

**Auto-Fix Strategy**:
- Same as E2E Testing (see above)
- Prompt user to start app
- Wait or skip after timeout

### Failure Type: Screenshot Capture Fails

**Auto-Fix Strategy**:
- Generate docs without screenshots
- Use text descriptions
- Non-blocking

```
⚠️ User docs screenshot capture failed

Generating documentation without screenshots.

User guide will use text descriptions instead.

This is acceptable - docs will still be useful.

Completing user documentation.
```

---

## Global Failure Handling

### Max Attempts Exceeded

When any phase exceeds its max auto-fix attempts:

```
❌ [Phase Name] Failed After [N] Attempts

Last error: [Error description]

Auto-fix attempts exhausted:
[List of strategies attempted]

Workflow paused.

Options:
1. Fix manually and resume: /ai-sdlc:feature:resume [path]
2. Skip phase and continue (NOT RECOMMENDED for required phases)
3. Restart phase from beginning (resets attempt counter)
4. Stop workflow completely

State saved to: [orchestrator-state.yml]

What would you like to do? [1-4]: _
```

### Multiple Phase Failures

If more than one phase has failed:

```
❌ Multiple Phase Failures Detected

Failed phases:
1. [Phase 1]: [Error] - [N] attempts
2. [Phase 2]: [Error] - [M] attempts

This indicates a more serious issue that requires analysis.

Recommendation:
- Review all failures together
- Consider if there's a common root cause
- May need to restart from earlier phase

Workflow halted. Manual intervention required.
```

---

## Auto-Fix Attempt Tracking

Store in `orchestrator-state.yml`:

```yaml
auto_fix_attempts:
  specification: 1      # 0-2
  planning: 0           # 0-2
  implementation: 4     # 0-5
  verification: 2       # 0-2
  e2e_testing: 1        # 0-2
  user_docs: 0          # 0-1
```

Increment after each auto-fix attempt.
Check before attempting auto-fix.
Reset to 0 when phase succeeds.

---

## When to Stop Auto-Fixing

**Stop and prompt user when**:
1. Max attempts for phase reached
2. Error is ambiguous or complex
3. Multiple conflicting errors
4. User decision needed (not a technical error)
5. Security or data integrity concerns
6. Architectural changes required

**Continue auto-fixing when**:
1. Error is clear and fixable
2. Attempts remaining
3. Fix is low-risk
4. Pattern matches known fix
5. Error is routine (syntax, imports, etc.)

**Philosophy**: Be aggressive with routine fixes, conservative with complex issues.

---

This reference provides comprehensive auto-recovery strategies for all failure types the feature orchestrator may encounter during workflow execution.
