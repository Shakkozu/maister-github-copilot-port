# Workflow Phases Reference

This reference defines the 7-phase refactoring workflow with phase dependencies, state transitions, and execution patterns.

## Purpose

Refactoring workflow progresses through distinct phases, each with specific responsibilities, inputs/outputs, and state transitions. This reference guides orchestrator execution through phases.

---

## Workflow Overview

```
Phase 0: Code Quality Baseline Analysis
    ↓
Phase 1: Refactoring Planning
    ↓
Phase 2: Behavioral Snapshot Capture
    ↓
Phase 2.5: Branch Setup (optional, asks user)
    ↓
Phase 3: Refactoring Execution (with git commit checkpoints)
    ↓
Phase 4: Behavior Verification
    ↓
Phase 5: Final Quality Verification
```

**Total Phases**: 7 (0, 1, 2, 2.5, 3, 4, 5)
**Execution Modes**: Interactive (pause between phases) or YOLO (continuous)
**Auto-Recovery**: Limited (Phase 0-2 only, not Phase 2.5 or 3-5)

---

## Phase 0: Code Quality Baseline Analysis

### Purpose
Establish quantitative baseline of current code quality to measure refactoring success

### Agent
`refactoring-analyzer` (read-only subagent)

### Input
- Refactoring description from user
- Task directory path: `.ai-sdlc/tasks/refactoring/YYYY-MM-DD-task-name/`

### Process
1. Locate target code (parse description, glob/grep search)
2. Analyze cyclomatic complexity (per function, average, max)
3. Measure code duplication (percentage, instances)
4. Identify code smells (long methods, god classes, deep nesting, magic numbers)
5. Assess test coverage (line, branch, function coverage)
6. Generate quality baseline report

### Output
- `analysis/code-quality-baseline.md`: Comprehensive metrics report
- `analysis/target-code-analysis.md`: List of target files

### Success Criteria
- ✅ Target code identified (at least 1 file)
- ✅ All metrics calculated
- ✅ Baseline report complete
- ✅ Refactoring goals defined

### State Update
```yaml
orchestrator_state:
  current_phase: 0
  last_completed_phase: -1
  phases_completed: []

# After completion:
orchestrator_state:
  current_phase: 1
  last_completed_phase: 0
  phases_completed: [0]
```

### Auto-Fix
**Max Attempts**: 2
- Expand search patterns if target code not found
- Use manual analysis if tools unavailable

### Failure Handling
If target code not found after 2 attempts: HALT, ask user to identify target files

---

## Phase 1: Refactoring Planning

### Purpose
Create detailed, incremental refactoring plan with git checkpoints and rollback procedures

### Agent
`refactoring-planner` (read-only subagent)

### Input
- `analysis/code-quality-baseline.md` from Phase 0

### Process
1. Load quality baseline metrics
2. Classify refactoring type (Extract, Rename, Simplify, etc.)
3. Break refactoring into small, testable increments (1 focused change per increment)
4. Plan git commit checkpoints (one commit per increment)
5. Identify affected tests and regression tiers
6. Assess complexity and risk per increment
7. Generate comprehensive refactoring plan

### Output
- `implementation/refactoring-plan.md`: Detailed plan with increments, commit checkpoints, test tiers, risk assessment

### Success Criteria
- ✅ Refactoring type classified
- ✅ Increments defined (testable, small)
- ✅ Git commit checkpoint strategy defined
- ✅ Test tiers identified
- ✅ Risk assessed
- ✅ Rollback procedures documented

### State Update
```yaml
orchestrator_state:
  current_phase: 2
  last_completed_phase: 1
  phases_completed: [0, 1]
  refactoring_type: "Extract Method"
  total_increments: 5
  risk_level: "Medium"
```

### Auto-Fix
**Max Attempts**: 2
- Ask user to clarify type if ambiguous
- Use conservative estimates if complexity unclear

### Failure Handling
If refactoring type unclear after 2 attempts: HALT, ask user to specify

---

## Phase 2: Behavioral Snapshot Capture

