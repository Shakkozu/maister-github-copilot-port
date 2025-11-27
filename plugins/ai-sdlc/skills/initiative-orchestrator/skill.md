# Initiative Orchestrator Skill

## Purpose

Orchestrates epic-level initiatives from planning through verification, managing multiple related tasks with dependency coordination, mixed sequential/parallel execution, and robust state management. Designed for multi-week projects requiring coordination of 3-15 tasks across different types (new-features, enhancements, migrations, etc.).

## When to Use

- **Epic-level work**: Large multi-week initiatives spanning multiple features
- **Coordinated delivery**: Multiple related tasks that must work together
- **Complex dependencies**: Tasks with technical or logical ordering requirements
- **Team coordination**: Work that requires parallel execution across team members
- **Milestone-based delivery**: Initiatives with clear delivery checkpoints

## Progress Tracking

Use `TodoWrite` to show real-time progress to the user. Create todos at workflow start, update at each phase transition.

**Phase Todos**:

| Phase | content | activeForm |
|-------|---------|------------|
| 0 | "Plan initiative tasks" | "Planning initiative tasks" |
| 1 | "Create task directories" | "Creating task directories" |
| 2 | "Resolve dependencies" | "Resolving dependencies" |
| 3 | "Execute tasks" | "Executing tasks" |
| 4 | "Verify initiative" | "Verifying initiative" |
| 5 | "Finalize initiative" | "Finalizing initiative" |

**Rules**:
- Create all phase todos at workflow start (pending)
- Mark current phase `in_progress` before execution
- Mark phase `completed` immediately after success
- State file remains source of truth for resume logic

---

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

Initiative: [description]
Mode: [Interactive/YOLO]

Workflow Phases:
0. [ ] Initiative Planning → initiative-planner subagent
1. [ ] Task Creation → create task directories
2. [ ] Dependency Resolution → validate and compute execution order
3. [ ] Task Execution → orchestrate task completion
4. [ ] Initiative Verification → verify all tasks, run integration tests
5. [ ] Finalization → update roadmap, create summary

State file: [initiative-path]/initiative-state.yml

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Initiative Planning...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Initiative Planning).

---

## Not Suitable For

- Single standalone tasks (use feature/enhancement/migration orchestrators)
- Quick fixes or small changes (use individual task types)
- Exploratory work without clear scope (define scope first)

## Workflow Overview

**6 Phases with Adaptive Execution**:

0. **Initiative Planning** → Delegate to initiative-planner agent
1. **Task Creation** → Create task directories and metadata
2. **Dependency Resolution** → Validate dependencies, determine execution strategy
3. **Task Execution** → Orchestrate task completion (sequential/parallel/mixed)
4. **Initiative Verification** → Verify all tasks complete, run integration tests
5. **Finalization** → Update roadmap, create summary, archive

**Execution Modes**:
- **Interactive**: Pause after each phase for user review (default)
- **YOLO**: Continuous execution with auto-decisions

**State Management**: File-based with timestamp conflict detection and full pause/resume capability

## Skill Configuration

```yaml
name: initiative-orchestrator
description: Orchestrates epic-level initiatives from planning through verification with dependency management and mixed execution
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
  - TodoWrite
  - AskUserQuestion
```

## Invocation

**Model-Invoked**: Claude automatically triggers this skill when users request epic-level coordination

**Command-Invoked**: Via `/ai-sdlc:initiative:new` or `/ai-sdlc:initiative:resume`

**Trigger Keywords**:
- "coordinate multiple features"
- "epic", "initiative", "project"
- "implement feature set"
- "multi-task workflow"
- "roadmap delivery"

## Prerequisites

✅ AI SDLC framework initialized (`.ai-sdlc/docs/` exists)
✅ Documentation INDEX and standards available
✅ Task orchestrators available (feature, enhancement, migration)

## Phase 0: Initiative Planning

**Objective**: Break epic into tasks with dependency graph

**Delegation**: Launch `initiative-planner` agent (autonomous planning specialist)

### Process

1. **Validate Input**
   - Check initiative description provided
   - Verify `.ai-sdlc/docs/` structure exists
   - Read INDEX.md for project context

2. **Create Initiative Directory**
   ```
   .ai-sdlc/docs/project/initiatives/YYYY-MM-DD-initiative-name/
   ```

