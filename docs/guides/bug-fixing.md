# Bug Fixing Workflow

Complete guide to fixing bugs using the AI SDLC plugin's bug-fix orchestrator with mandatory TDD Red→Green discipline.

## Overview

The bug fixing workflow is a systematic 4-phase process designed to fix defects with root cause analysis, test-driven development, and comprehensive verification. The workflow enforces **mandatory TDD Red→Green discipline**: tests MUST fail before fix (Red), then MUST pass after fix (Green).

**When to use this workflow:**
- Fixing bugs, errors, crashes, or defects
- Want root cause analysis (not just symptoms)
- Need TDD discipline enforced
- Want regression prevention

**When NOT to use this workflow:**
- Adding new features → Use [Feature Development](feature-development.md)
- Improving existing features → Use [Enhancement Workflow](enhancement-workflow.md)
- Refactoring code → Use [Refactoring Workflow](refactoring.md)

## Quick Start

```bash
# Interactive mode (recommended)
/ai-sdlc:bug-fix:new "Login timeout after 5 minutes of inactivity"

# YOLO mode (continuous execution)
/ai-sdlc:bug-fix:new "Null pointer exception in user profile" --yolo
```

## TDD Red→Green Discipline

**Critical Feature**: This workflow enforces strict TDD discipline with non-negotiable gates.

### The Red→Green Cycle

```
1. 🔴 RED GATE: Write regression test using exact reproduction data
   ↓
   Test MUST FAIL (proves test reproduces bug)
   ↓
   If test passes → ERROR: Test doesn't reproduce bug
   ↓
2. Implement fix
   ↓
3. 🟢 GREEN GATE: Run test again
   ↓
   Test MUST PASS (proves fix works)
   ↓
   If test fails → ERROR: Fix doesn't work
```

### Why This Matters

**Without TDD discipline:**
- ❌ Tests that don't actually reproduce the bug
- ❌ False confidence that bug is fixed
- ❌ Bug can recur undetected

**With TDD Red→Green:**
- ✅ Test proves it reproduces exact bug
- ✅ Fix proves it resolves exact bug
- ✅ Regression prevented forever

## Workflow Phases

### Phase 1: Bug Analysis & Reproduction

**Duration**: 20-35 minutes
**Interactive**: Pauses after completion for review

**Purpose**: Understand the bug's root cause and capture exact reproduction data.

**What you'll do:**
- Describe the bug symptoms
- Provide steps to reproduce
- Share error messages/stack traces
- Describe expected vs actual behavior
- Identify affected users/scenarios

**Questions you might be asked:**
```
Q: What is the bug? (Describe symptoms)
Q: How do you reproduce it? (Step-by-step)
Q: What should happen? (Expected behavior)
Q: What actually happens? (Actual behavior)
Q: Error messages or stack traces?
Q: When did this start occurring?
Q: Which users/scenarios are affected?
```

**What happens:**
1. **Capture Bug Information**
   - Description, symptoms, impact
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages

2. **Root Cause Analysis**
   - Analyzes code to find underlying cause
   - Identifies affected components
   - Determines scope of impact

3. **Capture Exact Reproduction Data**
   - Specific inputs that trigger bug
   - System state/configuration
   - Environment details
   - Timing/sequence factors

**Outputs:**
```
.ai-sdlc/tasks/bug-fixes/YYYY-MM-DD-bug-name/
├── metadata.yml
├── analysis/
│   ├── bug-report.md              # Bug description and analysis
│   └── reproduction-data.md       # EXACT data to reproduce bug
└── implementation/
    └── spec.md                    # Bug fix specification
```

**reproduction-data.md example:**
```markdown
# Bug Reproduction Data

## Exact Inputs
- Username: "user@test.com"
- Password: "p@ssw0rd!"  (special characters)
- Session time: 5 minutes idle
- Browser: Chrome 120.0

## System State
- User logged in
- Shopping cart has 3 items
- Session cookie present

## Environment
- Production URL: https://app.example.com
- Database: PostgreSQL 14.5
- Redis session store

## Timing
- Login at T=0
- Idle from T=5min to T=10min
- Click action at T=10min → TIMEOUT

## Expected Result
- Session maintained for 30 minutes
- Action succeeds

## Actual Result
- Timeout error after 5 minutes
- Error: "Session expired"
```

**Why reproduction data matters:**
- ✅ Enables writing accurate regression tests
- ✅ Ensures test reproduces EXACT bug scenario
- ✅ Prevents fixing wrong issue

