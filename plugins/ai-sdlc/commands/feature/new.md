---
name: feature:new
description: Start a new feature development workflow with guided orchestration through all phases
---

# New Feature Development Workflow

Start comprehensive feature development from specification through implementation and verification.

## Usage

```bash
/ai-sdlc:feature:new [description] [--yolo] [--from=PHASE] [--e2e] [--user-docs]
```

### Arguments

- **description** (optional): Brief description of the feature
  - Example: "Add user authentication with email/password"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `spec`, `plan`, `implement`, `verify`
  - Default: `spec`
- `--e2e`: Auto-enable E2E testing (don't prompt)
- `--user-docs`: Auto-enable user documentation generation (don't prompt)

## Examples

```bash
# Interactive mode (default)
/ai-sdlc:feature:new "Add shopping cart functionality"

# YOLO mode (fast execution)
/ai-sdlc:feature:new "Add dark mode toggle" --yolo

# With E2E and docs pre-enabled
/ai-sdlc:feature:new "Build user dashboard" --e2e --user-docs

# Resume from specific phase
/ai-sdlc:feature:new --from=implement
```

## What This Does

**Invoke the feature-orchestrator skill** which guides through 6-7 phases:

**Phase 1: Specification**
- Gather requirements via structured questions
- Research codebase for existing patterns
- Create comprehensive spec.md
- Verify spec quality

**Phase 2: Implementation Planning**
- Break spec into task groups by specialty
- Create implementation-plan.md with dependencies
- Test-driven approach (2-8 tests per group)

**Phase 3: Implementation**
- Execute plan with continuous standards discovery
- Run only affected tests after each group
- Adaptive complexity based on plan size

**Phase 4: Verification**
- Run full test suite
- Check standards compliance
- Create verification report

**Phase 5: E2E Testing** (optional)
- Playwright browser automation
- Test user workflows end-to-end

**Phase 6: User Documentation** (optional)
- Generate non-technical guides
- Include screenshots via Playwright

**Phase 7: Finalization**
- Create summary and commit guidance

## Outputs

Task directory: `.ai-sdlc/tasks/new-features/YYYY-MM-DD-name/`

- `implementation/spec.md` - Feature specification
- `implementation/implementation-plan.md` - Task breakdown
- `implementation/work-log.md` - Activity log
- `verification/implementation-verification.md` - Quality report
- `documentation/` - User docs (if enabled)

## Execution Modes

**Interactive** (default): Pauses after each phase. Always prompts for optional phases.

**YOLO** (`--yolo`): Runs continuously. Auto-decides on optional phases.

```
Example YOLO output:
[1/6] Specification... done (15m)
[2/6] Planning... done (10m)
[3/6] Implementation... done (120m, 2 auto-fixes)
[4/6] Verification... done (45m)
[5/6] E2E Testing... skipped (non-UI feature)
[6/6] User Docs... skipped (internal feature)

Feature Complete!
```

## Auto-Recovery

The orchestrator handles common failures:
- **Specification**: Re-generates if verification fails (max 2 attempts)
- **Planning**: Regenerates if incomplete (max 2 attempts)
- **Implementation**: Fixes syntax errors, imports, tests (max 5 attempts)
- **Verification**: Fixes failing tests (max 2 attempts)
- **E2E Testing**: Fixes UI issues (max 2 attempts)

## Prerequisites

- `.ai-sdlc/docs/` structure initialized (use `/init-sdlc` first)
- Git repository (for commits)
- For E2E: `playwright-mcp` server configured, app running
- For User Docs: `playwright-mcp` server configured, app running

## Resume

If interrupted:
```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-user-auth
```

---

**Invoke**: feature-orchestrator skill
