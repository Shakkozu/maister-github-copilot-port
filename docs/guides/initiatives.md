# Initiatives (Epic-Level Multi-Task Coordination)

Complete guide to coordinating multiple related tasks using the AI SDLC plugin's initiative orchestrator.

## Overview

Initiatives are epic-level workflows that coordinate 3-15 related tasks with dependency management, parallel execution where possible, and comprehensive progress tracking. Perfect for multi-week projects requiring coordination across different task types.

**When to use initiatives:**
- Coordinating 3-15 related tasks
- Tasks have dependencies (Task B needs Task A complete first)
- Multi-week projects with multiple phases
- Feature sets that need orchestration

**When NOT to use initiatives:**
- Single task → Use specific workflow
- 1-2 tasks → Execute separately
- No dependencies → Run tasks in parallel manually

## Quick Start

```bash
# Interactive mode
/ai-sdlc:initiative:new "Build complete authentication system with login, SSO, and MFA"

# Check progress
/ai-sdlc:initiative:status [initiative-path]

# Resume after interruption
/ai-sdlc:initiative:resume [initiative-path]
```

## Workflow Phases

### Phase 1: Planning

**Duration**: 30-60 minutes
**Purpose**: Break epic into concrete tasks with dependency graph

**Delegates to**: initiative-planner agent

**What happens:**
1. Analyzes initiative description
2. Breaks into 3-15 concrete tasks
3. Creates dependency graph
4. Validates no circular dependencies
5. Identifies milestones

**Outputs:**
```
.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-initiative-name/
├── initiative.yml          # Task list, dependencies, milestones
├── spec.md                 # Initiative vision and goals
└── task-plan.md            # Task breakdown with dependency graph
```

**task-plan.md example:**
```markdown
# Task Plan: Authentication System

## Tasks

### Task 1: Basic Login
**ID**: basic-login
**Type**: new-feature
**Priority**: high
**Dependencies**: none
**Blocks**: sso-integration, mfa-enhancement
**Estimated**: 40 hours

### Task 2: SSO Integration
**ID**: sso-integration
**Type**: new-feature
**Priority**: high
**Dependencies**: basic-login
**Blocks**: mfa-enhancement
**Estimated**: 50 hours

### Task 3: MFA Enhancement
**ID**: mfa-enhancement
**Type**: enhancement
**Priority**: medium
**Dependencies**: basic-login, sso-integration
**Blocks**: none
**Estimated**: 30 hours

## Dependency Graph

```
Level 0: basic-login
Level 1: sso-integration
Level 2: mfa-enhancement
```

## Milestones
- Basic Auth Complete: After basic-login
- Full SSO Ready: After sso-integration
- Security Enhanced: After mfa-enhancement
```

---

### Phase 2: Task Creation

**Duration**: 10-20 minutes
**Purpose**: Create task directories with initiative metadata

**What happens:**
1. For each task in plan:
   - Create task directory in `.ai-sdlc/tasks/[type]/`
   - Create metadata.yml with initiative linkage
   - Set dependencies and blocks fields

**Outputs:**
```
.ai-sdlc/tasks/
├── new-features/
│   ├── 2025-11-14-basic-login/
│   │   └── metadata.yml (with initiative_id, dependencies, blocks)
│   └── 2025-11-14-sso-integration/
│       └── metadata.yml
└── enhancements/
    └── 2025-11-16-mfa-enhancement/
        └── metadata.yml
```

**metadata.yml example:**
```yaml
name: Basic Login
type: new-feature
status: pending
priority: high

# Initiative linkage
initiative_id: 2025-11-14-auth-system
dependencies: []  # No dependencies
blocks:
  - sso-integration
  - mfa-enhancement
milestone: Basic Auth Complete

estimated_hours: 40
actual_hours: 0
```

---

### Phase 3: Dependency Resolution

**Duration**: 5-10 minutes
**Purpose**: Compute execution order and validate dependency graph

**What happens:**
1. Validates dependency graph (no cycles)
2. Computes execution levels (topological sort)
3. Identifies critical path
4. Determines execution strategy

**Execution Levels:**
```
Level 0: [basic-login]                    ← Can run immediately
Level 1: [sso-integration]                ← Waits for Level 0
Level 2: [mfa-enhancement]                ← Waits for Level 1
```

