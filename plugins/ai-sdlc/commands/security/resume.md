---
name: security:resume
description: Resume an interrupted or failed security remediation workflow from where it left off
category: Security Workflows
---

# Resume Security Remediation Workflow

Resume interrupted security remediation workflow from saved state.

## Command Usage

```bash
/ai-sdlc:security:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]
```

### Arguments

- **task-path** (optional): Path to task directory
  - Example: `.ai-sdlc/tasks/security/2025-11-17-fix-vulnerabilities`
  - If omitted, you'll be prompted

### Options

- `--from=PHASE`: Override state, force start from specific phase
  - Values: `baseline`, `planning`, `implementation`, `verification`, `compliance`
- `--reset-attempts`: Reset auto-fix attempt counters
- `--clear-failures`: Remove failed_phases from state

## Examples

### Example 1: Simple Resume

```bash
/ai-sdlc:security:resume .ai-sdlc/tasks/security/2025-11-17-vulnerabilities
```

Reads state, continues from next phase.

### Example 2: Force Resume from Specific Phase

```bash
/ai-sdlc:security:resume .ai-sdlc/tasks/security/2025-11-17-vulnerabilities --from=verification
```

Skips to verification phase (useful for re-running after manual fixes).

### Example 3: Reset After Manual Fixes

```bash
/ai-sdlc:security:resume .ai-sdlc/tasks/security/2025-11-17-vulnerabilities --reset-attempts --clear-failures
```

Clears failure history, gives fresh auto-fix attempts.

## What You Are Doing

**Invoke security-orchestrator skill in resume mode.**

Resume steps:
1. Load `orchestrator-state.yml` from task directory
2. Check completed_phases to determine next phase
3. Validate prerequisites (required files exist)
4. Continue workflow from next phase

## Use Cases

**Computer restarted mid-workflow**: Resume continues from last completed phase

**Phase failed after max attempts**: Fix manually, then resume with `--reset-attempts`

**Want to re-run specific phase**: Use `--from=phase` to restart from that phase

**Verification failed**: Fix security issues, resume from verification

## State Reconstruction

If `orchestrator-state.yml` missing but artifacts exist:
1. Check `analysis/security-baseline.md` → Phase 0 complete
2. Check `implementation/security-remediation-plan.md` → Phase 1 complete
3. Check fix completion in plan → Phase 2 progress
4. Check `verification/security-verification-report.md` → Phase 3 complete

Resume from most recent complete phase + 1.

## Prerequisites Validation

**Phase 1** requires: `analysis/security-baseline.md`
**Phase 2** requires: `implementation/security-remediation-plan.md`
**Phase 3** requires: Phase 2 complete (at least 1 fix implemented)
**Phase 4** requires: Phase 3 complete with verdict = PASS or PASS with Issues

If prerequisites missing, workflow prompts to start from earlier phase.

## Invoke

Invoke **security-orchestrator** skill in resume mode to continue security remediation from saved state.
