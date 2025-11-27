# Auto-Fix Strategies Reference

This reference provides recovery patterns and failure handling strategies for the refactoring orchestrator workflow.

## Purpose

Refactoring has strict behavior preservation requirements. This reference defines when auto-fix is appropriate, max attempt limits, and when to halt immediately with no recovery attempts.

---

## Refactoring Auto-Fix Philosophy

### Core Principles

**1. Behavior Preservation is Sacred**
- Zero tolerance for behavior changes
- Any test failure = Analyze root cause → Ask user → Execute user's choice
- Side effect changes = Analyze root cause → Ask user → Execute user's choice
- **NEVER rollback automatically** - always get user confirmation first

**2. Limited Auto-Fix Scope**
- Only analysis/planning phases allow auto-fix
- Execution phase (Phase 3): **ZERO auto-fix attempts**
- Verification phases: Flag only, never fix

**3. Safe Failure**
- Git checkpoints enable user-confirmed rollback
- State always saved before risky operations
- Clear guidance for manual intervention

**4. User-Confirmed Rollback**
- Test failures → Analyze root cause → Ask user → Execute user's choice
- Behavior changes → Analyze root cause → Ask user → Execute user's choice
- **NEVER rollback automatically** - user must confirm
- Check for easy fixes before suggesting rollback

---

## Max Attempts by Phase

| Phase | Max Attempts | Auto-Fix Strategy | Escalation |
|-------|--------------|-------------------|------------|
| Phase 0: Code Quality Baseline | 2 | Expand search, try manual analysis | User must locate target code |
| Phase 1: Refactoring Planning | 2 | Try alternative patterns, simplify | User must clarify refactoring goals |
| Phase 2: Behavioral Snapshot | 1 | Document limitations | User must add tests if coverage low |
| Phase 2.5: Branch Setup | N/A | User decision, no auto-fix | N/A (user chooses branch or no branch) |
| Phase 3: Refactoring Execution | **0** | **NO AUTO-FIX** | **Analyze → Ask user → User decides** |
| Phase 4: Behavior Verification | **0** | **NO AUTO-FIX** | **Analyze → Ask user → User decides** |
| Phase 5: Final Quality Check | 1 | Flag issues, don't fix | User must address quality concerns |

---

## Phase 0: Code Quality Baseline Auto-Fix

### Common Failures

**Failure**: Target code not found

**Auto-Fix Attempts**:

**Attempt 1**: Expand search patterns
- Broaden file patterns (`**/*user*` → `**/*`)
- Search additional directories
- Try alternative naming conventions

**Attempt 2**: Manual analysis
- If tools unavailable, use manual complexity counting
- Document tool limitations
- Proceed with available analysis methods

**Escalation**: If target code still not found after 2 attempts:
- Save state with error details
- Ask user to identify target files manually
- Provide resume capability

---

**Failure**: Quality tools not available

**Auto-Fix Attempts**:

**Attempt 1**: Fall back to manual analysis
- Manual complexity counting
- Pattern-based duplication detection
- Heuristic code smell identification

**Escalation**: Rarely needed - manual analysis is fallback

---

## Phase 1: Refactoring Planning Auto-Fix

### Common Failures

**Failure**: Refactoring type unclear from metrics

**Auto-Fix Attempts**:

**Attempt 1**: Ask user to specify type
- Present detected indicators
- Show type classification scores
- Ask user to confirm or override

**Attempt 2**: Default to "Mixed" refactoring
- Use combined approach
- Document assumption in plan

**Escalation**: Mixed type works for ambiguous cases

---

**Failure**: Test discovery finds no tests

**Auto-Fix Attempts**:

**Attempt 1**: Expand test search patterns
- Search for alternative test locations
- Try different naming patterns (`*.test.*`, `*.spec.*`, `*_test.*`)
- Check for non-standard test directories

**Attempt 2**: Document test gaps
- Proceed with refactoring plan
- Mark as high-risk due to low coverage
- Recommend adding tests in separate increment

**Escalation**: If critical functions untested:
- Save state
- Recommend user add tests BEFORE refactoring
- Pause workflow until tests added

