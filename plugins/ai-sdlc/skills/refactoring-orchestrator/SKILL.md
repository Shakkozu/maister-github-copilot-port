---
name: refactoring-orchestrator
description: Orchestrates safe, incremental refactoring workflows with optional git branch (asks user first), git commit checkpoints, user-confirmed rollback on failure (never automatic), and strict behavior preservation verification. Analyzes code quality baseline, creates detailed refactoring plan, captures behavioral snapshot, executes refactoring with test-driven verification, and confirms behavior unchanged.
---

# Refactoring Orchestrator Skill

## Overview

You are the Refactoring Orchestrator, responsible for executing safe refactoring workflows that improve code quality while preserving behavior exactly (zero functional changes). You orchestrate 7-phase workflows, delegate to specialized agents, optionally create a single git branch (asks user first), use git commits as checkpoints for safe rollback, handle test failures with immediate rollback, and verify behavior preservation comprehensively.

## Core Responsibilities

1. **Workflow Orchestration**: Manage 7-phase refactoring workflow from baseline analysis through quality verification (includes optional branch setup)
2. **Agent Delegation**: Delegate phases to specialized agents (refactoring-analyzer, refactoring-planner, behavioral-snapshot-capturer, behavioral-verifier)
3. **Git Checkpoint Management**: Optionally create single refactoring branch (asks user first), use git commits as checkpoints, enable rollback via git reset
4. **User Control**: Ask user if they want a dedicated git branch before creating one
5. **Test-Driven Verification**: Run appropriate test tiers after each increment, immediate rollback on ANY failure
6. **Behavior Preservation**: Enforce zero-tolerance policy for behavior changes
7. **State Management**: Maintain workflow state, enable pause/resume, track increments and commits

## Refactoring Philosophy

**Refactoring Definition**: "A change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior." - Martin Fowler

**Core Principle**: Zero functional changes allowed. ANY behavior change = Failed refactoring.

**Safety Mechanisms**:
- Optional dedicated git branch created with user consent
- Git commit checkpoints after each increment (rollback capability via git reset)
- Test-driven verification (run tests after every change)
- **User-confirmed rollback** on test failure (analyze first, ask user, never automatic)
- Behavioral snapshot comparison (baseline vs post-refactoring)
- Strict behavior preservation verification (Phase 4)

## Progress Tracking

Use `TodoWrite` to show real-time progress to the user. Create todos at workflow start, update at each phase transition.

**Phase Todos**:

| Phase | content | activeForm |
|-------|---------|------------|
| 0 | "Analyze code quality baseline" | "Analyzing code quality baseline" |
| 1 | "Create refactoring plan" | "Creating refactoring plan" |
| 2 | "Capture behavioral snapshot" | "Capturing behavioral snapshot" |
| 2.5 | "Set up git branch" | "Setting up git branch" |
| 3 | "Execute refactoring" | "Executing refactoring" |
| 4 | "Verify behavior preserved" | "Verifying behavior preserved" |
| 5 | "Verify final quality" | "Verifying final quality" |

**Rules**:
- Create all phase todos at workflow start (pending)
- Mark current phase `in_progress` before execution
- Mark phase `completed` immediately after success
- Optional phases skipped: mark as `completed`
- State file remains source of truth for resume logic

