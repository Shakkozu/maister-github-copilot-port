# Enhancement Workflow

Complete guide to enhancing existing features using the AI SDLC plugin's enhancement orchestrator.

## Overview

The enhancement workflow is designed for improving, extending, or modifying existing features. Unlike new feature development, enhancements start by analyzing the existing implementation, identifying gaps, and ensuring backward compatibility.

**When to use this workflow:**
- Improving existing features
- Adding capabilities to existing functionality
- Extending current features
- Modifying existing behavior (with compatibility)

**When NOT to use this workflow:**
- Building completely new features → Use [Feature Development](feature-development.md)
- Fixing bugs → Use [Bug Fixing](bug-fixing.md)
- Refactoring without adding features → Use [Refactoring](refactoring.md)

## Quick Start

```bash
# Interactive mode
/ai-sdlc:enhancement:new "Add sorting and filtering to user table"

# YOLO mode
/ai-sdlc:enhancement:new "Add export to CSV" --yolo
```

## Key Differences from Feature Development

| Aspect | Enhancement | Feature Development |
|--------|-------------|-------------------|
| **Starting Point** | Analyzes existing feature first | Starts from scratch |
| **Focus** | Gap analysis + compatibility | Requirements + implementation |
| **Testing** | Targeted regression (30-70% suite) | Full test suite |
| **Phases** | 6 phases | 6-7 phases |
| **Risk** | Backward compatibility critical | Fresh implementation |

## Workflow Phases

### Phase 0: Existing Feature Analysis

**Duration**: 20-30 minutes
**Purpose**: Understand current implementation before enhancement

**What happens:**
1. **Multi-Strategy Search** - Finds existing feature files using:
   - Filename patterns
   - Code pattern search
   - Confidence scoring

2. **Analyzes Existing Implementation**:
   - Functionality currently implemented
   - Dependencies and integrations
   - Test coverage
   - Code complexity

**Outputs:**
```
analysis/
└── existing-feature-analysis.md
```

**Why this matters**: Can't enhance what you don't understand. This phase ensures you know what exists before modifying it.

---

### Phase 1: Gap Analysis

**Duration**: 25-35 minutes
**Purpose**: Identify what's missing and how to add it without breaking existing functionality

**What happens:**

1. **Compare Current vs Desired State**
2. **Classify Enhancement Type**:
   - **Additive**: Adding new capabilities (safest)
   - **Modificative**: Changing existing behavior (medium risk)
   - **Refactor-Based**: Restructuring while adding features (highest risk)

3. **User Journey Impact Assessment**:
   - How users currently discover/access the feature
   - How enhancement changes user workflows
   - Discoverability scoring (1-10 scale)
   - Multi-persona analysis

4. **Data Entity Lifecycle Analysis**:
   - **Three-Layer Verification**:
     - Backend capability (API exists)
     - UI component (component renders)
     - User accessibility (users can actually reach it)
   - Detects orphaned features (e.g., display without input, input without display)
   - Ensures complete CRUD lifecycle

**Outputs:**
```
analysis/
├── gap-analysis.md
└── user-journey-impact.md
```

**Example gap analysis:**
```markdown
# Gap Analysis

## Current State
User table displays 50 users per page, no sorting, no filtering

## Desired State
User table with:
- Sorting by name, email, created_at
- Filtering by status, role
- Export to CSV

## Enhancement Type
**Additive** (adding capabilities to existing table)
Risk: Low

## Gaps Identified

### Backend
- ❌ Missing: Sort query parameters
- ❌ Missing: Filter query parameters
- ❌ Missing: CSV export endpoint
- ✅ Existing: Pagination working

### Frontend
- ❌ Missing: Sort UI controls
- ❌ Missing: Filter dropdowns
- ❌ Missing: Export button
- ✅ Existing: Table component reusable

### User Journey
Current: Users → Dashboard → Users List
New: Users → Dashboard → Users List → Sort/Filter/Export

**Discoverability**: 9/10 (Controls next to existing table)

## Data Lifecycle
Entity: User List

- ✅ Backend: GET /api/users (exists)
- ✅ UI Component: UserTable (exists)
- ✅ User Access: Dashboard → Users (accessible)
- ❌ Sort Backend: Need to add
- ❌ Sort UI: Need to add
- ❌ Filter Backend: Need to add
- ❌ Filter UI: Need to add

**Lifecycle Complete**: No (missing sort/filter functionality)
```

---

### Phase 2: Specification

**Duration**: 20-30 minutes
**Similar to feature development**: Creates spec.md

**Key difference**: Spec includes:
- Current behavior (baseline)
- Enhancement changes
- Backward compatibility requirements

---

### Phase 3: Implementation Planning

**Duration**: 20-30 minutes
**Similar to feature development**: Creates implementation-plan.md

**Key difference**: Plan identifies:
- Which existing code to modify
- Which new code to add
- Backward compatibility tests

---

### Phase 4: Implementation

**Duration**: 1-3 hours
**Similar to feature development**: Executes plan with TDD

**Key difference**:
- Checks existing tests still pass
- Adds new tests for enhancement
- Preserves existing behavior

---

### Phase 5: Compatibility Verification

**Duration**: 30-45 minutes
**Purpose**: Ensure enhancement doesn't break existing functionality

**What happens:**

1. **Run Targeted Regression Tests**
   - Not full suite (too slow)
   - 30-70% of suite (affected areas)
   - Identifies tests related to enhanced feature

2. **Verify Backward Compatibility**:
   - Existing API endpoints still work
   - Existing UI still functional
   - No breaking changes

3. **Compare Before/After**:
   - Functionality before enhancement
   - Functionality after enhancement
   - Verify additive (not destructive)

**Outputs:**
```
verification/
├── enhancement-verification.md
└── compatibility-report.md
```

