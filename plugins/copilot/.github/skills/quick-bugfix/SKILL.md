---
name: maister-quick-bugfix
description: Quick TDD-driven bug fix workflow. Use for simple, reproducible bugs. Escalates to full development workflow if complexity is high.
---

# Maister Quick Bugfix Skill

Fast, test-driven bug fixing with complexity escalation.

## When to Use

- Reproducible bugs
- Clear error messages
- Simple fixes
- Regression bugs

## Workflow (TDD)

### Red: Write Failing Test

1. Understand the bug
2. Write test that reproduces the bug
3. Verify test fails with the bug

### Green: Implement Fix

1. Implement the smallest fix
2. Verify test passes
3. Check edge cases

### Refactor: Improve

1. Ensure code is clean
2. Follow standards
3. Add regression tests

## Complexity Detection

After initial analysis, assess complexity:

| Level | Criteria | Action |
|-------|----------|--------|
| Low | Single file, obvious fix | Quick fix workflow |
| Medium | Multiple files, testing needed | Standard workflow |
| High | Architecture impact, unclear fix | Escalate to full `maister-development` |

## Usage

```bash
# Quick bug fix
gh copilot "Fix the login timeout bug"

# With TDD explicitly
gh copilot "TDD fix for the user avatar upload error"
```

## Output

```
.maister/tasks/development/YYYY-MM-DD-bugfix-name/
├── orchestrator-state.yml
├── implementation/
│   ├── tdd-red-gate.md
│   ├── tdd-green-gate.md
│   └── work-log.md
└── verification/
    └── verification.md
```

## State File

```yaml
version: "2.1.5"
task:
  type: "bug_fix"
  bug_description: "<description>"
  status: "in_progress"
tdd:
  red_gate_passed: false
  green_gate_passed: false
complexity: "low" | "medium" | "high"
escalated: false
```