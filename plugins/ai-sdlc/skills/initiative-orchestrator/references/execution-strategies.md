# Execution Strategies Reference

## Overview

Initiative orchestrator supports three execution strategies for coordinating multiple tasks: Sequential, Parallel, and Mixed. This reference explains when to use each, how they work, and trade-offs.

## Strategy Selection

### Decision Matrix

| Dependency Pattern | Recommended Strategy | Rationale |
|-------------------|----------------------|-----------|
| Linear chain (A→B→C→D) | Sequential | No parallelism possible |
| Star (A→[B,C,D]) | Parallel or Mixed | B, C, D can run concurrently |
| Diamond (A→[B,C]→D) | Mixed | Parallel middle layer, sequential levels |
| Multiple chains | Parallel | Independent chains can run together |
| Complex DAG | Mixed | Optimize per-level parallelism |

### Auto-Detection Algorithm

```
1. Build dependency graph
2. Compute levels (breadth-first from Level 0)
3. Analyze structure:
   - If all levels have 1 task: Sequential
   - If Level 0 has >1 task AND no other levels: Parallel
   - If multiple levels with >1 task per level: Mixed
4. Override if user-specified strategy provided
```

---

## Sequential Strategy

### Description

Execute tasks one at a time in dependency order. Simplest strategy with no concurrency.

### When to Use

- Linear dependency chain (each task depends on previous)
- Single developer workflow
- Resource-constrained environment
- Debugging/troubleshooting (easier to trace)

### Execution Pattern

```
Initialize:
  Queue = All tasks sorted by dependency order (topological sort)

Loop:
  1. Pop next task from queue
  2. Verify dependencies satisfied
  3. Launch task orchestrator (synchronous)
  4. Wait for completion
  5. Record result
  6. Check for newly unblocked tasks
  7. Add unblocked tasks to end of queue
  8. Repeat until queue empty
```

### Detailed Flow

```
Example: Tasks A→B→C→D

Time 0:
  Queue: [A, B, C, D]
  Execute: A

Time T1 (A complete):
  Queue: [B, C, D]
  Unblocked: B (was waiting for A)
  Execute: B

Time T2 (B complete):
  Queue: [C, D]
  Unblocked: C (was waiting for B)
  Execute: C

Time T3 (C complete):
  Queue: [D]
  Unblocked: D (was waiting for C)
  Execute: D

Time T4 (D complete):
  Queue: []
  Done
```

### Task Orchestrator Invocation

```markdown
Single Skill tool call:

Use Skill tool:
  skill: [task-type]-orchestrator
  prompt: |
    Execute [type]-orchestrator for: [task-path]
    Initiative: [name]
    Mode: [interactive|yolo]

Wait for completion (synchronous)
Process result
Move to next task
```

### State Tracking

```yaml
execution:
  current_level: null  # Not level-based
  task_queue: [task-ids in order]
  current_task: task-3

tasks:
  pending: [task-4, task-5]
  in_progress: [task-3]
  completed: [task-1, task-2]
  blocked: []
```

### Advantages

✅ Simple to implement and debug
✅ No coordination complexity
✅ No race conditions
✅ Clear progress tracking
✅ Works for any dependency graph

### Disadvantages

❌ Slowest execution time
❌ No parallelism (underutilizes resources)
❌ Poor for team collaboration
❌ Inefficient for independent tasks

### Performance

```
Total Time = Sum of all task durations
Example: 4 tasks × 40 hours each = 160 hours sequential time
```

---

## Parallel Strategy

### Description

Execute all independent tasks concurrently, respecting only direct dependencies.

### When to Use

- Multiple independent tasks (no dependencies between them)
- Team collaboration (multiple developers)
- Resource-rich environment
- Time-sensitive delivery

### Execution Pattern

```
Initialize:
  Ready tasks = Tasks with all dependencies satisfied
  Running tasks = []

Loop:
  1. Launch ALL ready tasks in SINGLE message (multiple Skill tool calls)
  2. Add to running tasks list
  3. Poll running tasks for completion
  4. On task completion:
     a. Move to completed
     b. Check for newly unblocked tasks
     c. Add unblocked tasks to ready queue
  5. If ready tasks exist AND running < max_parallel:
     Launch next batch
  6. Repeat until all tasks complete
```

### Detailed Flow

