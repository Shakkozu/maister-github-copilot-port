---
description: Start a new refactoring workflow with guided orchestration through all phases
---

Initiate a safe, incremental refactoring workflow to improve code quality while preserving behavior exactly.

**Usage**: `/ai-sdlc:refactoring:new [refactoring-description] [--yolo]`

**Parameters**:
- `refactoring-description`: Description of what to refactor (required)
- `--yolo`: Run in continuous mode without pausing between phases (optional)

**Examples**:
```
/ai-sdlc:refactoring:new "Extract validation logic from UserService into separate validator"
/ai-sdlc:refactoring:new "Simplify complex nested conditionals in processOrder function"
/ai-sdlc:refactoring:new "Remove duplication in authentication middleware" --yolo
/ai-sdlc:refactoring:new "Restructure 800-line UserManager into focused classes"
```

**What this does**:
1. Creates refactoring task directory in `.ai-sdlc/tasks/refactoring/YYYY-MM-DD-refactoring-name/`
2. Executes 6-phase refactoring workflow:
   - Phase 0: Code Quality Baseline (analyze complexity, duplication, smells, coverage)
   - Phase 1: Refactoring Planning (classify type, create incremental plan with git checkpoints)
   - Phase 2: Behavioral Snapshot (capture baseline behavior for comparison)
   - Phase 3: Refactoring Execution (apply changes incrementally with automatic rollback on test failure)
   - Phase 4: Behavior Verification (verify behavior preserved exactly)
   - Phase 5: Final Quality Verification (confirm quality goals met)
3. Produces refactored code with git checkpoint branches and comprehensive verification reports

**Execution modes**:
- **Interactive** (default): Pauses after each phase for review and approval
- **YOLO** (--yolo flag): Continuous execution without pauses (stops only on failure)

**Safety features**:
- **Git checkpoints**: Created before each increment (enables instant rollback)
- **Automatic rollback**: ANY test failure triggers immediate rollback to previous checkpoint
- **Zero auto-fix**: No automatic fixing in execution/verification phases (HALT on failure)
- **Behavior preservation**: Strict verification that behavior unchanged (zero functional changes)
- **Test-driven**: Runs appropriate test tiers after each increment

**Refactoring types supported**:
- **Extract Method/Function**: Break large functions into smaller focused functions
- **Rename**: Improve naming for clarity
- **Simplify Complex Logic**: Reduce cyclomatic complexity, flatten nesting
- **Remove Duplication**: Apply DRY principle, extract common code
- **Restructure/Reorganize**: Split god classes, improve architecture
- **Improve Error Handling**: Add proper error handling and propagation
- **Performance Optimization**: Improve performance while preserving behavior
- **Add Missing Tests**: Establish test coverage before other refactoring

**Outputs**:
- `analysis/code-quality-baseline.md` - Baseline quality metrics (always)
- `implementation/refactoring-plan.md` - Detailed incremental plan with checkpoints (always)
- `analysis/behavioral-snapshot.md` - Behavioral baseline for comparison (always)
- `verification/behavior-verification-report.md` - Behavior preservation verification (always)
- `verification/quality-improvement-report.md` - Quality improvement metrics (always)
- Git checkpoint branches: `refactor/checkpoint-N-description` (created during execution)

**When to use**:
- Code complexity too high (>10 average, >20 max)
- Code duplication significant (>10%)
- Code smells present (long methods, god classes, deep nesting)
- Test coverage low (<80%)
- Need to improve maintainability while preserving behavior
- Want safe, verifiable refactoring with automatic rollback

**Success criteria**:
- ✅ All increments complete successfully
- ✅ All tests pass identically before and after
- ✅ Behavior preserved exactly (PASS verdict from Phase 4)
- ✅ Quality metrics improved (goals met in Phase 5)
- ✅ No behavior changes introduced

**Failure scenarios**:

**Test failure during execution (Phase 3)**:
- Immediate rollback to previous checkpoint
- Failed checkpoint branch deleted
- Orchestrator halts
- User must investigate test failure and fix before resuming

**Behavior verification fails (Phase 4)**:
- Orchestrator halts (does not proceed to Phase 5)
- Comprehensive report shows discrepancies
- Recommends rollback to main
- User must investigate behavior changes and fix

**Quality goals not met (Phase 5)**:
- Documents achieved vs target metrics
- User decides: accept partial improvement, continue refactoring, or rollback

**Resume after failure**:
```
/ai-sdlc:refactoring:resume .ai-sdlc/tasks/refactoring/2025-11-14-extract-validation
```

**Important notes**:
- Refactoring must preserve behavior exactly - zero functional changes allowed
- Any test failure triggers immediate rollback (no auto-fix attempts)
- Behavior verification is strict - any discrepancy = failed refactoring
- Git checkpoint branches enable safe rollback at any point
- All changes are incremental and testable
- Recommended to review refactoring plan (Phase 1) before proceeding to execution

**Invoke**: ai-sdlc:refactoring-orchestrator skill