---

**Failure**: Complexity estimation unclear

**Auto-Fix Attempts**:

**Attempt 1**: Use conservative estimates
- Assume higher complexity
- Plan more increments (smaller, safer)
- Document uncertainty

**Escalation**: Rarely needed - conservative estimates work

---

## Phase 2: Behavioral Snapshot Auto-Fix

### Common Failures

**Failure**: Test framework doesn't expose input/output details

**Auto-Fix Strategy**: **ACCEPT LIMITATION**
- Document test pass/fail status only
- Rely on test verdicts (pass = behavior correct)
- Use side effect analysis for additional verification
- Note limitation in snapshot report

**Max Attempts**: 1 (document and proceed)

---

**Failure**: Functions without tests

**Auto-Fix Strategy**: **DOCUMENT GAP**
- List untested functions
- Assess risk level
- Recommend adding tests
- Proceed with higher risk assessment

**Max Attempts**: 1 (document and proceed)

**Critical Functions Without Tests**: Escalate
- If authentication, payment, or data loss functions untested: HALT
- Ask user to add tests before refactoring
- Too risky to refactor without tests

---

**Failure**: Non-deterministic behavior (timestamps, UUIDs)

**Auto-Fix Strategy**: **DOCUMENT PATTERN**
- Document non-deterministic aspects
- Verify behavior category (e.g., "generates UUID format")
- Adjust verification strategy accordingly

**Max Attempts**: 1 (document and proceed)

---

## Phase 3: Refactoring Execution - NO AUTO-FIX (But Ask User Before Rollback)

### Critical Principle

**ZERO auto-fix attempts during execution**
**ALWAYS ask user before any rollback**

**Rationale**:
- Refactoring must preserve behavior exactly
- Any test failure indicates behavior MAY have changed
- BUT: Often failures are config/setup issues with easy fixes
- **NEVER rollback automatically** - user must confirm
- Git checkpoints enable user-confirmed rollback

---

### Failure Handling Protocol

**IMPORTANT: NEVER automatically rollback without user confirmation. Always analyze first, then ask.**

**ANY test failure after increment**:
```
1. STOP immediately (no auto-fix attempts)

2. ANALYZE failure root cause:
   - Configuration/Environment issues? (missing env var, wrong connection string)
   - Test setup issues? (missing fixture, mock incomplete, import path wrong)
   - Actual behavioral change? (logic changed, side effect removed)

3. ASK USER with AskUserQuestion tool:
   question: "Test failure in Increment [N]. [DIAGNOSIS]. How would you like to proceed?"
   options:
     - "Try suggested fix" (if easy fix identified, e.g., "Add missing DATABASE_URL")
     - "Rollback changes" (user confirms rollback)
     - "Let me investigate" (pause for manual investigation)

4. EXECUTE based on user choice:
   - If "Try suggested fix": Apply fix, re-run tests (max 2 fix attempts)
   - If "Rollback changes": git reset --hard HEAD
   - If "Let me investigate": Save state, HALT, let user investigate

5. UPDATE state with failure analysis and user decision

6. If user chose rollback or investigation: HALT orchestrator
```

**ANY side effect discrepancy**:
```
1. STOP immediately
2. ANALYZE the discrepancy - is it real or config/mock issue?
3. ASK USER with same pattern as above
4. EXECUTE based on user choice
5. If user chose rollback or investigation: HALT orchestrator
```

**Code changes fail to apply**:
```
1. STOP immediately
2. ANALYZE the conflict - is it merge conflict, permission, or real issue?
3. ASK USER with options: retry, rollback, investigate
4. EXECUTE based on user choice
```

---

### Common Easy Fixes (Analyze Before Suggesting Rollback)

**Configuration/Environment Issues**:
- Missing environment variable → Suggest adding to .env or test config
- Database connection wrong → Suggest checking DATABASE_URL
- API endpoint changed → Suggest updating mock or config

**Test Setup Issues**:
- Test fixture missing → Suggest initializing test data
- Mock configuration incomplete → Suggest updating mock
- Async timing issue → Suggest adding wait/retry
- Import path changed but test not updated → Suggest updating import

