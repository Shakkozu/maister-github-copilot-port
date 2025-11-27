---
name: feature:resume
description: Resume an interrupted or failed feature development workflow from where it left off
---

# Resume Feature Development Workflow

You are resuming a feature development workflow that was interrupted, failed, or paused. The orchestrator will read the saved state and continue from the appropriate phase.

## Command Usage

```bash
/ai-sdlc:feature:resume [task-path] [options]
```

### Arguments

- **task-path** (optional): Path to the task directory
  - If omitted, you'll be prompted to provide the path
  - Example: `.ai-sdlc/tasks/new-features/2025-10-26-user-authentication`

### Options

- `--from=PHASE`: Override state and force start from specific phase
  - Values: `spec`, `plan`, `implement`, `verify`, `e2e`, `docs`
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
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-shopping-cart
```

Behavior:
1. Reads `orchestrator-state.yml` from task directory
2. Checks `completed_phases` to see what's done
3. Determines next phase to execute
4. Validates prerequisites
5. Continues workflow from that phase

### Example 2: Resume from Specific Phase

```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-user-auth --from=verify
```

Behavior:
- Ignores state file's current_phase
- Forces start from verification phase
- Validates prerequisites (implementation must be complete)
- Useful for re-running verification after manual fixes

### Example 3: Resume After Manual Fixes (Reset State)

```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-payment --reset-attempts --clear-failures
```

Behavior:
- Clears failed_phases history
- Resets all auto_fix_attempts to 0
- Gives orchestrator fresh attempts at auto-recovery
- Useful after fixing underlying issues manually

## What You Are Doing

**Invoke the feature-orchestrator skill NOW in resume mode using the Skill tool.**

The skill will execute the following steps:

### Step 1: Locate and Validate Task

1. **Check task path exists**
   ```
   If task path doesn't exist:
   ❌ Task not found: [path]

   Please provide valid task path.
   Example: .ai-sdlc/tasks/new-features/2025-10-26-feature-name
   ```

2. **Check state file exists**
   ```
   If orchestrator-state.yml not found:
   ⚠️ No state file found

   Task exists but has no orchestrator state.

   Options:
   1. Start new workflow for this task: /ai-sdlc:feature:new --from=spec
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

If phase in completed_phases:
  → Skip to next phase

If phase is current_phase:
  → Resume from current phase

Otherwise:
  → Continue to next incomplete phase
```

### Step 4: Handle Failures

If resuming from failed phase:

```
📋 Resuming from Failed Phase

Phase: [phase-name]
Previous attempts: [N]
Last error: [error message]

Options:
1. Retry with auto-fix (attempts left: [max - current])
2. Assume manually fixed, continue
3. Restart phase from beginning (reset attempts)
4. Skip phase and continue (NOT RECOMMENDED)
5. Abort resume

Which option? [1-5]: _
```

### Step 5: Validate Prerequisites

Before resuming:

**For spec phase** (no prerequisites):
```
✅ Ready to start specification
```

**For planning phase**:
```
Checking prerequisites...
✅ spec.md found
✅ Ready to start planning
```

**For implementation phase**:
```
Checking prerequisites...
✅ spec.md found
✅ implementation-plan.md found
✅ Ready to start implementation
```

**For verification phase**:
```
Checking prerequisites...
✅ spec.md found
✅ implementation-plan.md found
✅ implementation/work-log.md found

Checking implementation completion...
✅ 18/18 steps complete in implementation-plan.md
✅ Ready to start verification
```

**For E2E testing phase**:
```
Checking prerequisites...
✅ spec.md found
✅ Implementation complete
✅ Verification complete

Checking application...
⚠️ Application not running
Start application at [URL] and press Enter to continue...
```

If prerequisites missing:
```
❌ Prerequisites Missing

Cannot resume from [phase-name]:
- [Prerequisite 1]: ❌ Missing
- [Prerequisite 2]: ❌ Found

Options:
1. Start from earlier phase to create missing files
2. Create missing files manually
3. Change resume point with --from

What would you like to do? [1-3]: _
```

### Step 6: Continue Workflow

Once validated:

```
🚀 Resuming Feature Workflow

Task: [feature name from metadata.yml]
Location: [task-path]
Mode: [interactive/yolo from state]

Workflow Status:
✅ Specification - Complete
✅ Planning - Complete
🔄 Implementation - Resuming from here
⏳ Verification - Pending
⏳ E2E Testing - Pending
⏳ User Documentation - Pending

State file: orchestrator-state.yml

[If interactive mode]
You'll be prompted for review after each phase.

[If YOLO mode]
All remaining phases will run continuously.

