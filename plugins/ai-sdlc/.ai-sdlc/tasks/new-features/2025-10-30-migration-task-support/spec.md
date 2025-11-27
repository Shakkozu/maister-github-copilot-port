# Specification: Add Support for Migration Tasks

## Goal
Enable teams to handle technology migrations, platform changes, and architecture pattern transitions through a comprehensive migration-orchestrator workflow that provides guided planning, execution, and verification with rollback capabilities and dual-run support.

## User Stories
- As a developer, I want to migrate from one framework to another (e.g., Vue 2 to Vue 3, Express to Fastify) so that I can modernize the codebase with guided steps and rollback plans
- As a team lead, I want to plan database migrations (e.g., MySQL to PostgreSQL) so that I can execute data migration incrementally with minimal risk
- As an architect, I want to refactor architecture patterns (e.g., REST to GraphQL, Monolith to Microservices) so that I can transition gradually with both systems running in parallel
- As a developer, I want to use `/ai-sdlc:migration:new` to start a migration workflow so that I can follow a structured approach similar to feature/enhancement workflows
- As a developer, I want to resume interrupted migrations with `/ai-sdlc:migration:resume` so that I don't lose progress if the process is interrupted
- As a developer, I want the system to detect migration type automatically (code/data/architecture) so that I get workflow guidance specific to my migration needs

## Core Requirements

### Migration Orchestrator Skill
- Create `skills/migration-orchestrator/SKILL.md` following the pattern of feature-orchestrator and enhancement-orchestrator
- Implement 6-7 phase workflow structure:
  - **Phase 0**: Current State Analysis (analyze existing system)
  - **Phase 1**: Target State Planning (define migration goals and target system)
  - **Phase 2**: Migration Strategy Specification (create detailed migration specification)
  - **Phase 3**: Implementation Planning (break into executable steps with task groups)
  - **Phase 4**: Migration Execution (implement the migration incrementally)
  - **Phase 5**: Verification + Compatibility Testing (verify migration success and system compatibility)
  - **Phase 6**: Documentation (optional - create migration guide and rollback documentation)

### Migration Type Detection
- Auto-detect migration type from task description keywords:
  - **Code migrations**: framework names, library names, "upgrade", "migrate from X to Y"
  - **Data migrations**: database names (MySQL, PostgreSQL, MongoDB, etc.), "schema change", "data migration"
  - **Architecture migrations**: pattern names (REST/GraphQL, monolith/microservices), "refactor to", architecture terms
- Store detected type in orchestrator-state.yml: `migration_type: code | data | architecture | general`
- Prompt user to confirm detected type before proceeding
- Adapt workflow phases based on detected migration type

### Migration Strategies
Support three migration strategies with guidance in each phase:

**Incremental Migration**:
- Plan migration in phases (migrate piece by piece)
- Define incremental milestones with verification points
- Document dependencies between migration phases
- Enable partial rollback of individual phases

**Rollback Planning**:
- Document rollback steps for each migration phase
- Create rollback plan in planning/rollback-plan.md
- Include rollback testing as part of verification
- Store rollback strategy in orchestrator state

**Dual-Run Support**:
- Plan for running old and new systems in parallel
- Document data synchronization approach during dual-run
- Define cutover criteria and process
- Include dual-run verification in testing phase

### Slash Commands
Create two migration commands following existing orchestrator patterns:

**`/ai-sdlc:migration:new`** (`commands/migration/new.md`):
- Arguments: `[description]` (optional - prompt if omitted)
- Options:
  - `--yolo`: YOLO mode (continuous execution without pauses)
  - `--from=PHASE`: Start from specific phase (analysis, target, spec, plan, execute, verify)
  - `--type=TYPE`: Override auto-detection (code, data, architecture)
- Invokes migration-orchestrator skill
- Creates task folder: `.ai-sdlc/tasks/migrations/YYYY-MM-DD-task-name/`
- Supports interactive (default) and YOLO execution modes

