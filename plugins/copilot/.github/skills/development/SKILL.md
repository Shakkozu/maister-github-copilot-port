---
name: maister-development
description: Structured development workflow from specification through implementation to verification. Use for features, bug fixes, and enhancements.
---

# Maister Development Skill

Orchestrates structured development workflows. This skill guides you through analysis, specification, implementation, and verification phases.

## When to Use

- Bug fixes with reproducible defects
- New features
- Enhancements to existing features
- Any code modification task

## Workflow Phases

### Phase 1: Analyze

**What happens**: Codebase analysis + gap detection

**Your actions**:
1. Identify related files (glob, grep)
2. Understand current implementation
3. Detect task characteristics:
   - Reproducible defect?
   - Modifies existing code?
   - Creates new entities?
   - UI-heavy?

**Output**: `analysis/codebase-analysis.md`, `analysis/gap-analysis.md`

### Phase 2: Clarify

**What happens**: Requirements gathering

**Your actions**:
1. Ask clarifying questions:
   - How will users discover this?
   - Which personas are affected?
   - Similar existing features to reference?
   - Visual assets or mockups?
2. Document answers in `analysis/requirements.md`

### Phase 3: Specify

**What happens**: Create specification document

**Your actions**:
1. Write `implementation/spec.md`:
   - Title and scope (included/excluded)
   - Functional requirements
   - Architecture approach
   - Acceptance criteria (testable statements)
2. Review spec with user
3. Get approval before proceeding

### Phase 4: Plan

**What happens**: Implementation planning

**Your actions**:
1. Break spec into steps
2. Create `implementation/implementation-plan.md`:
   ```markdown
   ## Task Group 1: [Name]
   1. [Step 1.1]
   2. [Step 1.2]
   
   ## Task Group 2: [Name]
   ...
   ```
3. Identify dependencies

### Phase 5: Implement

**What happens**: Execute implementation

**Your actions**:
1. For each step:
   - Write code
   - Write/update tests
   - Run relevant tests
   - Log to `implementation/work-log.md`
2. Follow coding standards from `.maister/docs/standards/`

### Phase 6: Verify

**What happens**: Verification and testing

**Your actions**:
1. Run full test suite
2. Run code review
3. Create `verification/implementation-verification.md`
4. Present issues to user
5. Offer to fix issues

### Phase 7: Finalize

**What happens**: Complete workflow

**Your actions**:
1. Create workflow summary
2. Update state to completed
3. Provide commit message template

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

## State Management

All progress is saved to `orchestrator-state.yml`. To resume:

1. Read the state file
2. Continue from `phase.current`

## Usage

```bash
# Start new development task
gh copilot "Use maister-development to add user login"

# Resume existing task
cd .maister/tasks/development/2026-04-23-login-feature
gh copilot "Resume maister-development workflow"
```

## Interaction Pattern

Unlike Claude Code's interactive `AskUserQuestion`, Copilot CLI uses plain text prompts:

1. Phase completes
2. Agent presents findings
3. Agent asks: "Continue to next phase?"
4. User confirms or redirects

## Standards Integration

Before implementing:
1. Read `.maister/docs/INDEX.md` if exists
2. Reference `.maister/docs/standards/` during implementation

## TDD Mode (Optional)

For reproducible defects:

1. **Phase R (Red)**: Write failing test
2. **Phase G (Green)**: Implement to pass test
3. **Phase R (Refactor)**: Improve code

Invoke with: `"Add user login with TDD"`

## Comparison with Claude Code

| Aspect | Claude Code | Copilot CLI |
|--------|-------------|-------------|
| Subagent delegation | Task tool (nested) | Sequential agent calls |
| Interactive prompts | AskUserQuestion | Plain text |
| State management | Built-in | YAML file |
| Resume | Automatic | Manual file read |