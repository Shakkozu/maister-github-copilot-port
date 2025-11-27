# Progress Tracking Best Practices

This reference explains why and how to mark steps complete in implementation-plan.md during implementation.

## Why Mark Steps Complete

Marking steps complete in implementation-plan.md is **critical** for:

### 1. Progress Visibility
- See at a glance what's done vs pending
- Track completion percentage
- Identify bottlenecks or stuck steps
- Show measurable progress

### 2. Workflow Resumption
- Resume after interruptions (computer restart, breaks, errors)
- Pick up exactly where you left off
- No need to remember what was done
- State preserved across sessions

### 3. Verification Phase
- Verification phase checks all steps are complete
- Blocking validation ensures nothing was skipped
- Audit trail for quality assurance
- Proof of completion for reviewers

### 4. Audit Trail
- Document execution history for review
- Show which steps were completed when
- Provide evidence for code reviews
- Track how long implementation took

### 5. Team Coordination
- Other team members can see progress
- Handoff between team members easier
- Parallel work doesn't conflict
- Clear communication of status

## Checkbox Format

### Standard Format

**Before completion**:
```markdown
- [ ] 2.3 Implement user authentication
```

**After completion**:
```markdown
- [x] 2.3 Implement user authentication
```

### Important Notes

- ✅ Use lowercase `x`: `[x]` (correct)
- ❌ NOT uppercase `X`: `[X]` (incorrect)
- ❌ NOT checkmark: `[✓]` (incorrect)
- ❌ NOT asterisk: `[*]` (incorrect)

### Task Group Headers

Mark the group header (`X.0`) **only after** ALL steps in group are complete:

**Example**:
```markdown
- [x] 2.0 Complete API layer
  - [x] 2.1 Write 2-8 focused tests for API endpoints
  - [x] 2.2 Create resource controller
  - [x] 2.3 Implement authentication/authorization
  - [x] 2.4 Add error handling
  - [x] 2.5 Ensure API layer tests pass
```

**Do NOT** mark group header if any steps are incomplete:
```markdown
- [ ] 2.0 Complete API layer  ❌ Wrong - not all steps done
  - [x] 2.1 Write 2-8 focused tests for API endpoints
  - [x] 2.2 Create resource controller
  - [ ] 2.3 Implement authentication/authorization  ← Still pending
  - [ ] 2.4 Add error handling  ← Still pending
  - [ ] 2.5 Ensure API layer tests pass  ← Still pending
```

## How to Mark Steps

### Using Edit Tool

**Recommended approach** for updating checkboxes:

```
Edit tool:
file_path: .ai-sdlc/tasks/new-features/2025-10-27-auth/implementation-plan.md
old_string: "- [ ] 2.3 Implement user authentication"
new_string: "- [x] 2.3 Implement user authentication"
```

**Process**:
1. Read implementation-plan.md to get exact string
2. Copy the step line exactly (including spacing)
3. Use Edit tool to replace `[ ]` with `[x]`
4. Verify by reading the file again

### Multiple Steps at Once

If marking multiple steps (e.g., after completing a task group):

```
Edit tool:
file_path: .ai-sdlc/tasks/new-features/2025-10-27-auth/implementation-plan.md
old_string: "- [ ] 2.0 Complete API layer
  - [ ] 2.1 Write 2-8 focused tests for API endpoints
  - [ ] 2.2 Create resource controller"
new_string: "- [x] 2.0 Complete API layer
  - [x] 2.1 Write 2-8 focused tests for API endpoints
  - [x] 2.2 Create resource controller"
```

**Note**: Only do this after ALL the work is actually done. Never mark ahead.

## When to Mark

Timing is critical - mark steps **immediately** after completion.

### Mode 1: Direct Execution

**Mark**: IMMEDIATELY after completing each step
**Before**: Moving to next step
**Validate**: Checkbox is marked before proceeding

**Example flow**:
1. Complete step 2.3 (write code, run tests)
2. **IMMEDIATELY mark** `- [x] 2.3`
3. Verify checkbox is marked
4. Log in work-log.md
5. **THEN** move to step 2.4

### Mode 2: Plan-Execute

**Mark**: After applying each change from plan
**Before**: Running tests for that change
**Log**: Document marking in work-log.md

**Example flow**:
1. Apply change for step 2.3
2. **IMMEDIATELY mark** `- [x] 2.3`
3. Verify checkbox is marked
4. Log the change
5. Run tests for 2.3
6. **THEN** apply next change

### Mode 3: Orchestrated

**Mark**: All steps in group after group completes
**Before**: Running incremental tests for group
**Validate**: All group checkboxes marked

**Example flow**:
1. Complete all steps in Task Group 2
2. **IMMEDIATELY mark all**: `- [x] 2.0`, `- [x] 2.1`, `- [x] 2.2`, etc.
3. Validate all checkboxes in group
4. Log group completion
5. Run group tests
6. **THEN** move to Task Group 3