3. **Invoke initiative-planner via Task tool:**
   ```markdown
   Use Task tool with parameters:
   - subagent_type: "ai-sdlc:initiative-planner"
   - description: "Plan initiative tasks"
   - prompt: Execute initiative planning:
     - Requirements gathering via AskUserQuestion
     - Codebase analysis (INDEX.md, existing features)
     - Task decomposition (3-15 tasks)
     - Dependency graph construction
     - Execution strategy recommendation
     - Milestone definition
     - Risk assessment
     - Create: initiative.yml, spec.md, task-plan.md
   ```

4. **Validate Output**
   - ✅ initiative.yml exists with task list and dependencies
   - ✅ spec.md exists with initiative goals
   - ✅ task-plan.md exists with dependency graph
   - ✅ No circular dependencies
   - ✅ All task IDs unique
   - ✅ All dependencies reference valid task IDs

### Outputs

- `initiatives/YYYY-MM-DD-name/initiative.yml`
- `initiatives/YYYY-MM-DD-name/spec.md`
- `initiatives/YYYY-MM-DD-name/task-plan.md`

### Auto-Recovery

**Max Attempts**: 2

**Common Failures**:
1. **Circular dependencies detected**
   - Fix: Re-run planner with explicit instruction to avoid cycles
   - Provide detected cycle as feedback

2. **Task count out of range** (<3 or >15)
   - Fix: Re-run with scope adjustment guidance

3. **Missing dependency references**
   - Fix: Validate all referenced tasks exist, regenerate if needed

### Interactive Mode Pause

**Prompt User**:
```
Initiative planning complete:
- Total tasks: N
- Estimated hours: X
- Execution strategy: [Sequential/Parallel/Mixed]
- Milestones: [List]

Review: initiatives/YYYY-MM-DD-name/task-plan.md

Continue to task creation? [Yes/No/Adjust]
```

**Options**:
- **Yes**: Proceed to Phase 1
- **No**: Exit, allow manual adjustments
- **Adjust**: Re-run planner with new constraints

### State Update

```yaml
orchestrator:
  current_phase: planning
  completed_phases: []
  phase_results:
    planning:
      initiative_path: initiatives/YYYY-MM-DD-name
      task_count: N
      estimated_hours: X
      strategy: mixed
      milestones: [array]
```

---

## Phase 1: Task Creation

**Objective**: Create task directory structure and initialize metadata

### Process

1. **Read Initiative Plan**
   - Load `initiative.yml`
   - Extract task list with types and dependencies

2. **Create Task Directories**
   - For each task in initiative.yml:
     ```
     .ai-sdlc/tasks/[type]/YYYY-MM-DD-task-name/
     ├── metadata.yml (with initiative_id, dependencies)
     ├── analysis/
     ├── implementation/
     └── verification/
     ```

3. **Initialize Task Metadata**
   ```yaml
   name: Task Name
   type: new-feature|enhancement|migration|etc
   status: pending
   priority: high|medium|low
   created: YYYY-MM-DD
   updated: YYYY-MM-DD

   # Initiative fields
   initiative_id: YYYY-MM-DD-initiative-name
   dependencies: [array of task paths]
   blocks: [array of task paths that depend on this]
   milestone: Milestone Name

   estimated_hours: X
   actual_hours: 0
   ```

4. **Create Placeholder Specs**
   - For each task, create minimal `implementation/spec.md`:
     ```markdown
     # [Task Name]

     Part of initiative: [initiative-name]

     ## Description

     [From initiative.yml task description]

     ## Dependencies

     - [List prerequisite tasks]

     ## Blocks

     - [List dependent tasks]

     ## Acceptance Criteria

     [From task-plan.md]

     ---

     **Note**: This is a placeholder spec. Full specification will be created during task execution.
     ```

5. **Update Initiative State**
   - Create `initiative-state.yml` in initiative directory:
     ```yaml
     meta:
       last_updated: YYYY-MM-DDTHH:MM:SSZ
       version: 1

     orchestrator:
       mode: interactive|yolo
       current_phase: task-creation
       execution_strategy: sequential|parallel|mixed

     tasks:
       pending: [all-task-ids]
       in_progress: []
       completed: []
       blocked: []
       failed: []

       details:
         task-id-1:
           path: .ai-sdlc/tasks/new-features/YYYY-MM-DD-task-1
           type: new-feature
           status: pending
           dependencies: []
           blocks: [task-id-2]
           estimated_hours: 40
           actual_hours: 0

     progress:
       total_tasks: N
       completed: 0
       percent: 0

     coordination:
       parallel_running: 0
       max_parallel: 3
       next_poll: null
     ```

