---
name: migration:resume
description: Resume an interrupted or failed migration workflow from where it left off
---

# Resume Migration Workflow

You are resuming a migration workflow that was interrupted, failed, or paused. The orchestrator will read the saved state and continue from the appropriate phase.

## Command Usage

```bash
/ai-sdlc:migration:resume [task-path] [options]
```

### Arguments

- **task-path** (optional): Path to the task directory
  - If omitted, attempts to auto-detect from current directory
  - Example: `.ai-sdlc/tasks/migrations/2025-10-30-react-upgrade`

### Options

- `--from=PHASE`: Override state and force start from specific phase
  - Values: `analysis`, `target`, `spec`, `plan`, `execute`, `verify`, `docs`
  - Default: Continue from state file's current_phase
  - Use when: Want to restart a specific phase

- `--reset-attempts`: Reset auto-fix attempt counters to 0
  - Default: Preserve current attempt counts
  - Use when: Want to give auto-fix another full set of attempts

- `--clear-failures`: Remove failed_phases from state history
  - Default: Preserve failure history
  - Use when: Fixed issues manually and want clean retry

## Examples

### Example 1: Simple Resume (Use State)

```bash
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-react-upgrade
```

Behavior:
1. Reads `orchestrator-state.yml` from task directory
2. Checks `completed_phases` to see what's done
3. Validates migration-specific fields (migration_type, strategy)
4. Determines next phase to execute
5. Validates prerequisites
6. Continues workflow from that phase

### Example 2: Resume from Specific Phase

```bash
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-db-migration --from=verify
```

Behavior:
- Ignores state file's current_phase
- Forces start from verification phase
- Validates prerequisites (execution must be complete)
- Useful for re-running verification after manual fixes
- Particularly useful for data migrations to re-check data integrity

### Example 3: Resume After Manual Fixes (Reset State)

```bash
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-api-refactor --reset-attempts --clear-failures
```

Behavior:
- Clears failed_phases history
- Resets all auto_fix_attempts to 0
- Gives orchestrator fresh attempts at auto-recovery
- Useful after fixing underlying issues manually (syntax errors, missing dependencies, test failures)

## What You Are Doing

**Invoke the migration-orchestrator skill NOW in resume mode using the Skill tool.**

The skill will execute the following steps:

### Step 1: Locate and Validate Task

1. **Check task path exists**
   ```
   If task path doesn't exist:
   ❌ Migration task not found: [path]

   Please provide valid task path.
   Example: .ai-sdlc/tasks/migrations/2025-10-30-migration-name
   ```

2. **Check state file exists**
   ```
   If orchestrator-state.yml not found:
   ⚠️ No state file found

   Migration task exists but has no orchestrator state.

   Options:
   1. Start new workflow: /ai-sdlc:migration:new --from=analysis
   2. Reconstruct state from artifacts (experimental)
   3. Manually create orchestrator-state.yml

   Which option? [1-3]: _
   ```

### Step 2: Read and Validate State

1. **Load state file**
   - Read `orchestrator-state.yml`
   - Parse YAML structure
   - Validate required fields

2. **Validate migration-specific fields**
   ```
   Validating migration state...
   ✅ State structure valid
   ✅ Phase names valid (analysis/target/spec/plan/execute/verify/docs)
   ✅ migration_type field present: code
   ✅ current_system documented
   ✅ target_system documented
   ✅ migration_strategy selected: incremental
   ✅ No inconsistencies detected
   ```

   If issues found:
   ```
   ⚠️ State validation warnings:
   - migration_type missing (will prompt user)
   - migration_strategy not set (will select default)

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

If current_phase is "analysis":
  → Resume from current system analysis

If current_phase is "target":
  → Resume from target system planning (analysis prerequisite checked)

If current_phase is "spec":
  → Resume from specification (analysis + target prerequisites checked)

If current_phase is "execute":
  → Resume from migration execution (plan prerequisite checked)

(Similar logic for all 7 phases)
```

