# Existing Feature Analysis Reference

> **Design Documentation**: This file serves as **design documentation** for developers extending or understanding the existing feature analysis methodology. The actual runtime analysis logic is executed by the `agents/existing-feature-analyzer.md` subagent for path-independence when the plugin runs in user projects. This document explains the patterns and reasoning behind the subagent implementation.

**Purpose:** Pattern guide for analyzing existing features before enhancement (Phase 0)

This reference provides conceptual patterns and decision frameworks for identifying and analyzing existing features in the codebase.

---

## Table of Contents

1. [Overview](#overview)
2. [Feature Context Extraction](#feature-context-extraction)
3. [Search Strategy](#search-strategy)
4. [File Scoring Pattern](#file-scoring-pattern)
5. [Match Presentation](#match-presentation)
6. [Feature Analysis](#feature-analysis)
7. [Complexity Assessment](#complexity-assessment)
8. [Analysis Report Structure](#analysis-report-structure)
9. [Failure Handling](#failure-handling)

---

## Overview

Phase 0 (Existing Feature Analysis) establishes baseline understanding of existing implementation before enhancement planning.

### Goals

- **Locate existing feature files** with high confidence (>80%)
- **Understand current functionality** and design patterns
- **Map dependencies** to assess enhancement impact
- **Identify test coverage** to preserve during changes
- **Assess complexity** for effort estimation

### Process Flow

```
Enhancement Description
         ↓
Extract Feature Context (keywords, domain, tech hints)
         ↓
Generate Search Patterns (filename + code patterns)
         ↓
Execute Multi-Strategy Search (Glob + Grep)
         ↓
Score and Rank Matches (relevance scoring)
         ↓
Present Top Matches (3-5 files)
         ↓
User Confirms or Adjusts Selection
         ↓
Analyze Confirmed Files (functionality, deps, tests)
         ↓
Generate Analysis Report
```

---

## Feature Context Extraction

### Purpose

Parse enhancement description to extract searchable elements for locating existing feature.

### Algorithm Outline

**Input**: `"Add sorting to user table"`

**Steps**:
1. **Tokenize** → `["Add", "sorting", "to", "user", "table"]`
2. **Extract Actions** → `["add"]` (verbs: add, modify, improve, refactor, etc.)
3. **Identify Nouns** → `["sorting", "user", "table"]`
4. **Classify Components**:
   - UI components: table, form, button, modal, list, grid
   - Backend: api, endpoint, service, controller, model
5. **Detect Domain** → `"user"` (common domains: user, product, order, auth, payment)
6. **Extract Tech Hints**:
   - React: component, hook, jsx
   - API: endpoint, route, controller
   - Database: table, schema, model
7. **Find File/Path Mentions** → Any explicit paths or filenames

**Output Structure**:
```
{
  primary: ["sorting", "table"],
  components: ["table"],
  actions: ["add"],
  domain: "user",
  tech_hints: ["react"],
  file_hints: []
}
```

### Common Patterns

| Description | Primary | Components | Domain | Tech Hints |
|------------|---------|------------|---------|-----------|
| "Add export to user table" | ["export"] | ["table"] | "user" | ["react"] |
| "Improve API response time" | ["response", "time"] | ["api"] | null | ["api"] |
| "Refactor UserTable component" | ["UserTable"] | ["component"] | "user" | ["react"] |

---

## Search Strategy

### Multi-Strategy Approach

Use three complementary search strategies in parallel:

#### Strategy 1: Exact Filename Match
**When**: File/component explicitly mentioned
**Method**: Extract name → Search for `*Name.*` patterns
**Example**: "UserTable" → `*UserTable.*`, `*user-table.*`, `*user_table.*`

#### Strategy 2: Keyword-Based Filename Search
**When**: Feature has clear keywords
**Method**: Generate patterns from primary keywords
**Patterns**:
- Component name: `*{keyword}*.*`
- Variations: PascalCase, kebab-case, snake_case
- With domain: `*{domain}*{keyword}*.*`

**Example**: "user table" → `*UserTable.*`, `*user-table.*`, `*UserList.*`

#### Strategy 3: Code Pattern Search
**When**: No clear filename hints
**Method**: Search file contents for patterns
**Patterns**:
- Class/function declarations: `class UserTable`, `function UserTable`
- Exports: `export.*UserTable`
- JSX/Component usage: `<UserTable`, `{UserTable`
- Comments: `// User table`, `/* UserTable */`

### Search Execution

**Parallel Execution**:
```
Strategy 1 (Glob) → Results Set A
Strategy 2 (Glob) → Results Set B
Strategy 3 (Grep) → Results Set C

Combined → Deduplicated Results → Scored & Ranked
```

**Directory Prioritization**:
- Frontend: `src/components/`, `src/pages/`, `src/views/`
- Backend: `src/services/`, `src/controllers/`, `src/models/`
- Shared: `src/lib/`, `src/utils/`, `src/hooks/`

---

## File Scoring Pattern

### Scoring Algorithm

Assign points across multiple dimensions to rank file relevance:

| Criterion | Points | Conditions |
|-----------|--------|------------|
| **Filename Match** | 10 | Exact match (UserTable.tsx) |
| | 7 | Partial match (UserList.tsx) |
| | 5 | Domain match (user-*.tsx) |
| **Directory Relevance** | 5 | Domain in path (user/, users/) |
| | 3 | Tech-appropriate dir (components/ for React) |
| **File Size** | 3 | >5KB (substantial implementation) |
| | 1 | 1-5KB (moderate) |
| | 0 | <1KB (likely not main file) |
| **Has Tests** | 5 | Corresponding test file exists |
| **Usage Frequency** | 5 | Imported 10+ times |
| | 3 | Imported 5-9 times |
| | 1 | Imported 1-4 times |
| **Recency** | 3 | Modified within 30 days |
| | 1 | Modified within 90 days |
| **Code Pattern Match** | 5 | Contains target pattern in code |

**Total Possible**: 36 points

### Confidence Levels

| Score | Confidence | Action |
|-------|-----------|---------|
| 25-36 | High (>80%) | Present top 3 matches |
| 15-24 | Medium (50-80%) | Present top 5 + expand search |
| 0-14 | Low (<50%) | Prompt user for help |

### Tie-Breaking

If multiple files score similarly:
1. Prefer files with tests
2. Prefer recently modified
3. Prefer larger files
4. Prefer more specific directory

---

## Match Presentation

### High Confidence (>80%)

```
✅ Feature files detected with high confidence

Top matches:
1. src/components/UserTable.tsx (confidence: 95%)
   - Exact filename match
   - Has tests: UserTable.test.tsx
   - Imported 12 times
   - 8.5 KB, modified 2 days ago

2. src/hooks/useUserData.ts (confidence: 87%)
   - Related functionality
   - Has tests
   - Imported 8 times
   - 3.2 KB, modified 5 days ago

Are these the correct files? [Y/n/provide-different]
```

### Medium Confidence (50-80%)

```
⚠️ Multiple potential matches found

Possible files:
1. src/components/UserTable.tsx (65%)
2. src/components/UserList.tsx (62%)
3. src/views/UsersPage.tsx (58%)
4. src/components/DataTable.tsx (55%)
5. src/services/userService.ts (52%)

Which file(s) contain the feature you want to enhance?
[Select numbers or provide path manually]
```

### Low Confidence (<50%)

```
❌ Could not confidently locate feature files

Searches attempted:
- Filename patterns: *user*table*, *UserTable*
- Code patterns: class UserTable, <UserTable
- Found: 15 potential files, none with high confidence

Options:
1. Provide file path directly
2. Expand search with more keywords
3. Search different directory
4. Describe feature differently

What would you like to do?
```

---

## Feature Analysis

### Analysis Dimensions

After files are confirmed, analyze each file across these dimensions:

#### 1. Functionality Analysis
**Goal**: Understand what the feature currently does

**Key Questions**:
- What is the primary responsibility?
- What user actions does it handle?
- What data does it manage?
- What are the key functions/methods?

**Evidence**:
- Function/method names and signatures
- Props/parameters accepted
- State management patterns
- Comments and documentation

#### 2. Dependency Mapping
**Goal**: Identify what else will be affected

**Analyze**:
- **Imports**: What does this file depend on?
- **Exports**: What depends on this file?
- **Data flow**: Props, state, context, stores
- **API calls**: External service dependencies

**Techniques**:
- Parse import/export statements
- Grep for usages: `import.*UserTable`
- Check for prop drilling or context providers

#### 3. Test Coverage Analysis
**Goal**: Ensure tests exist and will be preserved

**Check for**:
- Unit test file (`*.test.*`, `*.spec.*`)
- Integration tests mentioning this feature
- E2E tests covering user workflows

**Assess**:
- Test file location and size
- Test coverage percentage (if available)
- Key test scenarios covered

#### 4. Code Patterns & Conventions
**Goal**: Match existing patterns in enhancement

**Observe**:
- Naming conventions (PascalCase, camelCase, kebab-case)
- Component structure (functional vs class)
- State management approach (hooks, Redux, MobX)
- Styling approach (CSS modules, styled-components, Tailwind)
- Error handling patterns
- TypeScript usage and type definitions

---

## Complexity Assessment

### Complexity Factors

Assess complexity to estimate enhancement effort:

| Factor | Low | Medium | High |
|--------|-----|--------|------|
| **File Size** | <200 lines | 200-500 lines | >500 lines |
| **Dependencies** | 0-3 imports | 4-10 imports | 11+ imports |
| **Consumers** | 0-2 usages | 3-8 usages | 9+ usages |
| **Nested Depth** | 1-2 levels | 3-4 levels | 5+ levels |
| **State Complexity** | Local state | Context/props | Global store |
| **Test Count** | 0-5 tests | 6-15 tests | 16+ tests |

### Overall Assessment

**Simple** (1-3 low factors):
- Single-purpose component
- Few dependencies
- Minimal state
- Well-tested
- **Effort**: 1-2 hours

**Moderate** (Mixed factors or 1-2 high):
- Multi-purpose component
- Several dependencies
- Moderate state management
- Adequate tests
- **Effort**: 2-4 hours

**Complex** (2+ high factors):
- Core component
- Many dependencies
- Complex state
- Extensive tests
- **Effort**: 4-8 hours

---

## Analysis Report Structure

### Report Template

```markdown
# Existing Feature Analysis: [Feature Name]

**Date**: [timestamp]
**Enhancement**: [description]

## Summary

[2-3 sentence overview of what exists]

## Feature Files

### Primary Files
- **src/components/UserTable.tsx** (350 lines)
  - Main table component
  - Manages sorting, filtering, pagination
  - Uses React hooks for state

### Related Files
- **src/hooks/useUserData.ts** (120 lines) - Data fetching
- **src/types/User.ts** (45 lines) - Type definitions

## Current Functionality

**What it does**:
- Displays user list in table format
- Supports column-based display
- Handles user selection
- Emits events on row click

**Key components**:
- UserTable (main component)
- TableHeader (headers)
- TableRow (row rendering)
- useUserData (data hook)

**Missing** (relevant to enhancement):
- No sorting capability
- No column reordering
- No export functionality

## Dependencies

### Imports (What this depends on)
- `useUserData` - Data fetching hook
- `UserType` - Type definitions
- `TableRow` - Row component
- React, useState, useEffect

### Consumers (What depends on this)
- `UsersPage.tsx` - Main usage
- `AdminDashboard.tsx` - Secondary usage
- 3 other components

### External Dependencies
- No API calls (data via props)
- No global state usage
- Local state management only

## Current Test Coverage

**Test files**:
- `UserTable.test.tsx` (15 tests, 85% coverage)

**Key scenarios tested**:
- Renders with data
- Handles empty state
- Row selection works
- Event handlers fire correctly

**Not tested**:
- Sorting (doesn't exist yet)
- Performance with large datasets

## Coding Patterns Observed

- **Component style**: Functional with hooks
- **Naming**: PascalCase for components
- **Props**: TypeScript interfaces
- **State**: useState for local state
- **Styling**: CSS modules (`UserTable.module.css`)
- **Testing**: Jest + React Testing Library

## Complexity Assessment

**Overall**: Medium complexity

**Factors**:
- File size: 350 lines (medium)
- Dependencies: 7 imports (medium)
- Consumers: 5 usages (medium)
- State: Local state only (low)
- Tests: 15 tests, good coverage (medium)

**Estimated Enhancement Effort**: 2-3 hours

## Recommendations

1. **Preserve existing tests** - Good coverage, keep passing
2. **Match existing patterns** - Use hooks, CSS modules, TypeScript
3. **Consider impact** - 5 components use this, test thoroughly
4. **Add targeted tests** - For new sorting functionality
5. **Maintain backwards compatibility** - Sorting should be opt-in

---

**Analysis complete. Ready for Phase 1: Gap Analysis.**
```

---

## Failure Handling

### Scenario 1: No Files Found

**Causes**:
- Feature doesn't exist yet (wrong orchestrator)
- Description too vague
- Unusual naming conventions

**Recovery**:
1. Use AskUserQuestion to ask clarifying questions
2. Expand search to broader patterns
3. Prompt user to provide path manually
4. Suggest using feature-orchestrator instead

### Scenario 2: Too Many Matches (>10)

**Causes**:
- Description too generic
- Common naming patterns

**Recovery**:
1. Add domain/tech hints to narrow
2. Filter by directory relevance
3. Ask user to specify more context
4. Present grouped by directory

### Scenario 3: Low Confidence Matches

**Causes**:
- Inconsistent naming
- Feature spread across multiple files
- Unusual architecture

**Recovery**:
1. Present all matches with scores
2. Explain why confidence is low
3. Ask user to select manually
4. Offer to search different way

### Scenario 4: Wrong Files Selected

**Causes**:
- Scoring algorithm prioritized wrong factors
- User provided unclear description

**Recovery**:
1. Ask what was wrong with selection
2. Adjust search based on feedback
3. Re-score with new criteria
4. Allow manual path input

---

## Best Practices

### Do's

✅ **Use multiple search strategies** - Filename, code patterns, and directory searches
✅ **Score comprehensively** - Consider all factors, not just filename
✅ **Present confidence clearly** - User needs to know reliability
✅ **Allow manual override** - User knows their codebase best
✅ **Analyze thoroughly** - Understand dependencies and patterns

### Don'ts

❌ **Don't assume single file** - Features often span multiple files
❌ **Don't ignore test files** - They reveal functionality
❌ **Don't skip dependency mapping** - Critical for impact assessment
❌ **Don't over-automate** - Involve user in ambiguous cases
❌ **Don't proceed with low confidence** - Confirm with user first

---

## Quick Reference

### Search Strategy Selection

| Situation | Primary Strategy | Fallback |
|-----------|-----------------|----------|
| Component mentioned | Exact filename | Keyword search |
| Domain + feature | Keyword search | Code patterns |
| Vague description | Code patterns | Prompt user |
| API/backend | Service patterns | Grep for functions |

### Confidence Thresholds

- **High (>80%)**: Auto-proceed with top 3
- **Medium (50-80%)**: Present options, ask user
- **Low (<50%)**: Expand search or manual input

### Complexity Indicators

- **Simple**: <200 lines, <5 deps, <3 usages
- **Moderate**: 200-500 lines, 5-10 deps, 3-8 usages
- **Complex**: >500 lines, 10+ deps, 8+ usages

---

**End of existing-feature-analysis.md reference**