### Purpose
Capture comprehensive behavioral baseline before refactoring for exact comparison

### Agent
`behavioral-snapshot-capturer` (read-only subagent)

### Input
- `implementation/refactoring-plan.md` from Phase 1 (target files)

### Process
1. Identify target functions (extract signatures, parameters, return types)
2. Analyze test coverage (find direct, integration, domain tests)
3. Run tests and capture baseline results (pass/fail, inputs/outputs if available)
4. Identify observable side effects (DB, API, files, logs, state changes)
5. Create behavioral fingerprint (hash of signatures + tests + side effects)
6. Generate behavioral snapshot report

### Output
- `analysis/behavioral-snapshot.md`: Comprehensive behavioral baseline
- `analysis/behavioral-fingerprint.yml`: Quick comparison hash

### Success Criteria
- ✅ All functions inventoried
- ✅ Test coverage analyzed
- ✅ Test results captured
- ✅ Side effects documented
- ✅ Behavioral fingerprint generated
- ✅ Test gaps identified

### State Update
```yaml
orchestrator_state:
  current_phase: 3
  last_completed_phase: 2
  phases_completed: [0, 1, 2]
  baseline_fingerprint: "xyz789abc012def345..."
  functions_analyzed: 15
  test_coverage: 70
```

### Auto-Fix
**Max Attempts**: 1
- Document limitations if test framework doesn't expose I/O
- Document test gaps if functions untested
- Proceed with noted constraints

### Failure Handling
If critical functions untested: HALT, recommend adding tests before refactoring

---

## Phase 2.5: Branch Setup

### Purpose
Ask user if they want a dedicated git branch for refactoring work

### Agent
Main orchestrator (uses AskUserQuestion tool)

### Input
- Task directory path
- Current git branch

### Process
1. Use AskUserQuestion to prompt user about branch creation
2. If user approves: Create single refactoring branch `refactor/YYYY-MM-DD-task-name`
3. If user declines: Continue on current branch
4. Update state with branch information

**Execution Pattern**:
```
AskUserQuestion:
  question: "Would you like to create a dedicated git branch for this refactoring?"
  header: "Git Branch"
  options:
    - "Yes, create a branch" → Create refactor/YYYY-MM-DD-task-name
    - "No, work on current branch" → Continue on current branch
```

### Output
- `refactoring_branch`: Branch name (either new refactor branch or current branch)
- `use_dedicated_branch`: Boolean (true if created, false if using current)

### Success Criteria
- ✅ User decision captured
- ✅ Branch created if requested (or current branch identified)
- ✅ State updated with branch info

### State Update
```yaml
orchestrator_state:
  current_phase: 2.5
  last_completed_phase: 2
  phases_completed: [0, 1, 2]
  use_dedicated_branch: true
  refactoring_branch: "refactor/2025-11-20-simplify-validation"
```

### Auto-Fix
**Max Attempts**: N/A (user decision, no auto-fix)

### Failure Handling
No failure scenario (user choice always succeeds)

---

## Phase 3: Refactoring Execution

### Purpose
Apply incremental refactoring changes with git commit checkpoints and user-confirmed rollback on failure

### Agent
Main orchestrator (delegates planning to `implementation-changes-planner` if needed)

### Input
- `implementation/refactoring-plan.md` from Phase 1
- `analysis/behavioral-snapshot.md` from Phase 2
- `refactoring_branch` from Phase 2.5

### Process
**For Each Increment**:
1. Apply refactoring changes (orchestrator or delegate to subagent for planning)
2. Run regression tests (appropriate tiers based on risk)
3. Verify behavior preserved (tests pass identically)
4. If tests pass: Create git commit checkpoint, continue
5. If tests fail: **ANALYZE → ASK USER → Execute user's choice**

