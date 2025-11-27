---
name: ai-sdlc:enhancement:resume
description: Resume an interrupted or failed enhancement workflow from where it left off
category: Enhancement Workflows
---

# Enhancement Workflow: Resume

You are resuming an interrupted or failed enhancement development workflow. You will read workflow state and continue from the appropriate phase.

## Command

```bash
/ai-sdlc:enhancement:resume [task-path] [options]
```

## Arguments

### task-path (Optional)
Path to the task directory containing the enhancement workflow state.

**Examples:**
- `.ai-sdlc/tasks/enhancements/2025-10-27-add-sorting`
- `tasks/enhancements/2025-10-27-improve-performance`
- Relative or absolute paths accepted

If omitted, you'll be prompted to provide it or the most recent enhancement will be detected.

## Options

### --from=PHASE (Optional)
Override saved state and force start from a specific phase.

**Valid phases:**
- `analysis` - Existing feature analysis (Phase 0)
- `gap` - Gap analysis & impact assessment (Phase 1)
- `mockup` - UI Mockup generation (Phase 2, optional)
- `spec` - Specification (Phase 3)
- `plan` - Planning (Phase 4)
- `implement` - Implementation (Phase 5)
- `verify` - Verification + Compatibility (Phase 6)
- `e2e` - E2E Testing (Phase 7, optional)
- `user-docs` - User Documentation (Phase 8, optional)
- `finalize` - Finalization (Phase 9)

**Use when:** You want to re-run a specific phase or skip ahead

### --reset-attempts (Optional)
Reset auto-fix attempt counters to 0 for all phases.

**Use when:** You manually fixed issues and want to give auto-fix fresh attempts

**Example:**
```bash
# After manually fixing a bug, resume with fresh attempts
/ai-sdlc:enhancement:resume [path] --reset-attempts
```

### --clear-failures (Optional)
Remove failed phases from state history.

**Use when:** You manually fixed failure causes and want to proceed as if failures didn't occur

**Example:**
```bash
# After fixing underlying issues, clear failure history
/ai-sdlc:enhancement:resume [path] --clear-failures
```

## What You Are Doing

**Invoke the enhancement-orchestrator skill NOW in resume mode using the Skill tool.**

The skill will execute the following process:

### 1. Locate Task

```
└─ Find task directory
   ├─ Use provided path
   ├─ OR prompt user for path
   └─ OR auto-detect most recent enhancement
```

### 2. Load State

```
└─ Read orchestrator-state.yml
   ├─ Current phase
   ├─ Completed phases
   ├─ Failed phases
   ├─ Auto-fix attempts
   └─ Workflow options
```

### 3. Determine Resume Point

```
└─ If --from specified:
   └─ Use that phase
└─ Else if failures exist:
   └─ Resume from first failed phase
└─ Else:
   └─ Resume from current_phase in state
```

### 4. Validate Prerequisites

```
└─ Check required artifacts exist for resume phase
   ├─ Phase 0: None (always can start)
   ├─ Phase 1: existing-feature-analysis.md
   ├─ Phase 2: gap-analysis.md
   ├─ Phase 3: ui-mockups.md (optional)
   ├─ Phase 4: spec.md
   ├─ Phase 5: implementation-plan.md
   ├─ Phase 6: work-log.md
   ├─ Phase 7: implementation-verification.md
   └─ Phase 8: e2e-verification-report.md
```

### 5. Continue Workflow

```
└─ Resume from determined phase
   └─ Maintains mode (interactive/YOLO)
   └─ Preserves options (e2e_enabled, user_docs_enabled)
   └─ Updates state as phases complete
```

## Resume Scenarios

### Scenario 1: Computer Restarted

**Situation:** Workflow running, computer crashed or restarted

**State:**
```yaml
current_phase: implementation
completed_phases: [analysis, gap_analysis, specification, planning]
failed_phases: []
```

**Command:**
```bash
/ai-sdlc:enhancement:resume .ai-sdlc/tasks/enhancements/2025-10-27-add-sorting
```

**Result:** Continues from implementation phase

---

### Scenario 2: Phase Failed

**Situation:** Implementation phase failed after auto-fix attempts exhausted

**State:**
```yaml
current_phase: implementation
completed_phases: [analysis, gap_analysis, specification, planning]
failed_phases: [implementation]
auto_fix_attempts:
  implementation: 5  # Max reached
```

