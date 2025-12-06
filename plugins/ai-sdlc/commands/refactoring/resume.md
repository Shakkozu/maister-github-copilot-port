---
name: ai-sdlc:refactoring:resume
description: Resume an interrupted or failed refactoring workflow from where it left off
---

Resume a refactoring workflow from saved state, with options to override resume point or reset attempts.

**Usage**: `/ai-sdlc:refactoring:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]`

**Parameters**:
- `task-path`: Path to refactoring task directory (required)
- `--from=phase`: Override resume point to specific phase (optional)
- `--reset-attempts`: Reset auto-fix attempt counters (optional)
- `--clear-failures`: Clear failed phases list and retry (optional)

**Examples**:
```
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-extract-validation
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-extract-validation --from=phase-3-execution
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-simplify-logic --reset-attempts
```

**What this does**:
1. Loads orchestrator-state.yml from task directory
2. Validates state and prerequisite phases
3. Validates git checkpoint branches exist (if Phase 3 in progress)
4. Resumes from last incomplete phase (or specified phase)
5. Continues workflow execution from that point

**When to use**:
- Refactoring workflow was interrupted (user halted)
- Refactoring workflow failed (test failure, behavior change detected)
- Want to restart specific phase with different approach
- Need to retry after manual corrections

**Resume scenarios**:

**Scenario 1: Normal interruption**
- User stopped workflow in interactive mode
- State saved correctly
- Resume continues from next phase

**Scenario 2: Test failure in Phase 3**
- Increment failed after tests didn't pass
- Automatic rollback executed
- State saved with failure details
- User fixed code or tests
- Resume restarts from failed increment (or earlier phase if `--from` specified)

**Scenario 3: Behavior verification failed (Phase 4)**
- Behavior changes detected after refactoring
- State saved with discrepancies
- User investigated and fixed behavior changes
- Resume restarts Phase 4 to re-verify

**Scenario 4: Manual corrections made**
- User manually fixed issues (added tests, fixed code)
- Use `--from=phase-N` to restart from specific phase
- Previous phases remain marked complete

**Scenario 5: State file corruption**
- orchestrator-state.yml missing or corrupted
- Orchestrator attempts state reconstruction from artifacts:
  - Check which phase outputs exist
  - Validate git checkpoint branches
  - Reconstruct most recent valid state
- If reconstruction fails, may need to restart refactoring

**State validation**:
- Checks all prerequisite phases marked complete
- Verifies output files exist for completed phases
- Validates git checkpoint branches exist (if Phase 3 completed)
- If validation fails, may restart earlier phase automatically

**Override options**:

**--from=phase**: Manually specify resume point
- Useful if want to redo a phase
- Example: `--from=phase-3-execution` restarts refactoring execution
- Previous phases stay marked complete (won't re-execute)
- Validates prerequisites completed before resuming

**--reset-attempts**: Reset auto-fix attempt counters
- Useful after phase failed due to max attempts
- Gives fresh attempts at auto-recovery
- Use when manual corrections make retry viable
- Only affects Phase 0-2 (Phase 3-5 have zero auto-fix)

**--clear-failures**: Remove failed phases from state
- Allows re-execution of previously failed phases
- Use when root cause fixed manually
- Workflow will retry failed phases with clean slate

**Resume phases**:
- `phase-0-baseline` - Code quality baseline analysis
- `phase-1-planning` - Refactoring planning
- `phase-2-snapshot` - Behavioral snapshot capture
- `phase-3-execution` - Refactoring execution (with increments)
- `phase-4-verification` - Behavior verification
- `phase-5-quality` - Final quality verification

**Git checkpoint validation**:
When resuming Phase 3 or later:
- Validates checkpoint branches exist: `refactor/checkpoint-N-...`
- Confirms branches are on correct commits
- If branches missing: May restart from earlier increment

**Important notes**:
- Resume preserves execution mode (interactive/YOLO) from original start
- Can't change refactoring description during resume (set in Phase 0)
- If Phase 3 failed (test failure): User MUST fix before resuming
- If Phase 4 failed (behavior changed): User MUST fix before resuming
- If major changes needed, better to start new refactoring workflow

**Failure handling on resume**:

**If Phase 3 resume fails again**:
- Another test failure triggers rollback
- State saved with second failure
- User may need to reconsider refactoring approach

**If Phase 4 resume fails again**:
- Behavior still not preserved
- May indicate fundamental issue with refactoring
- User should consider rolling back entire refactoring

**Resume limitations**:
- Cannot resume if task directory deleted
- Cannot resume if git checkpoint branches deleted (for Phase 3+)
- Cannot resume if prerequisite phase outputs missing
- If critical files missing, must restart refactoring

**State reconstruction**:
If `orchestrator-state.yml` missing:

```
Reconstruction logic:
1. Check analysis/code-quality-baseline.md → Phase 0 complete
2. Check implementation/refactoring-plan.md → Phase 1 complete
3. Check analysis/behavioral-snapshot.md → Phase 2 complete
4. Check git branches (refactor/checkpoint-*) → Phase 3 progress
5. Check verification/behavior-verification-report.md → Phase 4 complete
6. Check verification/quality-improvement-report.md → Phase 5 complete

Resume from most recent complete phase + 1
```

**Example workflows**:

**After test failure**:
```bash
# Phase 3 failed, tests didn't pass
# Orchestrator rolled back and halted
# User fixes tests or code
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-task

# Resumes from failed increment
```

**After behavior verification failure**:
```bash
# Phase 4 detected behavior changes
# User investigates and fixes behavior
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-task

# Re-runs Phase 4 to verify behavior now preserved
```

**Restart specific phase**:
```bash
# Want to redo refactoring plan with different approach
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-task --from=phase-1-planning

# Phase 1 executes again, subsequent phases follow
```

**Invoke**: ai-sdlc:refactoring-orchestrator skill with resume mode
