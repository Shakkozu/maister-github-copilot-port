# Research Workflow

Guide to conducting systematic research for understanding codebases, exploring best practices, and gathering requirements.

## Overview

Research workflow conducts comprehensive, structured research from question definition through findings documentation. Adapts methodology based on research type and produces reusable research artifacts.

**When to use:**
- Understanding how existing code works ("How does authentication work in this codebase?")
- Exploring best practices ("What's the best approach for implementing real-time notifications?")
- Requirements gathering ("What features do competitors offer?")
- Pre-development investigation

## Quick Start

```bash
/ai-sdlc:research:new "How does the payment processing system work?"
```

## Workflow Phases (5 Phases)

### Phase 1: Research Planning
- Analyze research question
- Classify research type:
  - **Technical**: Codebase exploration, architecture understanding
  - **Requirements**: User needs, competitive analysis
  - **Literature**: Best practices, technology comparison
  - **Mixed**: Combination of above

- Determine methodology
- Identify data sources (codebase, docs, web, config files)
- Create research plan with phases

### Phase 2: Information Gathering
- Execute systematic data collection across multiple sources:
  - **Codebase**: Grep, file reading, pattern analysis
  - **Documentation**: README, wikis, internal docs
  - **Configuration**: Config files, environment variables
  - **External**: Web research, API documentation

- Maintain source citations for all findings
- Organize findings with evidence
- Cross-reference related information

### Phase 3: Analysis & Synthesis
- Cross-reference findings from multiple sources
- Identify patterns and relationships
- Apply analytical frameworks
- Generate insights from raw data
- Create structured synthesis

### Phase 4: Documentation & Reporting
- Generate research report with:
  - Executive summary
  - Detailed findings
  - Source citations
  - Recommendations
  - Next steps

- Create knowledge base entries (optional)
- Generate specifications (if transitioning to implementation)

### Phase 5: Verification & Integration (Optional)
- Validate findings accuracy
- Update project documentation
- Integrate insights into `.ai-sdlc/docs/`

## Research Types

### Technical Research
**Example**: "How does the caching layer work?"
**Sources**: Codebase, config files, internal docs
**Output**: Architecture diagram, code flow analysis

### Requirements Research
**Example**: "What features do users need for mobile app?"
**Sources**: User feedback, competitor analysis, interviews
**Output**: Feature requirements, user stories

### Literature Research
**Example**: "Best practices for microservices authentication"
**Sources**: Web articles, documentation, academic papers
**Output**: Best practices summary, technology comparison

### Mixed Research
**Example**: "How should we implement real-time notifications?"
**Sources**: Codebase (current impl) + Web (best practices) + Docs (requirements)
**Output**: Comprehensive recommendation with implementation plan

## Execution Modes

### Direct (Standalone)
```bash
/ai-sdlc:research:new "Research question"
```
Creates task in `.ai-sdlc/tasks/research/`

### Embedded (Phase 0 in Other Workflows)
Research can be embedded as Phase 0 in other workflows when deep exploration needed before implementation.

## Research Output

```
.ai-sdlc/tasks/research/YYYY-MM-DD-research-topic/
├── planning/
│   ├── research-plan.md
│   └── sources.md
├── analysis/
│   ├── findings/
│   │   ├── codebase-findings.md
│   │   ├── documentation-findings.md
│   │   └── web-findings.md
│   ├── synthesis.md
│   └── research-report.md
└── documentation/
    └── knowledge-base.md (optional)
```

**research-report.md example:**
```markdown
# Research Report: Payment Processing System

## Executive Summary
The payment processing system uses Stripe API with custom retry logic and webhook handling...

## Research Question
How does the current payment processing system work?

## Methodology
- Codebase analysis (grep, file reading)
- Configuration review
- Documentation review

## Findings

### Architecture
[Detailed architecture with evidence]

Source: `src/payment/processor.ts:45-120`

### Integration Points
[Integration details with evidence]

Source: `config/stripe.yml`, `src/webhooks/stripe.ts`

### Error Handling
[Error handling patterns with evidence]

Source: Multiple files (see citations)

## Recommendations
1. Add retry exponential backoff
2. Improve webhook validation
3. Add monitoring for failed payments

## Next Steps
1. Implement recommendations
2. Update documentation
3. Add additional tests
```

## Best Practices

1. **Define Clear Research Question**: Specific, focused questions yield better results
2. **Multiple Sources**: Don't rely on single source - cross-reference
3. **Cite Evidence**: Every finding needs source citation
4. **Organize Findings**: Structure data for easy consumption
5. **Actionable Insights**: Research should lead to decisions/actions

## Common Research Questions

- "How does [feature] work in the codebase?"
- "What are best practices for [technology]?"
- "What features do competitors offer for [use case]?"
- "How should we implement [requirement]?"
- "What's the current state of [system/module]?"

## Related Resources

- [Command Reference](../../commands/research/new.md)
- [Skill Documentation](../../skills/research-orchestrator/SKILL.md)
- [Research Planner Agent](../../agents/research-planner.md)
- [Information Gatherer Agent](../../agents/information-gatherer.md)
- [Research Synthesizer Agent](../../agents/research-synthesizer.md)

**Next Steps**: `/ai-sdlc:research:new "[your research question]"`