**Review checklist:**
- ✅ Root cause identified (not just symptoms)
- ✅ Reproduction data is exact and specific
- ✅ Affected components listed
- ✅ Impact scope clear

---

### Phase 2: Fix Implementation (TDD Red→Green)

**Duration**: 30-90 minutes (varies by complexity)
**Interactive**: Pauses after completion for review

**Purpose**: Implement the bug fix with mandatory TDD Red→Green discipline.

**What happens:**

#### Step 1: Write Regression Test (Using Exact Reproduction Data)

```python
# Example regression test
def test_session_timeout_with_special_chars():
    """Regression test for bug: Login timeout with special characters"""
    # Use EXACT reproduction data from analysis/reproduction-data.md
    username = "user@test.com"
    password = "p@ssw0rd!"  # Special characters

    # Login
    session = login(username, password)

    # Wait 5 minutes (simulate idle)
    time.sleep(300)

    # Perform action
    result = perform_action(session)

    # BEFORE FIX: This should FAIL (timeout)
    # AFTER FIX: This should PASS (no timeout)
    assert result.success == True
    assert result.error == None
```

#### Step 2: 🔴 RED GATE - Validate Test Fails

**Run test BEFORE implementing fix:**
```bash
pytest test_session_timeout_with_special_chars.py

FAILED test_session_timeout_with_special_chars
AssertionError: Session timed out
```

**✅ GATE PASSED**: Test fails as expected (proves test reproduces bug)

**❌ GATE FAILED**: If test passes before fix:
```
ERROR: Test passed before fix was applied!
This means the test does NOT reproduce the bug.

Actions:
1. Review reproduction-data.md
2. Ensure test uses EXACT reproduction conditions
3. Re-write test to actually trigger the bug
4. HALT until test fails
```

#### Step 3: Implement Fix

**Root cause**: Session timeout set to 5 minutes instead of 30 minutes

```python
# config/session.py
# BEFORE (bug):
SESSION_TIMEOUT = 300  # 5 minutes

# AFTER (fixed):
SESSION_TIMEOUT = 1800  # 30 minutes
```

#### Step 4: 🟢 GREEN GATE - Validate Test Passes

**Run test AFTER implementing fix:**
```bash
pytest test_session_timeout_with_special_chars.py

PASSED test_session_timeout_with_special_chars ✓
```

**✅ GATE PASSED**: Test passes after fix (proves fix works)

**❌ GATE FAILED**: If test still fails after fix:
```
ERROR: Test failed after fix was applied!
This means the fix does NOT resolve the bug.

Actions:
1. Review fix implementation
2. Debug why test still fails
3. Adjust fix until test passes
4. HALT until test passes
```

**Cannot proceed without passing both gates!**

#### Step 5: Add Edge Case Tests

Add 2-8 additional tests varying the reproduction data:
```python
def test_session_timeout_different_special_chars():
    """Edge case: Different special characters"""
    password = "t3st!@#$%"
    # ... similar test logic

def test_session_timeout_long_idle():
    """Edge case: 29 minutes idle (just under limit)"""
    time.sleep(1740)  # 29 minutes
    # ... should still work

def test_session_timeout_exact_limit():
    """Edge case: Exactly 30 minutes"""
    time.sleep(1800)  # 30 minutes
    # ... should timeout appropriately
```

**Outputs:**
```
implementation/
├── fix-implementation.md      # Fix details and TDD log
├── work-log.md               # Activity log
└── tdd-validation-log.md     # RED/GREEN gate results

[Code changes with fix]
```

**tdd-validation-log.md example:**
```markdown
# TDD Validation Log

## Red Gate Validation
**Test**: test_session_timeout_with_special_chars
**Run**: Before fix implementation
**Expected**: FAIL ✓
**Actual**: FAIL ✓
**Status**: 🔴 RED GATE PASSED

Output:
```
FAILED test_session_timeout_with_special_chars
AssertionError: Session expired after 5 minutes
```

## Fix Implementation
**File**: config/session.py
**Change**: SESSION_TIMEOUT = 300 → 1800

## Green Gate Validation
**Test**: test_session_timeout_with_special_chars
**Run**: After fix implementation
**Expected**: PASS ✓
**Actual**: PASS ✓
**Status**: 🟢 GREEN GATE PASSED

Output:
```
PASSED test_session_timeout_with_special_chars ✓
```

## TDD Discipline: ✅ VERIFIED
Both gates passed. Fix verified with TDD Red→Green cycle.
```