---

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Analyze code quality baseline", "status": "pending", "activeForm": "Analyzing code quality baseline"},
  {"content": "Create refactoring plan", "status": "pending", "activeForm": "Creating refactoring plan"},
  {"content": "Capture behavioral snapshot", "status": "pending", "activeForm": "Capturing behavioral snapshot"},
  {"content": "Set up git branch", "status": "pending", "activeForm": "Setting up git branch"},
  {"content": "Execute refactoring", "status": "pending", "activeForm": "Executing refactoring"},
  {"content": "Verify behavior preserved", "status": "pending", "activeForm": "Verifying behavior preserved"},
  {"content": "Verify final quality", "status": "pending", "activeForm": "Verifying final quality"}
]
```

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Refactoring Orchestrator Started

Refactoring: [description]
Mode: [Interactive/YOLO]

Workflow Phases:
0. [ ] Code Quality Baseline Analysis → refactoring-analyzer subagent
1. [ ] Refactoring Planning → refactoring-planner subagent
2. [ ] Behavioral Snapshot Capture → behavioral-snapshot-capturer subagent
2.5. [ ] Git Branch Setup (optional) → main orchestrator
3. [ ] Refactoring Execution → main orchestrator with checkpoints
4. [ ] Behavior Verification → behavioral-verifier subagent
5. [ ] Final Quality Verification → main orchestrator

State file: [task-path]/orchestrator-state.yml

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously. Stops only on failure.

Starting Phase 0: Code Quality Baseline Analysis...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Code Quality Baseline Analysis).

---

## Workflow Phases

### Phase 0: Code Quality Baseline Analysis (Required)
- **Agent**: `ai-sdlc:refactoring-analyzer` (read-only)
- **Purpose**: Establish quantitative baseline to measure refactoring success
- **Process**: Locate target code, analyze complexity/duplication/smells/coverage
- **Outputs**: `analysis/code-quality-baseline.md`, `analysis/target-code-analysis.md`
- **Auto-Fix**: Max 2 attempts (expand search, try manual analysis)

### Phase 1: Refactoring Planning (Required)
- **Agent**: `ai-sdlc:refactoring-planner` (read-only)
- **Purpose**: Create detailed incremental refactoring plan with git commits for checkpoints
- **Process**: Classify type, break into increments, identify tests, assess risk
- **Outputs**: `implementation/refactoring-plan.md`
- **Auto-Fix**: Max 2 attempts (clarify type, use conservative estimates)

### Phase 2: Behavioral Snapshot Capture (Required)
- **Agent**: `ai-sdlc:behavioral-snapshot-capturer` (read-only)
- **Purpose**: Capture comprehensive behavioral baseline for comparison
- **Process**: Inventory functions, analyze test coverage, run tests, identify side effects, generate fingerprint
- **Outputs**: `analysis/behavioral-snapshot.md`, `analysis/behavioral-fingerprint.yml`
- **Auto-Fix**: Max 1 attempt (document limitations)

### Phase 2.5: Branch Setup (Optional but Recommended)
- **Execution**: Main orchestrator (uses AskUserQuestion)
- **Purpose**: Ask user if they want to create a dedicated git branch for the refactoring
- **Process**: Prompt user, create single branch if approved, or continue on current branch
- **Outputs**: Single git branch `refactor/YYYY-MM-DD-task-name` (if user approves), state updated
- **Auto-Fix**: N/A (user decision)

### Phase 3: Refactoring Execution (Required)
- **Execution**: Main orchestrator (orchestrates increments with git commit checkpoints)
- **Purpose**: Apply incremental refactoring with user-confirmed rollback on failure
- **Process**: For each increment → Apply changes → Run tests → Git commit checkpoint or analyze failure & ask user
- **Outputs**: Refactored code with git commit checkpoints on refactoring branch (or current branch)
- **On Failure**: Analyze root cause → Ask user (try fix / rollback / investigate) → Execute user's choice

### Phase 4: Behavior Verification (Required)
- **Agent**: `ai-sdlc:behavioral-verifier` (read-only)
- **Purpose**: Verify refactoring preserved behavior exactly
- **Process**: Compare signatures, validate tests, confirm side effects, check fingerprint
- **Outputs**: `verification/behavior-verification-report.md` with PASS/FAIL verdict
- **Auto-Fix**: **ZERO attempts** - Report only, never fix

### Phase 5: Final Quality Verification (Required)
- **Execution**: Main orchestrator (optionally delegates to code-reviewer, production-readiness-checker)
- **Purpose**: Verify refactoring achieved quality goals
- **Process**: Re-measure metrics, compare baseline vs post, verify goals met
- **Outputs**: `verification/quality-improvement-report.md`
- **Auto-Fix**: Max 1 attempt (flag issues only)

## Execution Modes

### Interactive Mode (Default)
- Pause after each phase for user review
- User can approve and continue, or halt
- Recommended for complex or high-risk refactoring

### YOLO Mode
- Continuous execution without pauses
- Stops only if phase fails or test failure occurs
- Best for straightforward refactoring with good test coverage

## Task Structure

```
.ai-sdlc/tasks/refactoring/YYYY-MM-DD-refactoring-name/
├── metadata.yml
├── orchestrator-state.yml
├── analysis/
│   ├── code-quality-baseline.md
│   ├── target-code-analysis.md
│   ├── behavioral-snapshot.md
│   └── behavioral-fingerprint.yml
├── implementation/
│   └── refactoring-plan.md
└── verification/
    ├── behavior-verification-report.md
    ├── post-refactoring-snapshot.md
    ├── fingerprint-comparison.yml
    └── quality-improvement-report.md
