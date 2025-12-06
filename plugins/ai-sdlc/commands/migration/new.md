---
name: ai-sdlc:migration:new
description: Start a new migration workflow with guided orchestration through all phases
---

# Migration Workflow: New

Start comprehensive migration from current system analysis through execution and verification.

## Usage

```bash
/ai-sdlc:migration:new [description] [--yolo] [--from=PHASE] [--type=TYPE]
```

### Arguments

- **description** (optional): Brief description of the migration
  - Example: "Migrate from React 16 to React 18"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `analysis`, `target`, `spec`, `plan`, `execute`, `verify`, `docs`
  - Default: `analysis`
- `--type=TYPE`: Migration type (auto-detected if omitted)
  - Values: `code`, `data`, `architecture`, `general`

## Examples

```bash
# Interactive mode (default)
/ai-sdlc:migration:new "Migrate from Express to Fastify"

# YOLO mode (fast execution)
/ai-sdlc:migration:new "Upgrade React 16 to 18" --yolo

# With type specified
/ai-sdlc:migration:new "Move to GraphQL" --type=architecture

# Resume from specific phase
/ai-sdlc:migration:new --from=execute
```

## What This Does

**Invoke the migration-orchestrator skill** which guides through 7 phases:

**Phase 0: Current System Analysis**
- Analyze existing implementation and architecture
- Document dependencies and data flows
- Assess migration scope and complexity

**Phase 1: Target System Planning**
- Define migration target (framework/platform/pattern)
- Detect/confirm migration type (code/data/architecture)
- Select strategy (incremental/rollback/dual-run)
- Create gap analysis

**Phase 2: Migration Specification**
- Create comprehensive migration spec
- Document rollback procedures
- Set acceptance criteria

**Phase 3: Implementation Planning**
- Create detailed implementation steps
- Set dependencies between migration phases
- Plan incremental verification

**Phase 4: Migration Execution**
- Execute plan step by step
- Test-driven approach (write tests → migrate → verify)
- Handle breaking changes

**Phase 5: Verification + Compatibility**
- Run full test suite
- Validate migration-specific requirements
- Check backward compatibility

**Phase 6: Documentation** (optional)
- Migration guide for team
- Rollback procedures

## Migration Types

| Type | Keywords | Risk | Focus |
|------|----------|------|-------|
| **Code** | React, Express, upgrade | Medium | API equivalence, breaking changes |
| **Data** | PostgreSQL, MongoDB, schema | High | Data integrity (100% validation) |
| **Architecture** | REST→GraphQL, microservices | High | System-level behavior |
| **General** | Fallback | Variable | Mixed concerns |

## Migration Strategies

- **Incremental**: Migrate piece by piece with checkpoints
- **Rollback Planning**: Document undo procedures before each phase
- **Dual-Run**: Old and new systems in parallel (zero-downtime)

## Outputs

Task directory: `.ai-sdlc/tasks/migrations/YYYY-MM-DD-name/`

- `planning/current-system-analysis.md` - Current state
- `planning/target-system-plan.md` - Target plan
- `implementation/spec.md` - Migration specification
- `implementation/implementation-plan.md` - Task breakdown
- `verification/implementation-verification.md` - Quality report
- `documentation/migration-guide.md` - Team guide (optional)

## Execution Modes

**Interactive** (default): Pauses after each phase. Best for complex/data migrations.

**YOLO** (`--yolo`): Runs continuously. Best for simple framework upgrades.

## Auto-Recovery

The orchestrator handles common failures:
- **Analysis**: Expands search if system files not found (max 2)
- **Planning**: Re-analyzes if target unclear (max 2)
- **Execution**: Fixes syntax errors, API changes (max 5)
- **Verification**: HALTS on data integrity failures (no auto-fix)

## Prerequisites

- `.ai-sdlc/docs/` structure initialized (use `/init-sdlc` first)
- For data migrations: **Full backup required** before starting

## Resume

If interrupted:
```bash
/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-20-express-to-fastify
```

---

**Invoke**: migration-orchestrator skill
