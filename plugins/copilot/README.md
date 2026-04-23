# Maister for GitHub Copilot CLI

Structured, standards-aware development workflows for GitHub Copilot CLI.

## Overview

This is a port of the [maister](https://github.com/SkillPanel/maister) plugin from Claude Code to GitHub Copilot CLI. It provides:

- **Development workflows** for features, bug fixes, and enhancements
- **Standards-aware** development with auto-discovered project conventions
- **State management** for pause/resume workflows
- **Multiple workflow types**: development, research, performance, migration, product design

## Compatibility Notes

| Feature | Claude Code | Copilot CLI | Impact |
|---------|------------|------------|--------|
| Interactive prompts | AskUserQuestion | Plain text | Less interactive |
| Subagent delegation | Task tool (nested) | Sequential | Simpler flow |
| State management | Built-in | YAML file | Manual resume |
| Slash commands | `/maister:xxx` | Skill invoke | Different syntax |

## Installation

### Option 1: Local Installation

```bash
# Clone or copy this directory to your project
cp -r plugins/copilot/.github /your-project/

# Or create a symlink
ln -s /path/to/maister/plugins/copilot/.github /your-project/.github
```

### Option 2: GitHub CLI Installation

```bash
# Add skill from repository (when published)
gh skill add owner/maister-copilot
```

### Option 3: Plugin Installation

```bash
# Copy plugin to copilot plugins directory
cp -r plugins/copilot ~/.copilot/plugins/maister
```

### Post-Installation

Reload skills:
```bash
gh copilot "reload skills"
# or
/skills reload
```

## Usage

### Basic Commands

```bash
# Initialize maister in a project
gh copilot "Initialize maister framework"

# Start development workflow
gh copilot "Use maister-development to add user login"

# Quick bug fix with TDD
gh copilot "Fix the login timeout bug"

# Research a topic
gh copilot "Research OAuth implementation options"

# Discover project standards
gh copilot "Discover coding standards"
```

### Workflow Invocation

Unlike Claude Code's slash commands (`/maister:development`), Copilot CLI uses skill invocation:

```bash
# Explicit skill use
gh copilot "Use the maister-development skill to add user authentication"

# With TDD
gh copilot "Use maister-development with TDD to fix the session bug"

# Resume workflow
cd .maister/tasks/development/2026-04-23-feature
gh copilot "Continue maister-development from current state"
```

### Skill List

| Skill | Purpose | Invocation |
|-------|---------|------------|
| `maister-development` | Full development workflow | `"Use maister-development to [task]"` |
| `maister-init` | Initialize framework | `"Initialize maister framework"` |
| `maister-research` | Research topics | `"Research [topic]"` |
| `maister-performance` | Performance optimization | `"Optimize [component]"` |
| `maister-migration` | Technology migration | `"Migrate from X to Y"` |
| `maister-product-design` | Feature design | `"Design [feature]"` |
| `maister-quick-bugfix` | Quick TDD bug fix | `"TDD fix for [bug]"` |
| `maister-standards-discover` | Discover standards | `"Discover coding standards"` |

## Task Directory Structure

All workflow artifacts are saved in `.maister/tasks/`:

```
.maister/
├── docs/
│   ├── INDEX.md
│   ├── project/
│   │   ├── vision.md
│   │   ├── roadmap.md
│   │   ├── tech-stack.md
│   │   └── architecture.md
│   └── standards/
│       ├── global/
│       ├── frontend/
│       └── backend/
└── tasks/
    ├── development/
    │   └── YYYY-MM-DD-task-name/
    ├── research/
    ├── performance/
    ├── migrations/
    └── product-design/
```

## State Management

Unlike Claude Code's automatic state management, Copilot CLI requires manual state handling:

### Resume Workflow

```bash
# 1. Navigate to task directory
cd .maister/tasks/development/2026-04-23-feature

# 2. Read orchestrator-state.yml to find current phase
cat orchestrator-state.yml

# 3. Continue from that phase
gh copilot "Continue maister-development from phase 5"
```

### State File Format

```yaml
version: "2.1.5"
task:
  description: "Feature description"
  status: "in_progress"
phase:
  current: 5
  completed: [1, 2, 3, 4]
task_context:
  risk_level: "medium"
  task_characteristics:
    ui_heavy: true
    creates_new_entities: true
```

## Configuration

### Custom Standards

After init, customize standards in `.maister/docs/standards/`:

```bash
# Add project-specific standards
echo "## Naming Conventions" >> .maister/docs/standards/global/coding-style.md
echo "- Components: PascalCase" >> .maister/docs/standards/global/coding-style.md
```

### Copy Standards from Another Project

```bash
# Copy existing standards
cp -r /path/to/project/.maister/docs/standards/* .maister/docs/standards/
```

## Best Practices

1. **Start in project root** - Maister expects to run from project root
2. **Check .maister/docs/INDEX.md** - Contains project documentation
3. **Follow the workflow phases** - Don't skip phases for "simple" tasks
4. **Log work to work-log.md** - Track implementation progress
5. **Use standards** - Reference `.maister/docs/standards/` when implementing

## Troubleshooting

### Skills Not Loading

```bash
# Reload skills
/skills reload

# Check skill list
/skills list
```

### Workflow State Issues

```bash
# Check current state
cat .maister/tasks/development/YYYY-MM-DD-task/orchestrator-state.yml

# Reset to beginning (manual)
# Edit the file and set:
#   phase.current: 1
#   phase.completed: []
```

### MCP Server Issues

Playwright MCP requires npx:
```bash
# Verify npx works
npx @playwright/mcp@latest --help
```

## Comparison Summary

| Aspect | Claude Code | Copilot CLI |
|--------|------------|-------------|
| Commands | `/maister:xxx` | Skill invocation |
| Subagents | Task tool (nested) | Sequential calls |
| Questions | Interactive UI | Plain text prompts |
| State | Automatic | YAML file |
| Resume | `TaskUpdate` | Manual file edit |
| Progress | Rich UI | Plain text |

## Contributing

This is a port of the main maister plugin. For the original Claude Code version, see the [main repository](../maister/).

## License

MIT - Same as main maister plugin