### Outputs

- Task directories created in `.ai-sdlc/tasks/[type]/`
- Task metadata.yml files initialized
- Placeholder spec.md files created
- `initiative-state.yml` created

### Auto-Recovery

**Max Attempts**: 3

**Common Failures**:
1. **Task directory already exists**
   - Fix: Skip existing, log warning, continue

2. **Invalid task type**
   - Fix: Map to closest valid type or prompt user

### Interactive Mode Pause

**Prompt User**:
```
Task directories created:
- Total: N tasks
- Types: X new-features, Y enhancements, Z migrations
- Status: All pending, ready for execution

Review: .ai-sdlc/tasks/

Continue to dependency resolution? [Yes/No]
```

### State Update

```yaml
completed_phases: [planning, task-creation]
current_phase: dependency-resolution
phase_results:
  task_creation:
    tasks_created: N
    task_types: {new-feature: X, enhancement: Y, ...}
```

---

## Phase 2: Dependency Resolution

**Objective**: Validate dependencies and finalize execution strategy

### Process

1. **Load Dependency Graph**
   - Read initiative.yml task dependencies
   - Build adjacency list representation

2. **Validate Graph**
   - ✅ **Cycle Detection**: Run topological sort, fail if cycle found
   - ✅ **Reference Validation**: All dependencies point to valid task IDs
   - ✅ **Completeness**: All tasks reachable from graph

3. **Compute Dependency Levels**
   - Perform breadth-first traversal from tasks with no dependencies
   - Assign level to each task (Level 0 = no deps, Level N = max dep level + 1)
   - Identify critical path (longest path through graph)

4. **Determine Execution Groups**
   - Group tasks by dependency level
   - Within each level, tasks can execute in parallel
   - Between levels, execution must be sequential

5. **Finalize Execution Strategy**
   - Read recommended strategy from initiative.yml
   - Validate against dependency graph
   - **Sequential**: Execute one task at a time, respect dependencies
   - **Parallel**: Execute all Level N tasks concurrently before Level N+1
   - **Mixed**: Execute sequential between levels, parallel within levels (recommended)

6. **Update Initiative State**
   - Save execution groups
   - Mark tasks with zero dependencies as "ready to start"
   - Mark tasks with unsatisfied dependencies as "blocked"

### Outputs

- Validated dependency graph
- Execution groups (Level 0, Level 1, ..., Level N)
- Critical path identified
- Updated `initiative-state.yml` with execution plan

### Auto-Recovery

**Max Attempts**: 2

**Common Failures**:
1. **Circular dependency detected**
   - Fix: Identify cycle, prompt user to resolve (manual intervention required)
   - Provide cycle path: A → B → C → A

2. **Missing dependency reference**
   - Fix: Remove invalid dependency, log warning, continue

3. **All tasks blocked** (no Level 0 tasks)
   - Fix: Graph construction error, fail with clear message

### Interactive Mode Pause

**Prompt User**:
```
Dependency resolution complete:
- Dependency levels: N
- Critical path: [task-1] → [task-2] → [task-3] (X hours)
- Execution strategy: Mixed
  - Level 0: [task-A, task-B] (parallel)
  - Level 1: [task-C] (depends on A, B)
  - Level 2: [task-D, task-E] (parallel)

Review: initiatives/YYYY-MM-DD-name/task-plan.md

Ready to begin task execution? [Yes/No]
```

### State Update

```yaml
completed_phases: [planning, task-creation, dependency-resolution]
current_phase: task-execution
phase_results:
  dependency_resolution:
    total_levels: N
    execution_groups: {level-0: [...], level-1: [...]}
    critical_path: [task-ids]
    critical_path_hours: X
    strategy: mixed
```

---

## Phase 3: Task Execution

**Objective**: Orchestrate task completion with dependency enforcement

**Core Mechanism**: Launch task orchestrators (feature/enhancement/migration) with dependency awareness

### Process

#### 3.1 Initialize Execution

1. **Read Initiative State**
   - Load `initiative-state.yml`
   - Identify current execution group (start with Level 0)

2. **Determine Tasks to Execute**
   - If sequential mode: Select 1 task from current level
   - If parallel/mixed mode: Select all tasks from current level

