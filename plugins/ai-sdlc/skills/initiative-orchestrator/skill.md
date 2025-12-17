---
name: initiative-orchestrator
description: Orchestrates epic-level initiatives from planning through verification, managing multiple related tasks with dependency coordination and sequential execution. Designed for multi-week projects requiring coordination of 3-15 tasks across different types (new-features, enhancements, migrations, etc.).
---

# Initiative Orchestrator

Epic-level coordination of 3-15 related tasks with dependency management and sequential execution.

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Plan initiative tasks", "status": "pending", "activeForm": "Planning initiative tasks"},
  {"content": "Create task directories", "status": "pending", "activeForm": "Creating task directories"},
  {"content": "Resolve dependencies", "status": "pending", "activeForm": "Resolving dependencies"},
  {"content": "Execute tasks", "status": "pending", "activeForm": "Executing tasks"},
  {"content": "Verify initiative", "status": "pending", "activeForm": "Verifying initiative"},
  {"content": "Finalize initiative", "status": "pending", "activeForm": "Finalizing initiative"}
]
```

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Initiative Orchestrator Started

Task: [initiative description]
Mode: [Interactive/YOLO]
Directory: [initiative-path]

Workflow phases:
[Todos list with status]

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Plan initiative tasks...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Initiative Planning).

---

## When to Use This Skill

Use when:
- Epic-level work spanning multiple features (multi-week initiatives)
- Coordinated delivery with related tasks that must work together
- Complex dependencies with technical or logical ordering requirements
- Milestone-based delivery with clear checkpoints

**DO NOT use for**:
- Single standalone tasks (use appropriate task orchestrator)
- Quick fixes or small changes (use individual task types)
- Exploratory work without clear scope (define scope first)

## Core Principles

1. **Dependency-First**: Enforce task execution order based on dependencies
2. **Sequential Execution**: One task at a time to maintain focus and quality
3. **Initiative Context**: Each task knows it's part of a larger initiative
4. **Milestone Tracking**: Group tasks into meaningful delivery checkpoints
5. **Full Resume**: Complete pause/resume capability at any point

---

## Framework Patterns

This orchestrator follows shared patterns. See:

- **Phase Execution**: `../orchestrator-framework/references/phase-execution-pattern.md`
- **State Management**: `../orchestrator-framework/references/state-management.md`
- **Interactive Mode**: `../orchestrator-framework/references/interactive-mode.md`
- **Initialization**: `../orchestrator-framework/references/initialization-pattern.md`

---

## Phase Configuration

| Phase | content | activeForm | Agent/Skill |
|-------|---------|------------|-------------|
| 0 | "Plan initiative tasks" | "Planning initiative tasks" | initiative-planner |
| 1 | "Create task directories" | "Creating task directories" | orchestrator |
| 2 | "Resolve dependencies" | "Resolving dependencies" | orchestrator |
| 3 | "Execute tasks" | "Executing tasks" | orchestrator + task orchestrators |
| 4 | "Verify initiative" | "Verifying initiative" | orchestrator |
| 5 | "Finalize initiative" | "Finalizing initiative" | orchestrator |

**Workflow Overview**: 6 phases

**CRITICAL TodoWrite Usage**:
1. At workflow start: Create todos for ALL phases using the Phase Configuration table above (all status=pending)
2. Before each phase: Update that phase to status=in_progress
3. After each phase: Update that phase to status=completed

---

## Workflow Phases

### Phase 0: Initiative Planning

**Delegate to**: `initiative-planner` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:initiative-planner"
description: "Plan initiative tasks"
prompt: |
  You are the initiative-planner agent. Break down epic into
  concrete tasks with dependency relationships.

  Initiative description: [description]
  Initiative directory: [.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name/]

  Please:
  1. Gather requirements via AskUserQuestion
  2. Analyze codebase (INDEX.md, existing features)
  3. Decompose into 3-15 tasks
  4. Construct dependency graph
  5. Recommend execution strategy
  6. Define milestones
  7. Assess risks

  Create:
  - initiative.yml (task list, dependencies, metadata)
  - spec.md (initiative goals, success criteria)
  - task-plan.md (dependency graph, milestones)

  Use Read, Grep, Glob, Bash, and AskUserQuestion tools. Do NOT modify code.
```