**Execution Pattern**:
```bash
# Apply changes
[orchestrator applies file modifications]

# Run tests
npm test  # or appropriate test command

# If pass:
git add .
git commit -m "Checkpoint N: Description"
COMMIT_HASH=$(git rev-parse HEAD)
echo "✅ Checkpoint $N created: $COMMIT_HASH"

# Continue to next increment

# If fail:
# 1. ANALYZE failure root cause (config? setup? behavior change?)
# 2. Check for easy fixes
# 3. ASK USER with AskUserQuestion:
#    - "Try suggested fix" (if easy fix found)
#    - "Rollback changes" (user confirms)
#    - "Let me investigate" (pause for manual review)
# 4. Execute based on user choice
# 5. If rollback: git reset --hard HEAD
# 6. HALT orchestrator
```

### Output
- Modified code files (refactored)
- Git commit checkpoints on refactoring branch (or current branch)
- `implementation/refactoring-plan.md`: Updated with completion status

### Success Criteria (Per Increment)
- ✅ Code change applied
- ✅ All assigned tests pass (Tier 1, 2, 3 based on risk)
- ✅ No new linting errors
- ✅ Git commit checkpoint created

### State Update (Per Increment)
```yaml
orchestrator_state:
  current_phase: 3
  last_completed_phase: 2.5
  phases_completed: [0, 1, 2, 2.5]
  current_increment: 3
  increments_completed: [1, 2]
  commit_checkpoints:
    - increment: 1
      description: "extract-validation"
      commit_hash: "abc1234"
      timestamp: "2025-11-20T10:15:00Z"
    - increment: 2
      description: "rename-variables"
      commit_hash: "def5678"
      timestamp: "2025-11-20T10:30:00Z"
```

### Auto-Fix
**Max Attempts**: **0 (ZERO)** - NO AUTO-FIX
**User Confirmation**: **ALWAYS required before rollback**

**Failure Protocol**:
- ANY test failure → STOP, ANALYZE root cause, ASK USER
- Present options: Try suggested fix / Rollback / Investigate
- Execute based on user choice
- NEVER rollback automatically without user confirmation
- Save state with failure analysis and user decision

### Failure Handling
```yaml
# On test failure - after user confirmation
failed_phases:
  - phase: phase-3-execution
    increment: 3
    error: "Test failure: testUpdateUser() FAILED"
    failure_analysis: "Missing DATABASE_URL in test config"
    user_decision: "rollback"  # or "fix_applied" or "manual_investigation"
    rollback_executed: true
    rollback_command: "git reset --hard HEAD"
    resolution: "User confirmed rollback after reviewing analysis"
```

---

## Phase 4: Behavior Verification

### Purpose
Comprehensive verification that refactoring preserved behavior exactly

### Agent
`behavioral-verifier` (read-only subagent)

### Input
- `analysis/behavioral-snapshot.md` from Phase 2 (baseline)
- Refactored code from Phase 3

### Process
1. Load baseline snapshot
2. Capture post-refactoring state (re-run same analysis as Phase 2)
3. Compare function signatures (must be identical unless explicit rename)
4. Validate test results (must be identical)
5. Confirm side effects preserved (must be identical)
6. Compare behavioral fingerprints (quick check)
7. Generate behavior verification report

### Output
- `verification/behavior-verification-report.md`: Comprehensive comparison with verdict
- `verification/post-refactoring-snapshot.md`: Current behavior snapshot
- `verification/fingerprint-comparison.yml`: Hash comparison

### Success Criteria
- ✅ All function signatures matched (or explicitly renamed per plan)
- ✅ All tests pass identically
- ✅ All side effects preserved
- ✅ Behavioral fingerprint matches
- ✅ No unexpected discrepancies

### Verdict
- ✅ **PASS**: Behavior preserved exactly, approve refactoring
- ❌ **FAIL**: Behavior changed, recommend ROLLBACK

### State Update (If PASS)
```yaml
orchestrator_state:
  current_phase: 5
  last_completed_phase: 4
  phases_completed: [0, 1, 2, 3, 4]
  behavior_verification_status: "PASS"
```

### State Update (If FAIL)
```yaml
orchestrator_state:
  current_phase: 4
  last_completed_phase: 3
  phases_completed: [0, 1, 2, 3]
  behavior_verification_status: "FAIL"
  discrepancies_found: 2
  # Orchestrator halts, does not proceed to Phase 5
```