**Abstract Test Class Issues**:
- Context parameter missing → Suggest adding required context
- Base class method not overridden → Suggest implementing method

---

### Why Analyze Before Rollback?

**Problem with Automatic Rollback**:
- Often failures are simple config issues with 1-line fixes
- Automatic rollback discards potentially valid refactoring work
- User loses visibility into what went wrong
- May cause repeated failures without understanding root cause

**Benefits of User-Confirmed Rollback**:
- User understands the failure before deciding
- Easy fixes can be applied without losing work
- Better user experience and trust
- Preserves refactoring progress when possible

---

### Why Zero Auto-Fix (But Ask User)?

**STILL NOT allowed** (orchestrator decides to fix):

❌ **"Test failed, let me automatically adjust the refactoring"**
- Orchestrator shouldn't make strategic decisions

❌ **"Test failed, let me automatically update the test"**
- Tests are the truth, don't modify them automatically

❌ **"Minor side effect change, I'll ignore it"**
- ANY behavior change violates refactoring

**NOW allowed** (user decides after analysis):

✅ **"Test failed. Analysis shows missing DATABASE_URL. Options: [Try fix] [Rollback] [Investigate]"**
- User makes informed decision
- Easy fixes can be applied with user consent
- Rollback only happens when user confirms

---

## Phase 4: Behavior Verification - NO AUTO-FIX (But Ask User Before Rollback)

### Principle

**Verification reports issues, never fixes them**
**ALWAYS ask user before recommending rollback**

**Max Attempts**: 0 (flag and report only, but analyze before suggesting action)

---

### Failure Scenarios

**IMPORTANT: NEVER automatically recommend rollback without user confirmation. Always analyze first, then ask.**

**Scenario 1: Behavioral fingerprint mismatch**

**Response**: **ANALYZE → ASK USER**
1. Document which hash differs
2. Analyze what changed (signatures, tests, side effects?)
3. Check for easy fixes (mock config, test assertion too strict?)
4. ASK USER with AskUserQuestion:
   - "Try suggested fix" (if easy fix found)
   - "Rollback changes" (user confirms)
   - "Let me investigate" (pause for manual review)

---

**Scenario 2: Test results differ**

**Response**: **ANALYZE → ASK USER**
1. Document new test failures
2. Analyze WHY tests fail - is it real behavior change or setup issue?
3. Check for easy fixes (timing, mock data, env config)
4. ASK USER with AskUserQuestion:
   - "Try suggested fix" (if easy fix found)
   - "Rollback changes" (user confirms)
   - "Let me investigate" (pause for manual review)

---

**Scenario 3: Side effects changed**

**Response**: **ANALYZE → ASK USER**
1. Document changed side effects
2. Analyze if change is real or logging/mock issue
3. Check for easy fixes (logger config, mock setup)
4. ASK USER with AskUserQuestion:
   - "Try suggested fix" (if easy fix found)
   - "Rollback changes" (user confirms)
   - "Let me investigate" (pause for manual review)

---

**Scenario 4: Function signatures changed (unexpectedly)**

**Response**: **ANALYZE → ASK USER**
1. Document signature changes
2. Determine if intentional (rename refactoring) or accidental
3. ASK USER with AskUserQuestion:
   - "Accept signature change" (if part of rename refactoring)
   - "Rollback changes" (user confirms)
   - "Let me investigate" (pause for manual review)

---

### Why No Auto-Fix in Verification (But Ask User)?

**Verification is Quality Gate, Not Fix-It Phase**

❌ **Wrong**: "Found behavior change, let me automatically fix the refactoring"
- Verification shouldn't modify code automatically

❌ **Wrong**: "Found behavior change, automatically rollback"
- User should understand what went wrong first
- Often there's an easy fix

✅ **Right**: "Found behavior change. Analysis: [details]. Options: [fix/rollback/investigate]"
- Clear analysis of what changed
- User makes informed decision
- Easy fixes can be applied with user consent

---

