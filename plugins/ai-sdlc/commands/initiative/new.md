---
name: ai-sdlc:initiative:new
description: Start a new epic-level initiative with guided orchestration through all phases
---

# Initiative Workflow: New

Orchestrate epic-level initiatives that coordinate 3-15 related tasks with dependency management.

## Usage

```bash
/ai-sdlc:initiative:new [description] [--yolo] [--from=PHASE]
```

### Arguments

- **description** (required): Brief description of the initiative
  - Example: "User authentication with SSO, MFA, and session management"

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `planning`, `task-creation`, `dependency-resolution`, `task-execution`, `verification`, `finalization`
  - Default: `planning`

## Examples

```bash
# Interactive mode (default)
/ai-sdlc:initiative:new "User authentication system with SSO and MFA"

# YOLO mode (continuous execution)
/ai-sdlc:initiative:new "Payment processing overhaul" --yolo

# Start from specific phase
/ai-sdlc:initiative:new "Multi-tenant support" --from=task-creation
```

## What You Are Doing

**Invoke the initiative-orchestrator skill NOW using the Skill tool.**

The skill guides through 6 phases:

**Phase 0: Initiative Planning**
- Break initiative into 3-15 tasks
- Create dependency graph
- Define milestones and estimate effort

**Phase 1: Task Creation**
- Create task directories in `.ai-sdlc/tasks/[type]/`
- Initialize metadata with dependencies

**Phase 2: Dependency Resolution**
- Validate dependency graph (detect cycles)
- Compute execution levels
- Determine execution strategy

**Phase 3: Task Execution**
- Execute tasks sequentially (one at a time)
- Respect dependency order
- Auto-recovery for failures

**Phase 4: Initiative Verification**
- Verify all tasks completed
- Check integration
- Deployment readiness assessment

**Phase 5: Finalization**
- Create initiative summary
- Update roadmap

## Execution Strategy

Tasks execute **sequentially** (one at a time) in dependency order:
- Level 0 tasks first (no dependencies)
- Then Level 1 tasks (depend on Level 0)
- And so on...

This ensures each task orchestrator can properly delegate to its subagents.

## Outputs

Initiative directory: `.ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name/`

- `initiative.yml` - Task list, dependencies, milestones
- `initiative-state.yml` - Execution state
- `spec.md` - Initiative vision and goals
- `task-plan.md` - Detailed task breakdown
- `verification-report.md` - Verification results
- `summary.md` - Final summary

Task directories: `.ai-sdlc/tasks/[type]/YYYY-MM-DD-task-N/`

## Execution Modes

**Interactive** (default): Pauses after each phase. Review task breakdown before execution.

**YOLO** (`--yolo`): Runs continuously. Stops only on critical failures.

## Monitoring Progress

```bash
/ai-sdlc:initiative:status .ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name
```

Shows: Progress %, completed/blocked/failed tasks, dependency graph.

## Handling Failures

1. **Auto-Recovery** (Attempts 1-2): Task orchestrator retries
2. **User Intervention** (Attempt 3+): Pause with options: skip, fix manually, abort
3. **Resume**: `/ai-sdlc:initiative:resume [path]`

## Prerequisites

- `.ai-sdlc/docs/` structure initialized (use `/init-sdlc` first)
- Clear initiative description with scope and goals

## Resume

If interrupted:
```bash
/ai-sdlc:initiative:resume .ai-sdlc/docs/project/initiatives/YYYY-MM-DD-name
```

State preserved automatically.

---

Invoke the **initiative-orchestrator** skill to coordinate your epic-level initiative with dependency management and sequential task execution.