### Step 4: Handle Failures

If `failed_phases` present and `--clear-failures` not set:

```
⚠️ Previous failures detected:
- Phase: execute
- Error: Syntax errors in migrated code
- Attempts: 5/5 (max exceeded)

Options:
1. Retry phase with fresh attempts (--reset-attempts)
2. Assume fixed manually, clear failures (--clear-failures)
3. Skip to next phase (--from=verify)
4. Stop and review logs

Your choice [1-4]: _
```

### Step 5: Validate Prerequisites

**For analysis phase**: No prerequisites

**For target phase**:
- ✅ Current system analysis complete
- ✅ planning/current-system-analysis.md exists

**For spec phase**:
- ✅ Current system analysis complete
- ✅ Target system planning complete
- ✅ planning/target-system-plan.md exists
- ✅ migration_type determined
- ✅ migration_strategy selected

**For plan phase**:
- ✅ Specification complete
- ✅ spec.md exists and verified

**For execute phase**:
- ✅ Implementation plan complete
- ✅ implementation-plan.md exists

**For verify phase**:
- ✅ Migration execution complete
- ✅ All implementation steps marked complete
- ✅ implementation/work-log.md exists

**For docs phase**:
- ✅ Verification complete
- ✅ verification/implementation-verification.md exists
- ✅ Overall status: Passed or Passed with Issues

Example validation output:
```
Validating prerequisites for "execute" phase...
✅ Specification exists: spec.md
✅ Implementation plan exists: implementation-plan.md
✅ Migration type: code (React 16 → 18)
✅ Migration strategy: incremental
✅ Rollback plan documented

All prerequisites satisfied. Ready to resume.
```

### Step 6: Continue Workflow

Resume orchestrator from determined phase:

```
🔄 Resuming Migration Workflow

Task: Migrate from React 16 to React 18
Type: Code Migration
Strategy: Incremental + Rollback
Resume Point: Phase 4 (Migration Execution)

Resuming in 3... 2... 1...

[Phase 4 execution begins...]
```

## Resume Scenarios

### Scenario 1: Computer Crashed During Execution

**Context**: Computer restarted while executing migration, workflow interrupted

**State Before**:
```yaml
current_phase: execute
completed_phases: [analysis, target, spec, plan]
failed_phases: []
```

**Resume Command**:
```bash
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-react-upgrade
```

**Result**: Continues from execute phase, no retry needed

---

### Scenario 2: Execution Failed, Fixed Manually

**Context**: Migration execution failed with syntax errors, you fixed them manually

**State Before**:
```yaml
current_phase: execute
completed_phases: [analysis, target, spec, plan]
failed_phases: [execute]
auto_fix_attempts:
  execution: 5  # Max exceeded
```

**Resume Command**:
```bash
# Reset attempts and clear failures
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-api-migration --reset-attempts --clear-failures
```

**Result**: Retries execute phase with fresh auto-fix attempts (0/5)

---

### Scenario 3: Re-run Verification After Manual Changes

**Context**: Verification found issues, you fixed them, want to re-verify

**Resume Command**:
```bash
# Force restart verification phase
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-db-migration --from=verify
```

**Result**: Skips completed phases, re-runs verification from scratch

**Critical for Data Migrations**: Re-running verification after data integrity fixes

---

### Scenario 4: Exceeded Max Attempts

**Context**: Auto-fix exceeded max attempts (5/5), manual intervention needed

**State Before**:
```yaml
current_phase: execute
failed_phases: [execute]
auto_fix_attempts:
  execution: 5  # Max
```

**Manual Steps**:
1. Review error logs in implementation/work-log.md
2. Fix underlying issues (install dependencies, fix config)
3. Test fixes manually

**Resume Command**:
```bash
# Reset attempts to give auto-fix fresh tries
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-migration --reset-attempts --clear-failures
```

