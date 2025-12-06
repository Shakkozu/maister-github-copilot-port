---
name: ai-sdlc:performance:resume
description: Resume an interrupted or failed performance optimization workflow from where it left off
category: Performance Workflows
---

# Resume Performance Optimization Workflow

Resume interrupted performance optimization workflow from saved state.

## Command Usage

```bash
/ai-sdlc:performance:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]
```

### Arguments

- **task-path** (optional): Path to task directory
  - Example: `.ai-sdlc/tasks/performance/2025-11-16-optimize-dashboard`
  - If omitted, you'll be prompted

### Options

- `--from=PHASE`: Override state, force start from specific phase
  - Values: `baseline`, `analysis`, `implementation`, `verification`, `load-testing`
- `--reset-attempts`: Reset auto-fix attempt counters
- `--clear-failures`: Remove failed_phases from state

## Examples

### Example 1: Simple Resume

```bash
/ai-sdlc:performance:resume .ai-sdlc/tasks/performance/2025-11-16-dashboard
```

Reads state, continues from next phase.

### Example 2: Force Resume from Specific Phase

```bash
/ai-sdlc:performance:resume .ai-sdlc/tasks/performance/2025-11-16-dashboard --from=verification
```

Skips to verification phase (useful for re-running after manual fixes).

### Example 3: Reset After Manual Fixes

```bash
/ai-sdlc:performance:resume .ai-sdlc/tasks/performance/2025-11-16-dashboard --reset-attempts --clear-failures
```

Clears failure history, gives fresh auto-fix attempts.

## What You Are Doing

**Invoke performance-orchestrator skill in resume mode.**

Resume steps:
1. Load `orchestrator-state.yml` from task directory
2. Check completed_phases to determine next phase
3. Validate prerequisites (required files exist)
4. Continue workflow from next phase

## Use Cases

**Computer restarted mid-workflow**: Resume continues from last completed phase

**Phase failed after max attempts**: Fix manually, then resume with `--reset-attempts`

**Want to re-run specific phase**: Use `--from=phase` to restart from that phase

**Verification failed**: Fix optimization issues, resume from verification

## State Reconstruction

If `orchestrator-state.yml` missing but artifacts exist:
1. Check `analysis/performance-baseline.md` → Phase 0 complete
2. Check `implementation/optimization-plan.md` → Phase 1 complete
3. Check optimization completion in plan → Phase 2 progress
4. Check `verification/performance-verification.md` → Phase 3 complete

Resume from most recent complete phase + 1.

## Prerequisites Validation

**Phase 1** requires: `analysis/performance-baseline.md`
**Phase 2** requires: `implementation/optimization-plan.md`
**Phase 3** requires: Phase 2 complete (at least 1 optimization implemented)
**Phase 4** requires: Phase 3 complete with verdict = PASS or PASS with Concerns

If prerequisites missing, workflow prompts to start from earlier phase.

## Invoke

Invoke **performance-orchestrator** skill in resume mode to continue performance optimization from saved state.
