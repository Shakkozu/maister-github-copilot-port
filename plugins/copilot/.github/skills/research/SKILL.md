---
name: maister-research
description: Multi-source research workflow with synthesis and solution brainstorming. Use for investigating technologies, patterns, or requirements.
---

# Maister Research Skill

Investigate topics and synthesize findings into actionable insights.

## When to Use

- Technology evaluation
- Pattern research
- Requirements exploration
- Solution option analysis

## Workflow Phases

### Phase 1: Plan Research

1. Define research question clearly
2. Identify information sources:
   - Web search for latest information
   - Documentation review
   - Codebase analysis (existing patterns)
3. Create research plan

### Phase 2: Gather Information

For each source:
1. Web search for current information
2. Read documentation
3. Analyze codebase for patterns
4. Document findings with citations

### Phase 3: Synthesize

1. Identify patterns across sources
2. Extract key insights
3. Note conflicting information
4. Assess confidence level

### Phase 4: Solution Exploration (Optional)

Generate solution alternatives:
1. Brainstorm 3-5 approaches
2. Document trade-offs
3. Recommend approach with rationale

### Phase 5: High-Level Design (Optional)

For architecture decisions:
1. Create C4 diagrams (text-based)
2. Document decision rationale
3. Create ADR if needed

## Output Structure

```
.maister/tasks/research/YYYY-MM-DD-research-topic/
├── orchestrator-state.yml
├── analysis/
│   ├── sources.md
│   └── synthesis.md
└── outputs/
    ├── research-report.md
    ├── solution-exploration.md (if Phase 4)
    └── high-level-design.md (if Phase 5)
```

## Usage

```bash
# Basic research
gh copilot "Research OAuth implementation options"

# With solution exploration
gh copilot "Research PostgreSQL vs MongoDB with solution design"

# From research to development
cd .maister/tasks/research/2026-04-23-db-comparison
gh copilot "Use maister-development for database implementation"
```

## State File

```yaml
version: "2.1.5"
task:
  type: "research"
  question: "<research-question>"
  confidence_level: "high" | "medium" | "low"
  status: "in_progress"
phase:
  current: <1-5>
  completed: []
outputs:
  report: null
  solutions: null
  design: null
```