```
Example: Tasks A, B, C (independent), then D (depends on A, B, C)

Time 0:
  Ready: [A, B, C]
  Running: []

  Launch A, B, C in SINGLE message with 3 Skill tool calls:
    - Skill call 1: skill=feature-orchestrator for task A
    - Skill call 2: skill=feature-orchestrator for task B
    - Skill call 3: skill=enhancement-orchestrator for task C

  Running: [A, B, C]

Time T1-T3 (tasks complete at different times):
  A completes at T1
  C completes at T2
  B completes at T3

  All complete → Check unblocked tasks
  D now has all dependencies satisfied

Time T3:
  Ready: [D]
  Launch D
  Running: [D]

Time T4:
  D completes
  Done
```

### Multi-Task Launch (Critical!)

**Per Claude Code documentation**: Use **single message with multiple Skill tool calls**

```markdown
Single message containing:

Skill tool call 1:
  skill: feature-orchestrator
  [Passes task A path and initiative context via prompt]

Skill tool call 2:
  skill: feature-orchestrator
  [Passes task B path and initiative context via prompt]

Skill tool call 3:
  skill: enhancement-orchestrator
  [Passes task C path and initiative context via prompt]

All three orchestrators launch concurrently

Note: Use Skill tool, NOT Task tool. Skills are the correct way to invoke
orchestrators (feature-orchestrator, enhancement-orchestrator, etc.).
Task tool should only be used for general-purpose agents.
```

### Polling for Completion

```
Polling interval: 30 seconds

While running_tasks > 0:
  For each task in running_tasks:
    1. Read task/orchestrator-state.yml
    2. Check current_phase
    3. If current_phase == "completed":
       - Move to completed
       - Update initiative-state.yml
       - Remove from running_tasks
    4. If failed_phases not empty:
       - Move to failed
       - Handle failure (see Failure Handling)

  Sleep 30 seconds
  Repeat
```

### State Tracking

```yaml
coordination:
  parallel_running: 3
  max_parallel: 3
  last_poll: YYYY-MM-DDTHH:MM:SSZ
  next_poll: YYYY-MM-DDTHH:MM:SS+30Z

tasks:
  pending: [task-D]
  in_progress: [task-A, task-B, task-C]
  completed: []
  blocked: [task-D]  # Waiting for A, B, C
```

### Conflict Handling

**File-based coordination** (no locks):

```
Scenario: Task A and Task B both modify same file

Problem: Race condition, last write wins

Solutions:
1. **Prevention**: Initiative planner should avoid such dependencies
2. **Detection**: Git merge conflicts on commit
3. **Resolution**: Manual merge required

Best Practice: Design tasks to minimize shared file modification
```

### Max Parallel Limit

```yaml
coordination:
  max_parallel: 3  # Default

Rationale:
- Avoid overwhelming system
- Balance speed vs resource usage
- 3 is optimal for typical workloads

Can be adjusted:
- More parallel: Faster but more resource usage
- Less parallel: Slower but more stable
```

### Advantages

✅ Fastest execution time (for independent tasks)
✅ Great for team collaboration
✅ Maximizes resource utilization
✅ Good for time-sensitive delivery

### Disadvantages

❌ More complex coordination
❌ Potential file conflicts
❌ Harder to debug (concurrent issues)
❌ Requires more system resources

### Performance

```
Total Time ≈ Length of longest task (if all independent)
Example: 4 tasks × 40 hours each in parallel = 40 hours total
Speedup: 4x vs sequential
```

---

## Mixed Strategy (Recommended)

### Description

Hybrid approach: Sequential between dependency levels, parallel within levels. Optimal for most real-world initiatives.

### When to Use

- Complex dependency graphs with some parallelism
- Mix of dependent and independent tasks
- Most real-world initiatives
- Balance between speed and simplicity

### Execution Pattern

```
Initialize:
  Current level = 0
  Total levels = N (from dependency resolution)

Loop over levels:
  1. Get all tasks in current level
  2. Launch all level tasks in SINGLE message (multiple Task calls)
  3. Poll for completion
  4. Wait until ALL level tasks complete
  5. Check for failures, handle if any
  6. Move to next level (current_level++)
  7. Repeat until all levels complete
```

### Detailed Flow

```
Example: Dependency graph with 3 levels

Level 0: [A, B] (independent)
Level 1: [C] (depends on A, B)
Level 2: [D, E] (D depends on C, E depends on C)

Execution:

Phase 1 - Level 0:
  Launch A and B in parallel (single message, 2 Task calls)
  Wait for both to complete

Phase 2 - Level 1:
  Launch C (single Task call)
  Wait for completion

Phase 3 - Level 2:
  Launch D and E in parallel (single message, 2 Task calls)
  Wait for both to complete

Done
```