**Validation**:
- ✅ initiative.yml exists with 3-15 tasks
- ✅ No circular dependencies
- ✅ All task IDs unique
- ✅ All dependency references valid

**Outputs**: `initiative.yml`, `spec.md`, `task-plan.md`

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 1.

---

### Phase 1: Task Creation

**Execution**: Main orchestrator (direct)

**Process**:
1. Read initiative.yml, extract task list
2. Create task directories in `.ai-sdlc/tasks/[type]/YYYY-MM-DD-task-name/`
3. Initialize task metadata.yml with initiative fields:
   ```yaml
   initiative_id: YYYY-MM-DD-initiative-name
   dependencies: [array of task paths]
   blocks: [array of task paths that depend on this]
   milestone: Milestone Name
   ```
4. Create placeholder spec.md in each task directory
5. Create initiative-state.yml with all task tracking

**Outputs**: Task directories, metadata.yml files, placeholder specs, initiative-state.yml

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 2.

---

### Phase 2: Dependency Resolution

**Execution**: Main orchestrator (direct)

**Process**:
1. Build dependency graph from initiative.yml
2. Validate graph:
   - **Cycle Detection**: Topological sort, fail if cycle found
   - **Reference Validation**: All dependencies point to valid task IDs
   - **Completeness**: All tasks reachable
3. Compute dependency levels (BFS from tasks with no dependencies)
4. Build execution queue ordered by levels
5. Identify critical path (longest path through graph)
6. Update initiative-state.yml with execution plan

**Outputs**: Validated dependency graph, execution queue, critical path

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 3.

---

### Phase 3: Task Execution

**Execution**: Main orchestrator (invokes task orchestrators via Skill tool)

**IMPORTANT**: Execute tasks ONE AT A TIME (sequential execution)

**Task Type to Orchestrator Mapping**:

| Task Type | Orchestrator |
|-----------|--------------|
| new-feature | development-orchestrator --type=feature |
| enhancement | development-orchestrator --type=enhancement |
| bug-fix | development-orchestrator --type=bug |
| migration | migration-orchestrator |
| refactoring | refactoring-orchestrator |
| performance | performance-orchestrator |
| security | security-orchestrator |
| documentation | documentation-orchestrator |

**Execution Loop**:
1. Select next task from queue (respecting dependency order)
2. Read task's metadata.yml to determine type
3. Invoke appropriate orchestrator via Skill tool
4. Wait for orchestrator to complete
5. Update initiative-state.yml with completion status
6. Unblock dependent tasks (check if their dependencies now satisfied)
7. Repeat until all tasks complete

**Dependency Unblocking**:
- On task completion, read its `blocks` field
- For each dependent task, check if ALL dependencies now completed
- If yes, move from `blocked` to `pending` in queue

**Failure Handling**:
- Task failure → Pause initiative, prompt user
- Options: Skip task (marks dependents as blocked), retry, abort
- Dependent tasks cannot proceed if dependency failed

**⏸️ INTERACTIVE MODE: STOP HERE** - After each task completes, use `AskUserQuestion` before proceeding to the next task.

---

### Phase 4: Initiative Verification

**Execution**: Main orchestrator (direct)

**Process**:
1. Validate all tasks completed (check initiative-state.yml)
2. Read each task's verification report
3. Aggregate issues across all tasks
4. Check initiative acceptance criteria from spec.md
5. Create initiative verification report with:
   - Task completion summary
   - Aggregated issues (critical, warnings)
   - Success criteria verification
   - Deployment readiness recommendation (GO/NO-GO)

**Outputs**: `verification-report.md`

**Gate**: Cannot proceed to Phase 5 if critical issues found

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 5.

---

### Phase 5: Finalization

**Execution**: Main orchestrator (direct)

**Process**:
1. Update roadmap.md (if exists) with initiative completion
2. Create initiative summary.md with:
   - Duration and hours (actual vs estimated)
   - Tasks completed
   - Milestones achieved
   - Metrics (estimation accuracy, success rate)
   - Lessons learned
3. Mark initiative-state.yml as completed

**Outputs**: Updated roadmap.md, summary.md, completed initiative-state.yml

