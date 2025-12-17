---
name: migration-orchestrator
description: Orchestrates the complete migration workflow from current state analysis through implementation to compatibility verification. Handles technology migrations, platform changes, and architecture pattern transitions with adaptive risk assessment, incremental execution, and rollback planning. Supports interactive mode (pause between phases) and YOLO mode (continuous execution). Use when migrating technologies, platforms, or architecture patterns.
---

# Migration Orchestrator

Systematic migration workflow from current state analysis to verified migration with rollback capabilities.

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Check dependencies", "status": "pending", "activeForm": "Checking dependencies"},
  {"content": "Analyze current state", "status": "pending", "activeForm": "Analyzing current state"},
  {"content": "Plan target state and gaps", "status": "pending", "activeForm": "Planning target state and gaps"},
  {"content": "Create migration strategy", "status": "pending", "activeForm": "Creating migration strategy"},
  {"content": "Plan implementation", "status": "pending", "activeForm": "Planning implementation"},
  {"content": "Execute migration", "status": "pending", "activeForm": "Executing migration"},
  {"content": "Verify and test compatibility", "status": "pending", "activeForm": "Verifying and testing compatibility"},
  {"content": "Generate documentation", "status": "pending", "activeForm": "Generating documentation"}
]
```

**Skip phases based on context** (remove from todo list before starting):
- **Not part of initiative**: Skip "Check dependencies"
- **Documentation not needed**: Skip "Generate documentation"

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Migration Orchestrator Started

Task: [migration description]
Mode: [Interactive/YOLO]
Directory: [task-path]

Workflow phases:
[Todos list with status]

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Analyze current state...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Current State Analysis).

---

## When to Use This Skill

Use when:
- Migrating from one framework/library to another (e.g., Vue 2 → Vue 3, Express → Fastify)
- Changing database platforms (e.g., MySQL → PostgreSQL, MongoDB → DynamoDB)
- Refactoring architecture patterns (e.g., REST → GraphQL, Monolith → Microservices)
- Upgrading major versions with breaking changes
- Any work involving "migrate", "move from X to Y", "upgrade to"

**DO NOT use for**:
- Completely new features (use `development-orchestrator --type=feature`)
- Bug fixes (use `development-orchestrator --type=bug`)
- Pure refactoring without technology change (use `refactoring-orchestrator`)

## Core Principles

1. **Analyze Before Migrating**: Understand current system before planning target state
2. **Risk Assessment**: Classify migration type (code/data/architecture) and assess complexity
3. **Incremental Execution**: Support phased migration with rollback points
4. **Rollback Planning**: Document undo procedures for each migration phase
5. **Dual-Run Support**: Enable running old and new systems in parallel during transition

---

## Framework Patterns

This orchestrator follows shared patterns. See:

- **Phase Execution**: `../orchestrator-framework/references/phase-execution-pattern.md`
- **State Management**: `../orchestrator-framework/references/state-management.md`
- **Interactive Mode**: `../orchestrator-framework/references/interactive-mode.md`
- **Initialization**: `../orchestrator-framework/references/initialization-pattern.md`

## Local References

Read these during relevant phases:

| File | When to Use | Purpose |
|------|-------------|---------|
| `references/migration-types.md` | Phase 0-1 | Migration type classification (code, data, architecture) |
| `references/migration-strategies.md` | Phase 2-4 | Rollback planning, dual-run patterns, verification strategies |

---

## Phase Configuration

| Phase | content | activeForm | Agent/Skill |
|-------|---------|------------|-------------|
| 0.5 | "Check dependencies" | "Checking dependencies" | orchestrator (initiative only) |
| 0 | "Analyze current state" | "Analyzing current state" | codebase-analyzer |
| 1 | "Plan target state and gaps" | "Planning target state and gaps" | gap-analyzer |
| 2 | "Create migration strategy" | "Creating migration strategy" | specification-creator |
| 3 | "Plan implementation" | "Planning implementation" | implementation-planner |
| 4 | "Execute migration" | "Executing migration" | implementer |
| 5 | "Verify and test compatibility" | "Verifying and testing compatibility" | implementation-verifier |
| 6 | "Generate documentation" | "Generating documentation" | user-docs-generator (optional) |

**Workflow Overview**: 7-8 phases (Phase 0.5 only if part of initiative, Phase 6 optional)

**CRITICAL TodoWrite Usage**:
1. At workflow start: Create todos for ALL phases using the Phase Configuration table above (all status=pending)
2. Before each phase: Update that phase to status=in_progress
3. After each phase: Update that phase to status=completed

---

## Migration Types

| Type | Keywords | Strategy | Risk Focus |
|------|----------|----------|------------|
| **Code** | framework, library, upgrade, version | Incremental or phased | Breaking changes, API differences |
| **Data** | database, schema, data migration | Dual-run (zero downtime) | Data integrity, checksums |
| **Architecture** | REST→GraphQL, monolith→microservices | Dual-run or phased | Compatibility, rollback |
| **General** | Ambiguous or mixed | Case-by-case | Varies |

**Migration Strategy Options**:
- **Incremental**: Migrate component-by-component with tests between
- **Big-Bang**: Complete migration in one change (simple migrations only)
- **Dual-Run**: Run old and new systems in parallel during transition
- **Phased**: Multiple deployment phases with validation between

---

## Workflow Phases

### Phase 0.5: Dependency Check (Initiative Only)

**Execution**: Main orchestrator (direct)

**When**: Only if task has `initiative_id` in metadata.yml

**Process**:
1. Read task metadata.yml, check for `initiative_id`
2. If no initiative_id → Skip to Phase 0
3. If has initiative_id → Check all dependencies have status="completed"
4. If dependencies not met → BLOCK with message and exit

**Success**: All dependencies satisfied or not part of initiative

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 0.

---

### Phase 0: Current State Analysis

**Delegate to**: `codebase-analyzer` skill

**Skill invocation**:
```
Invoke codebase-analyzer skill with:
- task_type: "enhancement" (migration analyzes existing code)
- description: [migration description]
- task_path: [.ai-sdlc/tasks/migrations/YYYY-MM-DD-name/]
- artifact_name: "current-state-analysis.md"
```

**Outputs**: `analysis/current-state-analysis.md`

**Success**: Current system files identified, technologies documented, complexity assessed

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 1.

---

### Phase 1: Target State Planning & Gap Analysis

**Delegate to**: `gap-analyzer` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:gap-analyzer"
description: "Analyze migration gaps and target state"
prompt: |
  You are the gap-analyzer agent. Perform comprehensive gap analysis
  for this migration.

  Migration Description: [description]
  Task directory: [task-path]
  Existing Analysis: analysis/current-state-analysis.md

  Please:
  1. Define target system from migration description
  2. Identify gaps (features to migrate, APIs to adapt, data to transform)
  3. Classify migration type (code/data/architecture)
  4. Recommend migration strategy (incremental/big-bang/dual-run/phased)
  5. Assess risk level and breaking changes
  6. Document rollback requirements
  7. Perform external research (WebSearch) for version upgrades or technology migrations

  Save to: analysis/target-state-plan.md
  Use only Read, Grep, Glob, WebSearch, and Bash tools. Do NOT modify code.
```