### Auto-Fix
**Max Attempts**: **0 (ZERO)** - NO AUTO-FIX
**User Confirmation**: **ALWAYS required before rollback**

Verification reports issues, never fixes them automatically

### Failure Handling
If behavior not preserved:
- Document all discrepancies with evidence
- ANALYZE root cause (real behavior change or config/mock issue?)
- Check for easy fixes
- ASK USER with AskUserQuestion:
  - "Try suggested fix" (if easy fix found)
  - "Rollback changes" (user confirms)
  - "Let me investigate" (pause for manual review)
- Execute based on user choice
- NEVER recommend rollback without user confirmation

---

## Phase 5: Final Quality Verification

### Purpose
Verify refactoring achieved quality goals and met all requirements

### Agent
Main orchestrator (optionally delegates to `code-reviewer` and `production-readiness-checker`)

### Input
- `analysis/code-quality-baseline.md` from Phase 0
- `verification/behavior-verification-report.md` from Phase 4 (PASS required)
- Refactored code

### Process
1. Re-measure all quality metrics from Phase 0
2. Compare baseline vs post-refactoring metrics
3. Calculate improvement percentages
4. Verify refactoring goals met
5. **(Optional)** Run code-reviewer for automated quality/security/performance analysis
6. **(Optional)** Run production-readiness-checker if deploying
7. Generate final quality report

### Output
- `verification/quality-improvement-report.md`: Metrics comparison, goals assessment
- `verification/code-review-report.md`: (Optional) Code review findings
- `verification/production-readiness-report.md`: (Optional) Deployment readiness

### Success Criteria
- ✅ All baseline metrics re-measured
- ✅ Metrics compared with baseline
- ✅ Refactoring goals met (or acceptable progress)
- ✅ Code quality improved
- ✅ No critical issues found

### Overall Status
- ✅ **Success**: Goals met, quality improved, no critical issues
- ⚠️ **Success with Concerns**: Goals mostly met, minor concerns
- ❌ **Failed**: Goals not met, quality concerns remain

### State Update
```yaml
orchestrator_state:
  current_phase: 5
  last_completed_phase: 5
  phases_completed: [0, 1, 2, 3, 4, 5]
  workflow_status: "completed"
  overall_status: "Success"
  quality_improvement:
    complexity_reduction: 33
    duplication_reduction: 67
    goals_met: true
```

