# Execution Modes Guide

This guide explains when to use each execution mode and how they differ.

## Overview

The implementer skill adapts its execution strategy based on implementation complexity. Three modes provide optimal balance between efficiency and quality.

## Mode Selection Criteria

### Primary Factor: Step Count

Count total implementation steps from implementation-plan.md:

| Steps | Mode | Strategy |
|-------|------|----------|
| 1-3 | Mode 1: Direct | Main agent executes directly |
| 4-8 | Mode 2: Plan-Execute | Delegate planning to subagent |
| 9+ | Mode 3: Orchestrated | Delegate by task group |

### Secondary Factors

Consider these factors when on the boundary between modes:

**Complexity Indicators** (suggest higher mode):
- Multiple technology layers (database + API + frontend)
- External service integrations
- Complex business logic
- Many file modifications
- Cross-cutting concerns

**Simplicity Indicators** (suggest lower mode):
- Single file changes
- Configuration updates
- Well-defined patterns to follow
- Minimal dependencies
- Straightforward logic

**Context Considerations**:
- Current token usage (higher = prefer delegation)
- Your familiarity with codebase (lower = prefer direct)
- Time constraints (delegation adds planning overhead)
- Quality requirements (higher = prefer orchestrated)

## Mode 1: Direct Execution

### When to Use

**Ideal For**:
- Simple bug fixes (1-3 file changes)
- Configuration updates
- Minor feature additions
- Documentation updates
- Quick improvements

**Characteristics**:
- Low complexity
- Clear requirements
- Minimal dependencies
- Single technical layer
- Well-understood problem

### How It Works

**Process**:
1. Main agent reads implementation-plan.md
2. Main agent checks docs/INDEX.md for standards
3. Main agent executes each step directly:
   - Write tests (if test-driven)
   - Implement changes
   - Run tests
   - Mark complete
4. No subagent delegation
5. Continuous standards checking throughout

**Example Steps**:
```markdown
## Implementation Plan (3 steps)

1. Write test for logout functionality (3 tests)
2. Add logout button to navigation
3. Verify tests pass
```

**Execution**:
- Step 1: Main agent writes 3 tests directly
- Step 2: Main agent modifies navigation directly
- Step 3: Main agent runs tests directly
- Total: Direct execution, no delegation

### Advantages

- **Fast**: No planning overhead
- **Simple**: Straightforward execution
- **Efficient**: Minimal context switching
- **Direct control**: Main agent maintains full context

### When to Avoid

- More than 3-4 steps
- Complex dependencies between steps
- Multiple technical layers
- High token usage (risk of running out)

## Mode 2: Plan-Execute

### When to Use

**Ideal For**:
- Standard features (4-8 steps)
- Moderate complexity
- 2-3 task groups
- Well-defined scope
- Multiple file modifications

**Characteristics**:
- Moderate complexity
- Clear structure
- Some dependencies
- Multiple files/components
- Standard patterns

### How It Works

**Process**:
1. Main agent reads implementation-plan.md
2. Main agent checks docs/INDEX.md initially
3. **Main agent delegates planning** to implementation-changes-planner subagent:
   - Subagent analyzes all steps
   - Subagent checks docs/INDEX.md continuously
   - Subagent creates detailed change plan (markdown)
   - Subagent returns plan to main agent
4. Main agent reviews change plan
5. Main agent applies all changes from plan:
   - Re-checks standards before each change
   - Applies changes using Edit/Write tools
   - Marks steps complete
   - Logs progress
6. Main agent runs tests incrementally

**Example Steps**:
```markdown
## Implementation Plan (6 steps, 2 task groups)

### Task Group 1: API Layer
1.1 Write API tests (5 tests)
1.2 Create endpoint
1.3 Add authentication
1.4 Verify tests pass

### Task Group 2: Frontend Layer
2.1 Write component tests (4 tests)
2.2 Create profile form component
2.3 Integrate with API
2.4 Verify tests pass
```

**Execution**:
- Main agent → Delegate to subagent: "Create change plan for all 6 steps"
- Subagent → Analyzes steps, checks standards, returns detailed plan
- Main agent → Applies changes from plan:
  - Step 1.1: Create test file (from plan)
  - Step 1.2: Create endpoint (from plan)
  - Step 1.3: Add auth (from plan)
  - Step 1.4: Run tests
  - Step 2.1: Create test file (from plan)
  - Step 2.2: Create component (from plan)
  - Step 2.3: Integrate API (from plan)
  - Step 2.4: Run tests

### Advantages

- **Organized**: Structured planning before execution
- **Comprehensive**: Subagent thoroughly analyzes all steps
- **Standards-focused**: Subagent discovers standards during planning
- **Maintainable**: Main agent has clear plan to follow
- **Traceable**: Plan documents all changes

### When to Avoid

