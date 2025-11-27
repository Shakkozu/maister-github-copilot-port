---
name: bug-fix:resume
description: Resume an interrupted or failed bug fix workflow from where it left off
category: Bug Fix Workflows
---

# Resume Bug Fix Workflow

You are resuming a bug fix workflow that was interrupted, failed, or paused. The orchestrator will read the saved state and continue from the appropriate phase.

## Command Usage

```bash
/ai-sdlc:bug-fix:resume [task-path] [options]
```

### Arguments

- **task-path** (optional): Path to the bug fix task directory
  - If omitted, you'll be prompted to provide the path
  - Example: `.ai-sdlc/tasks/bug-fixes/2025-10-27-fix-login-timeout`

### Options

- `--from=PHASE`: Override state and force start from specific phase
  - Values: `analysis`, `implementation`, `testing`, `documentation`
  - Default: Continue from state file's next phase
  - Use when: Want to restart a specific phase

- `--reset-attempts`: Reset auto-fix attempt counters
  - Default: Preserve current attempt counts
  - Use when: Want to give auto-fix another full set of attempts

- `--clear-failures`: Remove failed_phases from state
  - Default: Preserve failure history
  - Use when: Fixed issues manually and want clean retry

## Examples

### Example 1: Simple Resume (Use State)

```bash
/ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-27-fix-login-timeout
```

Behavior:
1. Reads `orchestrator-state.yml` from task directory
2. Checks `completed_phases` to see what's done
3. Determines next phase to execute
4. Validates prerequisites
5. Continues workflow from that phase

### Example 2: Resume from Specific Phase

```bash
/ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-27-null-pointer --from=testing
```

Behavior:
- Ignores state file's current_phase
- Forces start from testing phase
- Validates prerequisites (fix must be implemented)
- Useful for re-running tests after manual fixes

### Example 3: Resume After Manual Fixes (Reset State)

```bash
/ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-27-timeout-issue --reset-attempts --clear-failures
```

Behavior:
- Clears failed_phases history
- Resets all auto_fix_attempts to 0
- Gives orchestrator fresh attempts at auto-recovery
- Useful after fixing underlying issues manually

## What You Are Doing

**Invoke the bug-fix-orchestrator skill NOW in resume mode using the Skill tool.**

The skill will execute the following steps:

### Step 1: Locate and Validate Task

1. **Check task path exists**
   ```
   If task path doesn't exist:
   ❌ Task not found: [path]

   Please provide valid task path.
   Example: .ai-sdlc/tasks/bug-fixes/2025-10-27-bug-name
   ```

2. **Check state file exists**
   ```
   If orchestrator-state.yml not found:
   ⚠️ No state file found

   Task exists but has no orchestrator state.

   Options:
   1. Start new workflow for this task: /ai-sdlc:bug-fix:new
   2. Reconstruct state from artifacts (experimental)
   3. Manually create orchestrator-state.yml

   Which option? [1-3]: _
   ```

### Step 2: Read and Validate State

1. **Load state file**
   - Read `orchestrator-state.yml`
   - Parse YAML structure
   - Validate required fields

2. **Check state consistency**
   ```
   Validating state...
   ✅ State structure valid
   ✅ Phase names valid
   ✅ TDD gates tracked
   ✅ No inconsistencies detected
   ```

   If issues found:
   ```
   ⚠️ State validation warnings:
   - [Warning 1]
   - [Warning 2]

   Continue anyway? [Y/n]: _
   ```

### Step 3: Determine Resume Point

Based on state and options:

**If `--from` option provided**:
- Use specified phase as starting point
- Validate prerequisites for that phase
- Override state file's current_phase

**If no `--from` option**:
1. Check `completed_phases` array
2. Determine next incomplete phase
3. Check for phases in `failed_phases`
4. Decide resume point

**Decision logic**:
```
If phase in failed_phases and --clear-failures not set:
  → Prompt user to fix or retry

If TDD Red gate not validated:
  → MUST return to implementation phase
  → Cannot proceed without test failure validation

If TDD Green gate not validated:
  → Must validate fix passes test before testing phase

If completed_phases = [analysis, implementation, testing]:
  → Resume from documentation phase

If completed_phases = [analysis]:
  → Resume from implementation phase
```

