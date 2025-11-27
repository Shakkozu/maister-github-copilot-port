---
description: View initiative progress, dependency graph, and task status
---

# Initiative Status

Display comprehensive status of initiative execution including progress, task states, dependency graph, and estimates.

## Usage

```bash
/ai-sdlc:initiative:status [initiative-path] [--verbose] [--graph]
```

### Parameters

**`initiative-path`** (required): Path to initiative directory
- Example: `initiatives/2025-11-14-auth-system`
- Or: `.ai-sdlc/docs/project/initiatives/2025-11-14-auth-system`

**`--verbose`** (optional): Show detailed task information
- Default: Summary view
- Verbose: Includes task-level details (hours, phases, errors)

**`--graph`** (optional): Show ASCII dependency graph
- Default: Included in output
- Use `--graph=false` to hide graph (cleaner output)

### Examples

**Basic status**:
```bash
/ai-sdlc:initiative:status initiatives/2025-11-14-auth-system
```

**Detailed status**:
```bash
/ai-sdlc:initiative:status initiatives/2025-11-14-auth-system --verbose
```

**Status without graph**:
```bash
/ai-sdlc:initiative:status initiatives/2025-11-14-auth-system --graph=false
```

## Output Format

### Summary View (Default)

```
=== Initiative Status ===

Initiative: User Authentication System
ID: 2025-11-14-auth-system
Status: In Progress
Mode: Interactive

Progress:
- Total tasks: 7
- Completed: 3 ✅
- In progress: 1 🔄
- Blocked: 2 ⏸️
- Failed: 0 ❌
- Pending: 1 ⏳

Overall: [==========>           ] 43% (3/7 tasks)

Current Phase: Task Execution
Current Level: 2/4

Estimated Hours: 240
Actual Hours: 105
Remaining: 135
On Track: Yes

Critical Path:
  Database Schema (completed, 30h) →
  API Implementation (completed, 60h) →
  SSO Integration (in-progress, 50h, 15h done) →
  MFA Enhancement (blocked, 40h)

Total Critical Path: 180h
Estimated Completion: 2025-11-20

Current Task:
  🔄 SSO Integration (enhancement)
     Phase: Implementation
     Progress: ~30%
     Started: 2025-11-15 10:00
     Dependencies: ✅ All satisfied

Blocked Tasks:
  ⏸️ MFA Enhancement
     Blocked by: SSO Integration (in-progress)
     Reason: Waiting for dependency completion

  ⏸️ Documentation
     Blocked by: MFA Enhancement (blocked)
     Reason: Indirect dependency via MFA

Next Up:
  ⏳ Frontend UI Components
     Dependencies: ✅ All satisfied
     Ready to start: Yes
     Estimated: 80h

=== Dependency Graph ===

Level 0 (Start):
  ✅ Database Schema (30h)
  ✅ Basic Login API (40h)
       │
       ▼
Level 1:
  ✅ API Implementation (60h)
  ⏳ Frontend UI (80h)
       │
       ▼
Level 2:
  🔄 SSO Integration (50h, 15h done)
       │
       ▼
Level 3 (End):
  ⏸️ MFA Enhancement (40h) [BLOCKED]
  ⏸️ Documentation (20h) [BLOCKED]

Legend:
✅ Completed  🔄 In Progress  ⏸️ Blocked  ⏳ Pending  ❌ Failed
Critical path highlighted: Database → API → SSO → MFA

=== Commands ===

Resume: /ai-sdlc:initiative:resume initiatives/2025-11-14-auth-system
Details: /ai-sdlc:initiative:status initiatives/2025-11-14-auth-system --verbose
```

### Verbose View

Includes all above plus:

```
=== Detailed Task Information ===

✅ Task 1: Database Schema (Migration)
   Status: Completed
   Path: .ai-sdlc/tasks/migrations/2025-11-14-database-schema
   Dependencies: None
   Blocks: API Implementation, SSO Integration
   Milestone: Foundation
   Estimated: 30h
   Actual: 28h
   Efficiency: 107%
   Started: 2025-11-14 09:00
   Completed: 2025-11-14 16:30
   Duration: 7.5h elapsed (across 3 days)

✅ Task 2: Basic Login API (New Feature)
   Status: Completed
   Path: .ai-sdlc/tasks/new-features/2025-11-14-basic-login
   Dependencies: None
   Blocks: Frontend UI
   Milestone: Foundation
   Estimated: 40h
   Actual: 35h
   Efficiency: 114%
   Verification: ✅ Passed (0 issues)

✅ Task 3: API Implementation (New Feature)
   Status: Completed
   Path: .ai-sdlc/tasks/new-features/2025-11-14-api-impl
   Dependencies: Database Schema
   Blocks: SSO Integration
   Milestone: Core Features
   Estimated: 60h
   Actual: 55h
   Efficiency: 109%
   On Critical Path: Yes

🔄 Task 4: SSO Integration (Enhancement)
   Status: In Progress
   Path: .ai-sdlc/tasks/enhancements/2025-11-14-sso
   Current Phase: Implementation (step 4/8)
   Dependencies: API Implementation (✅ satisfied)
   Blocks: MFA Enhancement
   Milestone: Core Features
   Estimated: 50h
   Actual: 15h
   Remaining: ~35h
   Progress: ~30%
   Started: 2025-11-15 10:00
   ETA: 2025-11-18 (3 days)
   On Critical Path: Yes

⏳ Task 5: Frontend UI Components (New Feature)
   Status: Pending
   Path: .ai-sdlc/tasks/new-features/2025-11-15-frontend-ui
   Dependencies: Basic Login API (✅ satisfied)
   Blocks: None
   Milestone: Core Features
   Estimated: 80h
   Ready: Yes (can start now)
   On Critical Path: No

⏸️ Task 6: MFA Enhancement (Enhancement)
   Status: Blocked
   Path: .ai-sdlc/tasks/enhancements/2025-11-16-mfa
   Dependencies: SSO Integration (🔄 in-progress)
   Blocked by: Task 4 (SSO Integration)
   Blocks: Documentation
   Milestone: Production Ready
   Estimated: 40h
   On Critical Path: Yes

⏸️ Task 7: Documentation (Documentation)
   Status: Blocked
   Path: .ai-sdlc/tasks/documentation/2025-11-16-docs
   Dependencies: MFA Enhancement (⏸️ blocked)
   Blocked by: Task 6 (MFA Enhancement) → indirect via Task 4
   Milestone: Production Ready
   Estimated: 20h
   On Critical Path: No

=== Metrics ===

Overall Efficiency: 110% (ahead of estimates)
Average Task Duration: 15h elapsed (3 days)
Tasks Per Week: 2.3
Estimated Completion: 2025-11-20 (5 days remaining)

Milestone Progress:
  ✅ Foundation: 100% (2/2 tasks)
  🔄 Core Features: 50% (1/2 complete, 1 in-progress, 1 pending)
  ⏸️ Production Ready: 0% (2 blocked)

Execution Strategy: Mixed
  - Level 0: Completed (parallel execution, 2 tasks)
  - Level 1: 50% complete (1 done, 1 in-progress, 1 pending)
  - Level 2: Not started (blocked)
  - Level 3: Not started (blocked)

Risk Assessment:
  🟢 Low Risk: On schedule, no failures, ahead of estimates
```

