# Verification Report Template

This template defines the expected structure for implementation verification reports.

## Purpose

The verification report is a **comprehensive quality assurance document** that provides evidence that an implementation:
- Completed all planned tasks
- Passes its test suite
- Follows applicable coding standards
- Has complete documentation
- Is ready for code review and commit

## Template Structure

```markdown
# Implementation Verification Report: [Task Name]

**Task**: [Full task name from spec.md]
**Location**: `.ai-sdlc/tasks/[type]/[dated-name]/`
**Date**: [YYYY-MM-DD HH:MM]
**Verifier**: implementation-verifier
**Status**: ✅ Passed | ⚠️ Passed with Issues | ❌ Failed

---

## Executive Summary

[Provide 2-3 sentence overview of verification results]

Example:
"This implementation completed all 12 planned steps across 3 task groups. The full test
suite shows 47 of 50 tests passing (94%). Standards compliance is mostly verified with
minor documentation gaps. Overall status: Passed with Issues - minor test failures need
attention before merge."

---

## 1. Implementation Plan Verification

**Status**: ✅ Complete | ⚠️ Nearly Complete | ❌ Incomplete

### Completion Summary

- **Total Steps**: [N]
- **Completed Steps**: [M]
- **Completion Rate**: [M/N] = [percentage]%

### Completed Task Groups

- [x] **Task Group 1: [Name]** ([N] steps)
  - [x] 1.1 [Step description]
  - [x] 1.2 [Step description]
  - [x] 1.3 [Step description]
  - [x] 1.4 [Step description]
  - **Spot Check**: ✅ Verified - [Evidence found, e.g., "User model found in models/User.js"]

- [x] **Task Group 2: [Name]** ([N] steps)
  - [x] 2.1 [Step description]
  - [x] 2.2 [Step description]
  - [x] 2.3 [Step description]
  - **Spot Check**: ✅ Verified - [Evidence found]

[Continue for all task groups]

### Incomplete or Issues

[If 100% complete]
None - all steps verified complete.

[If <100% complete]
The following steps are marked incomplete or have questionable implementation:

- [ ] **Step X.Y**: [Step description]
  - Status: Incomplete / Questionable
  - Evidence: [What was found or not found]
  - Impact: [Minor / Major]

### Assessment

[Provide assessment of implementation completeness]

Example:
"All 12 implementation steps across 3 task groups are marked complete. Spot checks
confirm implementation exists for database models, API endpoints, and UI components.
Implementation appears thorough and complete."

---

## 2. Test Suite Results

**Status**: ✅ All Passing | ⚠️ Some Failures | ❌ Critical Failures

### Test Summary

- **Total Tests**: [N]
- **Passing**: [P]
- **Failing**: [F]
- **Errors**: [E]
- **Pass Rate**: [P/N] = [percentage]%

### Test Command Used

```bash
[test command]
```

### Failed Tests

[If all tests passing]
None - all tests passing ✅

[If tests failing]

#### Feature-Related Failures

Tests related to this feature that are failing:

1. **[test name]** - `[file path]`
   - **Error**: [error message]
   - **Category**: Unit | Integration | E2E
   - **Severity**: Minor | Major | Critical
   - **Notes**: [Additional context]

2. **[test name]** - `[file path]`
   - **Error**: [error message]
   - **Category**: [category]
   - **Severity**: [severity]

[Continue for all feature-related failures]

#### Potential Regressions

Tests failing in areas unrelated to this feature (potential regressions):

1. **[test name]** - `[file path]`
   - **Area**: [area of codebase]
   - **Error**: [error message]
   - **Notes**: May be pre-existing failure or regression introduced by this change

[Continue for all potential regressions]

### Test Coverage

- **Feature-Specific Tests**: [N] tests written for this feature
- **Feature Tests Passing**: [M] / [N] = [percentage]%
- **Overall Suite Impact**: [Description of how feature tests affected overall suite]

### Assessment

[Provide assessment of test results]

Example:
"Test suite shows 47 of 50 tests passing (94%). Three failures are feature-related and
appear to be minor edge cases in validation logic. No regressions detected in unrelated
areas. Test coverage for the feature is adequate with 15 focused tests across the 3 task
groups."

---

## 3. Standards Compliance

**Status**: ✅ Fully Compliant | ⚠️ Mostly Compliant | ❌ Non-Compliant

### Standards Applied (from work-log.md)

Based on review of `implementation/work-log.md`:

- ✅ **global/naming-conventions.md**
  - Applied to: [files/components where applied]
  - Evidence: [Quote from work-log.md or code evidence]

- ✅ **[area]/[standard].md**
  - Applied to: [where applied]
  - Evidence: [evidence]

[Continue for all standards mentioned in work-log.md]

**Total Standards Documented**: [N] standards referenced in work-log.md

### Expected Standards (from docs/INDEX.md)

Based on implementation scope and docs/INDEX.md:

**Global Standards** (always applicable):
- [x] global/naming-conventions.md - ✅ Applied and documented
- [x] global/code-organization.md - ✅ Applied and documented
- [x] global/error-handling.md - ⚠️ Applied but not explicitly documented
- [ ] global/comments-documentation.md - ⚠️ Not mentioned, may be missed

**Area-Specific Standards**:
- [x] backend/database.md - ✅ Applied (database task group)
- [x] backend/api.md - ✅ Applied (API task group)
- [x] frontend/components.md - ✅ Applied (frontend task group)
- [ ] frontend/accessibility.md - ⚠️ Not mentioned but may apply to forms

**Total Expected Standards**: [M] standards identified as applicable

### Cross-Reference Analysis

**Applied vs Expected**:
- **Documented in work-log.md**: [N] standards
- **Expected from INDEX.md**: [M] standards
- **Matched**: [X] standards documented and expected
- **Potentially Missed**: [Y] expected but not documented

### Potentially Missed Standards

[If no missed standards]
None - all expected standards appear applied based on work-log.md and code spot checks.

[If potentially missed standards]

The following standards were expected but not explicitly mentioned:

1. **[standard-name].md**
   - **Why Expected**: [Reason based on implementation scope]
   - **Spot Check**: [Results of code check]
   - **Assessment**: ✅ Appears applied | ⚠️ Unclear | ❌ Not applied

[Continue for all potentially missed standards]

### Continuous Standards Discovery

**Evidence of Continuous Discovery**:
- [Review work-log.md for evidence of standards discovered during implementation]
- [Quote specific examples of discovering standards mid-implementation]

Example:
"Work log shows evidence of continuous standards discovery:
- global/accessibility.md discovered during form implementation (Task Group 3)
- backend/external-services.md discovered during email integration (Task Group 2)
This demonstrates proper continuous checking of docs/INDEX.md throughout implementation."

### Assessment

[Provide assessment of standards compliance]

Example:
"Implementation shows good standards compliance. 8 of 10 expected standards are
documented in work-log.md. Two potentially missed standards (accessibility, comments)
were spot-checked in code and appear adequately applied despite not being explicitly
documented. Evidence shows continuous standards discovery throughout implementation."

---

## 4. Documentation Completeness

**Status**: ✅ Complete | ⚠️ Adequate | ❌ Incomplete

### Implementation Plan

**File**: `implementation-plan.md`
- **Present**: ✅ Yes | ❌ No
- **Completion**: [percentage]% steps marked complete
- **Integrity**: ✅ File intact and readable | ⚠️ Truncated/corrupted | ❌ Missing sections

### Work Log

**File**: `implementation/work-log.md`
- **Present**: ✅ Yes | ❌ No
- **Entry Count**: [N] dated entries
- **Date Range**: [first date] to [last date] ([N] days)
- **Completeness**: ✅ Comprehensive | ⚠️ Adequate | ❌ Sparse

**Coverage**:
- [x] All task groups covered
- [x] Standards discovery documented
- [x] File modifications recorded
- [x] Test execution documented
- [x] Final completion entry present

**Detailed Entries**:

1. **[YYYY-MM-DD HH:MM]** - [Event]
   - Covered: [What was documented]

2. **[YYYY-MM-DD HH:MM]** - [Event]
   - Covered: [What was documented]

[List key entries showing comprehensive logging]

### Spec Alignment

**Spec**: `spec.md`
- **Present**: ✅ Yes | ❌ No

**Alignment Check**:
- [x] All core requirements from spec appear in implementation-plan.md
- [x] Implementation plan steps align with spec sections
- [x] No major spec requirements missing from implementation

[If misalignment found]
⚠️ **Potential Misalignments**:
- Spec requirement: [requirement]
- Implementation: [how it was handled or missing]

### User Documentation

**Documentation**: `documentation/` folder

[If user-facing documentation required by spec]
- **Present**: ✅ Yes | ❌ No
- **Contents**:
  - [List documentation files found]
- **Completeness**: ✅ Matches implemented features | ⚠️ Incomplete | ❌ Missing

[If not required]
**N/A** - No user-facing documentation required for this task type.

### Assessment

[Provide assessment of documentation completeness]

Example:
"Documentation is comprehensive. Implementation plan is fully marked complete with all
12 steps checked off. Work log contains 8 detailed entries spanning 3 days, covering all
task groups, standards discovery, and implementation details. Spec alignment is verified
with all core requirements addressed. No user documentation required for this backend
feature."

---

## 5. Roadmap Updates

**Status**: ✅ Updated | ⚠️ No Matches | ❌ Issues | N/A - No Roadmap

[If roadmap exists and was updated]

### Roadmap File

**File**: `docs/project/roadmap.md`
- **Present**: ✅ Yes

### Updated Items

The following roadmap items were marked complete:

- [x] **[Roadmap item description]** - Completed [YYYY-MM-DD]
  - Matches: [How this relates to implemented task]

- [x] **[Roadmap item description]** - Completed [YYYY-MM-DD]
  - Matches: [How this relates to implemented task]

**Total Items Updated**: [N] items

[If roadmap exists but no matches]

### Roadmap File

**File**: `docs/project/roadmap.md`
- **Present**: ✅ Yes

### No Matching Items

**Status**: ⚠️ No matches found

**Analysis**: Reviewed roadmap but found no items clearly matching this task's
functionality. This may indicate:
- Task is not tracked in roadmap
- Roadmap uses different terminology
- Roadmap needs update with new entry for this task

[If no roadmap]

### Roadmap File

**File**: `docs/project/roadmap.md`
- **Present**: ❌ No

**Status**: N/A - No roadmap file found

**Note**: If project uses a roadmap, create one at `.ai-sdlc/docs/project/roadmap.md`
and add this task's functionality.

---

## 6. Overall Assessment

**Status**: ✅ Passed | ⚠️ Passed with Issues | ❌ Failed

### Summary

[Provide comprehensive summary of all verification aspects]

Example for ✅ Passed:
"This implementation successfully passes verification. All 12 planned steps are complete
across 3 task groups with code evidence confirming implementation. The full test suite
shows 100% pass rate (50/50 tests). Standards compliance is verified with 8 applicable
standards documented and applied. Documentation is comprehensive with detailed work log
and complete implementation plan. Roadmap updated with 2 completed items. This
implementation is ready for code review and commit."

Example for ⚠️ Passed with Issues:
"This implementation passes verification with minor issues requiring attention. All 12
steps are complete with verified implementation. Test suite shows 47/50 passing (94%)
with 3 minor failures in validation logic. Standards mostly compliant with 8 of 10
expected standards applied. Documentation is adequate but work log could be more
detailed. Issues are minor and do not block proceeding to code review, but should be
addressed before final merge."

Example for ❌ Failed:
"This implementation fails verification and requires additional work. Only 10 of 12 steps
are marked complete (83%), with 2 critical steps incomplete. Test suite shows 35/50
passing (70%) with 15 failures including critical functionality. Standards compliance is
questionable with only 3 of 10 expected standards documented. Work log is sparse with
minimal detail. This implementation needs completion and fixes before proceeding."

### Verification Breakdown

| Aspect | Status | Details |
|--------|--------|---------|
| Implementation Plan | ✅ / ⚠️ / ❌ | [M]/[N] steps ([percentage]%) |
| Test Suite | ✅ / ⚠️ / ❌ | [P]/[N] passing ([percentage]%) |
| Standards Compliance | ✅ / ⚠️ / ❌ | [N]/[M] standards applied |
| Documentation | ✅ / ⚠️ / ❌ | [Completeness level] |
| Roadmap | ✅ / ⚠️ / ❌ / N/A | [Update status] |

### Issues Requiring Attention

[If ✅ Passed]
None - no issues found.

[If ⚠️ or ❌]

**Critical Issues** (must fix):
- [List critical issues that block merging]

**Minor Issues** (should fix):
- [List minor issues that should be addressed]

**Optional Improvements** (nice to have):
- [List optional improvements]

### Recommendations

[Provide specific, actionable recommendations]

Example for ✅ Passed:
1. Proceed to code review
2. Create pull request with reference to this verification report
3. Schedule merge after code review approval

Example for ⚠️ Passed with Issues:
1. Address the 3 failing validation tests before merge
2. Add brief entry to work-log.md documenting test fixes
3. Consider adding accessibility standards documentation
4. Proceed to code review in parallel with minor fixes
5. Re-run verification after test fixes if significant changes made

Example for ❌ Failed:
1. Complete the 2 incomplete implementation steps (2.3, 3.4)
2. Fix the 15 failing tests, especially critical functionality
3. Review and apply missing standards from docs/INDEX.md
4. Add comprehensive work-log.md entries for all work
5. Re-run full verification after addressing issues
6. Do NOT proceed to code review until verification passes

---

## Verification Checklist

Verification process completion:

- [x] Implementation plan completion verified
- [x] Spot checks performed for code evidence
- [x] Full test suite executed and results documented
- [x] Standards compliance assessed against docs/INDEX.md
- [x] Work log reviewed for standards discovery evidence
- [x] Documentation completeness validated
- [x] Spec alignment checked
- [x] Roadmap checked and updated (if applicable)
- [x] Verification report created with all sections
- [x] Overall status determined and justified
- [x] Recommendations provided

**Verification Complete**: [YYYY-MM-DD HH:MM]

---

## Next Steps

[Based on overall status]

**Ready for**: [Code Review | Fixes Required | Re-Implementation]

[If ✅ Passed]
✅ This implementation is ready for code review and commit.

**Code Review Checklist**:
- Review implementation in `.ai-sdlc/tasks/[type]/[dated-name]/`
- Verify code quality and best practices
- Check for security concerns
- Validate error handling
- Approve for merge

[If ⚠️ Passed with Issues]
⚠️ This implementation can proceed with caution. Address minor issues before final merge.

**Action Items**:
1. [List specific actions from recommendations]
2. [Continue listing]
3. Consider re-running verification if changes are significant

[If ❌ Failed]
❌ This implementation requires additional work before code review.

**Required Actions**:
1. [List critical actions from recommendations]
2. [Continue listing]
3. **Re-run verification** after addressing all critical issues
```