3. **Pre-Execution Validation**
   - For each task, verify all dependencies are `completed`
   - If any dependency not completed: Mark task as `blocked`, skip

#### 3.2 Launch Task Orchestrators

**Key Principle**: Use **single message with multiple Skill tool calls** for parallel execution (per Claude Code docs)

**Sequential Mode**:
```markdown
1. Select next task from queue (dependency order)
2. Determine task type from metadata.yml
3. Launch appropriate orchestrator skill:
   - New features → Skill: feature-orchestrator
   - Enhancements → Skill: enhancement-orchestrator
   - Migrations → Skill: migration-orchestrator
   - Bug fixes → Skill: bug-fix-orchestrator
   - Refactoring → Skill: refactoring-orchestrator
4. Wait for completion
5. Update initiative-state.yml
6. Repeat until all tasks complete
```

**Parallel/Mixed Mode**:
```markdown
1. Identify all tasks in current level with satisfied dependencies
2. Launch ALL orchestrators in single message:

   Use Skill tool (multiple calls in one message):
   - Skill call 1: skill=feature-orchestrator for task-A
   - Skill call 2: skill=feature-orchestrator for task-B
   - Skill call 3: skill=enhancement-orchestrator for task-C

3. Monitor all running tasks (see 3.3 Task Monitoring)
4. Wait for ALL tasks in level to complete
5. Move to next level
6. Repeat until all levels complete
```

**Skill Invocation Details**:
```markdown
Skill tool usage:
- skill: [feature-orchestrator|enhancement-orchestrator|migration-orchestrator|bug-fix-orchestrator|refactoring-orchestrator]
- The skill receives task path and initiative context via its standard input

Orchestrator receives:
    Task path: [task-path]

    Initiative context:
    - Part of initiative: [initiative-name]
    - Initiative ID: [initiative-id]
    - Dependencies satisfied: [list]
    - This task will unblock: [list]

    Execution mode: [--yolo flag if initiative in yolo mode, otherwise interactive]

    Task metadata.yml already has:
    - initiative_id: [id]
    - dependencies: [paths]
    - blocks: [ids]

    Phase 0.5 (Dependency Check) verifies dependencies before proceeding.

After completion, orchestrator updates:
    - Task metadata.yml status to "completed"
    - actual_hours field with final hours
```

#### 3.3 Task Monitoring

**Polling Strategy** (for parallel execution):

1. **Launch all tasks in level** (single message, multiple Skill calls)
2. **Poll task states** every 30 seconds or on phase boundaries:
   - Read each task's `orchestrator-state.yml`
   - Check `current_phase` and `completed_phases`
3. **Detect completion**: When `current_phase == "completed"` or all phases in `completed_phases`
4. **Update initiative state**:
   - Move task from `in_progress` to `completed`
   - Record actual_hours from task metadata.yml
   - Update progress metrics

**State Coordination**:
- Each task orchestrator owns its `orchestrator-state.yml`
- Initiative orchestrator owns `initiative-state.yml`
- Coordination via file reads (poll task states)
- No shared state modification (no race conditions)

#### 3.4 Dependency Unblocking

**On Task Completion**:

1. **Identify dependent tasks**:
   - Read completed task's `blocks` field from metadata.yml
   - Get list of task IDs that depend on this task

2. **Check if unblocked**:
   - For each dependent task:
     - Read task's `dependencies` field
     - Check if ALL dependencies now `completed`
     - If yes: Update status from `blocked` to `pending`

3. **Add to execution queue**:
   - If sequential mode: Add to end of queue
   - If parallel/mixed mode: Add to next level's execution group

4. **Update initiative state**:
   - Move task from `blocked` to `pending`
   - Log unblock event with timestamp

#### 3.5 Failure Handling

**Task Orchestrator Failure**:

1. **Detect failure**:
   - Task orchestrator reports failure
   - Or: Task orchestrator-state.yml shows `failed_phases`

2. **Record failure**:
   ```yaml
   tasks:
     failed:
       - task_id: task-A
         phase: implementation
         error: "Tests failed, 5 failures detected"
         attempts: 3
         timestamp: YYYY-MM-DDTHH:MM:SSZ
   ```

3. **Determine impact**:
   - Read task's `blocks` field
   - Identify all dependent tasks
   - Mark dependent tasks as `blocked` (cannot proceed)