## Status Indicators

| Icon | Meaning |
|------|---------|
| ✅ | Completed successfully |
| 🔄 | Currently in progress |
| ⏸️ | Blocked (waiting for dependencies) |
| ⏳ | Pending (ready to start) |
| ❌ | Failed |

## Progress Calculation

**Overall Progress**: `(completed_tasks / total_tasks) * 100`

**Level Progress** (for mixed strategy): `(completed_tasks_in_level / total_tasks_in_level) * 100`

**Task Progress** (for in-progress tasks): Estimated from phase completion
- Specification: ~10%
- Planning: ~20%
- Implementation: ~60%
- Verification: ~90%
- Complete: 100%

## Estimated Completion

Calculated using:

1. **Remaining Critical Path Hours**: Sum of uncompleted critical path task estimates
2. **Efficiency Factor**: `actual_hours / estimated_hours` for completed tasks
3. **Work Rate**: Average hours per day based on completed tasks

**Formula**:
```
remaining_hours = sum(uncompleted_critical_path_estimates) * efficiency_factor
days_remaining = remaining_hours / work_rate
estimated_completion = today + days_remaining
```

**Accuracy**: Improves as more tasks complete (better efficiency data)

## Dependency Graph

### ASCII Format

Shows tasks organized by dependency level with status indicators:

```
Level 0:
  ✅ Task A (30h)
  ✅ Task B (40h)
       │
       ▼
Level 1:
  🔄 Task C (50h)
       │
       ├──────┐
       ▼      ▼
Level 2:
  ⏸️ Task D  ⏸️ Task E
     (40h)     (30h)
```

**Visual Elements**:
- Vertical arrows (│ ▼): Dependency flow
- Horizontal branches (├ ─): Multiple dependents
- Status icons: Current state
- Hours in parentheses: Estimated duration
- [BLOCKED] tag: Explicitly blocked tasks

**Critical Path**: Highlighted (bold or color if terminal supports)

## When to Check Status

**During Execution**:
- Check every 30-60 minutes to monitor progress
- Especially for parallel execution (multiple tasks running)

**After Failures**:
- Understand impact of failure
- See which tasks are blocked
- Determine recovery strategy

**Before Resume**:
- Verify current state
- Check what needs to be done
- Understand where you left off

**For Reporting**:
- Generate progress reports
- Share with team
- Update stakeholders

## Output Locations

Status is displayed to console only. Not written to files.

To save status to file:
```bash
/ai-sdlc:initiative:status initiatives/2025-11-14-name > status.txt
```

## Performance

**Fast**: Reads state files only, doesn't execute anything

**Timing**:
- Summary view: <1 second
- Verbose view: 1-2 seconds (reads all task metadata)
- Graph rendering: <1 second

## Use Cases

### 1. Daily Standup

```bash
/ai-sdlc:initiative:status initiatives/current-initiative
```

Quick summary of:
- What's complete
- What's in progress
- What's blocked
- What's next

### 2. Debugging Blockers

```bash
/ai-sdlc:initiative:status initiatives/current --verbose
```

Detailed view to:
- Identify why tasks are blocked
- Trace dependency chain
- Find bottlenecks

### 3. Timeline Estimation

```bash
/ai-sdlc:initiative:status initiatives/current
```

Check:
- Estimated completion date
- Efficiency (ahead/behind schedule)
- Remaining hours on critical path

### 4. Quick Health Check

```bash
/ai-sdlc:initiative:status initiatives/current --graph=false
```

No graph, just:
- Progress percentage
- Failed tasks count
- Current phase

## Related Commands

- **`/ai-sdlc:initiative:new`**: Start new initiative
- **`/ai-sdlc:initiative:resume`**: Resume initiative execution
- **`/ai-sdlc:feature:status`**: Check single task status (not initiative)

## See Also

- Initiative state structure: `skills/initiative-orchestrator/references/state-coordination.md`
- Dependency graphs: `skills/initiative-orchestrator/references/dependency-resolution.md`