**Options:**

**Option A: Let orchestrator retry**
```bash
/ai-sdlc:enhancement:resume [path]
```
Result: Prompts user for help (auto-fix exhausted)

**Option B: Fix manually, then resume with fresh attempts**
```bash
# 1. Fix the issue manually (e.g., correct syntax error)
# 2. Resume with reset attempts
/ai-sdlc:enhancement:resume [path] --reset-attempts
```
Result: Retries implementation with fresh auto-fix attempts (0/5)

---

### Scenario 3: Want to Re-Run Phase

**Situation:** Verification phase passed, but you want to re-run it

**State:**
```yaml
current_phase: e2e_testing
completed_phases: [..., verification]
```

**Command:**
```bash
/ai-sdlc:enhancement:resume [path] --from=verify
```

**Result:** Re-runs verification phase, then continues to E2E

---

### Scenario 4: Skip Ahead

**Situation:** Manually completed some phases outside orchestrator, want to resume later

**State:**
```yaml
current_phase: specification
completed_phases: [analysis, gap_analysis]
```

**Command:**
```bash
# Skip spec and planning, go straight to implementation
/ai-sdlc:enhancement:resume [path] --from=implement
```

**Prerequisites Check:** Ensures `spec.md` and `implementation-plan.md` exist before allowing skip

---

### Scenario 5: Multiple Failures

**Situation:** Workflow failed at multiple phases

**State:**
```yaml
current_phase: verification
completed_phases: [analysis, gap_analysis, specification, planning, implementation]
failed_phases: [implementation, verification]
```

**Command:**
```bash
# Clear failure history after manual fixes
/ai-sdlc:enhancement:resume [path] --clear-failures
```

**Result:** Resumes from verification (current phase) as if no failures occurred

## State Reconstruction

If `orchestrator-state.yml` is missing or corrupted, the resume command can attempt to reconstruct state from existing artifacts.

**See**: `skills/enhancement-orchestrator/skill.md` for complete reconstruction logic and limitations.

## Options Combinations

### Common Patterns

```bash
# Simple resume (use saved state as-is)
/ai-sdlc:enhancement:resume [path]

# Re-run verification phase
/ai-sdlc:enhancement:resume [path] --from=verify

# After manual fixes (fresh attempts)
/ai-sdlc:enhancement:resume [path] --reset-attempts --clear-failures

# Force start from beginning (re-do entire workflow)
/ai-sdlc:enhancement:resume [path] --from=analysis --reset-attempts

# Skip to finalization (if implementation verified manually)
/ai-sdlc:enhancement:resume [path] --from=finalize
```

## Prerequisites

### Always Required
- Task directory exists
- Task directory contains enhancement workflow artifacts

### Phase-Specific Requirements

| Resume From | Required Artifacts |
|-------------|-------------------|
| **analysis** | None |
| **gap** | `planning/existing-feature-analysis.md` |
| **spec** | `planning/gap-analysis.md` |
| **plan** | `spec.md` |
| **implement** | `implementation-plan.md` |
| **verify** | `implementation/work-log.md` + all steps in plan marked complete |
| **e2e** | `verification/implementation-verification.md` (passed) |
| **user-docs** | `verification/e2e-verification-report.md` (passed) |
| **finalize** | All previous phases complete |

## Examples

### Example 1: Basic Resume After Restart

```bash
# Workflow was running, computer restarted
/ai-sdlc:enhancement:resume .ai-sdlc/tasks/enhancements/2025-10-27-add-sorting
```

**Output:**
```
📍 Resuming enhancement workflow...

Task: Add sorting to user table
Last active: 2025-10-27 14:30:00

✅ Completed phases:
  - Existing Feature Analysis
  - Gap Analysis & Impact Assessment
  - Specification
  - Planning

⏸️  Interrupted at: Implementation (Task Group 2 of 3)

Resuming from: Implementation - Task Group 2
Continue? (y/n):
```

---

### Example 2: Resume After Implementation Failure

```bash
# Implementation failed, fixed issue manually, resume with fresh attempts
/ai-sdlc:enhancement:resume [path] --reset-attempts
```