4. **Auto-Recovery Strategy**:
   - **Attempt 1-2**: Auto-retry task orchestrator (delegate recovery to task orchestrator's own auto-fix)
   - **Attempt 3+**: Pause initiative, prompt user

5. **User Prompt** (after max attempts):
   ```
   Task failed: [task-name]
   Phase: [phase]
   Error: [error message]

   This task blocks: [list of dependent tasks]

   Options:
   1. Skip task and continue (will mark dependent tasks as blocked)
   2. Manually fix and resume task
   3. Abort initiative
   ```

#### 3.6 Progress Tracking

**Update after each task**:

```yaml
progress:
  total_tasks: 10
  completed: 3
  in_progress: 2
  blocked: 2
  failed: 1
  pending: 2
  percent: 30

  estimated_hours: 240
  actual_hours: 85
  remaining_hours: 155

  current_level: 1
  total_levels: 4
```

**TodoWrite Integration**:

```markdown
Initiative-level todos (updated during execution):
- [ ] Level 0: Execute tasks A, B (2/2 complete) ✅
- [ ] Level 1: Execute task C (1/1 in progress) 🔄
- [ ] Level 2: Execute tasks D, E (pending)
- [ ] Level 3: Execute task F (pending)
```

### Outputs

- All task orchestrators executed
- Task metadata.yml files updated with `status: completed` and actual_hours
- Initiative-state.yml updated with completion progress
- Failed tasks recorded (if any)

### Auto-Recovery

**Max Attempts**: Delegated to task orchestrators (each has own limits)

**Initiative-Level Recovery**:
- **Parallel execution failure**: Continue other parallel tasks, retry failed task
- **Critical path failure**: Pause initiative, prompt user (blocks entire initiative)
- **Non-critical path failure**: Log, continue (can fix later)

### Interactive Mode Pause

**After each level** (if interactive mode):
```
Level N complete:
- Tasks completed: [list]
- Total time: X hours
- Next level: [N+1] with tasks [list]

Continue to next level? [Yes/No/Pause]
```

**On failure** (both modes):
```
Task failed: [task-name]
[Details above in 3.5]
```

### State Update

```yaml
completed_phases: [planning, task-creation, dependency-resolution, task-execution]
current_phase: initiative-verification
phase_results:
  task_execution:
    completed_tasks: N
    failed_tasks: M
    total_hours: X
    execution_levels_completed: L
    failures: [array if any]
```

---

## Phase 4: Initiative Verification

**Objective**: Verify all tasks complete and integration works

### Process

1. **Validate Task Completion**
   - Read initiative-state.yml
   - Check all tasks in `completed` list
   - Verify: completed count == total count

2. **Check Task Verification Reports**
   - For each task, read `verification/implementation-verification.md`
   - Verify overall status is ✅ Passed or ⚠️ Passed with Issues
   - Aggregate issues across all tasks

3. **Integration Testing** (optional)
   - If initiative involves multiple interacting features:
     - Consider E2E tests across features
     - Example: User can log in (task 1) AND create content (task 2)
   - Run cross-task integration tests if defined

4. **Check Acceptance Criteria**
   - Read initiative spec.md success criteria
   - Verify each criterion met
   - Document evidence

5. **Create Initiative Verification Report**
   ```markdown
   # Initiative Verification Report

   Initiative: [Name]
   Date: YYYY-MM-DD

   ## Task Completion Summary

   | Task | Type | Status | Verification | Issues |
   |------|------|--------|--------------|--------|
   | [name] | feature | ✅ Complete | ✅ Passed | None |
   | [name] | enhancement | ✅ Complete | ⚠️ Issues | 2 warnings |

   **Overall**: X/X tasks completed

   ## Integration Testing

   [If performed, results here]

   ## Success Criteria Verification

   - [x] Criterion 1: [Evidence]
   - [x] Criterion 2: [Evidence]
   - [ ] Criterion 3: [Not met - reason]

   ## Aggregated Issues

   ### Critical
   - [List any critical issues across all tasks]

   ### Warnings
   - [List warnings]

   ### Info
   - [List info items]

   ## Recommendations

   - [Action item 1]
   - [Action item 2]

   ## Overall Status

   ✅ **Passed**: Initiative complete and verified
   ⚠️ **Passed with Issues**: Complete but issues need addressing
   ❌ **Failed**: Critical issues prevent completion

   ## Deployment Readiness

   **Recommendation**: [GO / NO-GO / GO with conditions]

   **Conditions** (if any):
   - [Condition 1]
   ```

6. **Save Report**
   - Write to `initiatives/YYYY-MM-DD-name/verification-report.md`

### Outputs

- Initiative verification report
- Aggregated issues list
- Deployment readiness recommendation

### Auto-Recovery

**Max Attempts**: 2

**Common Failures**:
1. **Not all tasks completed**
   - Fix: Return to Phase 3, identify incomplete tasks

2. **Critical issues found**
   - Fix: Prompt user, create remediation task list

### Interactive Mode Pause

**Prompt User**:
```
Initiative verification complete:
- Status: [Passed/Passed with Issues/Failed]
- Tasks: X/X complete
- Issues: Y critical, Z warnings

Review: initiatives/YYYY-MM-DD-name/verification-report.md

Proceed to finalization? [Yes/No/Fix Issues]
```

### State Update

```yaml
completed_phases: [..., initiative-verification]
current_phase: finalization
phase_results:
  verification:
    status: passed|passed-with-issues|failed
    critical_issues: Y
    warnings: Z
    deployment_ready: true|false
```

---

## Phase 5: Finalization

**Objective**: Update roadmap, create summary, mark initiative complete

### Process

1. **Update Roadmap** (if exists)
   - Read `.ai-sdlc/docs/project/roadmap.md`
   - Find initiative entry (or create if not exists)
   - Mark as complete:
     ```markdown
     ## Initiatives

     ### ✅ Initiative: User Authentication System
     **Status**: Completed
     **Completion Date**: YYYY-MM-DD
     **Actual Duration**: X weeks
     **Tasks**: [list with links]

     **Summary**: [Brief summary]
     ```

2. **Create Initiative Summary**
   ```markdown
   # Initiative Summary: [Name]

   ## Overview

   **Started**: YYYY-MM-DD
   **Completed**: YYYY-MM-DD
   **Duration**: X weeks
   **Total Hours**: Y hours (estimated: Z hours)

   ## Tasks Completed

   1. [Task name] ([type]) - X hours
   2. [Task name] ([type]) - Y hours
   ...

   Total: N tasks

   ## Milestones Achieved

   - [Milestone 1]: [Date]
   - [Milestone 2]: [Date]
   ...

   ## Metrics

   - **Estimation Accuracy**: Actual vs Estimated hours
   - **Task Success Rate**: X% completed without issues
   - **Critical Path Adherence**: [On time / Delayed by Y days]

   ## Lessons Learned

   ### What Went Well
   - [Item 1]
   - [Item 2]

   ### Challenges
   - [Challenge 1 and how resolved]
   - [Challenge 2 and how resolved]

   ### For Next Time
   - [Improvement 1]
   - [Improvement 2]

   ## Verification

   - Overall Status: [Passed/Passed with Issues]
   - See: verification-report.md

   ## Deliverables

   [Links to key outputs, documentation, features]
   ```

3. **Update Initiative State to Complete**
   ```yaml
   orchestrator:
     current_phase: completed
     completed_phases: [all phases]

   completion:
     timestamp: YYYY-MM-DDTHH:MM:SSZ
     total_duration_hours: X
     success_rate: Y%
   ```

4. **Archive Initiative** (optional)
   - Could move to `initiatives/archive/` or add `archived: true` flag
   - For now, just mark as complete in state

### Outputs

- Updated roadmap.md (if exists)
- Initiative summary.md
- Completed initiative-state.yml
- All tasks marked complete in metadata.yml

### Auto-Recovery

**Max Attempts**: 3

**Common Failures**:
1. **Roadmap file not found**
   - Fix: Skip roadmap update, log info message

2. **File write failures**
   - Fix: Retry, if fails, log warning but continue

### Interactive Mode Pause

**Prompt User**:
```
Initiative finalization complete:
- Summary: initiatives/YYYY-MM-DD-name/summary.md
- Roadmap updated: ✅
- Duration: X weeks (estimated: Y weeks)
- Total hours: A hours (estimated: B hours)

Initiative successfully completed! 🎉

View summary? [Yes/No]
```

### State Update

```yaml
completed_phases: [all]
current_phase: completed
final_status: success|partial-success|failed
phase_results:
  finalization:
    roadmap_updated: true
    summary_created: true
    archived: false
```

---

## State Management

### Initiative-State File Location

```
.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name/initiative-state.yml
```

### State File Structure

```yaml
meta:
  last_updated: YYYY-MM-DDTHH:MM:SSZ
  version: 1

orchestrator:
  mode: interactive|yolo
  current_phase: planning|task-creation|dependency-resolution|task-execution|initiative-verification|finalization|completed
  completed_phases: [array]
  failed_phases: [array]
  execution_strategy: sequential|parallel|mixed

  auto_fix_attempts:
    planning: 0
    task_creation: 0
    dependency_resolution: 0
    task_execution: 0
    verification: 0

tasks:
  pending: [task-ids]
  in_progress: [task-ids]
  completed: [task-ids]
  blocked: [task-ids]
  failed: [task-ids]

  details:
    task-id:
      path: .ai-sdlc/tasks/[type]/YYYY-MM-DD-name
      type: new-feature|enhancement|etc
      status: pending|in-progress|completed|blocked|failed
      dependencies: [task-paths]
      blocks: [task-ids]
      started: YYYY-MM-DDTHH:MM:SSZ
      completed: YYYY-MM-DDTHH:MM:SSZ
      estimated_hours: X
      actual_hours: Y
      orchestrator_phase: [current phase of task orchestrator]

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
  in_progress: Y
  blocked: Z
  failed: W
  pending: V
  percent: (completed/total * 100)

  estimated_hours: X
  actual_hours: Y
  remaining_hours: Z

coordination:
  parallel_running: N
  max_parallel: 3
  last_poll: YYYY-MM-DDTHH:MM:SSZ
  next_poll: YYYY-MM-DDTHH:MM:SSZ

timestamps:
  created: YYYY-MM-DDTHH:MM:SSZ
  started: YYYY-MM-DDTHH:MM:SSZ
  completed: YYYY-MM-DDTHH:MM:SSZ

phase_results:
  [phase-name]:
    [phase-specific results]
```

### Conflict Detection

**Timestamp-Based Locking**:

```yaml
# Before updating state:
1. Read current initiative-state.yml
2. Check meta.last_updated timestamp
3. If timestamp newer than last read: CONFLICT
   - Re-read state
   - Merge changes
   - Retry update
4. Update meta.last_updated to current time
5. Write state file
```

**Conflict Scenarios**:
- Multiple parallel tasks complete simultaneously
- User manually edits state while orchestrator running
- Race condition between polling cycles

**Resolution**:
- Re-read current state
- Preserve newer updates
- Apply new changes
- Increment conflict counter (for monitoring)

---

## Resume Capability

### Resume from Saved State

**Command**: `/ai-sdlc:initiative:resume [initiative-path]`

**Process**:

1. **Read State File**
   - Load `initiative-state.yml`
   - Check `current_phase`

2. **Validate State**
   - Verify all referenced tasks exist
   - Check for inconsistencies (e.g., completed task shows in-progress)

3. **Determine Resume Point**
   - If `current_phase == completed`: Already done, show summary
   - If `current_phase` in middle of execution: Resume from that phase
   - If failed_phases present: Offer to retry or skip

4. **Reconstruct Context**
   - Read initiative.yml, spec.md, task-plan.md
   - Load task states from task metadata.yml files
   - Reconcile any differences between initiative-state and task states

5. **Resume Execution**
   - Continue from current_phase
   - Respect mode (interactive vs YOLO)

### Resume from Task Failure

**Scenario**: Initiative paused due to task failure

**Process**:

1. **Check failed_tasks list** in initiative-state.yml
2. **User has two options**:
   - Fix manually and mark task as complete
   - Skip task and continue (will mark dependent tasks as blocked)
3. **Resume with**:
   ```
   /ai-sdlc:initiative:resume [path] --from=task-execution
   ```
4. **Orchestrator**:
   - Re-checks failed task status
   - If fixed: Move to completed, unblock dependents
   - If still failed: Skip, mark dependents as blocked
   - Continue with remaining tasks

### State Reconstruction

**If initiative-state.yml lost or corrupted**:

1. **Read initiative.yml** (source of truth for task list)
2. **Poll all task metadata.yml files**:
   - Read status field
   - Read actual_hours
3. **Reconstruct state**:
   - Completed: status == "completed"
   - In-progress: status == "in-progress"
   - Blocked: Dependencies not satisfied
   - Pending: Dependencies satisfied, not started
4. **Rebuild dependency graph** from initiative.yml
5. **Determine current phase**:
   - All complete → finalization
   - Some in-progress → task-execution
   - None started → task-creation or dependency-resolution
6. **Prompt user to confirm** reconstructed state

---

## Reference Documentation

For detailed algorithms and patterns, see:

- **references/phases.md**: Detailed phase workflows and decision points
- **references/execution-strategies.md**: Sequential, parallel, and mixed execution patterns
- **references/dependency-resolution.md**: Dependency graph algorithms and cycle detection
- **references/state-coordination.md**: File-based state management and conflict resolution

---

## Integration with Existing Orchestrators

### Minimal Changes to Task Orchestrators

**Add Phase 0.5 to**: feature-orchestrator, enhancement-orchestrator, migration-orchestrator

```markdown
### Phase 0.5: Dependency Check

**When**: Before Phase 1 (Specification)

**Process**:
1. Read task metadata.yml
2. IF initiative_id field exists:
   a. Read dependencies array
   b. For each dependency task path:
      - Read dependency task metadata.yml
      - Check status field
   c. IF any dependency status != "completed":
      - BLOCK task
      - Update task status to "blocked"
      - Exit with message: "Task blocked by [dep-1, dep-2]. Run /ai-sdlc:initiative:status to view."
   d. ELSE: Proceed to Phase 1
3. ELSE: Skip (standalone task, no initiative)
```

**Impact**:
- ~30 lines per orchestrator
- No breaking changes to standalone tasks
- Clean separation of concerns

---

## Example Usage

### Create New Initiative

```bash
/ai-sdlc:initiative:new "Complete user authentication system with SSO, MFA, and session management"
```

**Flow**:
1. Initiative planner asks clarifying questions
2. Analyzes codebase
3. Creates 5 tasks:
   - Database schema migration
   - Basic login/logout
   - SSO integration
   - MFA enhancement
   - Session management
4. Defines 3 milestones
5. Creates dependency graph
6. Prompts user to review
7. User approves
8. Creates task directories
9. Resolves dependencies
10. Begins task execution (Level 0 first)

### Resume Initiative

```bash
/ai-sdlc:initiative:resume initiatives/2025-11-14-auth-system
```

**Scenarios**:
- Interrupted during task execution → Continues from current level
- Task failed → Prompts user to fix or skip
- All complete → Shows summary, offers to finalize

### Check Status

```bash
/ai-sdlc:initiative:status initiatives/2025-11-14-auth-system
```

**Output**:
```
Initiative: User Authentication System
Status: In Progress (60% complete)

Progress:
- Total tasks: 5
- Completed: 3 ✅
- In progress: 1 🔄
- Blocked: 1 ⏸️
- Pending: 0

Current: Executing SSO integration (Level 2)

Dependency Graph:
  Level 0: Database schema ✅
  Level 1: Basic login ✅, Session mgmt ✅
  Level 2: SSO integration 🔄 (in progress)
  Level 3: MFA enhancement ⏸️ (blocked by SSO)

Estimated completion: 2025-11-20
```

---

## Success Criteria

Initiative orchestration is successful when:

✅ All tasks completed or accounted for (completed/blocked/skipped)
✅ Dependencies satisfied and enforced
✅ Verification reports show passed or passed-with-issues
✅ Initiative summary created
✅ Roadmap updated (if exists)
✅ State allows full pause/resume
✅ No data loss on interruption

---

## Constraints

- **Task Count**: 3-15 tasks per initiative (too few = not an epic, too many = break into multiple initiatives)
- **Max Parallel Tasks**: 3 concurrent executions (avoid overwhelming system)
- **Phase Boundaries**: Always pause on phase boundaries for state save
- **Dependency Depth**: Warn if >6 levels (indicates very long critical path)

---

## Known Limitations

- **No resource contention handling**: Can't prevent two tasks from modifying same file
- **No time-based scheduling**: Can't schedule tasks for specific dates
- **No external project management integration**: No Jira/GitHub Issues sync
- **No automatic rollback**: If initiative fails midway, manual cleanup required
- **No cost tracking**: Doesn't track API costs or resource usage

---

## Future Enhancements

- **Resource allocation**: Assign tasks to team members, track capacity
- **Calendar integration**: Schedule tasks for specific dates
- **Rollback capability**: Undo initiative changes if needed
- **External integration**: Sync with Jira, GitHub Projects, etc.
- **Cost tracking**: Monitor API usage and costs per initiative
- **Parallel execution limits**: Dynamic adjustment based on system load
- **Dependency visualization**: Generate visual dependency graphs (Mermaid, DOT)
