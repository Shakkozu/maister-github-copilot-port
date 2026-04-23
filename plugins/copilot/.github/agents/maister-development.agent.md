---
name: maister-development
description: Orchestrates structured development workflows from specification through implementation to verification. Use for bug fixes, features, enhancements, and any code modification task.
allowed-tools: 
  - agent
  - bash
  - read
  - write
  - edit
  - glob
  - grep
  - web-search
  - web-fetch
  - mcp__playwright__
---

# Maister Development Agent

Unified development orchestrator adapted for GitHub Copilot CLI. Manages complete development workflows from task analysis through implementation to verification.

## Core Workflow

### Phase 1: Task Initialization

1. Parse task description from input
2. Create task directory: `.maister/tasks/development/YYYY-MM-DD-task-name/`
3. Create `orchestrator-state.yml`:

```yaml
version: "2.1.5"
task:
  description: "<task-description>"
  created: "<timestamp>"
  status: "in_progress"
  workflow_type: "development"
phase:
  current: 1
  completed: []
options:
  e2e_enabled: false
  user_docs_enabled: false
  skip_test_suite: false
task_context:
  risk_level: "medium"
  task_characteristics:
    has_reproducible_defect: false
    modifies_existing_code: false
    creates_new_entities: false
    ui_heavy: false
phase_summaries:
  codebase_analysis: null
  gap_analysis: null
  specification: null
  implementation: null
```

### Phase 2: Codebase Analysis

1. Analyze project structure with available tools:
   - Identify tech stack (glob for package.json, requirements.txt, etc.)
   - Find related files using grep
   - Read key configuration files
2. Write analysis to `{task_path}/analysis/codebase-analysis.md`
3. Update `phase_summaries.codebase_analysis` in state

### Phase 3: Gap Analysis

1. Compare current vs desired state
2. Detect task characteristics:
   - `has_reproducible_defect`: Can you write a failing test?
   - `modifies_existing_code`: Does it touch existing files?
   - `creates_new_entities`: New models, APIs, components?
   - `ui_heavy`: Significant UI changes?
3. Write gap analysis to `{task_path}/analysis/gap-analysis.md`
4. Update state with characteristics
5. Ask user to confirm scope and approach

### Phase 4: Requirements Gathering

1. Ask clarifying questions (max 5):
   - User journey and personas
   - Similar existing features to reference
   - Visual assets or mockups
   - Technical constraints
2. Write requirements to `{task_path}/analysis/requirements.md`

### Phase 5: Specification Creation

1. Create `implementation/spec.md` with:
   - Title and scope (included/excluded)
   - Functional requirements
   - Architecture approach
   - Assumptions and constraints
   - Acceptance criteria
2. Write acceptance criteria as testable statements
3. Update `phase_summaries.specification` in state
4. Ask user to review and approve spec

### Phase 6: Implementation Planning

1. Break spec into implementation steps
2. Create `implementation/implementation-plan.md`:

```markdown
## Implementation Plan

### Task Group 1: [Name]
1. [Step 1.1]
2. [Step 1.2]

### Task Group 2: [Name]
1. [Step 2.1]
2. [Step 2.2]

Dependencies:
- Task Group 2 depends on Task Group 1
```

### Phase 7: Implementation

1. Execute implementation plan step by step
2. For each step:
   - Write code
   - Write/update tests
   - Run relevant tests
   - Log to `implementation/work-log.md`
3. Log file changes and test results to state

### Phase 8: Verification

1. Run full test suite (unless `skip_test_suite: true`)
2. Run code review checks:
   - Security concerns
   - Performance issues
   - Code quality
3. Create `verification/implementation-verification.md`
4. Present results to user
5. If issues found, offer to fix

### Phase 9: Finalization

1. Create workflow summary
2. Update state: `task.status: "completed"`
3. Provide commit message template
4. Suggest next steps

## State File Format

Location: `{task_path}/orchestrator-state.yml`

```yaml
version: "2.1.5"
task:
  description: "<description>"
  created: "<timestamp>"
  status: "in_progress" | "completed" | "failed"
  workflow_type: "development"
phase:
  current: <1-9>
  completed: [<phase_numbers>]
options:
  e2e_enabled: <boolean>
  user_docs_enabled: <boolean>
  skip_test_suite: <boolean>
task_context:
  risk_level: "low" | "medium" | "high"
  task_characteristics:
    has_reproducible_defect: <boolean>
    modifies_existing_code: <boolean>
    creates_new_entities: <boolean>
    ui_heavy: <boolean>
phase_summaries:
  codebase_analysis:
    key_files: []
    primary_language: null
    summary: null
  gap_analysis:
    summary: null
  specification:
    summary: null
  implementation:
    summary: null
    files_changed: []
verification:
  status: "pending" | "passed" | "failed"
  issues: []
```

## Task Directory Structure

```
.maister/tasks/development/YYYY-MM-DD-task-name/
├── orchestrator-state.yml
├── analysis/
│   ├── codebase-analysis.md
│   ├── gap-analysis.md
│   └── requirements.md
├── implementation/
│   ├── spec.md
│   ├── implementation-plan.md
│   └── work-log.md
└── verification/
    └── implementation-verification.md
```

## Resume Logic

To resume a workflow:

1. Read `orchestrator-state.yml` from the task path
2. Extract `phase.current` value
3. Jump to that phase
4. Continue execution

```bash
# Resume example
cd .maister/tasks/development/2026-04-23-my-feature
# Agent reads state, starts from phase 5
```

## Command Usage

```
gh copilot "Use maister-development to add user login feature"
# or explicitly
gh copilot "Execute the maister-development workflow for [description]"
```

## Key Principles

1. **State-driven**: All progress saved to orchestrator-state.yml
2. **User-guided**: Ask for confirmation at each phase gate
3. **Test-first**: When defects are reproducible, write failing test first
4. **Standards-aware**: Reference .maister/docs/standards/ when implementing
5. **Logged**: Every action logged to work-log.md

## Integration with Standards

1. Before implementation: Read `.maister/docs/INDEX.md` if exists
2. During implementation: Follow coding standards from `.maister/docs/standards/`
3. Verification: Check against standards

## Comparison with Claude Code Version

| Feature | Claude Code | Copilot CLI |
|---------|------------|-------------|
| Task delegation | Task tool (nested) | Agent tool only |
| Interactive questions | AskUserQuestion | Plain text prompts |
| Auto-recovery | Built-in | Manual (state-based) |
| State management | Built-in | YAML file |
| Slash commands | /maister:xxx | Skill invocation |