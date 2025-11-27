# Bug Analysis Report

**Date:** [YYYY-MM-DD]
**Analyzed By:** [Name/AI]
**Bug ID/Reference:** [Issue number or identifier]

---

## Bug Summary

### Description
[Clear, concise description of the bug and its symptoms]

### Severity
- [ ] Critical (System down, data loss, security issue)
- [ ] High (Major feature broken, significant user impact)
- [ ] Medium (Feature partially broken, workaround exists)
- [ ] Low (Minor issue, cosmetic, edge case)

### Impact Scope
- **Affected Users:** [All users / Specific user group / Edge case]
- **Affected Components:** [List of affected modules/features]
- **Environment:** [Production / Staging / Development / All]

---

## Reproduction

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]
...

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Reproduction Success Rate
- [ ] 100% reproducible
- [ ] Intermittent (X% success rate)
- [ ] Unable to reproduce

### Test Environment
- **OS/Platform:** [e.g., macOS 14.2, Ubuntu 22.04, Windows 11]
- **Browser/Runtime:** [e.g., Chrome 120, Node.js 20.10]
- **Application Version:** [Version or commit hash]
- **Configuration:** [Relevant config details]

---

## Root Cause Analysis

### Affected Code Locations
1. **File:** `path/to/file.ext:123`
   - **Function/Method:** `functionName()`
   - **Issue:** [Brief description of what's wrong here]

2. **File:** `path/to/another/file.ext:456`
   - **Function/Method:** `anotherFunction()`
   - **Issue:** [Brief description]

[Add more as needed]

### Root Cause Explanation
[Detailed explanation of why the bug occurs. Include:]
- What specific code behavior causes the issue
- Why this wasn't caught earlier
- Any underlying assumptions that were violated
- Whether this is a logic error, race condition, edge case, etc.

### Contributing Factors
- [Factor 1: e.g., Missing input validation]
- [Factor 2: e.g., Incorrect error handling]
- [Factor 3: e.g., Race condition in async code]

### Code Execution Path
```
[Trace the execution path that leads to the bug]
Entry Point → Function A → Function B → Bug Location
```

### Related Code Analysis
- **Similar patterns elsewhere:** [Yes/No - if yes, list locations]
- **Potential systematic issue:** [Yes/No - explanation]
- **Recent changes:** [Git commits that may have introduced this]

---

## Technical Details

### Error Messages / Stack Traces
```
[Paste relevant error messages or stack traces]
```

### Logs
```
[Paste relevant log entries]
```

### Data State
[Description of data state when bug occurs, relevant variable values, etc.]

---

## Proposed Fix

### Fix Approach
[High-level description of how to fix the root cause]

### Implementation Plan
1. [Specific change 1]
2. [Specific change 2]
3. [Specific change 3]

### Files to Modify
- `path/to/file1.ext` - [What will change]
- `path/to/file2.ext` - [What will change]
- `path/to/test/file.test.ext` - [Tests to add/update]

### Fix Complexity
- [ ] Simple (Single line or trivial change)
- [ ] Moderate (Multiple changes, straightforward logic)
- [ ] Complex (Significant refactoring or architectural change)

---

## Impact Assessment

### Potential Side Effects
- [Side effect 1 and mitigation]
- [Side effect 2 and mitigation]
- [None identified]

### Regression Risk
- [ ] Low - Isolated change, well-tested
- [ ] Medium - Affects shared code, good test coverage
- [ ] High - Core functionality, limited test coverage

### Edge Cases to Consider
1. [Edge case 1]
2. [Edge case 2]
3. [Edge case 3]

### Performance Implications
[Any performance considerations or impacts]

---

## Testing Strategy

### Unit Tests Required
- [ ] Test for original bug scenario
- [ ] Test for edge case A
- [ ] Test for edge case B
- [ ] Test for error handling

### Integration Tests Required
- [ ] Test in broader application context
- [ ] Test with real data scenarios
- [ ] Test user workflows

### Manual Testing Required
- [ ] [Specific manual test 1]
- [ ] [Specific manual test 2]

### Regression Testing
- [ ] Run full test suite
- [ ] Test related features: [list]
- [ ] Cross-browser/platform testing (if applicable)

---

## Standards Compliance

### Relevant Standards Reviewed
- [ ] `.ai-sdlc/docs/standards/global/error-handling.md`
- [ ] `.ai-sdlc/docs/standards/global/validation.md`
- [ ] `.ai-sdlc/docs/standards/global/coding-style.md`
- [ ] [Other relevant standards]

### Standards Applied in Fix
[List specific standards that will be followed in the implementation]

---

## Additional Notes

### Lessons Learned
[What can be learned from this bug to prevent similar issues?]

### Preventive Measures
[Suggested improvements to prevent similar bugs:]
- [ ] Add validation rule
- [ ] Add linting rule
- [ ] Update documentation
- [ ] Improve error messages
- [ ] Add monitoring/alerting

### Follow-up Tasks
- [ ] [Follow-up task 1]
- [ ] [Follow-up task 2]

### References
- Related issues: [Links]
- Documentation: [Links]
- Related PRs: [Links]

---

## Sign-off

**Analysis Complete:** [Yes/No]
**Ready for Implementation:** [Yes/No]
**Requires Team Discussion:** [Yes/No - if yes, explain why]

### Open Questions
1. [Question 1]
2. [Question 2]

### Decisions Needed
1. [Decision 1]
2. [Decision 2]