### Auto-Fix
**Max Attempts**: 1 (flag issues only, don't fix)

### Failure Handling
If goals not met:
- Document what was achieved vs goals
- User decides whether to:
  - Accept partial improvement
  - Continue refactoring (additional increments)
  - Rollback

---

## Phase Dependencies

### Prerequisite Requirements

**Phase 1** requires:
- Phase 0 complete
- `analysis/code-quality-baseline.md` exists

**Phase 2** requires:
- Phase 1 complete
- `implementation/refactoring-plan.md` exists

**Phase 2.5** requires:
- Phase 2 complete
- `analysis/behavioral-snapshot.md` exists

**Phase 3** requires:
- Phase 2.5 complete
- `refactoring_branch` defined (from Phase 2.5)
- `implementation/refactoring-plan.md` exists

**Phase 4** requires:
- Phase 3 complete
- All increments completed successfully
- At least 1 commit checkpoint created

**Phase 5** requires:
- Phase 4 complete
- Behavior verification: PASS
- Cannot proceed if Phase 4 failed

---

## State Transitions

### Valid Transitions

```
-1 (Start) → 0 → 1 → 2 → 2.5 → 3 → 4 → 5 (Complete)
                                  ↓
                               HALT (on failure)
```

### Invalid Transitions

❌ Cannot skip phases (e.g., 0 → 2)
❌ Cannot proceed if previous phase failed
❌ Cannot proceed to Phase 5 if Phase 4 verdict = FAIL

---

## Execution Modes

### Interactive Mode (Default)

**Behavior**: Pause after each phase, prompt user to continue

**User Prompts**:
- After Phase 0: "Quality baseline complete. Continue to planning?"
- After Phase 1: "Refactoring plan created. Review plan before proceeding?"
- After Phase 2: "Behavioral snapshot captured. Begin refactoring execution?"
- After Phase 3: "Refactoring complete. Verify behavior preservation?"
- After Phase 4: "Behavior verified. Run final quality check?"

**User Actions**: Approve to continue, or stop to review

---

### YOLO Mode

**Behavior**: Continuous execution, no pauses

**Command**: `/ai-sdlc:refactoring:new [description] --yolo`

**Stops Only If**:
- Phase fails (after auto-fix attempts exhausted)
- Test failure in Phase 3 (immediate rollback and halt)
- Behavior verification fails in Phase 4

---

## Resume Capability

### Resume After Interruption

**Command**: `/ai-sdlc:refactoring:resume [task-path]`

**Resume Points**:
- From last completed phase
- Or override: `--from=phase-N`

**State Reconstruction**:
If `orchestrator-state.yml` missing:
1. Check which phases have output files
2. Reconstruct state from artifacts
3. Resume from last complete phase

---

## Error Recovery

### Phase 0-2: Limited Auto-Fix

**Max Attempts**: 1-2 per phase

**Strategy**:
- Expand search patterns
- Try alternative methods
- Document limitations

**If Unresolved**: HALT, ask user for input

---

### Phase 3: Analyze → Ask → Execute

**Max Attempts**: 0 auto-fix (but ask user first)

**Strategy**:
- STOP on test failure
- ANALYZE root cause (config? setup? behavior change?)
- Check for easy fixes
- ASK USER with AskUserQuestion
- Execute based on user choice (fix/rollback/investigate)
- NEVER rollback automatically

**User Action**: Choose from options presented after analysis

---

### Phase 4-5: Analyze → Ask → Execute

**Max Attempts**: 0 auto-fix (but ask user first)

**Strategy**:
- Report issues with evidence
- ANALYZE root cause
- Check for easy fixes
- ASK USER before any rollback recommendation
- Don't modify code automatically

**User Action**: Choose from options presented after analysis

---

## Workflow Completion

### Success Path

```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ✅ → Phase 4 ✅ (PASS) → Phase 5 ✅

Final State:
- workflow_status: completed
- overall_status: Success
- All checkpoints can be merged
- Ready for code review and merge to main
```

---

### Failure Paths

**Failure in Phase 3 (Test failure)**:
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ❌ (Increment N failed)
                                          ↓
                                    ANALYZE root cause
                                    ASK USER (fix/rollback/investigate)
                                    Execute user's choice
                                    HALT

Final State:
- workflow_status: failed
- failed_phase: phase-3-execution
- failure_analysis: "[analysis details]"
- user_decision: "[user's choice]"
- rollback_executed: true/false (based on user choice)
```

**Failure in Phase 4 (Behavior changed)**:
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ✅ → Phase 4 ❌ (FAIL verdict)
                                                      ↓
                                          ANALYZE discrepancies
                                          ASK USER (fix/rollback/investigate)
                                          Execute user's choice
                                          HALT (don't proceed to Phase 5)

Final State:
- workflow_status: failed
- failed_phase: phase-4-verification
- behavior_verification_status: FAIL
- failure_analysis: "[analysis details]"
- user_decision: "[user's choice]"
```

---

## Summary

**7-Phase Workflow**: Baseline → Plan → Snapshot → Branch Setup → Execute → Verify Behavior → Verify Quality

**Key Features**:
- Git checkpoints enable safe incremental refactoring
- User-confirmed rollback on failure (NEVER automatic)
- On failure: Analyze → Ask user → Execute user's choice
- Strict behavior preservation verification (Phase 4)
- Two execution modes: Interactive (default) and YOLO

**Auto-Fix Policy**: Very limited (Phase 0-2 only), zero tolerance in Phase 3-5

**Rollback Policy**: NEVER automatic - always analyze first, then ask user for confirmation

**Success Criteria**: All phases complete with behavior preserved and quality improved

This workflow ensures safe, verifiable refactoring with user control over rollback decisions.