**Execution Strategies:**
- **Sequential**: One task at a time (simple, linear dependencies)
- **Parallel**: Independent tasks concurrently (fastest)
- **Mixed** (Recommended): Parallel within levels, sequential between levels

**Example Mixed Execution:**
```
Level 0: [task-A, task-B, task-C]  ← Run in parallel (independent)
         ↓
Level 1: [task-D, task-E]          ← Run in parallel (both depend on Level 0)
         ↓
Level 2: [task-F]                  ← Run alone (depends on all above)
```

---

### Phase 4: Task Execution

**Duration**: Hours to weeks (varies by task count and complexity)
**Purpose**: Launch task orchestrators respecting dependencies

**What happens:**

1. **For each execution level** (sequentially):
   2. **For each task in level** (in parallel):
      - Check dependencies complete
      - If blocked: Skip and mark as blocked
      - If ready: Launch appropriate orchestrator (feature/enhancement/migration/etc.)
      - Monitor via file-based polling

**File-Based State Coordination:**

Each task has `metadata.yml` that orchestrators update:
```yaml
status: pending      # → in_progress → completed/failed
```

Initiative polls task status:
```python
while tasks_remaining:
    for task in current_level:
        status = read_task_metadata(task)
        if status == "completed":
            mark_complete(task)
        elif status == "failed":
            handle_failure(task)
```

**Example execution:**
```
🚀 Initiative: Authentication System

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Level 0 (1 task):
  → basic-login: Launching feature-orchestrator...
     [========================================] 100%
     ✅ Complete (6h 24m)

Level 1 (1 task):
  → sso-integration: Launching feature-orchestrator...
     [====================>                   ] 52%
     🔄 In Progress (4h 12m elapsed)

Level 2 (1 task - blocked):
  ⏸️  mfa-enhancement: Waiting for dependencies...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Progress: 1/3 complete (33%)
```

---

### Phase 5: Verification

**Duration**: 30-60 minutes
**Purpose**: Verify all tasks complete and initiative goals met

**What happens:**
1. Verify all tasks status="completed"
2. Run integration tests (optional)
3. Check deployment readiness
4. Create verification report

**Outputs:**
```
.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-initiative-name/
└── verification-report.md
```

---

### Phase 6: Finalization

**Duration**: 10-20 minutes
**Purpose**: Create summary and update roadmap

**What happens:**
1. Calculate metrics (time, effort, completion)
2. Update roadmap if exists
3. Create summary
4. Archive initiative

**Outputs:**
```
.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-initiative-name/
└── summary.md
```

**summary.md example:**
```markdown
# Initiative Summary: Authentication System

## Status: ✅ COMPLETED

## Tasks Completed: 3/3

1. ✅ basic-login (6h 24m)
2. ✅ sso-integration (8h 15m)
3. ✅ mfa-enhancement (4h 48m)

## Total Time: 19 hours 27 minutes
**Estimated**: 120 hours
**Actual**: 19.5 hours
**Efficiency**: 84% under estimate

## Milestones Achieved:
✅ Basic Auth Complete
✅ Full SSO Ready
✅ Security Enhanced

## Deployment Status:
🟢 Ready for production
```

---

## Dependency Management

### Defining Dependencies

In task `metadata.yml`:
```yaml
dependencies:
  - .ai-sdlc/tasks/new-features/2025-11-14-basic-login
  - .ai-sdlc/tasks/migrations/2025-11-14-database-schema
```

### Dependency Validation

**Before task execution**, each task orchestrator checks dependencies:

```
Task: SSO Integration
Dependencies: [basic-login]

Checking dependencies...
  basic-login: status = completed ✅

All dependencies satisfied → Proceed
```

**If blocked:**
```
Task: MFA Enhancement
Dependencies: [basic-login, sso-integration]

Checking dependencies...
  basic-login: status = completed ✅
  sso-integration: status = in_progress ⏳

❌ BLOCKED: sso-integration not complete

Action: Wait for dependencies to complete
```

### Circular Dependency Detection

Initiative validates no cycles exist:

```
Task A depends on B
Task B depends on C
Task C depends on A  ← CYCLE!

Error: Circular dependency detected: A → B → C → A
```

---