**Auto-recovery:**
- Fixes syntax errors automatically
- Adds missing imports
- Max 3 attempts
- **NO auto-fix for test failures** (HALT immediately)

---

### Phase 3: Testing & Verification

**Duration**: 20-40 minutes
**Interactive**: Pauses after completion for review

**Purpose**: Verify the fix works and doesn't introduce regressions.

**What happens:**

1. **Verify TDD Gates Passed**
   - Confirms Red Gate passed (test failed before fix)
   - Confirms Green Gate passed (test passed after fix)

2. **Run Full Test Suite**
   - Execute **entire project test suite**
   - Ensure no regressions introduced
   - Document any new failures

3. **Verify Edge Cases**
   - Run all edge case tests (2-8 tests)
   - Ensure comprehensive coverage

4. **Create Verification Report**

**Outputs:**
```
verification/
├── bug-fix-verification.md    # Comprehensive verification report
└── test-results.md            # Detailed test results
```

**Verification report example:**
```markdown
# Bug Fix Verification Report

## Overall Status: ✅ PASSED

## TDD Discipline Verification
✅ 🔴 RED GATE: Test failed before fix (bug reproduced)
✅ 🟢 GREEN GATE: Test passed after fix (bug resolved)

## Regression Test
✅ test_session_timeout_with_special_chars: PASSED

## Edge Case Tests
✅ test_session_timeout_different_special_chars: PASSED
✅ test_session_timeout_long_idle: PASSED
✅ test_session_timeout_exact_limit: PASSED
✅ test_session_timeout_no_special_chars: PASSED

**Total new tests**: 5 (1 regression + 4 edge cases)

## Full Test Suite
✅ **1,234/1,234 tests passing (100%)**
⚠️ No regressions detected

## Root Cause Resolution
✅ Session timeout configuration corrected
✅ Fix applied to config/session.py
✅ All affected scenarios tested

## Deployment Recommendation
🟢 **GO** - Bug fixed, all tests passing, no regressions
```

**Review checklist:**
- ✅ Both TDD gates passed
- ✅ Full test suite passing
- ✅ Edge cases covered
- ✅ No regressions introduced

---

### Phase 4: Documentation & Completion

**Duration**: 10-15 minutes
**Always runs**: Yes

**Purpose**: Document the fix and provide commit guidance.

**What happens:**

1. **Update Code Documentation**
   - Add comments explaining the fix
   - Document the root cause
   - Note the bug symptoms

2. **Create Fix Summary**
   - What the bug was
   - What caused it (root cause)
   - How it was fixed
   - Tests added

3. **Generate Commit Message**
   - Follows project commit conventions
   - Includes bug reference
   - Lists tests added

**Outputs:**
```
implementation/
└── fix-summary.md

[Suggested commit message]
```

**fix-summary.md example:**
```markdown
# Bug Fix Summary

## Bug
Login timeout occurring after 5 minutes with special characters in password

## Root Cause
Session timeout configuration set to 300 seconds (5 minutes) instead of 1800 seconds (30 minutes)

## Fix
Updated SESSION_TIMEOUT constant in config/session.py from 300 to 1800

## Tests Added
1. test_session_timeout_with_special_chars (regression test)
2. test_session_timeout_different_special_chars (edge case)
3. test_session_timeout_long_idle (edge case)
4. test_session_timeout_exact_limit (edge case)
5. test_session_timeout_no_special_chars (edge case)

All tests passing (5/5)

## Impact
- Affected users: All users with special characters in passwords
- Severity: Medium (session interruption but no data loss)
- Fix verified: TDD Red→Green discipline enforced
```

**Commit message example:**
```
Fix session timeout with special characters

Session was timing out after 5 minutes instead of 30 minutes,
affecting users with special characters in passwords.

Root cause: SESSION_TIMEOUT constant incorrectly set to 300 seconds.

Fix: Updated SESSION_TIMEOUT to 1800 seconds (30 minutes)

Tests:
- Add regression test with exact reproduction data
- Add 4 edge case tests for comprehensive coverage
- All tests passing (5/5 new, 1,234/1,234 total)

Verified with TDD Red→Green discipline (test failed before fix, passes after)
```

---

## Key Differences from Feature Development

| Aspect | Bug Fix | Feature Development |
|--------|---------|-------------------|
| **Focus** | Root cause + fix | Requirements + implementation |
| **TDD** | Mandatory Red→Green gates | Test-driven but less strict |
| **Reproduction** | Exact reproduction data critical | N/A |
| **Root Cause** | Always analyzed | N/A |
| **Test Strategy** | Regression + edge cases | Feature tests + coverage |
| **Phases** | 4 phases | 6-7 phases |