**`/ai-sdlc:migration:resume`** (`commands/migration/resume.md`):
- Arguments: `[task-path]` (optional - auto-detect from current directory)
- Options:
  - `--from=PHASE`: Override state, force start from specific phase
  - `--reset-attempts`: Reset auto-fix attempt counters
  - `--clear-failures`: Remove failed phases from state history
- Reads orchestrator-state.yml to determine resume point
- Validates prerequisites before resuming
- Continues workflow from saved state

### Task Structure
Create migration task folder following standard structure:
```
.ai-sdlc/tasks/migrations/YYYY-MM-DD-task-name/
├── metadata.yml                          # Task metadata with migration type
├── spec.md                               # Migration specification
├── implementation-plan.md                # Implementation steps breakdown
├── orchestrator-state.yml                # Workflow state with migration-specific fields
├── planning/
│   ├── current-state-analysis.md        # Phase 0: Analysis of existing system
│   ├── target-state-plan.md             # Phase 1: Target system definition
│   ├── migration-strategy.md            # Phase 2: Detailed migration strategy
│   ├── rollback-plan.md                 # Rollback procedures for each phase
│   └── dual-run-plan.md                 # Dual-run configuration (if applicable)
├── implementation/
│   └── work-log.md                      # Migration execution log
└── verification/
    ├── implementation-verification.md   # Verification results
    └── compatibility-test-results.md    # Compatibility testing results
```

### State Management
Extend orchestrator-state.yml format for migrations:
```yaml
orchestrator:
  mode: interactive | yolo
  current_phase: analysis | target | spec | plan | execute | verify | docs
  completed_phases: [...]
  failed_phases: [...]

  # Migration-specific fields
  migration_type: code | data | architecture | general
  current_system:
    description: "Description of existing system"
    technologies: ["list", "of", "current", "tech"]
  target_system:
    description: "Description of target system"
    technologies: ["list", "of", "target", "tech"]
  migration_strategy:
    approach: incremental | big-bang | dual-run | phased
    phases: ["phase1", "phase2", "..."]
  rollback_plan_created: true | false
  dual_run_configured: true | false

  # Standard orchestrator fields
  auto_fix_attempts: {...}
  options: {...}
  created: timestamp
  updated: timestamp
```

### Integration with Task Classifier
Update task-classifier to route migration tasks:
- Detect migration keywords in task description
- Classify as `task_type: migration`
- Route to migration-orchestrator when detected
- Integration point in `/work` command

### Documentation Updates
Update CLAUDE.md sections:
- Confirm migration tasks are supported with orchestrator
- Document migration-orchestrator skill in Available Skills section
- Add migration commands to Available Commands section
- Update Typical Development Workflow to mention migration path
- Update Task Types Supported table with migration details

## Visual Design
No visual design required - this is backend workflow orchestration with no UI components.

## Reusable Components

### Existing Skills to Reuse
- **specification-creator** (Phase 2): Create migration specification
  - Reuse for migration spec creation with migration-specific prompts
  - Path: `skills/specification-creator/SKILL.md`

- **implementation-planner** (Phase 3): Create implementation plan
  - Reuse for breaking migration into executable steps
  - Path: `skills/implementation-planner/SKILL.md`

- **implementer** (Phase 4): Execute migration
  - Reuse for implementing migration steps with standards discovery
  - Path: `skills/implementer/SKILL.md`

- **implementation-verifier** (Phase 5): Verify migration results
  - Reuse for verification and compatibility testing
  - Path: `skills/implementation-verifier/SKILL.md`

### Existing Agents to Reuse
- **existing-feature-analyzer** (Phase 0): Analyze current system
  - Locate current implementation files
  - Analyze dependencies and complexity
  - Path: `agents/existing-feature-analyzer.md`

- **gap-analyzer** (Phase 1): Compare current vs target
  - Identify gaps between current and target systems
  - Classify migration complexity
  - Path: `agents/gap-analyzer.md`