**Output:**
```
📍 Resuming enhancement workflow...

⚠️  Previous failures detected:
  - Implementation (attempt 5/5) - Syntax error in UserTable.tsx

Auto-fix attempts reset to 0/5

Resuming from: Implementation
Will retry with fresh attempts.

Continue? (y/n):
```

---

### Example 3: Re-Run Verification

```bash
# Verification passed but want to check again after changes
/ai-sdlc:enhancement:resume [path] --from=verify
```

**Output:**
```
📍 Resuming enhancement workflow...

✅ Verification was already completed (passed)

Overriding state to re-run verification phase.

This will:
  - Re-run implementation completeness check
  - Re-run targeted regression tests
  - Re-run full test suite
  - Re-generate verification report

Continue? (y/n):
```

---

### Example 4: Skip to E2E (Manual Implementation)

```bash
# Implemented manually, want to run E2E tests
/ai-sdlc:enhancement:resume [path] --from=e2e
```

**Output:**
```
📍 Resuming enhancement workflow...

⚠️  Prerequisites check:
  ✅ implementation-plan.md exists
  ✅ work-log.md exists
  ✅ implementation-verification.md exists

Skipping directly to E2E Testing phase.

Note: This assumes implementation and verification were completed successfully outside the orchestrator.

Continue? (y/n):
```

## Troubleshooting

### Problem: "Task not found"

**Cause:** Invalid or incorrect task path

**Solutions:**
1. Check path is correct
2. Use absolute path: `/Users/you/project/.ai-sdlc/tasks/enhancements/...`
3. Use relative path from project root: `.ai-sdlc/tasks/enhancements/...`
4. Omit path and let command prompt you

---

### Problem: "State file missing or corrupted"

**Cause:** `orchestrator-state.yml` doesn't exist or is invalid

**Solution:** Resume command will attempt state reconstruction:
```
⚠️  State file missing. Attempting reconstruction from artifacts...

Detected completed phases:
  ✅ Existing Feature Analysis
  ✅ Gap Analysis
  ✅ Specification
  ❌ Planning (incomplete)

Reconstructed state (confidence: medium)
Resume from: Planning

Is this correct? (y/n/manual):
```

---

### Problem: "Prerequisites not met"

**Cause:** Trying to resume from phase without required artifacts

**Solution:** Either:
- Resume from earlier phase: `--from=analysis`
- Create missing artifacts manually
- Start fresh workflow

**Example:**
```
❌ Cannot resume from implementation phase

Missing prerequisites:
  - implementation-plan.md not found

Options:
  1. Resume from planning phase (will create implementation-plan.md)
  2. Start from beginning (--from=analysis)
  3. Create implementation-plan.md manually and retry

Your choice:
```

---

### Problem: "Failed phase cannot auto-recover"

**Cause:** Auto-fix attempts exhausted for a phase

**Solution:** Manually fix the issue, then:
```bash
/ai-sdlc:enhancement:resume [path] --reset-attempts --clear-failures
```

This gives auto-fix fresh attempts after your manual fixes.

## Best Practices

### Do's

✅ **Resume promptly** - Don't leave workflows interrupted too long
✅ **Check state first** - Review what phase you're resuming from
✅ **Use --reset-attempts** - After manually fixing issues
✅ **Verify artifacts exist** - Before skipping phases with --from
✅ **Keep state file** - Don't delete orchestrator-state.yml

### Don'ts

❌ **Don't skip phases without artifacts** - Prerequisites will fail
❌ **Don't resume with stale changes** - Pull latest code first
❌ **Don't clear failures prematurely** - Only after fixing issues
❌ **Don't ignore warnings** - Review state discrepancies carefully
❌ **Don't modify state manually** - Use commands to manipulate state

## State File Format

**See**: `skills/enhancement-orchestrator/skill.md` for complete state file format including all fields and their meanings.

## Related Commands

- `/ai-sdlc:enhancement:new` - Start new enhancement workflow
- `/init-sdlc` - Initialize AI SDLC framework

**Note**: E2E tests and user docs are handled automatically by the orchestrator. Use `--from=PHASE` to restart from a specific phase if needed.

## See Also

- **Enhancement Orchestrator Skill:** `skills/enhancement-orchestrator/SKILL.md`
- **State Management Reference:** `skills/enhancement-orchestrator/references/state-management.md`

---

*This command resumes the enhancement-orchestrator skill workflow.*