### Level-Based Launch

```markdown
For each level:

1. Get tasks in level from execution.levels[level-N]
2. Verify all dependencies satisfied (should be guaranteed)
3. Launch all tasks in SINGLE message:

   Message with multiple Skill tool calls:
   - Skill call 1: skill=[type]-orchestrator for task-X
   - Skill call 2: skill=[type]-orchestrator for task-Y
   - Skill call 3: skill=[type]-orchestrator for task-Z

4. Poll all running tasks (see Polling pattern above)
5. Wait until all level tasks complete (completed OR failed)
6. Handle any failures
7. Move to next level
```

### State Tracking

```yaml
execution:
  current_level: 1
  total_levels: 3
  levels:
    level-0: [task-A, task-B]
    level-1: [task-C]
    level-2: [task-D, task-E]

coordination:
  parallel_running: 1  # Currently executing level 1
  max_parallel: 3

tasks:
  pending: [task-D, task-E]  # Level 2
  in_progress: [task-C]  # Level 1
  completed: [task-A, task-B]  # Level 0
```

### Level Completion Check

```
All tasks in level complete when:
  For all tasks in execution.levels[current_level]:
    task status IN (completed, failed)

Then:
  - Log level completion
  - Update phase_results with level metrics
  - Move to current_level++
  - Continue if current_level < total_levels
```

### Advantages

✅ Optimal balance of speed and simplicity
✅ Some parallelism (within levels)
✅ Clear dependency enforcement (between levels)
✅ Easier to debug than full parallel
✅ Works for most dependency graphs

### Disadvantages

⚠️ Not as fast as pure parallel (waits per level)
⚠️ Slightly more complex than sequential

### Performance

```
Total Time = Sum of longest task per level
Example:
  Level 0: 2 tasks (40h, 30h) → 40h (parallel)
  Level 1: 1 task (50h) → 50h
  Level 2: 2 tasks (35h, 45h) → 45h (parallel)
  Total: 40 + 50 + 45 = 135 hours

vs Sequential: 40 + 30 + 50 + 35 + 45 = 200 hours
Speedup: 1.48x
```

---

## Strategy Comparison

### Performance Comparison

| Tasks | Dependencies | Sequential | Parallel | Mixed |
|-------|-------------|------------|----------|-------|
| A→B→C→D | Linear chain | 160h | 160h | 160h |
| A,B,C,D | All independent | 160h | 40h | 40h |
| A→[B,C]→D | Diamond | 120h | 80h | 80h |
| A→B, C→D | Two chains | 80h + 80h = 160h | 80h | 80h |

### Complexity Comparison

| Aspect | Sequential | Parallel | Mixed |
|--------|-----------|----------|-------|
| Implementation | Simple | Complex | Moderate |
| Debugging | Easy | Hard | Moderate |
| Coordination | None | Heavy | Moderate |
| Race conditions | None | Possible | Possible (within levels) |
| Progress tracking | Clear | Complex | Moderate |

### Resource Usage

| Strategy | CPU | Memory | Concurrent Processes |
|----------|-----|--------|---------------------|
| Sequential | Low | Low | 1 |
| Parallel | High | High | N (all tasks) |
| Mixed | Medium | Medium | M (max tasks per level) |

---

## Failure Handling Per Strategy

### Sequential

```
On task failure:
  1. Record failure
  2. Determine if on critical path
  3. If critical: Block all dependent tasks, pause
  4. If not critical: Continue with independent tasks
  5. Prompt user for resolution
```

**Simple**: Only one task failing at a time

### Parallel

```
On task failure (while others running):
  1. Record failure
  2. Continue monitoring other running tasks
  3. Do NOT launch tasks that depend on failed task
  4. Wait for all running tasks to complete
  5. Assess total impact
  6. Prompt user for resolution

**Complex**: Multiple tasks may fail, need to track all
```

### Mixed

```
On task failure (within level):
  1. Record failure
  2. Continue monitoring other level tasks
  3. Wait for level to complete
  4. Assess level status:
     - If ANY critical task failed: Pause before next level
     - If only non-critical failed: Ask user to continue
  5. Do NOT proceed to next level if it depends on failed tasks
```

**Moderate**: Contained to level, easier than full parallel

---

## Strategy Override

### User-Specified Strategy

```yaml
initiative.yml:
  execution:
    strategy: parallel  # User wants parallel

Dependency graph: Linear chain A→B→C

Incompatibility: Cannot parallelize linear chain

Resolution:
  - Override to sequential
  - Inform user of change and reason
  - Log in initiative-state.yml:

    strategy_requested: parallel
    strategy_actual: sequential
    override_reason: "Linear dependency chain prevents parallelization"
```

