# Bug Fix Workflow Checklist

This comprehensive checklist ensures all steps in the bug fixing workflow are completed systematically.

## Phase 1: Bug Analysis & Reproduction

### Initial Setup
- [ ] Read `.ai-sdlc/docs/INDEX.md` for project context
- [ ] Load relevant coding standards from `.ai-sdlc/docs/standards/`
- [ ] Create workspace for bug fix artifacts

### Bug Information Gathering
- [ ] Capture bug description and symptoms
- [ ] Document steps to reproduce
- [ ] Record expected vs actual behavior
- [ ] Identify affected components/files/functions
- [ ] Collect error messages, stack traces, logs
- [ ] Determine severity and impact scope
- [ ] Check if issue is reported elsewhere (duplicates)

### Bug Reproduction
- [ ] Create minimal test case reproducing the issue
- [ ] Document exact reproduction steps
- [ ] **CRITICAL: Capture exact reproduction data** (inputs, config, state)
- [ ] **Save reproduction data to `planning/bug-analysis/reproduction-data.md`**
- [ ] **Document data format, values, configuration, timing/sequence**
- [ ] Verify bug exists in current codebase
- [ ] Test in relevant environments (dev, staging, production)
- [ ] Record reproduction success/failure
- [ ] If unable to reproduce, document what was tried

### Root Cause Analysis
- [ ] Trace code execution path to the bug
- [ ] Identify specific code location(s) causing the issue
- [ ] Determine bug type (logic error, edge case, race condition, etc.)
- [ ] Check for similar issues in related code
- [ ] Review git history for recent changes that might have introduced the bug
- [ ] Identify contributing factors (configuration, environment, dependencies)
- [ ] Determine if this is a symptom of a larger architectural issue

### Analysis Documentation
- [ ] Create `bug-analysis.md` with root cause explanation
- [ ] Document affected code locations with file:line references
- [ ] Write impact assessment
- [ ] Propose fix approach with rationale
- [ ] List potential side effects or risks
- [ ] Identify edge cases to test

## Phase 2: Fix Implementation

### Standards Review
- [ ] Review error handling standards from `.ai-sdlc/docs/standards/global/error-handling.md`
- [ ] Review validation standards from `.ai-sdlc/docs/standards/global/validation.md`
- [ ] Check coding style conventions
- [ ] Review architectural patterns in project documentation
- [ ] Identify any domain-specific standards (frontend/backend)

### Fix Planning
- [ ] Determine minimal change needed to fix root cause
- [ ] Identify all files requiring modification
- [ ] Plan approach for each code change
- [ ] Consider edge cases and boundary conditions
- [ ] Assess potential side effects
- [ ] Plan any necessary refactoring (keep minimal)
- [ ] Review plan against project architecture

### Implementation
- [ ] Make targeted code changes addressing root cause
- [ ] Follow project coding standards and style guidelines
- [ ] Add input validation where appropriate
- [ ] Implement proper error handling
- [ ] Add defensive programming checks
- [ ] Update or add code comments for complex logic
- [ ] Keep changes focused and minimal
- [ ] Avoid scope creep (unrelated improvements)

### Implementation Review
- [ ] Verify fix addresses identified root cause
- [ ] Check for potential side effects
- [ ] Review code quality and readability
- [ ] Confirm standards compliance
- [ ] Ensure error messages are clear and helpful
- [ ] Validate edge case handling
- [ ] Check for code duplication

## Phase 3: Testing & Verification

### Unit Testing

**TDD Red Phase (Before Implementation):**
- [ ] Identify test file locations following project conventions
- [ ] **Read `planning/bug-analysis/reproduction-data.md` from Phase 1**
- [ ] **Create test using EXACT reproduction data** (inputs, config, state)
- [ ] **🔴 Run test and verify it FAILS (TDD Red Phase)**
- [ ] **If test passes, STOP - diagnose why test doesn't reproduce bug**
- [ ] **Document test failure in `implementation/regression-tests/test-failure-log.md`**
- [ ] **Complete TDD Validation Checklist in test-failure-log.md:**
  - [ ] Test executed without syntax errors
  - [ ] Test result is FAILED (not PASSED)
  - [ ] Failure message matches expected bug behavior
  - [ ] Test uses exact reproduction data from Stage 1
  - [ ] Error output matches original bug error
  - [ ] Test is deterministic (fails consistently)
- [ ] **✅ Only proceed to fix implementation after test failure validated**

**Implementation:**
- [ ] Implement minimal fix addressing root cause
- [ ] Follow project coding standards

**TDD Green Phase (After Implementation):**
- [ ] **🟢 Run regression test and verify it PASSES**
- [ ] **Document test success in test-failure-log.md**
- [ ] Add tests for edge cases and boundary conditions (2-8 total tests)
- [ ] Vary ONE aspect of reproduction data at a time for edge cases
- [ ] Test error handling paths
- [ ] Follow testing standards from `.ai-sdlc/docs/standards/testing/`
- [ ] Ensure test names are descriptive
- [ ] Check test coverage for modified code