**Compatibility report:**
```markdown
# Compatibility Verification

## Overall Status: ✅ COMPATIBLE

## Backward Compatibility
✅ Existing pagination works
✅ Existing API endpoints unchanged
✅ Existing UI displays correctly
✅ No breaking changes detected

## Regression Testing
**Tests Run**: 142/487 (29% - targeted)
**Passing**: 142/142 (100%)

Targeted areas:
- User API endpoints: 48 tests ✓
- User table component: 34 tests ✓
- User list page: 28 tests ✓
- Pagination: 18 tests ✓
- User permissions: 14 tests ✓

## New Functionality
✅ Sorting works (6 tests)
✅ Filtering works (8 tests)
✅ CSV export works (4 tests)

## Deployment Recommendation
🟢 **GO** - Enhancement complete, backward compatible
```

---

## Enhancement Types

### Additive (Lowest Risk)

**Characteristics**:
- Adds new capabilities
- Doesn't change existing behavior
- Safest enhancement type

**Example**: Add export button to existing table

**Testing**: Focus on new functionality + light regression

### Modificative (Medium Risk)

**Characteristics**:
- Changes existing behavior
- May affect current users
- Requires careful testing

**Example**: Change table layout from list to grid

**Testing**: Heavy regression testing required

### Refactor-Based (Highest Risk)

**Characteristics**:
- Restructures code while adding features
- Changes implementation significantly
- Highest complexity

**Example**: Rewrite table component with new framework while adding features

**Testing**: Full regression + behavior preservation verification

---

## Targeted Regression Testing

**Why not full suite?**
- Full suite slow (minutes to hours)
- Most tests unrelated to enhancement
- Targeted testing faster and focused

**How tests are selected** (30-70% of suite):
1. Tests for the enhanced feature
2. Tests for dependent features
3. Tests for integrated features
4. Tests for similar patterns

**Example**:
- Total test suite: 1,500 tests
- Enhancement: User table sorting
- Targeted tests: 450 tests (30%)
  - User table: 120 tests
  - User API: 180 tests
  - User permissions: 90 tests
  - Similar sorting features: 60 tests

---

## User-Centric Analysis

### Gap Detection

The workflow ensures features are **complete, usable, and discoverable**:

**Complete**:
- ✅ Backend implementation exists
- ✅ Frontend component exists
- ✅ Users can actually access it

**Example of incomplete feature**:
```
User requests: "Display allergy info on patient summary"

Without data lifecycle analysis:
- ✅ Implements display component
- ❌ No way to input allergies (feature useless!)

With data lifecycle analysis:
- ⚠️ Detects orphaned display (no input mechanism)
- ✅ Recommends: Add input form first
- ✅ Result: Complete, usable feature
```

### User Journey Impact

**Before Enhancement**:
```
User → Dashboard → Users List → View user details
```

**After Enhancement**:
```
User → Dashboard → Users List → Sort ↓
                               → Filter ↓
                               → Export ↓
                               → View details
```

**Discoverability**: 9/10 (controls visible, no training needed)

---

## Optional Phases

### UI Mockup Generation (If UI-Heavy)

**When**: After gap analysis, before specification
**Purpose**: Visualize how enhancement integrates with existing UI

Creates ASCII mockups showing:
- Current UI layout
- Where new controls fit
- Component reuse opportunities

**Example:**
```
┌──────────────────────────────────────────┐
│ User List                    [+ New User]│
│ ──────────────────────────────────────── │
│ [Sort: Name ▼] [Filter: Role ▼] [Export]│ ← NEW
│ ──────────────────────────────────────── │
│ Name        Email         Role    Actions│ ← EXISTING
│ Alice       alice@..      Admin   [Edit] │
│ Bob         bob@..        User    [Edit] │
└──────────────────────────────────────────┘
```

---

## Best Practices

### 1. Always Analyze Existing First

Don't start coding until you understand current implementation.

### 2. Classify Enhancement Type

Know your risk level:
- Additive → Fast, safe
- Modificative → Careful, test well
- Refactor-based → Slow, test extensively

### 3. Ensure Backward Compatibility

Existing users shouldn't notice breaking changes.

**Good**: Add optional sort parameter `?sort=name`
**Bad**: Remove existing pagination to add sorting

### 4. Use Targeted Regression Testing

Run 30-70% of test suite (related tests), not full suite.

### 5. Check User Journey Impact

Ensure users can discover and use the enhancement.

---

## Common Scenarios

### Scenario: Enhancement Breaks Existing Tests

**Problem**: Targeted regression tests failing

**Solution**:
1. Review which tests failed
2. Determine if tests need updating or enhancement needs fixing
3. Fix accordingly
4. Re-run targeted tests

### Scenario: Can't Find Existing Feature

**Problem**: Existing feature analysis finds nothing

**Solution**:
1. Verify feature actually exists
2. If yes: Provide file paths manually
3. If no: This is a new feature, use `/ai-sdlc:feature:new` instead

### Scenario: Enhancement Too Complex

**Problem**: Gap analysis shows massive changes needed

**Solution**:
Consider breaking into:
1. Phase 1: Refactor existing code (refactoring workflow)
2. Phase 2: Add enhancement (enhancement workflow)

---

## Related Workflows

- **[Feature Development](feature-development.md)** - For completely new features
- **[Bug Fixing](bug-fixing.md)** - For fixing defects
- **[Refactoring](refactoring.md)** - For code restructuring only

---

## Additional Resources

- [Command Reference](../../commands/enhancement/new.md)
- [Skill Documentation](../../skills/enhancement-orchestrator/SKILL.md)
- [Gap Analyzer Agent](../../agents/gap-analyzer.md)

---

**Next Steps**: Enhance your first feature with `/ai-sdlc:enhancement:new [description]`