## Phase 5: Final Quality Check Auto-Fix

### Common Failures

**Failure**: Code review finds quality issues

**Auto-Fix Strategy**: **FLAG ONLY**
- Document quality issues found
- Categorize by severity
- Provide recommendations
- Don't modify code

**Max Attempts**: 1 (report issues)

**Escalation**: User decides whether to address issues before merge

---

**Failure**: Metrics show quality didn't improve

**Auto-Fix Strategy**: **DOCUMENT**
- Compare baseline vs post-refactoring metrics
- Note which metrics improved, which didn't
- Assess whether refactoring goals met
- Don't modify code

**Max Attempts**: 1 (report results)

**Escalation**: User decides if goals met

---

## Attempt Tracking in State

### State Structure

```yaml
orchestrator_state:
  current_phase: 3
  last_completed_phase: 2
  mode: interactive

auto_fix_attempts:
  phase-0-baseline: 1
  phase-1-planning: 0
  phase-2-snapshot: 1
  phase-3-execution: 0  # Always 0
  phase-4-verification: 0  # Always 0
  phase-5-quality: 0

failed_phases:
  - phase: phase-3-execution
    increment: 3
    error: "Test failure: testUpdateUser() FAILED"
    test_details:
      failed_tests:
        - name: testUpdateUser
          expected: "{ success: true }"
          actual: "{ success: false, error: 'Invalid ID' }"
    rollback_executed: true
    rollback_command: "git reset --hard HEAD"
    timestamp: "2025-11-14T14:30:00Z"
    resolution: "HALTED - User must investigate test failure"
```

---

## Auto-Fix Decision Tree

```
Phase Fails
    ↓
Is phase execution or verification?
    ↓
Yes (Phase 3, 4, 5) → HALT IMMEDIATELY
    ↓
    Execute rollback (if Phase 3)
    Save state
    Report to user
    Exit workflow
    ↓
No (Phase 0, 1, 2) → Check if auto-fixable
    ↓
Is failure auto-fixable?
    ↓
No → HALT immediately, save state, report
    ↓
Yes → Check attempt count
    ↓
Attempts >= Max?
    ↓
Yes → HALT, save state, escalate to user
    ↓
No → Attempt auto-fix
    ↓
Increment attempt counter
    ↓
Apply auto-fix strategy
    ↓
Retry phase execution
    ↓
Success? → Continue to next phase
Failure? → Return to "Check attempt count"
```

---

## Escalation Patterns

### Pattern 1: Analyze → Ask → Execute (Phase 3, 4)

**When**: Test failures, behavior changes in execution/verification

**Action**:
1. STOP immediately (no auto-fix)
2. ANALYZE failure root cause
3. Check for easy fixes (config, setup, mock issues)
4. ASK USER with AskUserQuestion:
   - "Try suggested fix" (if easy fix found)
   - "Rollback changes" (user confirms)
   - "Let me investigate" (pause for manual review)
5. EXECUTE based on user choice
6. If rollback or investigation: HALT workflow

**User Next Steps**:
- User chose: Try suggested fix → Apply and re-run
- User chose: Rollback → Changes reverted
- User chose: Investigate → Pause for manual investigation

---

### Pattern 2: Limited Retry (Phase 0, 1, 2)

**When**: Analysis or planning issues

**Action**:
1. Attempt auto-fix (max 1-2 attempts)
2. If resolved: Continue
3. If unresolved: HALT and request user input

**User Next Steps**:
- Provide missing information
- Clarify requirements
- Resume workflow

---

### Pattern 3: Document and Proceed (Phase 2)

**When**: Non-critical limitations (test framework, non-deterministic code)

**Action**:
1. Document limitation
2. Adjust verification strategy
3. Proceed with noted constraints

**Impact**: Higher risk assessment, but workflow continues

---

## Rollback Execution

### User-Confirmed Rollback (Phase 3 and 4)

**IMPORTANT**: NEVER rollback automatically. Always ask user first.

**Trigger**: User chooses "Rollback changes" after reviewing failure analysis