**TDD Gate Validation** (Critical):
```
If bug_context.tdd_red_validated == false:
  ⚠️ TDD Red Phase Not Validated

  Test must FAIL before implementing fix.
  Returning to implementation phase to validate test failure.

If bug_context.tdd_green_validated == false and fix implemented:
  ⚠️ TDD Green Phase Not Validated

  Test must PASS after implementing fix.
  Will validate during testing phase.
```

### Step 4: Validate Prerequisites

For each phase, check required artifacts exist:

**Analysis → Implementation**:
- ✅ `planning/bug-analysis/bug-report.md`
- ✅ `planning/bug-analysis/reproduction-data.md` (critical)
- ✅ `planning/bug-analysis/root-cause-analysis.md`

**Implementation → Testing**:
- ✅ Fix code changes applied
- ✅ `implementation/regression-tests/test-failure-log.md`
- ✅ TDD Red phase validated (test failed before fix)
- ✅ TDD Green phase validated (test passes after fix)

**Testing → Documentation**:
- ✅ Full test suite passing (or >90% with documented failures)
- ✅ `verification/fix-verification.md`

If prerequisites missing:
```
❌ Prerequisites Missing for [phase]

Required but missing:
- [file1]: ❌ Not found
- [file2]: ❌ Not found

Options:
1. Start from earlier phase that creates these
2. Create missing files manually
3. Abort resume

Which option? [1-3]: _
```

### Step 5: Apply State Modifications (if requested)

**If `--reset-attempts`**:
```
Resetting auto-fix attempt counters...
- analysis: 2 → 0
- implementation: 3 → 0
- testing: 1 → 0
- documentation: 0 → 0
✅ All attempts reset
```

**If `--clear-failures`**:
```
Clearing failed phases...
- Removed: implementation (failed 3 times)
- Removed: testing (failed 1 time)
✅ Failure history cleared
```

### Step 6: Continue Workflow

```
📂 Resuming Bug Fix Workflow

Bug: [bug description]
Last phase: [phase name] ([status])
Completed: [list of completed phases]
Resume from: [next phase name]

Mode: [Interactive/YOLO]
State file: [path]/orchestrator-state.yml

[If failed phases exist and not cleared]
⚠️ Previous Failures:
- [Phase]: Failed after [N] attempts
  Error: [error message]

Press Enter to continue from [phase]...
```

Then executes remaining phases using normal orchestrator workflow.

## Use Cases

### Use Case 1: Computer Restarted Mid-Fix

```bash
# Workflow was running, computer restarted
/ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-27-timeout
```

Orchestrator reads state, sees analysis complete, resumes from implementation.

### Use Case 2: Auto-Fix Exhausted, Manual Fix Applied

```bash
# Fix failed after 3 auto-fix attempts
# You manually fixed the code issue
/ai-sdlc:bug-fix:resume [task-path] --reset-attempts --clear-failures
```

Orchestrator retries from failed phase with fresh attempts.

### Use Case 3: Want to Re-Run Tests

```bash
# Tests ran but want to run again after tweaks
/ai-sdlc:bug-fix:resume [task-path] --from=testing
```

Orchestrator skips to testing phase, re-runs all tests.

### Use Case 4: TDD Red Validation Failed

```bash
# Test passed before fix (should have failed)
# You corrected the test
/ai-sdlc:bug-fix:resume [task-path] --from=implementation
```

Orchestrator re-validates TDD Red phase (test must fail before fix).

## Common Scenarios

### Scenario: "Phase keeps failing"

**Problem**: Implementation fails after 3 attempts

**Solution**:
```bash
# 1. Check state for error details
cat [task-path]/orchestrator-state.yml

# 2. Fix the issue manually in code

# 3. Resume with reset attempts
/ai-sdlc:bug-fix:resume [task-path] --reset-attempts --clear-failures
```