## Validation Commands

### Check for Unmarked Steps

```bash
# Show all unmarked steps
grep "- \[ \]" implementation-plan.md
```

**Expected output if incomplete**:
```
  - [ ] 2.3 Implement authentication/authorization
  - [ ] 2.4 Add error handling
```

**Expected output if complete**:
```
(no output - all steps marked)
```

### Count Completion Progress

```bash
# Count total and completed steps
total=$(grep -c "^  - \[" implementation-plan.md)
completed=$(grep -c "^  - \[x\]" implementation-plan.md)
percentage=$((completed * 100 / total))

echo "Progress: $completed/$total steps complete ($percentage%)"
```

**Example output**:
```
Progress: 12/15 steps complete (80%)
```

### Verify Specific Task Group Complete

```bash
# Check Task Group 2 for unmarked steps
sed -n "/### Task Group 2/,/### Task Group 3/p" implementation-plan.md | grep "- \[ \]"
```

**Expected output if group complete**:
```
(no output - all steps marked)
```

**Expected output if group incomplete**:
```
  - [ ] 2.3 Implement authentication
  - [ ] 2.4 Add error handling
```

### Validate Before Finalization

```bash
# Comprehensive validation (same as Phase 3 validation)
unmarked=$(grep -c "^  - \[ \]" implementation-plan.md || echo "0")
unmarked_headers=$(grep -c "^- \[ \] [0-9]\.0" implementation-plan.md || echo "0")

if [ "$unmarked" -gt "0" ] || [ "$unmarked_headers" -gt "0" ]; then
  echo "❌ Validation failed - $unmarked steps and $unmarked_headers headers unmarked"
  exit 1
else
  echo "✅ Validation passed - all steps marked complete"
fi
```

## Common Mistakes

### ❌ Mistake 1: Forgetting to Mark

**Problem**: Steps complete but checkboxes unchecked

**Example**:
```markdown
- [ ] 2.3 Implement authentication  ← Actually done but not marked
```

**Solution**: Go back through implementation-plan.md and mark all completed steps

### ❌ Mistake 2: Batch Marking

**Problem**: Marking multiple steps at once without actually doing the work

**Example**:
```markdown
- [x] 2.3 Implement authentication  ← Marked ahead but not done yet
- [x] 2.4 Add error handling  ← Marked ahead but not done yet
```

**Solution**: Only mark steps AFTER completing the work, one at a time

### ❌ Mistake 3: Wrong Format

**Problem**: Using incorrect checkbox format

**Examples**:
```markdown
- [X] 2.3 Implement authentication  ❌ Uppercase X
- [✓] 2.3 Implement authentication  ❌ Checkmark symbol
- [*] 2.3 Implement authentication  ❌ Asterisk
```

**Solution**: Always use lowercase `x`: `[x]`

### ❌ Mistake 4: Marking Too Early

**Problem**: Marking before actually completing the work

**Example**:
```markdown
- [x] 2.3 Implement authentication  ← Marked but tests are still failing
```

**Solution**: Only mark after work is complete AND tests pass

### ❌ Mistake 5: Skipping Group Headers

**Problem**: Marking steps but not group headers

**Example**:
```markdown
- [ ] 2.0 Complete API layer  ← Not marked
  - [x] 2.1 Write tests  ← All steps marked
  - [x] 2.2 Create controller
  - [x] 2.3 Implement auth
```

**Solution**: Mark group header after ALL steps in group are complete

### ❌ Mistake 6: Inconsistent Spacing

**Problem**: Checkbox spacing doesn't match original format

**Example**:
```markdown
Original: - [ ] 2.3 Implement authentication
Wrong:    -[x] 2.3 Implement authentication  ❌ No space after -
Wrong:    - [x]2.3 Implement authentication  ❌ No space after [x]
Correct:  - [x] 2.3 Implement authentication  ✅
```

**Solution**: Maintain exact spacing: `- [x] `

## Best Practices

### ✅ Practice 1: Mark Immediately

**Do**: Update checkbox right after completing step

```
1. Write code for step 2.3
2. Run tests for step 2.3
3. Tests pass
4. ← IMMEDIATELY mark checkbox
5. Log in work-log.md
6. Move to step 2.4
```

**Don't**: Wait to mark multiple steps at end

### ✅ Practice 2: One at a Time

**Do**: Mark each step individually as you complete it

```
✅ Complete step 2.1 → Mark [x] → Log → Continue
✅ Complete step 2.2 → Mark [x] → Log → Continue
✅ Complete step 2.3 → Mark [x] → Log → Continue
```

**Don't**: Mark all at once after completing multiple steps

### ✅ Practice 3: Validate After Marking

**Do**: Confirm checkbox is marked before proceeding

```
1. Edit implementation-plan.md
2. Change [ ] to [x]
3. Save file
4. Read implementation-plan.md
5. ← Verify checkbox shows [x]
6. Continue to next step
```