**Outputs**: `analysis/target-state-plan.md`

**Success**: Migration type classified, strategy recommended, breaking changes documented

**State Update**: After gap-analyzer completes, read structured output:
- Update `migration_context.migration_type` from output (code/data/architecture/general)
- Update `migration_context.current_system` from output (description, technologies)
- Update `migration_context.target_system` from output (description, technologies)
- Update `migration_context.migration_strategy` from output (approach, phases)
- Update `migration_context.risk_level` from output
- Update `migration_context.breaking_changes` from output
- If external research performed, update `external_research` block (performed, category, breaking_changes, migration_guide_url)

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 2.

---

### Phase 2: Migration Strategy Specification

**Delegate to**: `specification-creator` skill

**Process**:
1. Invoke specification-creator with migration context
2. Pass current_system, target_system, migration_type, migration_strategy from state
3. Create specification with migration-specific details:
   - Rollback requirements for each phase
   - Dual-run synchronization (if dual-run strategy)
   - Incremental milestone definitions (if incremental)
   - Data migration procedures (if data migration)
4. Create rollback plan

**Outputs**:
- `implementation/spec.md` - Migration specification
- `analysis/rollback-plan.md` - Rollback procedures for each phase
- `analysis/dual-run-plan.md` - (if dual-run strategy)
- `verification/spec-verification.md`

**Success**: Specification complete, rollback plan documented

**State Update**: After specification-creator completes:
- Set `migration_context.rollback_plan_created: true` (if rollback-plan.md created)
- Set `migration_context.dual_run_configured: true` (if dual-run-plan.md created)

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 3.

---

### Phase 3: Implementation Planning

**Delegate to**: `implementation-planner` skill

**Process**:
1. Invoke implementation-planner with migration specification
2. Break migration into task groups by strategy:
   - **Incremental**: Task group per migration phase
   - **Big-bang**: Standard task groups (prep, migrate, verify)
   - **Dual-run**: Task groups (old system, new system, sync, cutover)
   - **Phased**: Task groups per phase with dependencies
3. Include rollback steps in each task group
4. Define verification points between phases

**Outputs**: `implementation/implementation-plan.md` with rollback procedures

**Success**: Plan complete with rollback steps, dependencies correct

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 4.

