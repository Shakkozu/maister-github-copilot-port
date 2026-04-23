---
name: maister-init
description: Initialize maister framework in a project. Analyzes codebase, generates documentation, and sets up standards. Run when starting a new project with maister.
---

# Maister Init Skill

Initialize the maister framework by analyzing the project and creating foundational documentation.

## What This Does

1. **Analyzes the codebase** to understand tech stack, architecture, conventions
2. **Creates documentation structure** in `.maister/docs/`
3. **Discovers coding standards** from config files and code patterns
4. **Generates project documentation** from templates

## Prerequisites

- Working directory should be the project root
- Project should have some code files

## Execution Steps

### Step 1: Analyze Project

Detect project characteristics:

1. **Tech Stack Detection**
   - JavaScript/TypeScript: package.json
   - Python: requirements.txt, setup.py, pyproject.toml
   - Rust: Cargo.toml
   - Go: go.mod
   - Java: pom.xml, build.gradle
   - .NET: *.csproj

2. **Framework Detection**
   - React/Vue/Angular for frontend
   - Express/Django/FastAPI/Flask/Rails for backend
   - Next.js, Nuxt, etc.

3. **Architecture Pattern**
   - Monolith vs microservices
   - MVC vs layered architecture
   - API style (REST, GraphQL, gRPC)

### Step 2: Create Directory Structure

```
.maister/
├── docs/
│   ├── INDEX.md
│   ├── project/
│   │   ├── vision.md
│   │   ├── roadmap.md
│   │   ├── tech-stack.md
│   │   └── architecture.md (optional)
│   └── standards/
│       ├── global/
│       │   ├── coding-style.md
│       │   ├── conventions.md
│       │   ├── error-handling.md
│       │   └── commenting.md
│       ├── frontend/ (if applicable)
│       ├── backend/ (if applicable)
│       └── testing/ (if applicable)
└── tasks/
    ├── development/
    ├── performance/
    ├── migrations/
    ├── research/
    └── product-design/
```

### Step 3: Generate Documentation

**INDEX.md** - Master index:
```markdown
# Project Documentation

## Project Overview
[From tech stack analysis]

## Documentation
- [Project docs links]
- [Standards docs links]

## Standards Quick Reference
[Key standards summarized]

## Active Tasks
[Link to tasks directory]
```

**tech-stack.md**:
```markdown
# Technology Stack

## Frontend
- Framework: [detected]
- UI Library: [detected]
- State Management: [detected]

## Backend
- Language: [detected]
- Framework: [detected]
- Database: [detected]

## Build & Tooling
- Package Manager: [detected]
- Build Tool: [detected]
- Linting: [detected]

## Notes
[Observations about the stack]
```

**coding-style.md** - Auto-populated from:
- ESLint/Prettier config
- .editorconfig
- PEP8/pycodestyle config
- Rustfmt config
- Editor config patterns

### Step 4: Copy Standards from Another Project (Optional)

If `--standards-from=PATH` is provided:
1. Read `.maister/docs/standards/` from the source path
2. Copy to current project's `.maister/docs/standards/`
3. Merge with auto-detected standards

## Output

When complete:
```
✅ Maister initialized

Directory: .maister/
Documentation: .maister/docs/
Standards: .maister/docs/standards/
Tasks: .maister/tasks/

Ready to use:
  gh copilot "Use maister-development to [task]"
```

## Usage

```bash
# Basic initialization
gh copilot "Initialize maister framework"

# Copy standards from existing project
gh copilot "Initialize maister with standards from ~/projects/api"
```

## Differences from Claude Code Version

| Feature | Claude Code | Copilot CLI |
|---------|------------|-------------|
| Progress display | Rich console output | Plain text |
| Parallel analysis | Task tool subagents | Sequential reads |
| Project docs | Extensive templates | Simplified templates |