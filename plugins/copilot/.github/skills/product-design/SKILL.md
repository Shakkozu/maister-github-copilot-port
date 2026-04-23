---
name: maister-product-design
description: Design features and products before building. Use for interactive product/feature design with user research and prototyping.
---

# Maister Product Design Skill

Interactive product and feature design workflow.

## When to Use

- New feature design
- Product redesign
- UX improvements
- Wireframing
- User research

## Workflow Phases

### Phase 1: Understand

1. Define design question
2. Identify users and personas
3. Map current workflows
4. Research best practices

### Phase 2: Explore

1. Generate multiple design directions
2. Create user journey maps
3. Sketch wireframes (text-based)
4. Identify patterns to reuse

### Phase 3: Define

1. Narrow to 1-2 directions
2. Create detailed designs
3. Document rationale
4. Define acceptance criteria

### Phase 4: Prototype

1. Create functional prototype (if applicable)
2. Test with users (if available)
3. Refine based on feedback

## Output Structure

```
.maister/tasks/product-design/YYYY-MM-DD-design-name/
├── orchestrator-state.yml
├── analysis/
│   ├── user-research.md
│   ├── competitor-analysis.md
│   └── workflow-maps.md
├── design/
│   ├── directions.md
│   ├── wireframes.md
│   └── decisions.md
└── outputs/
    └── product-brief.md
```

## Usage

```bash
gh copilot "Design the checkout flow for the e-commerce site"

# Continue to development
cd .maister/tasks/product-design/2026-04-23-checkout
gh copilot "Implement the checkout design"
```