Resuming...
```

Then continues with normal orchestration from the resume point.

## Resume Scenarios

### Scenario 1: Computer Crashed During Implementation

**State Before**:
```yaml
current_phase: implementation
completed_phases:
  - specification
  - planning
auto_fix_attempts:
  implementation: 1
```

**Resume Command**:
```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-feature
```

**Behavior**:
- Resumes implementation phase
- Checks what steps are complete in implementation-plan.md
- Continues from first incomplete step
- Preserves auto-fix attempt count (1)
- Continues to subsequent phases after implementation

### Scenario 2: Implementation Failed, Fixed Manually

**State Before**:
```yaml
current_phase: implementation
failed_phases:
  - phase: implementation
    attempts: 5
    error: "Cannot import 'user_service'"
auto_fix_attempts:
  implementation: 5
```

**Manual Fix**:
```python
# Fixed the import issue in user_service.py
# All tests now passing
```

**Resume Command**:
```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-auth --clear-failures --from=verify
```

**Behavior**:
- Clears implementation from failed_phases
- Starts from verification (skips re-running implementation)
- Validates implementation is actually complete
- Continues to verification and beyond

### Scenario 3: Want to Re-run Verification After Manual Changes

**State Before**:
```yaml
completed_phases:
  - specification
  - planning
  - implementation
  - verification
```

**Manual Changes**:
```
# Made some improvements to implementation
# Want to re-verify everything
```

**Resume Command**:
```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-feature --from=verify
```

**Behavior**:
- Forces restart of verification phase
- Re-runs full test suite
- Re-checks standards compliance
- Creates updated verification report

### Scenario 4: Workflow Paused in Interactive Mode

**State Before**:
```yaml
current_phase: verification
completed_phases:
  - specification
  - planning
  - implementation
```

**Resume Command**:
```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-feature
```

**Behavior**:
- Starts from verification phase (current_phase)
- Checks prerequisites are still valid
- Continues in interactive mode
- Pauses after verification for review

### Scenario 5: Exceeded Max Attempts, Need Fresh Tries

**State Before**:
```yaml
current_phase: implementation
failed_phases:
  - phase: implementation
    attempts: 5
auto_fix_attempts:
  implementation: 5
```

**Resume Command**:
```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-feature --reset-attempts --clear-failures
```

**Behavior**:
- Resets auto_fix_attempts.implementation to 0
- Clears failed_phases array
- Gives orchestrator fresh 5 attempts at auto-fix
- Useful if underlying issue was fixed (dependencies updated, etc.)

## State Reconstruction

If state file is lost, attempts reconstruction from existing artifacts:
- Analyzes task directory for completed phases
- Creates new state file based on evidence
- Best-effort reconstruction (may not be 100% accurate)

**See**: `skills/feature-orchestrator/skill.md` for reconstruction algorithm and limitations.

## Troubleshooting

### State file corrupted
```bash
# Attempt reconstruction
/ai-sdlc:feature:resume [path]
# Choose option 2 when prompted

# Or manually recreate state file using template from state-management.md
```

### Want to change execution mode (interactive ↔ yolo)
```bash
# Edit orchestrator-state.yml
# Change: mode: interactive
# To: mode: yolo
# Or vice versa

# Then resume
/ai-sdlc:feature:resume [path]
```

### Phase stuck, want to skip it
```bash
# Edit orchestrator-state.yml
# Add phase to completed_phases array
completed_phases:
  - specification
  - planning
  - implementation  # Add manually to skip

# Then resume from next phase
/ai-sdlc:feature:resume [path]
```

### Multiple failures, need clean slate
```bash
# Reset everything
/ai-sdlc:feature:resume [path] --reset-attempts --clear-failures --from=spec

# Or delete state file and start fresh
rm [path]/orchestrator-state.yml
/ai-sdlc:feature:new --from=spec
```

## Related Commands

- `/ai-sdlc:feature:new [description]` - Start new feature workflow

**Note**: Individual phases are handled automatically by the orchestrator. Use `--from=PHASE` to restart from a specific phase if needed.

## Tips

### Before Resuming
1. Check what failed: `cat [path]/orchestrator-state.yml`
2. Review failure error messages
3. Fix underlying issues if known
4. Consider if fresh auto-fix attempts needed

### After Manual Fixes
- Use `--clear-failures` to remove failure history
- Use `--reset-attempts` to give auto-fix fresh tries
- Start from specific phase with `--from` if appropriate

### For Long-Running Workflows
- Resume frequently if interrupted
- State saves progress automatically
- No work is lost, can always resume

### For Debugging
- Review state file for detailed status
- Check completed_phases for progress
- Check failed_phases for error history
- Check auto_fix_attempts for retry info

---

Invoke the **feature-orchestrator** skill in resume mode to continue your feature development workflow from where it left off, with intelligent state management and recovery capabilities.
