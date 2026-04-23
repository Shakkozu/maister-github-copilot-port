---
name: maister-migration
description: Migrate code or data between technologies or patterns. Use when changing frameworks, databases, or architectural patterns.
---

# Maister Migration Skill

Structured approach to technology and pattern migrations.

## When to Use

- Framework upgrades
- Database migrations
- API redesign
- Pattern refactoring
- Library replacements

## Workflow

### Phase 1: Assess Scope

1. Identify migration scope
2. Map dependencies
3. Assess risk level
4. Plan rollback strategy

### Phase 2: Create Migration Plan

1. Document current state
2. Document target state
3. Create step-by-step plan
4. Identify risks and mitigations

### Phase 3: Implement in Stages

1. Set up dual operation (if needed)
2. Migrate in reversible stages
3. Test at each stage
4. Keep rollback paths

### Phase 4: Verify & Cleanup

1. Full verification
2. Remove old code (if applicable)
3. Update documentation
4. Archive migration artifacts

## Usage

```bash
# Framework migration
gh copilot "Migrate from Express to FastAPI"

# Database migration
gh copilot "Migrate user data to new schema"

# Pattern migration
gh copilot "Migrate from callbacks to async/await"
```

## Output

```
.maister/tasks/migrations/YYYY-MM-DD-migration-name/
├── orchestrator-state.yml
├── analysis/
│   ├── assessment.md
│   └── risk-analysis.md
├── implementation/
│   ├── migration-plan.md
│   └── rollback-plan.md
└── verification/
    └── migration-results.md
```

## State File

```yaml
version: "2.1.5"
task:
  type: "migration"
  from: "<source-tech>"
  to: "<target-tech>"
  status: "in_progress"
migration:
  strategy: "big-bang" | "phased" | "parallel"
  rollback_plan: "<path>"
  verified: false
```