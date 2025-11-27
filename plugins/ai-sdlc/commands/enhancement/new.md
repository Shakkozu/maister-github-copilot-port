---
name: ai-sdlc:enhancement:new
description: Start a new enhancement workflow with complete orchestration through all phases
---

# Enhancement Workflow: New

Start enhancement development from existing feature analysis through implementation to verified code.

## Usage

```bash
/ai-sdlc:enhancement:new [description] [--yolo] [--from=PHASE] [--e2e] [--user-docs]
```

### Arguments

- **description** (optional): Enhancement to implement
  - Example: "Add sorting to user table"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `analysis`, `gap`, `spec`, `plan`, `implement`, `verify`
  - Default: `analysis`
- `--e2e` / `--no-e2e`: Force enable/skip E2E testing
- `--user-docs` / `--no-user-docs`: Force enable/skip user documentation

## Examples

```bash
# Interactive mode (default)
/ai-sdlc:enhancement:new "Add export button to user table"

# YOLO mode (fast execution)
/ai-sdlc:enhancement:new "Add tooltips" --yolo

# With optional phases enabled
/ai-sdlc:enhancement:new "Build dashboard filters" --e2e --user-docs

# Resume from specific phase
/ai-sdlc:enhancement:new --from=implement
```

## What This Does

**Invoke the enhancement-orchestrator skill** which guides through 8-9 phases:

**Phase 0: Existing Feature Analysis** → `existing-feature-analyzer` agent
- Auto-locate and analyze current implementation
- Identify affected components and test coverage

**Phase 1: Gap Analysis** → `gap-analyzer` agent
- Compare current vs desired state
- Classify type: additive, modificative, refactor-based
- User journey impact assessment

**Phase 2: UI Mockup Generation** (optional for UI changes)
- ASCII mockups showing layout integration

**Phase 3: Enhanced Specification**
- Create spec with compatibility requirements

**Phase 4: Implementation Planning**
- Task groups with targeted testing (30-70% of suite)

**Phase 5: Implementation**
- Execute plan with continuous standards discovery

**Phase 6: Verification + Compatibility**
- Full test suite + backward compatibility checks

**Phase 7: E2E Testing** (optional)
**Phase 8: User Documentation** (optional)

## Enhancement Types

| Type | Risk | Description |
|------|------|-------------|
| **Additive** | Low | New functionality alongside existing |
| **Modificative** | Medium-High | Changes existing behavior |
| **Refactor-Based** | Medium-High | Restructures implementation |

## Outputs

Task directory: `.ai-sdlc/tasks/enhancements/YYYY-MM-DD-name/`

- `analysis/existing-feature-analysis.md` - Current implementation
- `analysis/gap-analysis.md` - Current vs desired comparison
- `implementation/spec.md` - Enhanced specification
- `implementation/implementation-plan.md` - Task breakdown
- `verification/implementation-verification.md` - Quality report

## Execution Modes

**Interactive** (default): Pauses after each phase. Prompts for optional phases.

**YOLO** (`--yolo`): Runs continuously. Auto-decides on optional phases (runs E2E if UI changes detected).

## Auto-Recovery

The orchestrator handles common failures:
- **Analysis**: Expands search if feature not found (max 2)
- **Gap Analysis**: Re-analyzes with clarification (max 2)
- **Implementation**: Fixes syntax, imports, tests (max 5)
- **Verification**: Fixes failing tests (max 2)

## Prerequisites

- `.ai-sdlc/docs/` structure initialized (use `/init-sdlc` first)
- For E2E: `playwright-mcp` server configured, app running
- For User Docs: `playwright-mcp` server configured, app running

## Resume

If interrupted:
```bash
/ai-sdlc:enhancement:resume .ai-sdlc/tasks/enhancements/2025-10-27-add-sorting
```

---

**Invoke**: enhancement-orchestrator skill