---

### Phase 4: Migration Execution

**Delegate to**: `implementer` skill

**Standards Reminder**: Review `.ai-sdlc/docs/INDEX.md` for project standards before implementing.

**Process**:
1. Invoke implementer to execute implementation-plan.md
2. Execute migration incrementally per task group
3. Run tests after each migration phase (not just at end)
4. Enable pause/resume at task group boundaries (critical for migrations)
5. Log progress in implementation/work-log.md

**Outputs**:
- Implemented migration changes
- Updated `implementation-plan.md` (all steps complete)
- `implementation/work-log.md`

**Success**: All migration steps complete, tests pass after each task group

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 5.

---

### Phase 5: Verification + Compatibility Testing

**Delegate to**: `implementation-verifier` skill

**Migration-Specific Checks**:
- Verify old system still works (if dual-run)
- Test rollback procedures (non-destructive test)
- Validate data integrity (for data migrations)
- Check performance benchmarks (before/after comparison)
- Verify backward compatibility (if required)

**Outputs**:
- `verification/implementation-verification.md`
- `verification/compatibility-test-results.md`

**Gate**: Cannot complete if data integrity issues in data migration

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 6.

---

### Phase 6: Documentation (Optional)

**Delegate to**: `user-docs-generator` subagent

**Enable if**: Complex migration (medium-high risk), `--docs` flag, or user requests in interactive

**State Update**: When deciding whether to run documentation (Interactive or YOLO):
- Set `options.docs_enabled` based on user choice, `--docs` flag, or auto-decision (true for medium-high risk migrations)

**Content**:
- Migration overview and goals
- Prerequisites and preparation steps
- Step-by-step migration procedure
- Rollback procedures
- Troubleshooting common issues
- Verification checklist

**Outputs**: `documentation/migration-guide.md`

---

## Domain Context (State Extensions)

Migration-specific fields in `orchestrator-state.yml`:

```yaml
migration_context:
  migration_type: "code" | "data" | "architecture" | "general"
  current_system:
    description: "[summary]"
    technologies: []
  target_system:
    description: "[summary]"
    technologies: []
  migration_strategy:
    approach: "incremental" | "big-bang" | "dual-run" | "phased"
    phases: []
  risk_level: "low" | "medium" | "high"
  breaking_changes: []
  rollback_plan_created: false
  dual_run_configured: false

external_research:
  performed: false
  category: null  # version_upgrade|technology_migration|api_integration
  breaking_changes: []
  migration_guide_url: null

options:
  docs_enabled: false
```

---

## Task Structure

```
.ai-sdlc/tasks/migrations/YYYY-MM-DD-migration-name/
├── metadata.yml
├── orchestrator-state.yml
├── analysis/
│   ├── current-state-analysis.md    # Phase 0
│   ├── target-state-plan.md         # Phase 1
│   ├── rollback-plan.md             # Phase 2
│   └── dual-run-plan.md             # Phase 2 (if dual-run)
├── implementation/
│   ├── spec.md                      # Phase 2
│   ├── implementation-plan.md       # Phase 3
│   └── work-log.md                  # Phase 4
├── verification/
│   ├── spec-verification.md         # Phase 2
│   ├── implementation-verification.md  # Phase 5
│   └── compatibility-test-results.md   # Phase 5
└── documentation/
    └── migration-guide.md           # Phase 6 (optional)
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| 0 | 2 | Expand search patterns, prompt user for file paths |
| 1 | 2 | Re-prompt for target details, prompt user to specify type |
| 2 | 2 | Re-invoke spec-creator with issues, regenerate rollback plan |
| 3 | 2 | Regenerate with migration constraints, fix dependencies |
| 4 | 5 | Fix syntax errors, prompt user for manual intervention on repeated failure |
| 5 | 2-3 | Invoke implementer with fix instructions. **HALT on data integrity issues** |
| 6 | 1 | Generate text-only without screenshots (optional phase) |

**Data Safety Critical**: For data migrations, HALT on data integrity issues - don't auto-fix.

---

## Command Integration

Invoked via:
- `/ai-sdlc:migration:new [description] [--yolo] [--type=TYPE]`
- `/ai-sdlc:migration:resume [task-path] [--from=PHASE]`

Task directory: `.ai-sdlc/tasks/migrations/YYYY-MM-DD-task-name/`

---

## Success Criteria

Workflow successful when:

- Current state thoroughly analyzed (Phase 0)
- Migration type detected and confirmed (Phase 1)
- Migration strategy selected (incremental/big-bang/dual-run/phased)
- Rollback plan created and documented
- Migration executes incrementally with verification points
- Tests pass after each migration phase
- Compatibility testing validates migration success
- For data migrations: 100% data integrity verified
- Ready for production cutover or rollback if needed
