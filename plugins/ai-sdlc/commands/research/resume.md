---
name: ai-sdlc:research:resume
description: Resume an interrupted or failed research workflow from where it left off
---

Resume a research workflow from saved state, with options to override resume point or reset attempts.

**Usage**: `/ai-sdlc:research:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]`

**Parameters**:
- `task-path`: Path to research task directory (required)
- `--from=phase`: Override resume point to specific phase (optional)
- `--reset-attempts`: Reset auto-fix attempt counters (optional)
- `--clear-failures`: Clear failed phases list and retry (optional)

**Examples**:
```
/ai-sdlc:research:resume .ai-sdlc/tasks/research/2025-11-14-auth-research
/ai-sdlc:research:resume .ai-sdlc/tasks/research/2025-11-14-auth-research --from=phase-2-gathering
/ai-sdlc:research:resume .ai-sdlc/tasks/research/2025-11-14-auth-research --reset-attempts
```

**What this does**:
1. Loads orchestrator-state.yml from task directory
2. Validates state and prerequisite phases
3. Resumes from last incomplete phase (or specified phase)
4. Continues workflow execution from that point

**When to use**:
- Research workflow was interrupted (user halted)
- Research workflow failed (exceeded auto-fix attempts)
- Want to restart specific phase with different approach
- Need to retry after manual corrections

**Resume scenarios**:

**Scenario 1: Normal interruption**
- User stopped workflow in interactive mode
- State saved correctly
- Resume continues from next phase

**Scenario 2: Failure after max attempts**
- Phase failed after auto-fix attempts exhausted
- State saved with failure details
- Use `--reset-attempts` to retry with fresh attempt count
- May need `--clear-failures` to retry failed phase

**Scenario 3: Manual corrections made**
- User manually fixed issues (added missing files, corrected sources)
- Use `--from=phase-N` to restart from specific phase
- Previous phases remain marked complete

**Scenario 4: State file corruption**
- orchestrator-state.yml missing or corrupted
- Orchestrator will attempt state reconstruction from artifacts
- If reconstruction fails, may need to restart research

**State validation**:
- Checks all prerequisite phases marked complete
- Verifies output files exist for completed phases
- If validation fails, may restart earlier phase automatically

**Override options**:

**--from=phase**: Manually specify resume point
- Useful if want to redo a phase
- Example: `--from=phase-2-gathering` restarts information gathering
- Previous phases stay marked complete (won't re-execute)

**--reset-attempts**: Reset auto-fix attempt counters
- Useful after phase failed due to max attempts
- Gives fresh attempts at auto-recovery
- Use when manual corrections make retry viable

**--clear-failures**: Remove failed phases from state
- Allows re-execution of previously failed phases
- Use when root cause fixed manually
- Workflow will retry failed phases with clean slate

**Resume phases**:
- `phase-0-initialization` - Research setup
- `phase-1-planning` - Methodology and sources
- `phase-2-gathering` - Information collection
- `phase-3-synthesis` - Analysis and report generation
- `phase-4-outputs` - Output artifact generation
- `phase-5-verification` - Validation (optional)
- `phase-6-integration` - Project integration (optional)

**Important notes**:
- Resume preserves execution mode (interactive/YOLO) from original start
- Can't change research question or type during resume (those are set in Phase 0)
- If major changes needed, better to start new research workflow

**Invoke**: ai-sdlc:research-orchestrator skill with resume mode