```

**Git Branch** (optional, created during Phase 2.5 if user approves):
```
refactor/YYYY-MM-DD-refactoring-name
```

**Git Commit Checkpoints** (created during Phase 3 execution):
- Each increment gets its own commit on the refactoring branch (or current branch if no dedicated branch)
- Commit messages follow pattern: `Checkpoint N: [increment description]`
- Rollback uses `git reset --hard HEAD~1` to revert to previous checkpoint

## Orchestration Instructions

### When This Skill is Invoked

**Manual Invocation** (User commands):
- `/ai-sdlc:refactoring:new [description]` - Start new refactoring
- `/ai-sdlc:refactoring:resume [task-path]` - Resume interrupted refactoring

**Automatic Classification** (via `/work` command):
- Task classifier detects refactoring keywords: "refactor", "clean up", "restructure"

---

### Step 1: Determine Execution Context

**Check invocation source**:
- **New refactoring**: Create new task directory
- **Resume refactoring**: Load existing state, validate checkpoints

**Parse parameters**:
- Refactoring description or task path
- Mode flag: `--yolo` or default interactive
- Resume flags: `--from=phase`, `--reset-attempts`, `--clear-failures`

**Validate resume** (if resuming):
- Check `orchestrator-state.yml` exists
- Validate git checkpoint branches exist
- Verify prerequisite phases completed

---

### Step 2: Initialize or Load State

#### For New Refactoring (`/ai-sdlc:refactoring:new`)

**A. Create Task Directory**:

```bash
TASK_NAME=$(echo "$DESCRIPTION" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | head -c 50)
TASK_DIR=".ai-sdlc/tasks/refactoring/$(date +%Y-%m-%d)-$TASK_NAME"
mkdir -p "$TASK_DIR"/{analysis,implementation,verification}
```

**B. Create metadata.yml**:

```yaml
task_type: refactoring
created_at: "2025-11-14T12:00:00Z"
description: "[User-provided refactoring description]"
status: in_progress
priority: medium
tags: [refactoring, code-quality]
```

**C. Initialize orchestrator-state.yml**:

```yaml
orchestrator: ai-sdlc:refactoring-orchestrator
version: 1.0
workflow_status: in_progress
mode: interactive  # or yolo
current_phase: 0
last_completed_phase: -1
phases_completed: []
refactoring_type: null  # Set in Phase 1
total_increments: null  # Set in Phase 1
risk_level: null  # Set in Phase 1
refactoring_branch: null  # Set in Phase 2.5 if user approves, or stays null
use_dedicated_branch: null  # Set in Phase 2.5 (true/false based on user choice)
auto_fix_attempts: {}
failed_phases: []
increments_completed: []
commit_checkpoints: []
baseline_fingerprint: null
created_at: "2025-11-14T12:00:00Z"
last_updated: "2025-11-14T12:00:00Z"
```

#### For Resume (`/ai-sdlc:refactoring:resume`)

**A. Load State**:

```bash
STATE_FILE="$TASK_PATH/orchestrator-state.yml"
if [ ! -f "$STATE_FILE" ]; then
  echo "ERROR: orchestrator-state.yml not found. Cannot resume."
  echo "Attempting state reconstruction from artifacts..."
  # Reconstruct state (check which phase outputs exist)
fi
```

**B. Validate State**:
- Check prerequisite phases completed
- Verify output files exist for completed phases
- Validate git checkpoint branches exist

**C. Determine Resume Point**:
- Default: `last_completed_phase + 1`
- Override: `--from=phase-N` flag
- Special case: If Phase 3 failed, resume from failed increment

---

### Step 3: Phase Execution Loop

**Execute phases sequentially from current_phase to completion**:

```
while current_phase <= 5 and workflow_status == in_progress:
  execute_phase(current_phase)
  if phase_failed:
    handle_failure()
    break
  if interactive_mode and not final_phase:
    prompt_user_continue()
  current_phase += 1
```

---

### Step 4: Execute Phase 0 - Code Quality Baseline Analysis

**Delegate to**: `ai-sdlc:refactoring-analyzer` subagent

**Invoke refactoring-analyzer via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:refactoring-analyzer"
- description: "Analyze code quality baseline"
- prompt: |
    Execute code quality baseline analysis for refactoring task.

    Task Directory: [TASK_DIR]
    Refactoring Description: [USER_DESCRIPTION]

    Your Mission:
    1. Parse refactoring description to identify target code
    2. Locate target files using Glob/Grep
    3. Analyze cyclomatic complexity (per function, average, max)
    4. Measure code duplication (percentage, instances)
    5. Identify code smells (long methods, god classes, deep nesting, magic numbers)
    6. Assess test coverage (line, branch, function)
    7. Generate comprehensive quality baseline report

    Output: analysis/code-quality-baseline.md with all metrics

    Report back:
    - Target files found: [count]
    - Average complexity: [score]
    - Max complexity: [score] at [location]
    - Duplication: [X]%
    - Test coverage: [X]%
    - Refactoring priority: [High/Medium/Low]
```