### Scenario: "Want to restart a phase"

**Problem**: Documentation phase complete but want to redo it

**Solution**:
```bash
# Option 1: Force restart from that phase
/ai-sdlc:bug-fix:resume [task-path] --from=documentation

# Option 2: Edit state file, remove from completed_phases
# Edit: orchestrator-state.yml
# Remove "documentation" from completed_phases array
/ai-sdlc:bug-fix:resume [task-path]
```

### Scenario: "TDD gate not validated"

**Problem**: Bug context shows `tdd_red_validated: false`

**Solution**:
```bash
# Orchestrator will automatically return to implementation
# to validate test fails before implementing fix
/ai-sdlc:bug-fix:resume [task-path]

# It will:
# 1. Read reproduction-data.md
# 2. Run regression test
# 3. VALIDATE test FAILS (Red phase)
# 4. Only then proceed to implement fix
```

### Scenario: "Prerequisites missing"

**Problem**: Trying to resume from testing but fix not implemented

**Solution**:
```bash
# Option 1: Let orchestrator start from earlier phase
/ai-sdlc:bug-fix:resume [task-path] --from=implementation

# Option 2: Implement fix manually, then resume
# [Implement fix in code]
/ai-sdlc:bug-fix:resume [task-path] --from=testing
```

## State Reconstruction (Experimental)

If `orchestrator-state.yml` is lost but artifacts exist:

```
Attempting state reconstruction...

Scanning task directory...
✅ Found: planning/bug-analysis/root-cause-analysis.md
✅ Found: implementation/work-log.md
✅ Found: verification/fix-verification.md

Reconstructed state:
- Completed: analysis, implementation, testing
- Next phase: documentation

⚠️ Warning: Reconstruction is best-effort
- TDD gate validation status unknown (assuming passed)
- Auto-fix attempts unknown (reset to 0)
- Failure history lost

Create reconstructed state file? [Y/n]: _
```

**Limitations**:
- Cannot restore auto-fix attempt counts
- Cannot restore failure history
- TDD gate validation status assumed based on files
- May not be 100% accurate

**Recommendation**: Always preserve `orchestrator-state.yml`

## Tips

### For Safe Resume
- Always check state file before resuming
- Use `--from` to explicitly control resume point
- Verify TDD gates are properly validated

### For After Manual Fixes
- Use `--reset-attempts --clear-failures`
- Gives orchestrator fresh attempts at auto-recovery
- Clears old failure history

### For Re-Running Specific Phase
- Use `--from=PHASE`
- Validates prerequisites first
- Useful for testing changes

### For TDD Discipline
- Never skip TDD Red validation
- If `tdd_red_validated: false`, orchestrator forces re-validation
- Test MUST fail before fix is implemented

## Troubleshooting

### State file corrupted
**Solution**: Manually edit or delete and use reconstruction
```bash
# Option 1: Fix YAML syntax
vim [task-path]/orchestrator-state.yml

# Option 2: Delete and reconstruct
rm [task-path]/orchestrator-state.yml
/ai-sdlc:bug-fix:resume [task-path]
# Choose reconstruction option
```

### Can't determine resume point
**Solution**: Use `--from` to explicitly specify
```bash
/ai-sdlc:bug-fix:resume [task-path] --from=implementation
```

### TDD gates blocking progress
**Solution**: Proper validation required (cannot skip)
```bash
# If test didn't fail before fix, must re-validate
/ai-sdlc:bug-fix:resume [task-path] --from=implementation

# Orchestrator will:
# 1. Run test to confirm it FAILS (Red phase)
# 2. Only then allow fix implementation
# 3. Verify test PASSES after fix (Green phase)
```

## Related Commands

- `/ai-sdlc:bug-fix:new [description]` - Start new bug fix workflow

**Note**: Individual phases are handled automatically by the orchestrator. Use `--from=PHASE` to restart from a specific phase if needed.

---

Invoke the **bug-fix-orchestrator** skill in resume mode to continue the bug fix workflow from where it left off, with full state management and prerequisite validation.