## Progress Tracking

### Real-Time Status

```bash
/ai-sdlc:initiative:status [initiative-path]
```

**Output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Initiative: Authentication System
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Progress: 66% (2/3 tasks complete)

Tasks:
  ✅ basic-login           (completed in 6h 24m)
  🔄 sso-integration      (in progress, 52% complete, 4h 12m elapsed)
  ⏸️  mfa-enhancement      (blocked, waiting for: sso-integration)

Dependency Graph:
  Level 0: [✅ basic-login]
  Level 1: [🔄 sso-integration]
  Level 2: [⏸️ mfa-enhancement]

Critical Path: basic-login → sso-integration → mfa-enhancement
Estimated Completion: 8 hours (if current pace continues)

Next Steps:
  1. Wait for sso-integration to complete
  2. mfa-enhancement will auto-start when ready
```

---

## Task Integration

### Workflow Orchestrators with Phase 0.5

**All workflow orchestrators** (feature, enhancement, migration, etc.) now include **Phase 0.5: Dependency Check**.

**Example** (feature-orchestrator):
```
Starting feature development: SSO Integration

Phase 0.5: Dependency Check
  Checking metadata.yml for initiative_id... Found!
  Initiative: 2025-11-14-auth-system
  Dependencies: [basic-login]

  Checking basic-login status... ✅ completed

  All dependencies satisfied → Continue to Phase 1

Phase 1: Specification
  [Normal workflow continues...]
```

**If blocked:**
```
Phase 0.5: Dependency Check
  Dependencies: [basic-login, database-migration]

  Checking basic-login... ✅ completed
  Checking database-migration... ⏳ in_progress

  ❌ BLOCKED by dependencies: database-migration

  Updating metadata.yml: status = blocked
  Exit with instructions to check initiative status
```

---

## Best Practices

### 1. Keep Initiatives Focused (3-15 Tasks)

**Good**: "Build authentication system" (5 tasks)
**Too Small**: "Add login button" (1 task - just use feature workflow)
**Too Large**: "Rewrite entire application" (50 tasks - break into multiple initiatives)

### 2. Define Clear Dependencies

**Good**:
```
basic-login → sso-integration → mfa-enhancement
```

**Bad** (unnecessary dependencies):
```
basic-login → mfa-enhancement
```
If mfa doesn't really need basic-login, don't add dependency.

### 3. Use Milestones

Group tasks into milestones:
```
Milestone 1: Basic Auth (tasks 1-2)
Milestone 2: Advanced Features (tasks 3-5)
```

### 4. Monitor Progress Regularly

```bash
/ai-sdlc:initiative:status [path]
```

Check daily for large initiatives.

### 5. Plan for Failures

If a task fails:
1. Fix the task
2. Resume the task
3. Initiative continues automatically when task completes

---

## Common Scenarios

### Scenario: Task Failed Mid-Initiative

**Problem**: One task failed, blocking others

**Solution:**
```bash
# Check which task failed
/ai-sdlc:initiative:status [initiative-path]

# Fix the failed task
/ai-sdlc:[workflow]:resume [failed-task-path]

# Resume initiative (auto-continues)
/ai-sdlc:initiative:resume [initiative-path]
```

### Scenario: Need to Add Task Mid-Initiative

**Problem**: Realized you need an additional task

**Solution:**
1. Update `initiative.yml` with new task
2. Create task directory with `initiative_id`
3. Set dependencies
4. Resume initiative

### Scenario: Dependency No Longer Needed

**Problem**: Task A doesn't actually need Task B

**Solution:**
1. Edit Task A's `metadata.yml`
2. Remove dependency from `dependencies: []`
3. Task A will unblock

---

## Related Workflows

- **[Feature Development](feature-development.md)** - Individual feature tasks
- **[Enhancement Workflow](enhancement-workflow.md)** - Enhancement tasks
- **[Migration Workflow](migrations.md)** - Migration tasks

---

## Additional Resources

- [Command Reference](../../commands/initiative/new.md)
- [Skill Documentation](../../skills/initiative-orchestrator/skill.md)
- [Initiative Planner Agent](../../agents/initiative-planner.md)

---

**Next Steps**: Coordinate your first initiative with `/ai-sdlc:initiative:new [description]`