### Integration Testing
- [ ] Test fix in broader application context
- [ ] Verify original reproduction steps no longer trigger bug
- [ ] Test related functionality (regression prevention)
- [ ] Test with different data sets
- [ ] Test edge cases in integrated environment
- [ ] Verify error handling in realistic scenarios
- [ ] Check user-facing behavior

### Test Suite Execution
- [ ] Run full unit test suite
- [ ] Run integration test suite
- [ ] Run end-to-end tests (if applicable)
- [ ] Address any failing tests
- [ ] Verify no regressions introduced
- [ ] Check overall test coverage metrics
- [ ] Run linting and code quality checks

### Manual Verification
- [ ] Test in development environment
- [ ] Verify user-facing behavior is correct
- [ ] Check UI/UX if applicable
- [ ] Test error messages displayed to users
- [ ] Verify logging and monitoring
- [ ] Test performance (no degradation)
- [ ] Cross-browser/platform testing (if relevant)

## Phase 4: Documentation & Completion

### Code Documentation
- [ ] Update inline comments where necessary
- [ ] Add JSDoc/docstrings for modified functions (if applicable)
- [ ] Document complex logic or non-obvious fixes
- [ ] Update API documentation (if public APIs changed)
- [ ] Add TODO comments for follow-up work (if any)

### Project Documentation
- [ ] Update relevant project documentation
- [ ] Document architectural decisions (if applicable)
- [ ] Update troubleshooting guides
- [ ] Add to known issues documentation (if partial fix)
- [ ] Update changelog or release notes

### Fix Summary
- [ ] Write clear summary of bug and root cause
- [ ] Describe fix implementation approach
- [ ] List all files changed
- [ ] Document test coverage added
- [ ] Note any remaining concerns or limitations
- [ ] Identify follow-up tasks (if any)
- [ ] Create commit message draft

### Cleanup
- [ ] Remove debug code and console.log statements
- [ ] Remove commented-out code
- [ ] Remove temporary test files or fixtures
- [ ] Ensure proper code formatting
- [ ] Remove unused imports or variables
- [ ] Verify no unintended changes included
- [ ] Check for sensitive data in code or comments

### Version Control
- [ ] Review all changes in diff
- [ ] Stage only relevant files
- [ ] Write clear, descriptive commit message
- [ ] Include bug reference/issue number
- [ ] Follow project commit conventions
- [ ] Consider whether to squash commits

### Final Verification
- [ ] All tests passing
- [ ] Code review ready (if applicable)
- [ ] Documentation complete
- [ ] No debug code remaining
- [ ] Standards compliance verified
- [ ] Ready for deployment/merge

## Post-Fix Considerations

### Optional Follow-ups
- [ ] Consider if similar bugs exist elsewhere
- [ ] Evaluate if preventive measures needed (linting rules, etc.)
- [ ] Assess if additional monitoring would help
- [ ] Consider if documentation could prevent future similar bugs
- [ ] Evaluate if architectural improvements warranted
- [ ] Plan for backporting fix to other branches (if needed)

### Communication
- [ ] Notify bug reporter of fix
- [ ] Update issue tracker status
- [ ] Communicate with team if architectural concerns found
- [ ] Document lessons learned (for team knowledge base)

---

## Quick Reference: Minimum Required Steps

For simple bugs, at minimum you must:

1. ✅ Understand and reproduce the bug
2. ✅ **Capture exact reproduction data** (`planning/bug-analysis/reproduction-data.md`)
3. ✅ Identify root cause
4. ✅ **Write failing test using reproduction data (TDD Red Phase 🔴)**
5. ✅ **Validate test FAILS before implementation**
6. ✅ Implement focused fix following standards
7. ✅ **Verify test PASSES after fix (TDD Green Phase 🟢)**
8. ✅ Add edge case tests (2-8 total)
9. ✅ Run test suite (all tests passing)
10. ✅ Clean up and document changes

---

## Common Pitfalls to Avoid

❌ **Skipping root cause analysis** - Leads to incomplete fixes
❌ **Fixing symptoms instead of causes** - Bug will likely recur
❌ **Not capturing reproduction data** - Tests may not reproduce bug
❌ **Writing tests that pass before fix** - Defeats TDD purpose
❌ **Skipping test failure validation** - Can't prove test reproduces bug
❌ **Not using exact reproduction data** - Test may not trigger bug
❌ **Scope creep** - Mixing bug fixes with unrelated improvements
❌ **Inadequate testing** - May introduce regressions
❌ **Ignoring edge cases** - Incomplete fix coverage
❌ **Poor documentation** - Future confusion
❌ **Not following standards** - Inconsistent codebase
❌ **Skipping code review** - Missing potential issues
