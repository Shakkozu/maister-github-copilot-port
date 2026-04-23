---
name: maister-standards-discover
description: Discover coding standards from codebase patterns, config files, and documentation. Use to learn project conventions.
---

# Standards Discover Skill

Automatically discover coding standards from your codebase.

## What This Does

1. Scans config files for established patterns
2. Analyzes code for convention patterns
3. Extracts standards from documentation
4. Creates standardized reference documents

## Discovery Sources

### Config Files

| Type | Files to Scan |
|------|---------------|
| JS/TS | `.eslintrc`, `.prettierrc`, `tsconfig.json` |
| Python | `setup.cfg`, `pyproject.toml`, `.flake8` |
| Rust | `rustfmt.toml`, `clippy.toml` |
| Go | `go.mod` comments, `gofmt` config |
| General | `.editorconfig`, `Makefile` |

### Code Patterns

Extract standards from:
- Naming conventions
- Import ordering
- Error handling patterns
- Comment styles
- Documentation patterns

### Existing Documentation

- README.md conventions
- CONTRIBUTING.md
- Architecture Decision Records

## Discovery Process

### Step 1: Config Analysis

Read all config files and extract:
- Linting rules
- Formatting preferences
- Type checking strictness
- Build conventions

### Step 2: Pattern Mining

Search code for:
- Naming patterns (camelCase, snake_case, PascalCase)
- Error handling approaches
- Logging patterns
- Testing patterns
- Comment styles

### Step 3: Standard Document Creation

Create/update `.maister/docs/standards/` files:

```
standards/
├── global/
│   ├── coding-style.md
│   ├── conventions.md
│   ├── error-handling.md
│   └── commenting.md
├── frontend/
│   └── ...
└── backend/
    └── ...
```

## Usage

```bash
# Discover all standards
gh copilot "Discover coding standards"

# Discover specific scope
gh copilot "Discover frontend standards only"
```

## Output

```
✅ Standards discovered

Discovered:
  - Naming conventions: camelCase for JS, snake_case for Python
  - Error handling: custom exception classes
  - Comments: JSDoc for functions, docstrings for Python

Standards saved to: .maister/docs/standards/
```

## Integration with Development

Standards are automatically loaded by `maister-development` skill from `.maister/docs/standards/`. You can also manually invoke:

```bash
gh copilot "Check standards before implementing feature X"
```