### Valid Overrides

| Graph Structure | User Requests | Can Honor? | Action |
|----------------|---------------|-----------|---------|
| Linear chain | Sequential | Yes | Use sequential |
| Linear chain | Parallel | No | Override to sequential |
| Star | Sequential | Yes | Use sequential (suboptimal) |
| Star | Parallel | Yes | Use parallel |
| Diamond | Sequential | Yes | Use sequential (suboptimal) |
| Diamond | Mixed | Yes | Use mixed |
| Complex DAG | Any | Depends | Validate and honor or override |

---

## Implementation Checklist

### Sequential Implementation

- [ ] Build task queue (topological sort)
- [ ] Launch task orchestrator synchronously
- [ ] Wait for completion before next task
- [ ] Handle failures one at a time
- [ ] Track progress linearly

### Parallel Implementation

- [ ] Identify all ready tasks (dependencies satisfied)
- [ ] Launch ALL ready tasks in SINGLE message (multiple Task calls)
- [ ] Implement polling loop (30s interval)
- [ ] Detect completion/failure per task
- [ ] Update initiative-state atomically
- [ ] Handle concurrent failures
- [ ] Respect max_parallel limit

### Mixed Implementation

- [ ] Compute dependency levels (BFS)
- [ ] For each level sequentially:
  - [ ] Launch all level tasks in parallel (single message)
  - [ ] Poll for level completion
  - [ ] Handle level failures
  - [ ] Wait until all level tasks done
  - [ ] Move to next level
- [ ] Track current_level in state

---

## Performance Optimization

### Maximize Parallelism

```
Given dependency graph:
  A → C → E
  B → D → F

Naive: 6 levels (A, B, C, D, E, F) - slow
Optimized: 3 levels ([A,B], [C,D], [E,F]) - 2x faster

Strategy: Group independent tasks into same level
```

### Minimize Wait Time

```
Level with tasks of varying duration:
  Task A: 10 hours
  Task B: 60 hours
  Task C: 20 hours

Total level time: 60 hours (wait for longest)

Optimization: If possible, move short tasks to earlier level
```

### Critical Path Optimization

```
Identify critical path (longest chain)
Prioritize critical path tasks for early execution
Example:
  Critical: A → C → E (120 hours)
  Non-critical: B → D (40 hours)

Start critical path tasks first to minimize total time
```

---

## Monitoring and Visibility

### Progress Metrics Per Strategy

**Sequential**:
```yaml
progress:
  current_task: 3
  total_tasks: 10
  percent: 30%
  sequential_position: 3/10
```

**Parallel**:
```yaml
progress:
  running_tasks: 3
  completed_tasks: 5
  total_tasks: 10
  percent: 50%
  parallel_efficiency: 3/3 (100%)
```

**Mixed**:
```yaml
progress:
  current_level: 2
  total_levels: 4
  level_progress: 50%
  running_in_level: 2
  completed_in_level: 1
  total_tasks: 10
  percent: 40%
```

### Visualization

**Sequential**:
```
[====>    ] 40% (Task 4/10)
```

**Parallel**:
```
Task A: [========>  ] 80%
Task B: [====>      ] 40%
Task C: [======>    ] 60%
Overall: [======>   ] 60%
```

**Mixed**:
```
Level 0: [==========] 100% (2/2 complete)
Level 1: [=====>    ] 50% (1/2 in-progress)
Level 2: [          ] 0% (pending)
Overall: [====>     ] 40%
```

---

## Summary

### Strategy Selection Guide

```
Choose Sequential if:
✓ Linear dependency chain
✓ Single developer
✓ Debugging needed
✓ Resource-constrained

Choose Parallel if:
✓ Many independent tasks
✓ Team collaboration
✓ Time-critical delivery
✓ Resource-rich environment

Choose Mixed if:
✓ Complex dependency graph
✓ Mix of dependent/independent tasks
✓ Most real-world initiatives (RECOMMENDED)
✓ Balance speed and simplicity
```

### Key Implementation Points

1. **Parallel launch**: Use SINGLE message with multiple Skill tool calls
2. **Polling**: 30-second intervals for task completion
3. **State coordination**: File-based, no shared writes
4. **Failure handling**: Continue others, then assess
5. **Level-based execution (Mixed)**: Wait for full level completion

For dependency algorithms, see `dependency-resolution.md`.
For state management, see `state-coordination.md`.
