# Auto-Fix Strategies Reference

> **Design Documentation**: This file serves as **design documentation** for developers and Claude implementing migration workflows. It provides auto-recovery patterns for each phase of the migration-orchestrator.

**Purpose:** Pattern guide for automatic failure recovery in migration workflows

This reference provides detailed auto-recovery patterns for each type of failure the migration-orchestrator may encounter across all 7 phases (0-6).

---

## Table of Contents

1. [Overview](#overview)
2. [Phase 0: Current State Analysis](#phase-0-current-state-analysis)
3. [Phase 1: Target State Planning](#phase-1-target-state-planning)
4. [Phase 2: Migration Strategy Specification](#phase-2-migration-strategy-specification)
5. [Phase 3: Implementation Planning](#phase-3-implementation-planning)
6. [Phase 4: Migration Execution](#phase-4-migration-execution)
7. [Phase 5: Verification + Compatibility Testing](#phase-5-verification--compatibility-testing)
8. [Phase 6: Documentation](#phase-6-documentation)

---

## Overview

### Auto-Fix Philosophy

**Goals**:
- Recover from common, predictable failures automatically
- Minimize user intervention for routine issues
- Preserve migration progress and state
- Know when to stop trying and ask for help

**Boundaries**:
- **DO fix**: Missing files, syntax errors, test failures, incomplete reports
- **DON'T fix**: Data integrity issues (data migrations), architectural decisions, security concerns
- **When uncertain**: Report and prompt rather than guess

**Critical Principle: NEVER rollback/halt without user confirmation**:
- Always analyze failure root cause first
- Check for easy fixes (config, setup, environment)
- Present options via AskUserQuestion
- User decides: try fix / rollback / investigate manually

**Attempt Limits**:
- Per-phase maximum attempts (2-5 depending on phase)
- Increment counters in `orchestrator-state.yml`
- Halt when max exceeded and prompt user

### State Management

All auto-fix attempts tracked in state file:
```yaml
auto_fix_attempts:
  analysis: 0  # max 2
  target_planning: 0  # max 2
  specification: 0  # max 2
  planning: 0  # max 2
  execution: 0  # max 5 (distributed across task groups)
  verification: 0  # max 2 (max 3 for data migrations)
  documentation: 0  # max 1
```

---

## Phase 0: Current State Analysis

**Subagent**: `ai-sdlc:existing-feature-analyzer`

### Failure: System Files Not Found

**Symptoms**:
- Subagent returns: `status: failed` or `status: partial`
- `files_found` array empty or very low confidence (<40%)
- Error: "Unable to locate current system files"

**Auto-Fix Strategy**:

**Attempt 1** (orchestrator re-invoke subagent):
```
"Previous analysis failed to locate current system files.

Migration description: [description]

Please broaden search:
1. Search for generic patterns (*.vue, *.js, config files)
2. Check package files (package.json, requirements.txt)
3. Analyze imports to infer system structure
4. List partial results and prompt user if uncertain
"
```

**Attempt 2** (prompt user):
```
"❌ Unable to auto-detect current system files.

Please provide:
1. Primary files/directories to analyze: [user input]
2. Or confirm this is a new system: [Y/n]

After input, re-invoke subagent with explicit paths.
"
```

**Max Attempts**: 2

---

## Phase 1: Target State Planning

**Subagent**: `gap-analyzer`

### Failure: Target System Unclear

**Symptoms**:
- Subagent returns low confidence classification
- Migration type ambiguous (tied scores)
- Gap analysis incomplete

**Auto-Fix Strategy**:

**Attempt 1** (orchestrator clarify):
```
"Gap analysis requires clarity on target system.

Current system: [from Phase 0]
Migration description: [description]

Please specify:
1. Target technology/platform: [prompt user]
2. Target version: [prompt user]
3. Primary goal: [modernization/performance/compatibility]

Re-run gap analysis with specific target.
"
```

**Attempt 2** (handle ambiguous type):
```
"🤔 Migration type unclear. Detected keywords:
- Code: [code keywords]
- Data: [data keywords]
- Architecture: [architecture keywords]

Please classify:
1. Code (framework/library change)
2. Data (database/storage change)
3. Architecture (pattern change)
4. General (mixed/complex)

Your selection: [user input]
"
```

**Max Attempts**: 2

---

## Phase 2: Migration Strategy Specification

**Skill**: `specification-creator`

### Failure: Spec Verification Failed

**Symptoms**:
- Verification report shows ❌ Failed
- Rollback plan incomplete
- Dual-run plan missing
- Spec/requirements misalignment

**Auto-Fix Strategy**:

**Attempt 1**:
```
"Previous specification failed verification:

Critical Issues:
- [Issue 1 from verification report]
- [Issue 2]

Please revise:
1. Address all critical issues
2. Ensure rollback plan complete
3. If dual-run: Create planning/dual-run-plan.md
4. Include migration-specific verification criteria

Attempt 1/2.
"
```

**Attempt 2** (targeted):
```
If rollback plan incomplete:
"Rollback plan incomplete.

Missing sections:
- [Section 1]
- [Section 2]

Regenerate with:
- Rollback procedure for each phase
- Data recovery procedures
- Rollback time estimate
- Verification steps

Attempt 2/2.
"
```

**Max Attempts**: 2

---

## Phase 3: Implementation Planning

**Skill**: `implementation-planner`

### Failure: Incomplete Migration Plan

**Symptoms**:
- Missing rollback steps in task groups
- Incorrect dependencies
- Task groups don't align with strategy

**Auto-Fix Strategy**:

**Attempt 1**:
```
"Previous plan incomplete. Regenerate with:

Migration Strategy: [from state]
- If incremental: Task groups per migration phase
- If dual-run: Include setup, sync, cutover groups

Required in each group:
- Rollback step (how to undo)
- Verification step (how to validate)

Dependencies:
- Ensure correct order
- [Specific issues found]

Attempt 1/2.
"
```

**Attempt 2** (specific fix):
```
If rollback steps missing:
"Add rollback steps to each task group.

Format:
- Step X.n: Rollback [group name]
  - Document undo procedure
  - Verification: Confirm rollback succeeded

Add to all [N] groups.
"
```

**Max Attempts**: 2

---

## Phase 4: Migration Execution

**Skill**: `implementer`

### Failure: Migration Step Failed

**Symptoms**:
- Syntax errors in migrated code
- Missing imports
- Test failures
- Breaking changes not handled

**Auto-Fix Strategy**:

**Overall Max**: 5 attempts (distributed across all task groups)

**Fix Type: Syntax Errors**:
```
Error: "SyntaxError: Unexpected token"

Auto-Fix:
1. Read file with error
2. Identify common issues:
   - Missing brackets
   - Incorrect function syntax
   - Deprecated syntax
3. Apply fix using Edit tool
4. Re-run tests

Example:
Old Vue 2: export default { data() {...} }
New Vue 3: export default defineComponent({ setup() {...} })
```

**Fix Type: Missing Imports**:
```
Error: "ReferenceError: defineComponent is not defined"

Auto-Fix:
1. Read file
2. Identify missing import
3. Add import at top
4. Re-run tests

Example: Add import { defineComponent } from 'vue'
```

**Fix Type: Test Failures**:
```
Error: "Test failed: expected X but got Y"

Auto-Fix:
1. Read test file
2. Identify assertion based on old API
3. Update for new API
4. Re-run tests

Example:
Old: expect(wrapper.vm.$data.count).toBe(0)
New: expect(wrapper.vm.count).toBe(0)
```

**Max Attempts**: 5 overall

---

## Phase 5: Verification + Compatibility Testing

**Skill**: `implementation-verifier`

### Failure: Tests Failing

**Symptoms**:
- Test suite failures
- Compatibility tests fail
- Rollback test fails

**Auto-Fix Strategy**:

**Standard Migrations**: Max 2 attempts

**Attempt 1**:
```
"Verification failed.

Failed tests:
- [Test 1]: [Error]
- [Test 2]: [Error]

Invoking implementer to fix:
1. Analyze test failures
2. Identify root cause
3. Apply fixes
4. Re-run full suite

Attempt 1/2.
"
```

**Data Migrations**: Max 3 attempts

**CRITICAL - Data Integrity Failure**:
```
If data integrity fails:

**IMPORTANT**: NEVER halt automatically. Always analyze and ask user first.

Step 1 - ANALYZE Root Cause:
- Is this a configuration issue? (connection string, credentials)
- Is this a timing issue? (data still syncing)
- Is this a transformation issue? (mapping error)
- Is this actual data loss? (requires investigation)

Step 2 - ASK USER with AskUserQuestion:
"🚨 Data integrity check failed

Issue: [Row count mismatch / Checksum mismatch]
Current DB: [count/checksum]
Target DB: [count/checksum]

Analysis: [Root cause analysis from Step 1]

How would you like to proceed?"

options:
  - "Try suggested fix" (if easy fix found, e.g., "Retry sync with longer timeout")
  - "Halt migration" (user confirms halt)
  - "Let me investigate" (pause for manual investigation)

Step 3 - EXECUTE based on user choice:
- If "Try fix": Apply suggested fix, re-run verification
- If "Halt": Save state, halt workflow
- If "Investigate": Save state, pause workflow

Note: Data migrations are critical, but user should still confirm halt.
Never halt automatically without user understanding the issue.
"
```

**Rollback Test Failures** (Non-Critical):
```
"⚠️ Rollback test failed

Issue: [Rollback didn't work as expected]

Non-critical failure (informational only).

Options:
1. Document issue in verification report
2. Update planning/rollback-plan.md
3. Continue workflow (doesn't block deployment)

Proceed? [Y/n]
"
```

**Max Attempts**: 2 (standard), 3 (data migrations)

---

## Phase 6: Documentation

**Agent**: `user-docs-generator`

### Failure: Documentation Generation Failed

**Symptoms**:
- Subagent fails to generate guide
- Screenshot capture fails
- Documentation incomplete

**Auto-Fix Strategy**:

**Max Attempts**: 1 (documentation optional, low priority)

**Attempt 1**:
```
If screenshot capture fails:

"Documentation generation failed: Unable to capture screenshots

Generating text-only migration guide:
1. Migration overview
2. Step-by-step instructions (text only)
3. Rollback procedures
4. Troubleshooting

Output: documentation/migration-guide.md (text-only)

Attempt 1/1.
"

Invoke user-docs-generator with --text-only flag.
```

**If Still Fails**:
```
"⚠️ Phase 6 Failed: Documentation generation failed

Non-critical failure. Migration complete and verified.

Continuing without user documentation.

Generate manually later by re-running with --user-docs flag.

Proceeding to finalization...
"

Continue to Phase 7 without docs.
```

---

## Summary

**Key Principles**:
1. **Auto-fix routine issues**: Syntax, imports, test assertions
2. **NEVER halt/rollback without user confirmation**: Always analyze first, then ask
3. **Respect attempt limits**: 1-5 depending on phase
4. **Preserve state**: Always save before halting
5. **Clear guidance**: Tell user what to fix and how to resume

**Rollback/Halt Policy**:
- NEVER rollback or halt automatically
- Always analyze failure root cause first
- Check for easy fixes (config, setup, environment)
- Present options via AskUserQuestion (try fix / halt / investigate)
- User decides the action

**Attempt Limits Summary**:
- Phase 0 (Analysis): 2
- Phase 1 (Target Planning): 2
- Phase 2 (Specification): 2
- Phase 3 (Planning): 2
- Phase 4 (Execution): 5 (distributed)
- Phase 5 (Verification): 2 (3 for data migrations)
- Phase 6 (Documentation): 1

**Special Cases**:
- **Data integrity failures**: ANALYZE → ASK USER → Execute user's choice (never auto-halt)
- **Rollback test failures**: Document but don't block
- **Documentation failures**: Skip phase, don't block
