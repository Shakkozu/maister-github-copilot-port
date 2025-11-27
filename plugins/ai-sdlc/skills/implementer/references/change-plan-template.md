# Change Plan Template

This template defines the expected output format when the implementation-changes-planner subagent creates change plans.

## Purpose

The change plan is a **structured markdown document** that describes all file changes needed to implement a task group or full implementation plan. It is created by the subagent and applied by the main agent.

**Important**: The subagent creates this plan as markdown output. The subagent does NOT make any file changes. The main implementer agent reads this plan and applies the changes using Edit/Write tools.

## Template Structure

```markdown
# Change Plan: [Task Name]

**Generated**: [YYYY-MM-DD HH:MM]
**Task Path**: [.ai-sdlc/tasks/type/dated-name/]
**Task Groups**: [N]
**Total Changes**: [X file modifications]

## Standards Applied

Based on docs/INDEX.md and standards files:

- **Global Standards**: [List from .ai-sdlc/docs/standards/global/]
- **Area Standards**: [List from .ai-sdlc/docs/standards/[area]/]
- **Project Guidelines**: [Any from docs/project/]

### Standards Discovery Notes

[Document any standards discovered during planning that weren't obvious initially]

Example:
- global/accessibility.md - Discovered when analyzing form implementation
- backend/external-services.md - Discovered when planning email integration

---

## Task Group 1: [Group Name]

**Dependencies**: [None / Task Group X]
**Steps**: [N]
**Tests**: [2-8 focused tests]

### Step 1.1: Write Tests for [Component]

**Action**: Create test file and write 2-8 focused tests

**File**: `[path/to/test-file]`

**Changes**:
```[language]
// NEW FILE - Create with this content

import { describe, it, expect } from '[test-framework]';
import { [Component] } from '[path]';

describe('[Component]', () => {
  it('[test description 1]', () => {
    // Test implementation
    expect([assertion]).toBe([expected]);
  });

  it('[test description 2]', () => {
    // Test implementation
    expect([assertion]).toBe([expected]);
  });

  // ... 2-8 total tests
});
```

**Standards Applied**:
- testing/unit-tests.md - Test structure and naming
- testing/assertions.md - Assertion patterns

**Rationale**: Following test-driven approach from implementation-plan.md. Writing tests first ensures clear requirements before implementation.

---

### Step 1.2: Implement [Feature]

**Action**: Create or modify file to implement feature

**File**: `[path/to/implementation-file]`

**Changes**:

**Option A - New File**:
```[language]
// NEW FILE - Create with this content

[complete file content]
```

**Option B - Modify Existing File**:
```[language]
// FIND in [path/to/file]:
[exact text to find - must be unique]

// REPLACE WITH:
[new text to replace it with]