- Very simple tasks (overhead not worth it)
- More than 8-9 steps (too much in one plan)
- Highly uncertain requirements (planning won't help)

## Mode 3: Orchestrated

### When to Use

**Ideal For**:
- Complex features (9+ steps)
- 3-6 task groups
- Multiple technical layers
- External integrations
- High complexity

**Characteristics**:
- High complexity
- Many dependencies
- Multiple layers (database → API → frontend → testing)
- Large scope
- Multiple concerns

### How It Works

**Process**:
1. Main agent reads implementation-plan.md
2. Main agent checks docs/INDEX.md initially
3. Main agent identifies task groups (from implementation-plan.md)
4. **For each task group**:
   a. Main agent re-checks docs/INDEX.md for group-specific standards
   b. Main agent delegates planning to subagent for THIS GROUP ONLY:
      - Subagent analyzes steps in this group
      - Subagent checks standards for this specialty
      - Subagent creates group-specific change plan
      - Subagent returns plan to main agent
   c. Main agent reviews group plan
   d. Main agent applies all changes for this group:
      - Re-checks standards before each change
      - Applies changes using Edit/Write tools
      - Marks steps complete
      - Logs progress
   e. Main agent runs incremental tests for this group
   f. Main agent verifies group acceptance criteria
   g. Main agent moves to next group
5. Main agent runs final verification across all groups

**Example Steps**:
```markdown
## Implementation Plan (12 steps, 4 task groups)

### Task Group 1: Database Layer (3 steps)
1.1 Write model tests
1.2 Create User model
1.3 Create migration
1.4 Verify tests pass

### Task Group 2: API Layer (4 steps)
2.1 Write API tests
2.2 Create user endpoints
2.3 Add authentication
2.4 Add validation
2.5 Verify tests pass

### Task Group 3: Frontend Layer (4 steps)
3.1 Write component tests
3.2 Create profile form
3.3 Create profile page
3.4 Add routing
3.5 Verify tests pass

### Task Group 4: Testing (3 steps)
4.1 Review existing tests
4.2 Add integration tests
4.3 Run full test suite
```

**Execution**:

**Round 1: Database Layer**
- Main agent checks docs/INDEX.md for database standards
- Main agent → Delegate: "Create plan for Task Group 1 (Database)"
- Subagent → Returns database layer plan
- Main agent → Applies changes from plan:
  - 1.1: Create model tests
  - 1.2: Create model
  - 1.3: Create migration
  - 1.4: Run database tests
- Verify: Database layer complete

**Round 2: API Layer**
- Main agent checks docs/INDEX.md for API standards
- Main agent → Delegate: "Create plan for Task Group 2 (API)"
- Subagent → Returns API layer plan
- Main agent → Applies changes from plan:
  - 2.1: Create API tests
  - 2.2: Create endpoints
  - 2.3: Add authentication
  - 2.4: Add validation
  - 2.5: Run API tests
- Verify: API layer complete

**Round 3: Frontend Layer**
- Main agent checks docs/INDEX.md for frontend standards
- Main agent → Delegate: "Create plan for Task Group 3 (Frontend)"
- Subagent → Returns frontend layer plan
- Main agent → Applies changes from plan:
  - 3.1: Create component tests
  - 3.2: Create form
  - 3.3: Create page
  - 3.4: Add routing
  - 3.5: Run frontend tests
- Verify: Frontend layer complete

**Round 4: Testing**
- Main agent → Delegate: "Create plan for Task Group 4 (Testing)"
- Subagent → Returns testing plan
- Main agent → Applies testing plan:
  - 4.1: Review tests
  - 4.2: Add integration tests
  - 4.3: Run full suite
- Verify: All tests passing

**Final Verification**
- Main agent checks all acceptance criteria
- Main agent verifies all standards applied
- Main agent marks implementation complete

### Advantages

- **Manageable**: Breaks large implementation into chunks
- **Focused**: Each round focuses on one specialty
- **Progressive**: Builds upon completed layers
- **Verifiable**: Incremental testing after each group
- **Scalable**: Handles very complex implementations
- **Standards-aware**: Checks standards for each specialty area

### When to Avoid

- Simple tasks (massive overhead)
- Time-sensitive (slower due to multiple planning rounds)
- Unclear boundaries between groups (hard to orchestrate)

## Decision Tree

Use this decision tree to select execution mode:

```
Start
  |
  v
Count total steps in implementation-plan.md
  |
  +--> 1-3 steps?
  |      |
  |      +--> Yes: Check complexity
  |      |      |
  |      |      +--> Simple (single file, clear pattern)
  |      |      |      |
  |      |      |      v
  |      |      |    MODE 1: Direct Execution
  |      |      |
  |      |      +--> Complex (multiple files, dependencies)
  |      |             |
  |      |             v
  |      |           Consider MODE 2
  |      |
  |      +--> No: Continue
  |
  +--> 4-8 steps?
  |      |
  |      +--> Yes: Check task groups
  |      |      |
  |      |      +--> 1-2 task groups, moderate complexity
  |      |      |      |
  |      |      |      v
  |      |      |    MODE 2: Plan-Execute
  |      |      |
  |      |      +--> 3+ task groups, high complexity
  |      |             |
  |      |             v
  |      |           Consider MODE 3
  |      |
  |      +--> No: Continue
  |
  +--> 9+ steps?
         |
         +--> Yes: Check task groups
                |
                +--> 3+ task groups, multiple layers
                |      |
                |      v
                |    MODE 3: Orchestrated
                |
                +--> 1-2 task groups (unusual for 9+ steps)
                       |
                       v
                     MODE 2: Plan-Execute
                     (or consider breaking into smaller tasks)
```

## Real-World Examples

### Example 1: Bug Fix (Mode 1)

**Task**: Fix login timeout error

**Implementation Plan**:
```markdown
1. Write test reproducing timeout bug (2 tests)
2. Increase timeout in auth service
3. Verify tests pass
```

**Analysis**:
- Steps: 3
- Complexity: Low (single file, clear fix)
- Task Groups: 1
- Dependencies: None

**Decision**: Mode 1 (Direct Execution)

**Rationale**: Simple fix, clear approach, minimal files

### Example 2: Standard Feature (Mode 2)

**Task**: Add profile editing

**Implementation Plan**:
```markdown
### Task Group 1: API Layer (3 steps)
1.1 Write API tests (4 tests)
1.2 Create profile update endpoint
1.3 Add validation
1.4 Verify tests pass

### Task Group 2: Frontend Layer (3 steps)
2.1 Write component tests (5 tests)
2.2 Create profile form
2.3 Connect to API
2.4 Verify tests pass
```

**Analysis**:
- Steps: 6
- Complexity: Moderate (API + Frontend)
- Task Groups: 2
- Dependencies: Frontend depends on API

**Decision**: Mode 2 (Plan-Execute)

**Rationale**: Moderate complexity, clear structure, benefits from planning

### Example 3: Complex Feature (Mode 3)

**Task**: Implement payment processing

**Implementation Plan**:
```markdown
### Task Group 1: Database Layer (3 steps)
1.1 Write model tests
1.2 Create Payment model
1.3 Create migrations
1.4 Verify tests pass

### Task Group 2: Payment Service (4 steps)
2.1 Write service tests
2.2 Integrate Stripe SDK
2.3 Create payment processing service
2.4 Add webhook handler
2.5 Verify tests pass

### Task Group 3: API Layer (3 steps)
3.1 Write API tests
3.2 Create payment endpoints
3.3 Add security
3.4 Verify tests pass

### Task Group 4: Frontend Layer (4 steps)
4.1 Write component tests
4.2 Create payment form
4.3 Add Stripe Elements
4.4 Handle payment flow
4.5 Verify tests pass

### Task Group 5: Testing (2 steps)
5.1 Add integration tests
5.2 Run full test suite
```

**Analysis**:
- Steps: 16
- Complexity: High (Database + Service + API + Frontend + Testing)
- Task Groups: 5
- Dependencies: Multiple layers with complex dependencies

**Decision**: Mode 3 (Orchestrated)

**Rationale**: High complexity, multiple layers, benefits from orchestrated approach with focused planning per layer

## Switching Modes

### Can You Switch Mid-Implementation?

**Yes, but be intentional:**

**Upgrading** (Mode 1 → Mode 2, or Mode 2 → Mode 3):
- **When**: Discover complexity is higher than expected
- **How**: Pause, delegate remaining steps to subagent for planning
- **Document**: Note in work-log.md why you switched

**Downgrading** (Mode 3 → Mode 2, or Mode 2 → Mode 1):
- **When**: Remaining steps are simpler than expected
- **How**: Complete current group, then execute remaining steps directly
- **Document**: Note in work-log.md why you switched

**Example**:
```markdown
## Work Log Entry

Started with Mode 2 (Plan-Execute) for 6 steps.

After completing Task Group 1, discovered remaining steps in Task Group 2 are
simpler than expected (single file modification).

Switching to Mode 1 (Direct Execution) for Task Group 2 to improve efficiency.
```

## Summary

### Quick Reference

| Mode | Steps | Task Groups | Complexity | Delegation |
|------|-------|-------------|------------|------------|
| **Mode 1: Direct** | 1-3 | 1 | Low | None |
| **Mode 2: Plan-Execute** | 4-8 | 1-3 | Moderate | Full plan upfront |
| **Mode 3: Orchestrated** | 9+ | 3+ | High | Per task group |

### Key Principles

1. **Step count is primary factor** - Start with step count
2. **Complexity adjusts** - Consider complexity as secondary factor
3. **Task groups matter** - Multiple groups suggest higher mode
4. **Context aware** - Consider token usage and familiarity
5. **Can switch** - Adjust mode if complexity changes
6. **Document decisions** - Record mode choice and rationale

### Decision Guidelines

- **When uncertain**: Choose higher mode (better quality, more organized)
- **When time-constrained**: Choose lower mode (faster, less overhead)
- **When learning**: Choose higher mode (more structured, easier to follow)
- **When expert**: Choose lower mode (trust your judgment, execute directly)

The goal is to balance efficiency with quality. Choose the mode that provides the right level of planning and organization for the task at hand.
