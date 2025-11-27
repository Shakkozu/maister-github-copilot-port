# Refactoring Workflow

Guide to safe refactoring with git checkpoints and automatic rollback on test failure.

## Overview

Refactoring workflow improves code structure while preserving behavior exactly. Uses git checkpoints, automatic rollback on ANY test failure, and comprehensive behavior verification.

**When to use:**
- Code complexity too high (>10 average, >20 max cyclomatic complexity)
- Code duplication significant (>10%)
- Code smells present (long methods, god classes, deep nesting)
- Need to improve maintainability while preserving behavior

## Quick Start

```bash
/ai-sdlc:refactoring:new "Extract user authentication logic into separate service"
```

## Workflow Phases (6 Phases)

### Phase 1: Code Quality Baseline
- Calculate cyclomatic complexity
- Measure code duplication
- Identify code smells
- Assess test coverage
- Generate quantitative baseline

### Phase 2: Refactoring Planning
- Classify refactoring type
- Break into incremental steps (small changes)
- Define git checkpoint branches
- Identify affected tests
- Assess risk

### Phase 3: Behavioral Snapshot
- Capture function signatures
- Run tests and record results
- Document side effects
- Create behavioral fingerprint for comparison

### Phase 4: Refactoring Execution
- **Create git checkpoint before each increment**
- Apply refactoring change
- Run appropriate test tier
- **If ANY test fails → AUTOMATIC ROLLBACK to checkpoint**
- No auto-fix in execution (HALT on failure)

### Phase 5: Behavior Verification
- Compare function signatures (must match exactly)
- Compare test results (must match exactly)
- Verify side effects preserved
- Generate PASS/FAIL verdict
- **Any behavior change = FAILED refactoring**

### Phase 6: Final Quality Verification
- Re-measure complexity, duplication, smells
- Confirm quality goals met
- Generate before/after comparison

## Key Safety Features

### Git Checkpoints

```bash
# Before Increment 1
git checkout -b refactor-user-auth-checkpoint-1

# After Increment 1 (if tests pass)
git checkout -b refactor-user-auth-checkpoint-2

# If tests fail
git checkout refactor-user-auth-checkpoint-1  # Rollback
```

### Automatic Rollback

```
Apply refactoring change
Run tests
If ANY test fails:
  → git checkout [previous-checkpoint]  # Automatic rollback
  → HALT and report to user
  → NO auto-fix attempts
```

### Zero Tolerance for Behavior Changes

```
Compare before/after:
  Function signatures: MUST match exactly
  Test results: MUST match exactly
  Side effects: MUST match exactly

If ANYTHING differs → FAILED refactoring
```

## Refactoring Types

- **Extract Method/Function**: Break long methods into smaller ones
- **Rename**: Improve variable/function names
- **Simplify Logic**: Reduce complexity
- **Remove Duplication**: DRY principle
- **Restructure**: Reorganize files/modules
- **Improve Error Handling**: Better exception handling
- **Performance**: Optimize while preserving behavior

## Best Practices

1. **Small Increments**: One change at a time
2. **Trust the Checkpoints**: Git saves you from mistakes
3. **Don't Skip Tests**: Run tests after EVERY change
4. **Zero Behavior Changes**: Refactoring preserves behavior exactly
5. **Measure Improvement**: Compare before/after metrics

## Related Resources

- [Command Reference](../../commands/refactoring/new.md)
- [Skill Documentation](../../skills/refactoring-orchestrator/SKILL.md)
- [Refactoring Analyzer Agent](../../agents/refactoring-analyzer.md)
- [Behavioral Verifier Agent](../../agents/behavioral-verifier.md)

**Next Steps**: `/ai-sdlc:refactoring:new [description]`