// RATIONALE: [Why this change]
// STANDARDS: [Standards applied to this change]
```

**Standards Applied**:
- [List specific standards applied to this change]
- [With relevant section references]

**Rationale**: [Explain why this implementation approach, how it aligns with spec.md, how it follows discovered standards]

**Reusability**: [If reusing existing components/patterns, note them here]

---

### Step 1.3: [Additional Implementation Step]

[Repeat structure from Step 1.2]

---

### Step 1.n: Verify Tests Pass

**Action**: Run the 2-8 tests written in Step 1.1

**Command**: `[test command to run only these tests]`

**Expected Result**: All [N] tests passing

**Standards Applied**:
- testing/verification.md - Test execution approach

**Rationale**: Incremental verification ensures this task group works before proceeding. Do NOT run entire test suite yet.

---

## Task Group 2: [Next Group Name]

**Dependencies**: Task Group 1
**Steps**: [N]
**Tests**: [2-8 focused tests]

[Repeat structure from Task Group 1]

---

## Implementation Order

Execute task groups in this sequence:

1. **Task Group 1: [Name]**
   - No dependencies
   - Can start immediately
   - Expected duration: [estimate]

2. **Task Group 2: [Name]**
   - Depends on: Task Group 1
   - Start after Task Group 1 tests pass
   - Expected duration: [estimate]

3. **Task Group 3: [Name]**
   - Depends on: Task Group 2
   - Start after Task Group 2 tests pass
   - Expected duration: [estimate]

[Continue for all task groups]

---

## File Manifest

Complete list of files to be modified or created:

### New Files
- `[path/to/new-file-1]` - [Purpose]
- `[path/to/new-file-2]` - [Purpose]

### Modified Files
- `[path/to/modified-file-1]` - [Changes summary]
- `[path/to/modified-file-2]` - [Changes summary]

### Test Files
- `[path/to/test-file-1]` - [Tests for component 1]
- `[path/to/test-file-2]` - [Tests for component 2]

**Total**: [X] new files, [Y] modified files, [Z] test files

---

## Standards Compliance Checklist

Verify these standards have been applied throughout the plan:

### Global Standards
- [ ] naming-conventions.md - File names, variables, functions
- [ ] code-organization.md - File structure and imports
- [ ] comments-documentation.md - Code comments and docs
- [ ] error-handling.md - Error handling patterns
- [ ] [Other global standards]

### Area-Specific Standards
- [ ] [area]/[standard].md - [What was applied]
- [ ] [area]/[standard].md - [What was applied]

### Project Guidelines
- [ ] [guideline from docs/project/] - [What was applied]

---

## Test Strategy

### Test-Driven Approach

Each task group follows this pattern:
1. Write 2-8 focused tests (Step X.1)
2. Implement functionality (Steps X.2 through X.n-1)
3. Run only those 2-8 tests (Step X.n)

### Expected Test Count

- Task Group 1: [2-8] tests
- Task Group 2: [2-8] tests
- Task Group 3: [2-8] tests
- [Additional groups]
- Testing Group (if exists): [max 10] additional tests

**Total Expected**: [16-34] tests for this feature

### Incremental Verification

- Do NOT run entire test suite after each task group
- Run only the new tests for that group
- Full feature test suite runs in final Testing Group (if exists)
- This keeps feedback fast and focused

---

## Notes for Main Agent

### Applying This Plan

**For Each Change**:
1. Check standards again before applying (continuous discovery)
2. Read existing file if modifying (understand context)
3. Apply change exactly as specified in plan
4. Verify change aligns with standards
5. Mark step complete in implementation-plan.md
6. Log change in implementation/work-log.md

### If Changes Needed

If you discover issues while applying the plan:
1. Note the issue
2. Check docs/INDEX.md for relevant standards
3. Adjust the change to align with standards
4. Document the adjustment in work-log.md
5. Continue with adjusted approach

### Continuous Standards Discovery

Even though this plan applied standards, you should:
1. Re-check docs/INDEX.md before each task group
2. Re-read relevant standards before applying changes
3. Discover any standards missed during planning
4. Apply newly discovered standards
5. Document all standards applied

**Remember**: Not all standards are obvious during planning. Continue discovering throughout application.

---

## Summary

**Scope**: [Brief summary of what this plan implements]

**Approach**: [High-level approach - test-driven, follows spec, applies standards]

**Standards**: Applied [X] standards from .ai-sdlc/docs/standards/

**Testing**: [N] focused tests across task groups, incremental verification

**Execution**: Main agent applies all changes following this plan

**Duration**: Estimated [timeframe] for full implementation

Ready for main agent to apply!
```

## Usage Examples

### Example 1: Simple Feature (4 steps, 1 task group)

```markdown
# Change Plan: Add User Logout Button

**Generated**: 2025-10-24 14:30
**Task Path**: .ai-sdlc/tasks/new-features/2025-10-24-logout-button/
**Task Groups**: 1
**Total Changes**: 3 file modifications

## Standards Applied

- global/naming-conventions.md - Component naming
- frontend/components.md - Component structure
- frontend/styling.md - Button styling
- testing/unit-tests.md - Component testing

---

## Task Group 1: Frontend Implementation

**Dependencies**: None
**Steps**: 4
**Tests**: 3 focused tests

### Step 1.1: Write Tests for LogoutButton

**Action**: Create test file and write 3 focused tests

**File**: `src/components/LogoutButton/LogoutButton.test.tsx`

**Changes**:
```typescript
// NEW FILE

import { render, screen, fireEvent } from '@testing-library/react';
import { LogoutButton } from './LogoutButton';
import { useAuth } from '@/hooks/useAuth';

jest.mock('@/hooks/useAuth');

describe('LogoutButton', () => {
  it('renders logout button with correct text', () => {
    render(<LogoutButton />);
    expect(screen.getByText('Logout')).toBeInTheDocument();
  });

  it('calls logout handler when clicked', () => {
    const mockLogout = jest.fn();
    (useAuth as jest.Mock).mockReturnValue({ logout: mockLogout });

    render(<LogoutButton />);
    fireEvent.click(screen.getByText('Logout'));

    expect(mockLogout).toHaveBeenCalledTimes(1);
  });

  it('disables button while logout is in progress', async () => {
    const mockLogout = jest.fn(() => new Promise(resolve => setTimeout(resolve, 100)));
    (useAuth as jest.Mock).mockReturnValue({ logout: mockLogout });

    render(<LogoutButton />);
    const button = screen.getByText('Logout');

    fireEvent.click(button);
    expect(button).toBeDisabled();
  });
});
```

**Standards Applied**:
- testing/unit-tests.md - Test structure, describe/it blocks
- testing/mocking.md - Mocking useAuth hook

---

### Step 1.2: Create LogoutButton Component

**Action**: Create component file

**File**: `src/components/LogoutButton/LogoutButton.tsx`

**Changes**:
```typescript
// NEW FILE

import { useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/Button';

export function LogoutButton() {
  const { logout } = useAuth();
  const [isLoggingOut, setIsLoggingOut] = useState(false);

  const handleLogout = async () => {
    setIsLoggingOut(true);
    try {
      await logout();
    } finally {
      setIsLoggingOut(false);
    }
  };

  return (
    <Button
      onClick={handleLogout}
      disabled={isLoggingOut}
      variant="secondary"
    >
      {isLoggingOut ? 'Logging out...' : 'Logout'}
    </Button>
  );
}
```

**Standards Applied**:
- global/naming-conventions.md - Component and function names in PascalCase/camelCase
- frontend/components.md - Component structure, hooks at top
- frontend/state-management.md - Local state for loading
- global/error-handling.md - Try-finally for cleanup

**Reusability**: Uses existing Button component from ui library

---

### Step 1.3: Add LogoutButton to Navigation

**Action**: Modify navigation to include logout button

**File**: `src/components/Navigation/Navigation.tsx`

**Changes**:
```typescript
// FIND:
import { Link } from '@/components/ui/Link';
import { useAuth } from '@/hooks/useAuth';

// REPLACE WITH:
import { Link } from '@/components/ui/Link';
import { LogoutButton } from '@/components/LogoutButton/LogoutButton';
import { useAuth } from '@/hooks/useAuth';
```

```typescript
// FIND:
      {user && (
        <div className="user-menu">
          <span>Welcome, {user.name}</span>
        </div>
      )}

// REPLACE WITH:
      {user && (
        <div className="user-menu">
          <span>Welcome, {user.name}</span>
          <LogoutButton />
        </div>
      )}
```

**Standards Applied**:
- global/code-organization.md - Import grouping
- frontend/components.md - Conditional rendering

---

### Step 1.4: Verify Tests Pass

**Action**: Run the 3 tests written in Step 1.1

**Command**: `npm test LogoutButton.test.tsx`

**Expected Result**: All 3 tests passing

---

## File Manifest

### New Files
- `src/components/LogoutButton/LogoutButton.tsx` - Logout button component
- `src/components/LogoutButton/LogoutButton.test.tsx` - Component tests

### Modified Files
- `src/components/Navigation/Navigation.tsx` - Added logout button

**Total**: 2 new files, 1 modified file

Ready for main agent to apply!
```

### Example 2: Complex Feature (12 steps, 3 task groups)

```markdown
# Change Plan: User Profile Editing

**Generated**: 2025-10-24 15:00
**Task Path**: .ai-sdlc/tasks/new-features/2025-10-24-profile-editing/
**Task Groups**: 3
**Total Changes**: 8 file modifications

## Standards Applied

- global/naming-conventions.md
- global/error-handling.md
- backend/database.md
- backend/api.md
- frontend/components.md
- frontend/forms.md
- frontend/validation.md
- global/accessibility.md (discovered during form planning)
- testing/integration-tests.md

### Standards Discovery Notes

- **global/accessibility.md**: Discovered when planning form implementation. Applied ARIA labels and keyboard navigation to profile form.

---

## Task Group 1: Database Layer

[Full task group with steps 1.1 through 1.4]

---

## Task Group 2: API Layer

[Full task group with steps 2.1 through 2.5]

---

## Task Group 3: Frontend Layer

[Full task group with steps 3.1 through 3.6]

---

## Implementation Order

[Detailed execution sequence]

---

[Continue with all remaining sections]
```

## Key Points

1. **Structured Format**: Consistent structure makes plans easy to follow
2. **Standards Documentation**: All applied standards listed and explained
3. **Discovery Notes**: Document standards discovered during planning
4. **Exact Changes**: Precise FIND/REPLACE or NEW FILE specifications
5. **Rationale**: Explain why each change
6. **Test-Driven**: Follow test-first pattern from implementation-plan.md
7. **Incremental Verification**: Run only new tests after each group
8. **File Manifest**: Complete list of changes for transparency
9. **Main Agent Guidance**: Notes on how to apply the plan
10. **Continuous Discovery**: Reminder to keep checking standards

## Output Requirements

When creating a change plan, the subagent must:

- ✓ Use this exact template structure
- ✓ List ALL standards applied with sources
- ✓ Document standards discovered during planning
- ✓ Provide exact FIND/REPLACE text or full file content
- ✓ Include rationale for each change
- ✓ Follow test-driven approach (tests → implement → verify)
- ✓ Specify incremental test execution
- ✓ Create complete file manifest
- ✓ Add notes for main agent on continuous standards discovery
- ✗ NOT make any file changes (plan only)
- ✗ NOT invoke tools to modify files
- ✗ NOT skip standards compliance documentation

The main implementer agent will read this plan and apply all changes using appropriate tools (Edit, Write, Bash for tests, etc.).