---

## Execution Modes

### Interactive Mode (Default)

```bash
/ai-sdlc:bug-fix:new "Session timeout bug"

# After Phase 1
Review bug analysis and continue...

# After Phase 2
Review fix implementation and TDD gates...

# After Phase 3
Review verification report...
```

### YOLO Mode

```bash
/ai-sdlc:bug-fix:new "Null pointer exception" --yolo

🚀 YOLO Mode Activated!

[1/4] Bug Analysis... ✅ (18m)
[2/4] Fix Implementation (TDD)... ✅ (42m, RED✓ GREEN✓)
[3/4] Testing & Verification... ✅ (28m)
[4/4] Documentation... ✅ (8m)

🎉 Bug Fixed! All tests passing, TDD verified
```

---

## Common Scenarios

### Scenario: Red Gate Fails (Test Passes Before Fix)

**Problem**: Test passes before implementing fix

**Diagnosis**: Test doesn't actually reproduce the bug

**Solution:**
1. Review `analysis/reproduction-data.md`
2. Ensure test uses EXACT reproduction conditions
3. Re-write test to trigger the bug
4. Verify test fails before fix
5. Proceed only when Red Gate passes

### Scenario: Green Gate Fails (Test Fails After Fix)

**Problem**: Test still fails after implementing fix

**Diagnosis**: Fix doesn't resolve the bug

**Solution:**
1. Review fix implementation
2. Debug why test still fails
3. Check if root cause analysis was correct
4. Adjust fix until test passes
5. Proceed only when Green Gate passes

### Scenario: Full Test Suite Has Regressions

**Problem**: Fix causes other tests to fail

**Diagnosis**: Fix introduced side effects

**Solution:**
1. Review failing tests
2. Identify which functionality broke
3. Adjust fix to avoid side effects
4. Re-run full test suite
5. Proceed only when 100% passing

---

## Best Practices

### 1. Capture Exact Reproduction Data

**Good**: "User logs in and waits"
**Better**: "User 'test@example.com' logs in with password 'p@ss!', waits exactly 5 minutes, clicks 'Dashboard', receives timeout error"

### 2. Focus on Root Cause, Not Symptoms

**Symptom**: "Session times out"
**Root Cause**: "SESSION_TIMEOUT constant set to wrong value"

Fix the root cause, not the symptom.

### 3. Trust the TDD Gates

Don't skip or bypass the Red→Green gates. They exist to ensure:
- Test actually reproduces the bug
- Fix actually resolves the bug

### 4. Add Comprehensive Edge Cases

Don't just add one regression test. Add 2-8 edge case tests:
- Different inputs
- Boundary conditions
- Timing variations
- Alternative paths

### 5. Run Full Test Suite

Always run the entire project test suite, not just the new tests. Regressions are the enemy.

---

## Troubleshooting

### Error: "Red Gate Failed - Test passed before fix"

**Cause**: Test doesn't reproduce bug

**Fix:**
```bash
# Review reproduction data
cat analysis/reproduction-data.md

# Ensure test matches exact conditions
# Re-write test to actually fail

# Resume from implementation
/ai-sdlc:bug-fix:resume [path] --from=implementation
```

### Error: "Green Gate Failed - Test failed after fix"

**Cause**: Fix doesn't work

**Fix:**
```bash
# Debug the fix
# Adjust implementation

# Resume from implementation
/ai-sdlc:bug-fix:resume [path] --from=implementation
```

### Error: "Regressions detected"

**Cause**: Fix broke other functionality

**Fix:**
```bash
# Review failing tests
npm test -- --verbose

# Adjust fix to avoid side effects

# Resume from testing
/ai-sdlc:bug-fix:resume [path] --from=testing
```

---

## Related Workflows

- **[Feature Development](feature-development.md)** - For adding new capabilities
- **[Enhancement Workflow](enhancement-workflow.md)** - For improving existing features
- **[Refactoring Workflow](refactoring.md)** - For improving code structure

---

## Additional Resources

- [Command Reference](../../commands/bug-fix/new.md) - Detailed command documentation
- [Skill Documentation](../../skills/bug-fix-orchestrator/SKILL.md) - Technical implementation details
- [Troubleshooting Guide](../Troubleshooting.md) - Common issues

---

**Next Steps**: Fix your first bug with `/ai-sdlc:bug-fix:new [bug description]`