**On Completion**:
- Validate output file exists: `analysis/code-quality-baseline.md`
- Update state: `last_completed_phase = 0`, add to `phases_completed`
- If interactive: Prompt user to review baseline and continue

**On Failure**:
- If max attempts (2) exhausted: HALT, ask user to identify target files
- Save state and exit

---

### Step 5: Execute Phase 1 - Refactoring Planning

**Delegate to**: `ai-sdlc:refactoring-planner` subagent

**Invoke refactoring-planner via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:refactoring-planner"
- description: "Create refactoring plan"
- prompt: |
    Create detailed refactoring plan with git checkpoints.

    Task Directory: [TASK_DIR]
    Input: analysis/code-quality-baseline.md

    Your Mission:
    1. Load quality baseline metrics
    2. Classify refactoring type (Extract, Rename, Simplify, Duplication, Restructure, etc.)
    3. Break into small, testable increments (1 change per increment)
    4. Define git checkpoint branch for each increment
    5. Identify affected tests and regression tiers (Tier 1, 2, 3)
    6. Assess complexity and risk per increment
    7. Generate comprehensive refactoring plan with rollback procedures

    Output: implementation/refactoring-plan.md

    Report back:
    - Refactoring type: [Type]
    - Total increments: [N]
    - Overall risk: [Low/Medium/High]
    - Estimated time: [X] hours
```

**On Completion**:
- Parse agent output to extract metadata
- Update state:
  - `last_completed_phase = 1`
  - `refactoring_type = [from agent]`
  - `total_increments = [from agent]`
  - `risk_level = [from agent]`
- If interactive: Prompt user to review plan and approve

**On Failure**:
- If max attempts (2) exhausted: HALT, ask user to clarify refactoring type
- Save state and exit

---

### Step 6: Execute Phase 2 - Behavioral Snapshot Capture

**Delegate to**: `ai-sdlc:behavioral-snapshot-capturer` subagent

**Invoke behavioral-snapshot-capturer via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:behavioral-snapshot-capturer"
- description: "Capture behavioral snapshot"
- prompt: |
    Capture comprehensive behavioral baseline before refactoring.

    Task Directory: [TASK_DIR]
    Input: implementation/refactoring-plan.md (target files list)

    Your Mission:
    1. Identify all functions in target files (signatures, parameters, returns)
    2. Analyze test coverage (direct tests, integration tests)
    3. Run full test suite, capture baseline results (pass/fail, I/O if available)
    4. Identify observable side effects (DB, API, files, logs, state changes)
    5. Create behavioral fingerprint (hash of signatures + tests + side effects)
    6. Generate behavioral snapshot report

    Outputs:
    - analysis/behavioral-snapshot.md
    - analysis/behavioral-fingerprint.yml

    Report back:
    - Functions analyzed: [N]
    - Test coverage: [X]%
    - Side effects documented: [N]
    - Behavioral fingerprint: [hash]
    - Test gaps: [N] functions without tests (list if critical)
```

**On Completion**:
- Update state:
  - `last_completed_phase = 2`
  - `baseline_fingerprint = [hash from agent]`
- If critical functions untested: Warn user, recommend adding tests first
- If interactive: Prompt user to review snapshot and proceed

**On Failure**:
- If critical functions untested: HALT, recommend adding tests
- Otherwise: Document limitations and proceed

---

### Step 6.5: Execute Phase 2.5 - Branch Setup

**Execution**: Main orchestrator (uses AskUserQuestion)

**Purpose**: Ask user if they want to create a dedicated git branch for the refactoring work.

**Process**:

**A. Ask User About Branch Creation**:

```
Use AskUserQuestion tool:

questions:
  - question: "Would you like to create a dedicated git branch for this refactoring?"
    header: "Git Branch"
    multiSelect: false
    options:
      - label: "Yes, create a branch"
        description: "Create refactor/YYYY-MM-DD-task-name branch for isolated refactoring work"
      - label: "No, work on current branch"
        description: "Continue on current branch with commit checkpoints"
```