**Result**: Orchestrator retries with 0/5 attempts

---

### Scenario 5: Want to Change Migration Strategy

**Context**: Started with incremental, want to switch to dual-run

**Manual Steps**:
1. Edit orchestrator-state.yml:
   ```yaml
   migration_strategy: dual-run  # Changed from incremental
   dual_run_configured: false    # Needs configuration
   ```
2. Update planning/target-system-plan.md with dual-run details

**Resume Command**:
```bash
# Resume from execute to apply new strategy
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-db-migration --from=execute
```

**Result**: Execution phase uses dual-run strategy instead

---

### Scenario 6: Data Integrity Failure (Data Migration)

**Context**: Data migration failed verification with data integrity issues

**State Before**:
```yaml
current_phase: verify
failed_phases: [verify]
migration_type: data
```

**Error Output**:
```
🚨 CRITICAL: Data integrity check failed
Row count mismatch: Source=10000, Target=9987

❌ HALTING MIGRATION
Data migrations cannot be auto-fixed (data loss risk).
```

**Manual Steps**:
1. Investigate missing 13 rows
2. Fix data synchronization/transformation
3. Re-run data validation manually
4. Verify 100% row count match

**Resume Command**:
```bash
# After fixing, re-run verification with fresh attempts
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-30-db-migration --from=verify --reset-attempts
```

**Result**: Verification re-runs with fresh attempts, checks data integrity again

## State Reconstruction (Experimental)

If state file is lost or corrupted, the orchestrator can attempt to reconstruct state from existing artifacts.

**Reconstruction Logic**:

1. Check `planning/current-system-analysis.md` → Analysis complete
2. Check `planning/target-system-plan.md` → Target planning complete
3. Check `spec.md` → Specification complete
4. Check `implementation-plan.md` → Planning complete
5. Check `implementation/work-log.md` + all steps marked `[x]` → Execution complete
6. Check `verification/implementation-verification.md` → Verification complete
7. Check `documentation/migration-guide.md` → Documentation complete

**Migration-Specific Reconstruction Limitations**:
- ⚠️ Cannot reconstruct `migration_type` (will prompt user)
- ⚠️ Cannot reconstruct `migration_strategy` (will prompt user)
- ⚠️ Cannot reconstruct `current_system` details (reads from analysis doc if exists)
- ⚠️ Cannot reconstruct `target_system` details (reads from target plan if exists)
- ⚠️ Auto-fix attempt counters reset to 0

**Example Reconstruction**:
```
⚠️ State file missing, attempting reconstruction...

Detected completed phases:
✅ Phase 0: Current System Analysis (found current-system-analysis.md)
✅ Phase 1: Target System Planning (found target-system-plan.md)
✅ Phase 2: Specification (found spec.md)
✅ Phase 3: Planning (found implementation-plan.md)
✅ Phase 4: Execution (work-log.md shows all steps complete)
❓ Phase 5: Verification (no verification report found)

Migration type not found. Please specify:
1. Code migration
2. Data migration
3. Architecture migration
4. General migration

Your choice [1-4]: 1

Migration strategy not found. Please specify:
1. Incremental
2. Rollback planning
3. Dual-run
4. Combined (incremental + rollback)

Your choice [1-4]: 4

✅ State reconstructed successfully
Resume point: Phase 5 (Verification)

Continue? [Y/n]: _
```

## Troubleshooting

### State file corrupted

**Problem**: YAML parsing errors

**Solution**:
```bash
# Validate YAML syntax
cat .ai-sdlc/tasks/migrations/[dated-name]/orchestrator-state.yml | python -m yaml

# Or use state reconstruction
/ai-sdlc:migration:resume [path]  # Choose option 2: Reconstruct
```

### Want to change migration strategy

**Problem**: Started with wrong strategy, need to switch