**Don't**: Assume it worked without verifying

### ✅ Practice 4: Consistent Format

**Do**: Always use exactly `[x]` (lowercase x)

**Don't**: Use variations like `[X]`, `[✓]`, `[*]`, `[done]`

### ✅ Practice 5: Group Completion

**Do**: Mark group header only after ALL steps done

```
1. Complete all steps in group (2.1, 2.2, 2.3, 2.4, 2.5)
2. Verify all step checkboxes marked
3. ← THEN mark group header [x]
```

**Don't**: Mark group header before all steps are complete

### ✅ Practice 6: Sync with Work Log

**Do**: Document in work-log.md when you mark complete

```markdown
## [2025-10-27 14:30] - Step 2.3 Complete

Implemented user authentication with JWT tokens.

Files modified:
- src/auth/auth.controller.ts
- src/auth/jwt.strategy.ts

Tests: 4 tests written, all passing

Status: ✅ Marked complete in implementation-plan.md
```

**Don't**: Mark checkbox without logging the work

## Troubleshooting

### Problem: "Steps not marked but work is done"

**Symptoms**:
- Implementation complete
- All code written and tests passing
- But implementation-plan.md still shows `- [ ]`

**Solution**:
1. Review work-log.md to see what was completed
2. Go through implementation-plan.md systematically
3. Mark each completed step: `- [ ]` → `- [x]`
4. Validate using: `grep "- \[ \]" implementation-plan.md`
5. If no output, all steps marked

### Problem: "Can't remember which steps were completed"

**Symptoms**:
- Workflow was interrupted
- Can't recall which steps were done
- work-log.md not detailed enough

**Solution**:
1. Review code changes: `git diff` or `git log`
2. Check which files were modified recently
3. Compare with implementation-plan.md steps
4. Mark steps that correspond to modified files
5. Test to verify functionality works

### Problem: "Edit tool not working"

**Symptoms**:
- Edit tool says "string not found"
- Can't update checkbox

**Solution**:
1. Read implementation-plan.md first
2. Copy EXACT string including all spacing
3. Verify string matches exactly (no extra/missing spaces)
4. Use Edit tool with exact match
5. If still fails, check file path is correct

**Example**:
```bash
# Read to get exact format
Read implementation-plan.md

# Look for line with spacing:
"  - [ ] 2.3 Implement authentication"
  ^^ Two spaces before dash

# Use exact format in Edit:
old_string: "  - [ ] 2.3 Implement authentication"
new_string: "  - [x] 2.3 Implement authentication"
```

### Problem: "Validation failing at finalization"

**Symptoms**:
- Phase 3 validation fails
- Shows unmarked steps
- Can't proceed to finalization

**Solution**:
1. Read the validation output carefully
2. Note which steps are unmarked (line numbers shown)
3. Mark each unmarked step manually
4. Re-run finalization
5. Validation should pass

**Example output**:
```
❌ VALIDATION FAILED

Found 3 unmarked steps:

234:  - [ ] 2.3 Implement authentication
245:  - [ ] 3.1 Write frontend tests
267:  - [ ] 4.2 Add documentation

🔧 Action Required:
1. Mark these 3 steps complete
2. Re-run finalization
```

**Fix**:
```
1. Edit line 234: - [x] 2.3 Implement authentication
2. Edit line 245: - [x] 3.1 Write frontend tests
3. Edit line 267: - [x] 4.2 Add documentation
4. Run finalization again
5. ✅ Validation passes
```

### Problem: "Group header validation failing"

**Symptoms**:
- All steps marked
- But group headers still show `- [ ] X.0`
- Finalization validation fails

**Solution**:
1. Identify which group headers are unmarked
2. Verify ALL steps in those groups are marked
3. Mark the group headers
4. Format: `- [x] X.0 Complete [specialty] layer`

**Example**:
```markdown
Before:
- [ ] 2.0 Complete API layer  ← Not marked
  - [x] 2.1 Write tests
  - [x] 2.2 Create controller
  - [x] 2.3 Implement auth
  - [x] 2.4 Add error handling
  - [x] 2.5 Ensure tests pass

After:
- [x] 2.0 Complete API layer  ← Now marked
  - [x] 2.1 Write tests
  - [x] 2.2 Create controller
  - [x] 2.3 Implement auth
  - [x] 2.4 Add error handling
  - [x] 2.5 Ensure tests pass
```

## Summary

**Critical Points**:
1. ✅ Mark steps IMMEDIATELY after completion
2. ✅ Use exact format: `- [x]` (lowercase x)
3. ✅ Validate checkbox is marked before proceeding
4. ✅ Mark group headers ONLY after all steps done
5. ✅ Document marking in work-log.md
6. ✅ Final validation in Phase 3 is BLOCKING
7. ✅ Cannot proceed without all checkboxes marked

**Remember**: Marking checkboxes is as important as writing code. It's not optional - it's mandatory for successful implementation tracking and verification.