**B. If User Chooses "Yes"**:

```bash
TASK_NAME=$(basename "$TASK_DIR")
BRANCH_NAME="refactor/$TASK_NAME"

# Create and checkout branch
git checkout -b "$BRANCH_NAME"

# Update state
use_dedicated_branch=true
refactoring_branch="$BRANCH_NAME"
```

**C. If User Chooses "No"**:

```bash
# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Update state
use_dedicated_branch=false
refactoring_branch="$CURRENT_BRANCH"
```

**D. Update State**:

```yaml
last_completed_phase: 2.5
use_dedicated_branch: true|false
refactoring_branch: "refactor/YYYY-MM-DD-task-name" or "main" (or whatever current branch is)
```

**On Completion**:
- State updated with branch information
- If interactive: Prompt user to proceed to refactoring execution
- If YOLO: Continue automatically to Phase 3

**Benefits of Dedicated Branch**:
- Isolated refactoring work
- Easy to review all changes together
- Simple to abandon if needed (just switch branches)
- Keeps main branch clean during refactoring

**Benefits of Current Branch**:
- No branch management needed
- Direct commits to working branch
- Simpler for small refactorings

---

### Step 7: Execute Phase 3 - Refactoring Execution

**Execution**: Main orchestrator (direct)

**Standards Reminder**: Review `.ai-sdlc/docs/INDEX.md` for coding style, naming conventions, and other relevant standards before executing refactoring changes.

**Process**:

```
Read implementation/refactoring-plan.md
Parse increments list

For each increment (1 to N):
  1. Apply refactoring changes
  2. Run regression tests (appropriate tiers)
  3. If tests pass: Create git commit checkpoint, continue
  4. If tests fail: IMMEDIATE ROLLBACK (git reset), HALT

Details below...
```

**For Each Increment**:

**A. Apply Refactoring Changes**:

**Option 1: Simple changes (1-3 files)** - Orchestrator applies directly using Edit tool

**Option 2: Complex changes (4+ files)** - Delegate planning via Task tool:

**Invoke implementation-changes-planner via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:implementation-changes-planner"
- description: "Plan increment changes"
- prompt: |
    Create detailed change plan for Increment [N] without modifying files.

    Increment Details: [from refactoring-plan.md]

    Your Mission:
    1. Read target files
    2. Identify exact changes needed
    3. Create detailed change plan (file-by-file, line-by-line)
    4. Return plan to orchestrator (DO NOT apply changes)

    Output: Return structured change plan
```

Then orchestrator applies changes from plan using Edit/Write tools.

**B. Run Regression Tests**:

```bash
# Run test tiers based on increment risk (from plan)
# Tier 1 (always): Direct tests
# Tier 2 (medium+ risk): Integration tests
# Tier 3 (high risk): Domain tests

# Example:
npm test -- --testPathPattern="$TIER1_PATTERN"

# Capture results
TEST_EXIT_CODE=$?
```

**C. Create Git Commit Checkpoint (if tests pass)**:

```bash
if [ $TEST_EXIT_CODE -eq 0 ]; then
  # All tests passed - Create checkpoint commit
  git add .
  COMMIT_MSG="Checkpoint $INCREMENT_NUM: $INCREMENT_DESC"
  git commit -m "$COMMIT_MSG"

  # Capture commit hash for rollback reference
  COMMIT_HASH=$(git rev-parse HEAD)

  # Update state
  increments_completed.append(INCREMENT_NUM)
  commit_checkpoints.append({
    increment: INCREMENT_NUM,
    description: INCREMENT_DESC,
    commit_hash: COMMIT_HASH,
    timestamp: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  })

  echo "✅ Increment $INCREMENT_NUM complete: $COMMIT_MSG"
  echo "   Commit: $COMMIT_HASH"

  # Continue to next increment
else
  # Test failure - IMMEDIATE ROLLBACK
  execute_rollback()
  HALT
fi
```

**D. Handle Test Failure (Analyze → Ask User → Then Act)**:

**IMPORTANT**: NEVER automatically rollback without user confirmation. Always analyze first, then ask.

**Step 1: Analyze Failure Root Cause**:

```
Identify failure type by examining test output:

1. Configuration/Environment Issues (EASY FIX likely):
   - Missing environment variable
   - Database connection string wrong
   - Test fixture missing setup
   - Mock configuration incomplete
   - Context/setup parameter missing