---

## Domain Context (State Extensions)

Initiative-specific fields in `initiative-state.yml`:

```yaml
orchestrator:
  mode: interactive | yolo
  current_phase: planning | task-creation | dependency-resolution | task-execution | verification | finalization | completed
  execution_strategy: sequential

tasks:
  pending: [task-ids]
  in_progress: [task-ids]
  completed: [task-ids]
  blocked: [task-ids]
  failed: [task-ids]

  details:
    task-id:
      path: .ai-sdlc/tasks/[type]/YYYY-MM-DD-name
      type: new-feature | enhancement | etc
      status: pending | in-progress | completed | blocked | failed
      dependencies: [task-paths]
      blocks: [task-ids]
      estimated_hours: X
      actual_hours: Y

execution:
  current_level: N
  total_levels: M
  levels:
    level-0: [task-ids]
    level-1: [task-ids]
  critical_path: [task-ids]

progress:
  total_tasks: N
  completed: X
  percent: (completed/total * 100)
  estimated_hours: X
  actual_hours: Y
```

---

## Integration with Task Orchestrators

Task orchestrators (development, migration, etc.) add **Phase 0.5: Dependency Check** when part of an initiative:

1. Read task metadata.yml
2. If `initiative_id` exists:
   - Check all dependencies have `status: completed`
   - If any dependency not completed: BLOCK task, exit
3. If no `initiative_id`: Skip check (standalone task)

**Impact**: ~30 lines per orchestrator, no breaking changes to standalone tasks

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| 0 | 2 | Re-run planner with feedback if circular deps or task count issues |
| 1 | 3 | Skip existing directories, map invalid types to closest valid |
| 2 | 2 | Remove invalid dependencies, fail if no Level 0 tasks |
| 3 | Delegated | Task orchestrators handle their own recovery; initiative pauses on persistent failure |
| 4 | 2 | Return to Phase 3 if not all tasks complete |
| 5 | 3 | Skip roadmap update if file not found |

**Task Failure Handling**:
- Attempts 1-2: Delegate to task orchestrator's auto-fix
- Attempt 3+: Pause initiative, prompt user (skip/retry/abort)

---

## Resume Capability

**Command**: `/ai-sdlc:initiative:resume [initiative-path]`

**Process**:
1. Load initiative-state.yml
2. Validate state consistency (tasks exist, states match)
3. Determine resume point from current_phase
4. Reconstruct context from initiative.yml and task metadata files
5. Continue from current_phase

**State Reconstruction** (if initiative-state.yml corrupted):
1. Read initiative.yml (source of truth for task list)
2. Poll all task metadata.yml files for current status
3. Rebuild dependency graph
4. Prompt user to confirm reconstructed state

---

## Task Structure

```
.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-initiative-name/
├── initiative.yml         # Task list, dependencies, metadata
├── initiative-state.yml   # Execution state and progress
├── spec.md                # Initiative goals, success criteria
├── task-plan.md           # Dependency graph, milestones
├── verification-report.md # Phase 4 output
└── summary.md             # Phase 5 output

.ai-sdlc/tasks/[type]/YYYY-MM-DD-task-name/
├── metadata.yml           # Includes initiative_id, dependencies, blocks
├── implementation/spec.md # Task specification (placeholder then full)
└── ...                    # Standard task structure
```

---

## Command Integration

Invoked via:
- `/ai-sdlc:initiative:new [description] [--yolo]`
- `/ai-sdlc:initiative:resume [initiative-path]`
- `/ai-sdlc:initiative:status [initiative-path]` (view progress)

Initiative directory: `.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name/`

---

## Constraints

- **Task Count**: 3-15 tasks per initiative
- **Execution**: Sequential (one task at a time)
- **Dependency Depth**: Warn if >6 levels (very long critical path)
- **Phase Boundaries**: Always save state at phase boundaries

---

## Success Criteria

Initiative orchestration successful when:

- All tasks completed or accounted for (completed/blocked/skipped)
- Dependencies enforced throughout execution
- Verification reports show passed or passed-with-issues
- Initiative summary created with metrics
- Roadmap updated (if exists)
- Full pause/resume capability maintained
- No data loss on interruption
