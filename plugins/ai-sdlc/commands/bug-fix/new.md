---
name: ai-sdlc:bug-fix:new
description: Start a comprehensive bug fixing workflow with guided orchestration through all phases
---

# Bug Fix Workflow: New

Start comprehensive bug fixing from analysis through fix implementation with TDD Red-Green discipline.

## Usage

```bash
/ai-sdlc:bug-fix:new [description] [--yolo] [--from=PHASE]
```

### Arguments

- **description** (optional): Brief description of the bug
  - Example: "Fix login timeout with special characters"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `analysis`, `implementation`, `testing`, `documentation`
  - Default: `analysis`

## Examples

```bash
# Interactive mode (default)
/ai-sdlc:bug-fix:new "Fix login timeout with special characters"

# YOLO mode (fast execution)
/ai-sdlc:bug-fix:new "Null pointer in profile page" --yolo

# Resume from specific phase
/ai-sdlc:bug-fix:new --from=implementation
```

## What This Does

**Invoke the bug-fix-orchestrator skill** which guides through 4 phases:

**Phase 1: Bug Analysis & Reproduction**
- Capture bug info (description, steps, expected vs actual)
- Identify affected components and files
- Create minimal reproduction test case
- Analyze root cause with code tracing

**Phase 2: Fix Implementation (TDD Red-Green)**
- Write regression test using reproduction data
- **VALIDATE test FAILS** before fix (mandatory TDD gate)
- Implement targeted fix following standards
- **Verify test PASSES** after fix

**Phase 3: Testing & Verification**
- Add edge case tests (2-8 total)
- Run full test suite for regressions
- Check code coverage for fixed paths

**Phase 4: Documentation & Completion**
- Update code comments
- Create fix summary report
- Generate commit message template

## Outputs

Task directory: `.ai-sdlc/tasks/bug-fixes/YYYY-MM-DD-name/`

- `planning/bug-analysis/bug-report.md` - Bug report
- `planning/bug-analysis/reproduction-data.md` - TDD reproduction data
- `planning/bug-analysis/root-cause-analysis.md` - Root cause
- `implementation/regression-tests/test-failure-log.md` - TDD validation
- `implementation/work-log.md` - Activity log
- `verification/fix-verification.md` - Verification report

## Execution Modes

**Interactive** (default): Pauses after each phase for review. Best for complex bugs.

**YOLO** (`--yolo`): Runs continuously without pauses. Best for simple bugs.

```
Example YOLO output:
[1/4] Bug Analysis & Reproduction... done (10m)
[2/4] Fix Implementation (TDD)... done (15m)
[3/4] Testing & Verification... done (8m)
[4/4] Documentation & Completion... done (5m)

Bug Fixed! All tests passing
```

## Auto-Recovery

The orchestrator handles common failures:
- **Analysis**: Expands search if bug files not found (max 2 attempts)
- **Implementation**: Fixes syntax errors, missing imports (max 3 attempts)
- **Testing**: Re-runs and analyzes failures (max 2 attempts)
- **Documentation**: Auto-generates missing docs (max 1 attempt)

## Prerequisites

- `.ai-sdlc/docs/` structure initialized (use `/init-sdlc` first)
- Git repository (for commits)
- Bug reproduction information available

## Resume

If interrupted:
```bash
/ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-27-fix-login-timeout
```

## TDD Discipline

**Critical**: The orchestrator enforces TDD Red-Green:
1. Test must FAIL before fix (proves test catches the bug)
2. Test must PASS after fix (proves fix works)

If test passes before fix, the test doesn't reproduce the bug - check reproduction data.

---

**Invoke**: bug-fix-orchestrator skill