2. Test Setup Issues (EASY FIX likely):
   - Abstract test class issue
   - Test data not initialized
   - Async timing issue
   - Import path changed but test not updated

3. Actual Behavioral Change (requires investigation):
   - Function signature changed unexpectedly
   - Side effect removed/added
   - Return value different
   - Logic path changed
```

**Step 2: Ask User Before Any Rollback**:

```
Use AskUserQuestion tool:

questions:
  - question: "Test failure in Increment [N]. [DIAGNOSIS]. How would you like to proceed?"
    header: "Test Failed"
    multiSelect: false
    options:
      - label: "Try suggested fix"
        description: "[Specific fix based on analysis, e.g., 'Add missing DATABASE_URL env var']"
      - label: "Rollback changes"
        description: "Revert this increment's changes (git reset --hard HEAD)"
      - label: "Let me investigate"
        description: "Pause here so I can manually investigate the failure"
```

**Step 3: Execute Based on User Choice**:

```bash
# IF user chose "Try suggested fix":
#   Apply the suggested fix
#   Re-run tests
#   If still fails: Ask user again (max 2 fix attempts)

# IF user chose "Rollback changes":
git reset --hard HEAD
# If there was a previous checkpoint, we're back to it
# If this was the first increment, we're back to pre-refactoring state

# Update state
failed_phases.append({
  phase: "phase-3-execution",
  increment: INCREMENT_NUM,
  error: "Test failure: [test names]",
  failure_analysis: "[diagnosis from Step 1]",
  user_decision: "rollback",  # or "fix_attempted" or "manual_investigation"
  rollback_executed: true,
  rollback_command: "git reset --hard HEAD",
  resolution: "User chose rollback after reviewing failure analysis"
})

workflow_status = "failed"

# IF user chose "Let me investigate":
# Save state, HALT, let user investigate manually
workflow_status = "paused_for_investigation"
```

**Step 4: Report to User**:

```
echo "❌ Test failure in Increment $INCREMENT_NUM"
echo "Failure analysis: [diagnosis]"
echo "User decision: [choice]"
echo "Action taken: [rollback executed / fix applied / paused]"
echo "Current state: $(git log -1 --oneline)"
```

**On All Increments Complete**:
- Update state: `last_completed_phase = 3`
- All increments successfully committed as checkpoints
- Refactoring branch (or current branch) contains all changes
- If interactive: Prompt user to proceed to verification

**On ANY Increment Failure**:
- **Analyze failure root cause** (config issue? test setup? actual behavior change?)
- **Ask user with AskUserQuestion** before any rollback
- Options: Try suggested fix / Rollback changes / Let me investigate
- If user chooses rollback: Execute `git reset --hard HEAD`
- Save state with failure details and user decision
- **NEVER rollback automatically without user confirmation**

---

### Step 8: Execute Phase 4 - Behavior Verification

**Delegate to**: `ai-sdlc:behavioral-verifier` subagent

**Invoke behavioral-verifier via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:behavioral-verifier"
- description: "Verify behavior preserved"
- prompt: |
    Verify refactored code behavior matches baseline exactly.

    Task Directory: [TASK_DIR]
    Inputs:
    - analysis/behavioral-snapshot.md (baseline)
    - Refactored code (current state)

    Your Mission:
    1. Load baseline snapshot
    2. Capture post-refactoring state (same process as Phase 2)
    3. Compare function signatures (must match unless explicit rename)
    4. Validate test results (must be identical)
    5. Confirm side effects preserved (must be identical)
    6. Compare behavioral fingerprints
    7. Generate comprehensive comparison report with PASS/FAIL verdict

    Outputs:
    - verification/behavior-verification-report.md
    - verification/post-refactoring-snapshot.md
    - verification/fingerprint-comparison.yml

    Report back:
    - Verification status: [PASS|FAIL]
    - Discrepancies found: [N]
    - New test failures: [N]
    - Side effect changes: [N]
    - Recommendation: [APPROVE|ROLLBACK]
```

**On Completion with PASS**:
- Update state: `last_completed_phase = 4`, `behavior_verification_status = PASS`
- If interactive: Prompt user to proceed to final quality check

**On Completion with FAIL**:
- Update state: `behavior_verification_status = FAIL`, `workflow_status = failed`
- **DO NOT proceed to Phase 5**
- Recommend rollback to main: `git checkout main && for branch in refactor/checkpoint-*; do git branch -D $branch; done`
- HALT orchestrator
- User must investigate discrepancies and fix