**Solution**:
```bash
# Edit state file
vim .ai-sdlc/tasks/migrations/[dated-name]/orchestrator-state.yml

# Change strategy
migration_strategy: dual-run  # Changed from incremental

# Resume from execute to apply new strategy
/ai-sdlc:migration:resume [path] --from=execute
```

### Want to change migration type

**Problem**: Type detected incorrectly (e.g., detected as code, actually data)

**Solution**:
```bash
# Edit state file
vim .ai-sdlc/tasks/migrations/[dated-name]/orchestrator-state.yml

# Change type
migration_type: data  # Changed from code

# Resume from analysis (type affects all phases)
/ai-sdlc:migration:resume [path] --from=analysis
```

### Phase stuck, want to skip

**Problem**: Phase repeatedly failing, want to skip to next

**Solution**:
```bash
# Mark current phase as complete in state file
vim orchestrator-state.yml
# Add current phase to completed_phases
# Remove from failed_phases

# Or force start from next phase
/ai-sdlc:migration:resume [path] --from=[next-phase] --clear-failures
```

**Warning**: Skipping phases may cause issues in downstream phases. Only skip if you completed the work manually.

### Data integrity keeps failing

**Problem**: Data migration verification fails repeatedly with data issues

**Solution**:
```bash
# DO NOT use --reset-attempts blindly
# This is a CRITICAL issue requiring manual investigation

# Steps:
# 1. Check verification report for specific data issues
cat verification/implementation-verification.md

# 2. Investigate root cause (synchronization, transformation, missing data)

# 3. Fix data pipeline/transformation logic

# 4. Run data validation manually outside orchestrator
npm run validate-data-migration

# 5. Only after 100% data integrity confirmed, resume
/ai-sdlc:migration:resume [path] --from=verify --reset-attempts
```

**Critical**: Never skip data integrity failures. Data loss is unrecoverable.

## Related Commands

- `/ai-sdlc:migration:new [description]` - Start new migration workflow

**Note**: Individual phases are handled automatically by the orchestrator. Use `--from=PHASE` to restart from a specific phase if needed.

## Tips

### Before Resuming

Check state file to understand current status:
```bash
# View state
cat .ai-sdlc/tasks/migrations/[dated-name]/orchestrator-state.yml

# Check migration type and strategy
grep "migration_type" orchestrator-state.yml
grep "migration_strategy" orchestrator-state.yml

# Check completed phases
grep "completed_phases" orchestrator-state.yml

# Check failed phases
grep "failed_phases" orchestrator-state.yml
```

Review key fields:
- `migration_type`: code | data | architecture | general
- `current_system`: Source technology
- `target_system`: Target technology
- `migration_strategy`: incremental | rollback | dual-run
- `risk_level`: low | medium | high

### After Manual Fixes

If you fixed issues manually:
```bash
# Clear failures and reset attempts for clean retry
/ai-sdlc:migration:resume [path] --reset-attempts --clear-failures
```

If you want orchestrator to see fresh state:
```bash
# Update work-log.md with what you fixed
echo "Manual fix: [description]" >> implementation/work-log.md

# Then resume
/ai-sdlc:migration:resume [path]
```

### For Long Migrations

If migration spans days/weeks:
- Resume frequently if interrupted (state preserves progress)
- Review progress in state file periodically
- Document manual changes in work-log.md
- Keep rollback procedures up-to-date

### For Data Migrations

Extra caution required:
- **Never** reset attempts on data integrity failures without investigation
- **Always** understand root cause before retrying
- **Document** all data validation steps in work-log.md
- **Test** rollback procedures before proceeding

### When Migration Strategy Changes

If you need to switch strategies mid-flight:
- Edit orchestrator-state.yml
- Update strategy field
- Resume from execute phase (--from=execute)
- Document why strategy changed in work-log.md

---

**Invoke the migration-orchestrator skill in resume mode NOW to continue your migration workflow from where it left off.**