## Field Descriptions

### Status Indicators

Use consistent status indicators throughout:

- **✅** - Passed, complete, no issues
- **⚠️** - Warning, minor issues, mostly complete
- **❌** - Failed, critical issues, incomplete
- **N/A** - Not applicable

### Overall Status Criteria

**✅ Passed** - All of:
- Implementation: 100% complete
- Tests: 95-100% passing with no critical failures
- Standards: Fully or mostly compliant
- Documentation: Complete or adequate

**⚠️ Passed with Issues** - Any of:
- Implementation: 90-99% complete
- Tests: 90-94% passing or minor failures
- Standards: Mostly compliant with gaps
- Documentation: Adequate but improvable

**❌ Failed** - Any of:
- Implementation: <90% complete
- Tests: <90% passing or critical failures
- Standards: Major compliance issues
- Documentation: Incomplete or missing

## Usage Guidelines

### Executive Summary

Keep it brief (2-3 sentences) but informative:
- Overall completion status
- Key metrics (test pass rate, etc.)
- Major findings
- Final verdict

### Evidence-Based Reporting

Always provide evidence:
- Test counts, not just "tests failing"
- File names and paths for spot checks
- Specific standards from docs/INDEX.md
- Quotes from work-log.md
- Concrete examples

### Actionable Recommendations