- **user-docs-generator** (Phase 6, optional): Generate migration guide
  - Document migration process for team
  - Path: `agents/user-docs-generator.md`

### Orchestrator Patterns to Follow
- **feature-orchestrator** (`skills/feature-orchestrator/SKILL.md`):
  - Overall structure and phase execution loop
  - State management in orchestrator-state.yml
  - Auto-recovery mechanisms and max retry logic
  - Interactive vs YOLO mode handling
  - Phase result tracking and finalization

- **enhancement-orchestrator** (`skills/enhancement-orchestrator/SKILL.md`):
  - Phase 0 (Existing Feature Analysis) pattern
  - Phase 1 (Gap Analysis) pattern
  - Compatibility verification approach
  - Current vs target state comparison

- **Command patterns** from `commands/feature/new.md` and `commands/feature/resume.md`:
  - Command structure and option handling
  - Skill invocation pattern
  - Documentation format

### New Components Required
- **migration-orchestrator skill** (`skills/migration-orchestrator/SKILL.md`):
  - Cannot reuse existing orchestrators directly due to migration-specific phases
  - Must implement 6-7 phase workflow specific to migrations
  - Includes migration type detection and strategy selection
  - Why new: Migration workflow fundamentally different from feature/enhancement/bug-fix

- **Migration reference documentation**:
  - `skills/migration-orchestrator/references/migration-strategies.md` - Incremental, rollback, dual-run patterns
  - `skills/migration-orchestrator/references/migration-types.md` - Code, data, architecture migration guides
  - `skills/migration-orchestrator/references/auto-fix-strategies.md` - Migration-specific error recovery
  - Why new: Migration-specific guidance not covered in existing references

- **Slash commands**:
  - `commands/migration/new.md` - Follows feature:new pattern but adapted for migrations
  - `commands/migration/resume.md` - Follows feature:resume pattern but adapted for migrations
  - Why new: Migration commands need different options (--type flag, migration-specific phases)

## Technical Approach

### Phase 0: Current State Analysis
- Invoke existing-feature-analyzer agent to locate current system files
- Analyze current technologies, dependencies, and complexity
- Document current system in planning/current-state-analysis.md
- Store current system description in orchestrator-state.yml

### Phase 1: Target State Planning
- Invoke gap-analyzer agent to compare current vs target
- Define target system goals and requirements
- Identify migration scope and complexity
- Document target state in planning/target-state-plan.md
- Store target system description in orchestrator-state.yml

### Phase 2: Migration Strategy Specification
- Invoke specification-creator with migration-specific prompts
- Select migration strategy (incremental/big-bang/dual-run/phased)
- Document approach in spec.md
- Create rollback plan in planning/rollback-plan.md
- If dual-run: Create planning/dual-run-plan.md

### Phase 3: Implementation Planning
- Invoke implementation-planner to break migration into steps
- Organize steps into task groups by migration phase
- Define dependencies between migration phases
- Include rollback steps in plan
- Output: implementation-plan.md

### Phase 4: Migration Execution
- Invoke implementer to execute implementation-plan.md
- Execute migration incrementally per task group
- Run tests after each migration phase
- Log progress in implementation/work-log.md
- Enable pause/resume at task group boundaries

### Phase 5: Verification + Compatibility Testing
- Invoke implementation-verifier for standard checks
- Add compatibility testing:
  - Verify old system still works (if dual-run)
  - Test migration rollback procedures
  - Validate data integrity (for data migrations)
  - Check performance benchmarks
- Output: verification/implementation-verification.md + verification/compatibility-test-results.md

### Phase 6: Documentation (Optional)
- Invoke user-docs-generator if user requests
- Generate migration guide for team
- Document rollback procedures
- Include troubleshooting section
- Output: documentation/migration-guide.md

## Implementation Guidance

### Testing Approach
- Each implementation step group should include 2-8 focused tests maximum
- Tests should cover:
  - Migration steps execute successfully
  - Rollback procedures work correctly
  - Data integrity maintained (for data migrations)
  - Backward compatibility preserved (if applicable)
