# Maister

> Structured, standards-aware development workflows for Claude Code

Maister brings guided workflows to your Claude Code projects. Describe what you want to build, and the plugin handles the rest — from specification through implementation to verification — while enforcing your project's coding standards at every step.

## What You Get

- **Guided workflows** for features, bug fixes, enhancements, performance, migrations, and research
- **Auto-discovered standards** from your codebase — config files, source patterns, and documentation are analyzed and enforced throughout every workflow
- **Test-driven implementation** with automated planning, incremental verification, and full test suite runs before completion
- **Pause and resume** any workflow — state is preserved across sessions
- **Production readiness checks** including code review, reality assessment, and pragmatic over-engineering detection

## Getting Started

**1. Add the marketplace**

```
/plugin marketplace add SkillPanel/ai-sdlc
```

**2. Install the plugin**

```
/plugin install maister@maister-plugins
```

**3. Initialize your project**

```
/maister:init
```

This scans your codebase and creates `.maister/` with auto-detected coding standards, project documentation, and task folders. It may take a few minutes on larger projects.

**4. Start working**

```
/maister:work "Add user profile page with avatar upload"
```

## How It Works

1. You describe a task in natural language
2. The plugin classifies it (feature, bug, enhancement, etc.) and proposes a workflow
3. You confirm, and it guides you through phases: **requirements → spec → plan → implement → verify**
4. At each phase, it asks for your input and decisions (or pass `--yolo` for continuous execution)
5. You get tested, verified code with a detailed work log

All artifacts are saved in `.maister/tasks/` organized by type and date.

## Supported Workflows

| Type | Command | Use When |
|------|---------|----------|
| **Feature** | `/maister:development-new --type=feature` | Adding new capabilities |
| **Bug Fix** | `/maister:development-new --type=bug` | Fixing defects with TDD Red→Green |
| **Enhancement** | `/maister:development-new --type=enhancement` | Improving existing features |
| **Performance** | `/maister:performance-new` | Optimizing speed or resource usage |
| **Migration** | `/maister:migration-new` | Changing technologies or patterns |
| **Research** | `/maister:research-new` | Investigating questions or gathering requirements |

Or just use `/maister:work "description"` and let the plugin classify automatically.

## Standards-Aware Development

This is the key differentiator. Maister doesn't just run workflows — it learns your project's conventions and enforces them:

- **`/maister:init`** scans config files, source code, and documentation to auto-detect your coding standards
- **Continuous checking** — standards are consulted before specification, during planning, and while coding (not just at the start)
- **`/maister:standards-discover`** refreshes standards from your evolving codebase
- **`/maister:standards-update`** lets you add or refine standards manually

Standards live in `.maister/docs/standards/` and are indexed in `.maister/docs/INDEX.md`.

## Execution Modes

- **Interactive** (default): pauses between phases for your review and input
- **YOLO** (`--yolo` flag): runs continuously through all phases, asking only critical questions

## Learn More

- [Workflow Details](docs/workflows.md) — phases, examples, and task structure for each workflow type
- [Full Command Reference](docs/commands.md) — all workflow, review, utility, and quick commands