Make recommendations specific and actionable:
- ❌ Bad: "Fix tests"
- ✅ Good: "Fix the 3 failing validation tests in UserForm.test.tsx before merge"

- ❌ Bad: "Improve documentation"
- ✅ Good: "Add entry to work-log.md documenting accessibility standards applied to forms"

### Balanced Assessment

Be fair and balanced:
- Acknowledge what was done well
- Clearly identify issues
- Distinguish critical vs minor issues
- Provide context for findings

## Example Reports

### Example 1: ✅ Passed (Simple Feature)

```markdown
# Implementation Verification Report: Add Logout Button

**Status**: ✅ Passed

## Executive Summary

Implementation of logout button feature completed successfully. All 4 steps across 1 task
group are complete with verified implementation. Full test suite shows 100% pass rate
(53/53 tests including 3 new feature tests). Standards compliant with 4 applicable
standards documented and applied. Documentation complete with comprehensive work log.
Ready for code review.

## 1. Implementation Plan Verification

**Status**: ✅ Complete

- **Completion**: 4/4 steps (100%)
- All steps verified with spot check finding LogoutButton component and tests

## 2. Test Suite Results

**Status**: ✅ All Passing

- **Total**: 53 tests
- **Passing**: 53 (100%)
- **Feature Tests**: 3 new tests, all passing

## 3. Standards Compliance

**Status**: ✅ Fully Compliant

- Applied 4 standards: naming-conventions, components, styling, unit-tests
- All documented in work-log.md

## 4. Documentation Completeness

**Status**: ✅ Complete

- Implementation plan: 100% complete
- Work log: 4 entries, comprehensive
- Spec alignment: Verified

## 5. Roadmap Updates

**Status**: N/A - No roadmap file

## 6. Overall Assessment

**Status**: ✅ Passed

Ready for code review and commit.
```

### Example 2: ⚠️ Passed with Issues (Standard Feature)

```markdown
# Implementation Verification Report: User Profile Editing

**Status**: ⚠️ Passed with Issues

## Executive Summary

Implementation of user profile editing is substantially complete. All 12 steps across 3
task groups are complete with verified implementation. Test suite shows 47/50 passing
(94%) with 3 minor validation failures. Standards mostly compliant with 8 of 10 expected
standards applied. Documentation adequate but could include more detail on accessibility
approach. Minor issues should be addressed before final merge.

[Full detailed sections...]

## 6. Overall Assessment

**Status**: ⚠️ Passed with Issues

### Issues Requiring Attention

**Minor Issues**:
- 3 validation tests failing (edge cases in email validation)
- Accessibility standards applied but not documented in work-log.md

### Recommendations

1. Fix the 3 failing validation tests in UserProfileForm.test.tsx
2. Add work-log.md entry documenting accessibility standards applied
3. Proceed to code review in parallel with fixes
```

## Summary

The verification report is a comprehensive QA document that:
- Provides evidence of implementation quality
- Documents all verification findings
- Makes clear recommendations
- Creates audit trail for posterity
- Enables informed decisions about readiness

Use this template consistently to ensure thorough, professional verification reporting.