- Test verification runs only newly written tests, not entire suite
- Additional testing (if needed) adds maximum 10 strategic tests
- Final verification runs full test suite

### Standards Compliance
This implementation must follow standards from:
- `.ai-sdlc/docs/standards/global/` - Language-agnostic standards (if exists)
- Existing orchestrator patterns:
  - `skills/feature-orchestrator/SKILL.md` - Overall structure
  - `skills/enhancement-orchestrator/SKILL.md` - Analysis and gap identification patterns
  - `skills/bug-fix-orchestrator/SKILL.md` - Simpler workflow patterns
- Command patterns:
  - `commands/feature/new.md` - Command structure
  - `commands/feature/resume.md` - Resume functionality

### Orchestrator Structure Pattern
Follow this structure (from feature-orchestrator):
1. **When to Use This Skill** section
2. **Core Principles** section (6 principles)
3. **Execution Modes** (Interactive vs YOLO)
4. **Workflow Phases** (detailed phase descriptions)
5. **Orchestrator Workflow Execution** (initialization, phase execution loop, auto-fix strategies)
6. **State Management** (state file format, operations)
7. **Integration Points** (reusing skills/agents)
8. **Error Handling Philosophy**
9. **Important Guidelines**
10. **Example Workflows**
11. **Validation Checklist**
12. **Success Criteria**

### Auto-Recovery Strategy
Implement auto-recovery for common migration failures:
- Phase 0 (Analysis): Retry with expanded search if files not found (max 2 attempts)
- Phase 1 (Target Planning): Re-prompt user if target unclear (max 2 attempts)
- Phase 2 (Specification): Regenerate spec if verification fails (max 2 attempts)
- Phase 3 (Planning): Regenerate plan if incomplete (max 2 attempts)
- Phase 4 (Execution): Fix common errors (syntax, imports, tests) (max 5 overall retries)
- Phase 5 (Verification): Re-run tests after fixes (max 2 attempts)
- Phase 6 (Docs): Generate text-only if screenshots fail (max 1 attempt)

## Out of Scope
- **Performance benchmarking tools**: Users handle performance comparison manually
- **Cloud-specific migration features**: No AWS/Azure/GCP-specific migrations in v1
- **Automated database migration script generation**: Use existing database migration tools (Flyway, Liquibase, Prisma Migrate)
- **Real-time data synchronization engines**: Document dual-run approach, but users implement sync mechanism
- **Migration cost estimation tools**: No cost analysis or ROI calculation
- **Automated testing tool generation**: Use existing test frameworks, don't generate custom test suites
- **Migration metrics dashboard**: No visual analytics or progress tracking UI
- **Automatic code conversion**: Provide guidance but no AI-powered automatic code transformation

## Success Criteria
- **Orchestrator Functional**: `/ai-sdlc:migration:new` creates migration task and runs 6-7 phase workflow
- **Commands Work**: Both `migration:new` and `migration:resume` follow existing orchestrator command patterns
- **Type Detection**: System correctly detects code/data/architecture migrations from description keywords
- **Strategy Support**: All three migration strategies (incremental, rollback, dual-run) documented and supported in workflow
- **Integration Complete**: task-classifier routes migration tasks to migration-orchestrator
- **Task Structure**: Migration tasks created in `.ai-sdlc/tasks/migrations/` with correct folder structure
- **Reuse Successful**: specification-creator, implementation-planner, implementer, implementation-verifier reused without modification
- **State Management**: orchestrator-state.yml tracks migration-specific fields (type, current/target system, strategy)
- **Documentation Updated**: CLAUDE.md reflects migration task support with orchestrator details
- **Tests Pass**: 2-8 tests per implementation step group, all passing
- **Standards Compliant**: Follows patterns from feature-orchestrator and enhancement-orchestrator

## Next Steps
After specification approval, use the **implementation-planner** skill to create implementation-plan.md with detailed implementation steps, task groups, and acceptance criteria for implementing the migration-orchestrator.