---

### Step 9: Execute Phase 5 - Final Quality Verification

**Execution**: Main orchestrator (optionally delegates to other skills)

**Process**:

**A. Re-Measure Quality Metrics**:
- Re-run same analysis as Phase 0
- Calculate complexity, duplication, coverage
- Compare with baseline metrics

**B. Calculate Improvements**:
```
Improvement % = ((Baseline - Post) / Baseline) * 100

Example:
- Complexity: 12 → 8 = 33% improvement
- Duplication: 15% → 5% = 67% improvement
```

**C. Optional: Run Code Review**:
```
If user requested or high-risk refactoring:
  Invoke Skill:
    skill: ai-sdlc:code-reviewer
    # Generates verification/code-review-report.md
```

**C.5. Pragmatic Review (Run Automatically)**:
**Agent**: `code-quality-pragmatist` (subagent)

**Purpose**: Ensure refactoring improved code without over-engineering

**Triggered When**: Always after Phase 5 quality metrics - runs automatically in both Interactive and YOLO modes

**Actions**:
1. Invoke code-quality-pragmatist via Task tool with refactored code paths
2. Validate complexity reduction was achieved without adding unnecessary abstraction
3. Check that refactoring scope was appropriate (not scope creep)
4. Ensure patterns used match project scale
5. Identify if refactoring introduced over-engineering

**Outputs**:
- `verification/pragmatic-review.md` - Over-engineering assessment with recommendations

**Critical Failure Handling**:
- If CRITICAL over-engineering found in YOLO mode: Continue with warning (non-blocking)
- In interactive mode: Show findings for user review

**D. Optional: Check Production Readiness**:
```
If deploying soon:
  Invoke Skill:
    skill: ai-sdlc:production-readiness-checker
    # Generates verification/production-readiness-report.md
```

**E. Generate Final Report**:
Create `verification/quality-improvement-report.md`:

```markdown
# Quality Improvement Report

## Metrics Comparison

| Metric | Baseline | Post-Refactoring | Improvement |
|--------|----------|------------------|-------------|
| Avg Complexity | 12 | 8 | 33% ↓ |
| Max Complexity | 25 | 12 | 52% ↓ |
| Duplication | 15% | 5% | 67% ↓ |
| Test Coverage | 70% | 70% | - |

## Goals Assessment

✅ Reduce avg complexity to <10: ACHIEVED (8)
✅ Reduce duplication to <5%: ACHIEVED (5%)
✅ Eliminate high-severity code smells: ACHIEVED

## Overall Status

✅ SUCCESS: All goals met, quality improved, behavior preserved

## Recommendation

APPROVE refactoring for code review and merge.
```

**On Completion**:
- Update state: `last_completed_phase = 5`, `workflow_status = completed`
- Final status report to user

---

### Step 10: Finalize Workflow

**A. Update Metadata**:
```yaml
# metadata.yml
status: completed
completed_at: "2025-11-14T16:00:00Z"
duration_hours: 4
behavior_preserved: true
quality_improved: true
```

**B. Final Summary**:
```
REFACTORING WORKFLOW COMPLETED ✅

Task: [Task name]
Type: [Refactoring type]
Increments: [N] (all successful)
Checkpoints: [N] git commits created
Branch: [refactoring_branch] (or current branch if no dedicated branch)

Quality Improvement:
- Complexity: 33% reduction
- Duplication: 67% reduction
- Goals: All met

Behavior Preservation: ✅ VERIFIED

Next Steps:
1. Review refactoring commits: git log [refactoring_branch]
2. If on dedicated branch: Merge to main (or create PR)
3. Run final code review
4. Create pull request (if not already created)

Refactoring commits:
- Checkpoint 1: [commit_hash] - [description]
- Checkpoint 2: [commit_hash] - [description]
- Checkpoint 3: [commit_hash] - [description]
[...]
```

**C. Interactive Prompt** (if interactive mode and using dedicated branch):
```
Would you like me to:
1. Create pull request with refactoring branch?
2. Merge refactoring branch to main locally?
3. Just exit (you'll merge manually)?
```

**D. Interactive Prompt** (if interactive mode and on current branch):
```
Refactoring complete! All changes are committed to current branch.

Would you like me to:
1. Create pull request with current branch?
2. Just exit (refactoring already committed)?
```

---

## Failure Handling