**Process**:
```
1. ANALYZE failure root cause
2. ASK USER with AskUserQuestion (try fix / rollback / investigate)
3. IF user chose "Rollback changes":
   Execute rollback commands
```

**Commands (only after user confirmation)**:
```bash
# Reset to previous commit checkpoint
git reset --hard HEAD

# This reverts all changes from failed increment
# Returns to last successful checkpoint commit

# State preserved for resume
```

**State Update**:
```yaml
rollback_history:
  - increment: 3
    rollback_method: "git reset --hard HEAD"
    rollback_reason: "Test failure: testUpdateUser FAILED"
    failure_analysis: "Missing DATABASE_URL environment variable in test config"
    user_decision: "rollback"  # or "fix_applied" or "manual_investigation"
    rollback_timestamp: "2025-11-14T14:30:00Z"
    reverted_to_commit: "def5678"
    current_branch: "refactor/2025-11-20-simplify-validation"
```

---

## Best Practices

### 1. Analyze Before Suggesting Rollback
- Test failures → Analyze root cause first
- Behavior changes → Check for easy fixes
- Often config/setup issues can be fixed in 1 line

### 2. Always Ask User Before Rollback
- NEVER rollback automatically
- Present analysis and options
- Let user make informed decision

### 3. Clear Communication
- Log all failure details with analysis
- Explain what went wrong and why
- Provide options: try fix, rollback, investigate

### 4. State Consistency
- Always save state before HALT
- Track failure analysis and user decision
- Enable resume from failure point

### 5. User Respect
- Don't assume user wants rollback
- Provide clear diagnosis
- Give user control over decision

### 6. Preserve Code Integrity
- Git checkpoints before risky operations
- User-confirmed rollback (never automatic)
- Never leave codebase in broken state

---

## Common Anti-Patterns

### ❌ Automatic Rollback Without User Confirmation

**Problem**: "Test failed, automatically rolling back changes"

**Why Wrong**:
- Often failures are simple config issues with easy fixes
- User loses visibility into what went wrong
- Discards potentially valid refactoring work
- May cause repeated failures without understanding root cause

**Fix**: ALWAYS analyze first, then ask user with AskUserQuestion

---

### ❌ Auto-Fixing Test Failures

**Problem**: "Test failed, let me adjust code to pass it"

**Why Wrong**: Might hide real behavior changes

**Fix**: ZERO auto-fix attempts in Phase 3 (but ask user if they want to try a fix)

---

### ❌ Modifying Tests During Verification

**Problem**: "Tests don't match, let me update them"

**Why Wrong**: Tests are the truth, not the problem

**Fix**: Report discrepancy, don't modify tests

---

### ❌ "Close Enough" Behavior

**Problem**: "Side effect changed slightly, good enough"

**Why Wrong**: ANY behavior change violates refactoring

**Fix**: Zero tolerance for behavior changes

---

### ❌ Endless Retries

**Problem**: No max attempt limit in early phases

**Why Wrong**: Wastes time, frustrates user

**Fix**: Max 2 attempts for analysis phases

---

### ❌ Silent Failures

**Problem**: Failure occurs but not clearly reported

**Why Wrong**: User doesn't know what went wrong

**Fix**: Detailed failure reports with evidence

---

## Summary

**Refactoring has strictest auto-fix policy of all workflows:**

**Phase 0-2**: Limited auto-fix (max 1-2 attempts)
**Phase 3**: **ZERO auto-fix** (analyze → ask user → execute user's choice)
**Phase 4**: **ZERO auto-fix** (analyze → ask user → execute user's choice)
**Phase 5**: **ZERO auto-fix** (flag issues)

**Key Principle: NEVER rollback automatically without user confirmation**

**On ANY failure:**
1. STOP immediately (no auto-fix)
2. ANALYZE failure root cause
3. Check for easy fixes (config, setup, mock issues)
4. ASK USER with AskUserQuestion
5. EXECUTE based on user choice

**Philosophy**: Preserve code integrity while respecting user's control. Analyze before rollback. User decides.

This approach ensures refactoring is safe, behavior is preserved, and users have clear visibility and control over any issues.
