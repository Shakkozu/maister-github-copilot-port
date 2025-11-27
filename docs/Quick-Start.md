# Quick Start Guide

Get up and running with AI SDLC in 5-10 minutes. This guide walks you through installation, initialization, and creating your first task.

## Prerequisites

Before starting, ensure you have:

- **Claude Code** installed and configured
- **A project** (new or existing) where you want to use AI SDLC workflows
- **Git repository** (recommended but not required)
- **Basic familiarity** with your project's tech stack

## Step 1: Install the Plugin

The AI SDLC plugin is installed through Claude Code's plugin system:

1. Navigate to your project directory
2. The plugin should be available in your Claude Code environment
3. Verify installation by typing `/init-sdlc` (don't run it yet)

If you see the command autocomplete, the plugin is installed correctly.

## Step 2: Initialize the Framework

Run the initialization command to set up AI SDLC in your project:

```bash
/init-sdlc
```

**What happens:**

1. **Codebase Analysis**: The plugin analyzes your project to detect:
   - Project type (new/existing/legacy)
   - Tech stack (languages, frameworks, tools)
   - Architecture patterns
   - Existing conventions

2. **Interactive Setup**: You'll be prompted to select:
   - Which project documentation to generate (vision, roadmap, tech-stack, architecture)
   - Which technical standards to initialize (frontend, backend, testing, global)

3. **Framework Creation**: Creates the `.ai-sdlc/` directory structure:

```
.ai-sdlc/
├── docs/
│   ├── INDEX.md              # Master index (read this first!)
│   ├── project/
│   │   ├── vision.md         # Project goals and vision
│   │   ├── roadmap.md        # Development roadmap
│   │   ├── tech-stack.md     # Technology choices
│   │   └── architecture.md   # System architecture (optional)
│   └── standards/
│       ├── global/           # Language-agnostic standards
│       ├── frontend/         # Frontend-specific standards
│       ├── backend/          # Backend-specific standards
│       └── testing/          # Testing standards
└── tasks/                    # Task folders (created as you work)
    ├── new-features/
    ├── bug-fixes/
    ├── enhancements/
    ├── refactoring/
    ├── performance/
    ├── security/
    ├── migrations/
    └── documentation/
```

**Tip**: The plugin auto-detects your tech stack and creates relevant documentation. Review `.ai-sdlc/docs/INDEX.md` after initialization—it's your roadmap to all documentation and standards.

## Step 3: Create Your First Task

Now let's create your first task using the `/work` command, which automatically classifies and routes to the appropriate workflow.

### Option A: Using /work (Recommended for Beginners)

The `/work` command analyzes your description and suggests the best workflow:

```bash
/work "Add user profile page with avatar upload"
```

**What happens:**

1. **Auto-Classification**: Plugin analyzes the description
2. **Codebase Context**: Checks if similar features exist (enhancement vs new feature)
3. **Workflow Proposal**: Shows proposed task type and workflow
4. **Confirmation**: Asks you to confirm before proceeding

**Example output:**
```
📋 Task Classification
─────────────────────
Description: "Add user profile page with avatar upload"
Proposed Type: new-feature
Confidence: 95%
Workflow: feature-orchestrator (6-7 phases)

Proceed with this workflow? [Yes/No]
```

### Option B: Using Specific Workflow Commands

If you know the task type, use a specific workflow command:

```bash
# New feature
/ai-sdlc:feature:new "Add user profile page with avatar upload"

# Bug fix
/ai-sdlc:bug-fix:new "Login timeout after 5 minutes"

# Enhancement
/ai-sdlc:enhancement:new "Add sorting to user table"
```

## Step 4: Follow the Guided Workflow

Once you start a workflow, the plugin guides you through each phase:

### Phase 1: Specification

**What you'll do:**
- Answer questions about the feature
- Provide requirements and acceptance criteria
- Share any design mockups or references

**Output:**
- `.ai-sdlc/tasks/new-features/2025-11-17-user-profile-page/implementation/spec.md`
- `analysis/requirements.md`

**Example questions:**
```
Q: Who are the target users for this feature?
Q: What should happen when a user uploads an avatar?
Q: Are there file size or format restrictions?
```

After specification, you'll be prompted to review and approve before continuing.

### Phase 2: Implementation Planning

**What happens:**
- Plugin reads the spec
- Breaks work into task groups (database, API, frontend, testing)
- Creates detailed implementation steps
- Defines acceptance criteria

**Output:**
- `implementation/implementation-plan.md` with:
  - Task groups by specialty
  - Implementation steps (specific, testable actions)
  - Dependencies between groups
  - Test requirements (2-8 tests per group)

**Example plan:**
```markdown
## Task Group 1: Database Schema
**Steps:**
1.1 Create users.avatar_url column migration
1.2 Add file storage configuration
1.3 Test: Verify column exists and accepts URLs

## Task Group 2: API Endpoints
**Steps:**
2.1 Create POST /api/users/avatar upload endpoint
2.2 Implement file validation (size, format)
2.3 Test: Upload valid/invalid files
...
```

### Phase 3: Implementation

**What happens:**
- Plugin executes the implementation plan
- Follows test-driven approach (tests → code → verify)
- Checks `.ai-sdlc/docs/INDEX.md` for standards continuously
- Logs all activities in `work-log.md`

**What you'll see:**
```
✓ Task Group 1: Database Schema
  ✓ 1.1 Create users.avatar_url column migration
  ✓ 1.2 Add file storage configuration
  ✓ 1.3 Test: Verify column exists (3 tests passing)

→ Task Group 2: API Endpoints
  → 2.1 Create POST /api/users/avatar upload endpoint
```

### Phase 4: Verification

**What happens:**
- Verifies implementation plan completion
- Runs **full project test suite** (entire project, not just feature tests)
- Checks standards compliance
- Validates documentation completeness
- Generates comprehensive verification report

**Output:**
- `verification/implementation-verification.md` with:
  - Overall status (✅ Passed / ⚠️ Passed with Issues / ❌ Failed)
  - Test results (95-100% passing required)
  - Standards compliance assessment
  - Recommendations

**Example report:**
```markdown
# Implementation Verification Report

## Overall Status: ✅ PASSED

## Summary
- Implementation: 100% complete (all 12 steps)
- Tests: 287/287 passing (100%)
- Standards: Compliant (all 5 standards applied)
- Documentation: Complete

## Recommendations
- Consider adding error boundary for file uploads
- Document file size limits in user documentation
```

## Step 5: Review and Understand the Output

After the workflow completes, review the generated files:

### Task Directory Structure

```
.ai-sdlc/tasks/new-features/2025-11-17-user-profile-page/
├── metadata.yml                      # Task tracking
├── analysis/
│   ├── requirements.md              # Gathered requirements
│   └── visuals/                     # Design mockups (if provided)
├── implementation/
│   ├── spec.md                      # WHAT to build
│   ├── implementation-plan.md       # HOW to build it
│   └── work-log.md                  # Activity log
└── verification/
    └── spec-verification.md         # Verification results
```

### Key Files to Review

1. **spec.md** - Complete specification of what was built
2. **implementation-plan.md** - All implementation steps (marked complete)
3. **work-log.md** - Chronological log of all activities
4. **verification report** - Test results and compliance check

### Understanding Task Status

Check `metadata.yml` for task status:

```yaml
status: completed
phase: verification
created_at: 2025-11-17T10:30:00Z
updated_at: 2025-11-17T11:45:00Z
priority: medium
tags: [user-management, file-upload, frontend]
```

## Step 6: Next Steps

### If Verification Passed ✅

1. **Review the code changes** - Check what was implemented
2. **Run tests locally** - Verify everything works
3. **Create a commit** - Commit the changes to git
4. **Create a PR** - Submit for team review

### If Verification Had Issues ⚠️

1. **Review the verification report** - Understand what needs fixing
2. **Address failing tests** - Fix any test failures
3. **Apply missing standards** - Add any missing standards compliance
4. **Re-run verification** - Use the implementer skill to complete missing items

### If Verification Failed ❌

1. **Read the verification report** - Understand critical issues
2. **Fix critical issues** - Address blockers first
3. **Resume the workflow** - Use `/ai-sdlc:feature:resume [task-path]`

## Common Workflows to Try Next

Now that you've completed your first task, try other workflows:

### Fix a Bug

```bash
/ai-sdlc:bug-fix:new "Login button doesn't work on mobile"
```

**Phases**: Bug Analysis → TDD Fix Implementation → Verification → Documentation

**Key difference**: Mandatory Red→Green TDD discipline (test must fail before fix, pass after)

### Enhance an Existing Feature

```bash
/ai-sdlc:enhancement:new "Add pagination to user list"
```

**Phases**: Existing Feature Analysis → Gap Analysis → Specification → Planning → Implementation → Compatibility Verification

**Key difference**: Analyzes existing feature first, ensures backward compatibility

### Optimize Performance

```bash
/ai-sdlc:performance:new "Dashboard loads too slowly"
```

**Phases**: Baseline Profiling → Bottleneck Analysis → Implementation with Benchmarking → Performance Verification → Load Testing

**Key difference**: Measures before/after metrics, proves every optimization with benchmarks

## Understanding Execution Modes

Workflows support two execution modes:

### Interactive Mode (Default)

Pauses between phases for your review:

```bash
/ai-sdlc:feature:new "Add user profile page"
```

**Best for**: Learning, complex tasks, when you want control

### YOLO Mode (Continuous)

Runs all phases without pausing:

```bash
/ai-sdlc:feature:new "Add user profile page" --yolo
```

**Best for**: Simple tasks, experienced users, automation

## Pause and Resume

All workflows support pause/resume:

### To Pause

Simply stop responding to the workflow (close Claude Code, take a break, etc.)

### To Resume

```bash
/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-11-17-user-profile-page
```

The plugin reads the saved state and continues from where it left off.

## Tips for Success

### 1. Read INDEX.md First

Always check `.ai-sdlc/docs/INDEX.md` before starting work—it shows all available documentation and standards.

### 2. Be Specific in Descriptions

**Good**: "Add user profile page with avatar upload, bio field, and social links"
**Better**: "Add user profile page with: avatar upload (max 2MB, JPG/PNG), bio field (500 char max), Twitter/LinkedIn links"

### 3. Provide Visual References

If you have mockups, wireframes, or design references, share them during specification phase.

### 4. Trust the Process

The plugin asks questions to ensure quality—take time to answer thoroughly.

### 5. Review Verification Reports

Always read verification reports before committing—they catch issues early.

## Getting Help

If you encounter issues:

1. **Check Troubleshooting** - See [Troubleshooting.md](Troubleshooting.md) for common problems
2. **Review the Architecture** - Understand how components work in [Architecture.md](Architecture.md)
3. **Read Workflow Guides** - Detailed guides in [docs/guides/](guides/)
4. **Check the FAQ** - Common questions answered in [Troubleshooting.md](Troubleshooting.md)

## What's Next?

- **[Workflow Overview](guides/workflow-overview.md)** - Complete guide to all workflows and phases
- **[Understand the Architecture](Architecture.md)** - Learn how skills, commands, and agents work together
- **[Explore All Workflows](../README.md#core-workflows)** - Try different task types
- **[Learn About Standards](concepts/standards-discovery.md)** - How continuous standards discovery works
- **[Try an Initiative](guides/initiatives.md)** - Coordinate multiple related tasks

---

**You're ready to start using AI SDLC workflows!** Try creating a task in your project and experience structured, test-driven development with automated verification.