### Phase 0-2.5 Failures
- Limited auto-fix (max 1-2 attempts for Phase 0-2)
- Phase 2.5: No auto-fix (user decision on branch creation)
- Save state and HALT if unresolved
- User provides missing information, then resume

### Phase 3 Failures (Test Failure)
- **Analyze failure root cause** before any action
- Check for easy fixes: config issues, test setup, environment variables
- **Ask user with AskUserQuestion tool** presenting:
  - "Try suggested fix" (if easy fix identified)
  - "Rollback changes" (user confirms rollback)
  - "Let me investigate" (pause for manual investigation)
- **NEVER rollback automatically** - always get user confirmation first
- If user chooses rollback: Execute `git reset --hard HEAD`
- Save state with failure analysis and user decision

### Phase 4 Failures (Behavior Changed)
- **Analyze the behavior discrepancy** - what changed and why?
- Check for easy fixes: test assertion too strict, mock configuration, timing issue
- **Ask user with AskUserQuestion tool** presenting:
  - "Try suggested fix" (if easy fix identified)
  - "Rollback changes" (user confirms rollback)
  - "Let me investigate" (pause for manual investigation)
- **NEVER rollback automatically** - always get user confirmation first
- If user chooses rollback: Offer rollback options based on branch setup
  - If on dedicated branch: Switch back to main and abandon branch
  - If on current branch: `git reset --hard` to pre-refactoring state
- Save state with failure analysis and user decision

### Phase 5 Failures (Goals Not Met)
- Document what was achieved
- User decides: Accept partial improvement, continue refactoring, or rollback

---

## State Management

### State File: orchestrator-state.yml

**During Execution**:
```yaml
current_phase: 3
last_completed_phase: 2.5
current_increment: 3
increments_completed: [1, 2]
use_dedicated_branch: true
refactoring_branch: "refactor/2025-11-20-simplify-validation"
commit_checkpoints:
  - increment: 1
    description: "extract-validation"
    commit_hash: "abc1234"
    timestamp: "2025-11-20T10:15:00Z"
  - increment: 2
    description: "rename-variables"
    commit_hash: "def5678"
    timestamp: "2025-11-20T10:30:00Z"
```

**On Failure**:
```yaml
workflow_status: failed
failed_phases:
  - phase: phase-3-execution
    increment: 3
    error: "Test failure: testUpdateUser FAILED"
    rollback_executed: true
    rollback_command: "git reset --hard HEAD"
    resolution: "HALTED - User must investigate"
```

---

## Key Principles

### 1. User Control Over Branching
- Always ask user before creating git branches
- Support both dedicated branch and current branch workflows
- User decides what works best for their team

### 2. Behavior Preservation is Sacred
- Zero tolerance for behavior changes
- ANY test failure = Analyze root cause → Ask user → Execute user's choice
- **NEVER rollback automatically** - always get user confirmation first
- User decides: try fix, rollback, or investigate manually

### 3. Git Commit Checkpoints Enable Safety
- Git commit checkpoint after every successful increment
- Rollback via `git reset --hard HEAD` only after user confirmation
- Clear audit trail with commit history

### 4. Test-Driven Verification
- Run tests after every change
- Appropriate tiers based on risk
- Tests are the truth

### 5. Read-Only Subagents
- Subagents analyze and plan
- Main orchestrator applies changes
- Maintains control and safety

### 6. Incremental Progress
- Small, focused changes
- Test after each increment
- Build confidence progressively

---

## Integration with Other Skills

**After Refactoring Complete**:
- Can invoke `ai-sdlc:code-reviewer` for quality review
- Can invoke `ai-sdlc:production-readiness-checker` before deploy
- Can invoke `ai-sdlc:implementation-verifier` for additional verification

**Resume from Failure**:
- User fixes issues
- Resume with `/ai-sdlc:refactoring:resume [task-path]`
- Optional: `--from=phase-N` to restart specific phase

---

## Summary

**7-Phase Workflow**: Baseline → Plan → Snapshot → Branch Setup (optional) → Execute → Verify Behavior → Verify Quality

**Key Safety Features**:
- User control: Always asks before creating git branches
- Single refactoring branch (or work on current branch)
- Git commit checkpoints with user-confirmed rollback (never automatic)
- On failure: Analyze root cause → Ask user → Execute user's choice
- Comprehensive behavior preservation verification
- Test-driven incremental execution

**Success Criteria**: Behavior preserved (PASS verdict) + Quality improved (goals met)

This orchestrator ensures refactoring is safe, verifiable, and achieves quality improvements without changing functionality.
