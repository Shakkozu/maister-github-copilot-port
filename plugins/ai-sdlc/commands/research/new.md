---
description: Start a new research workflow with guided orchestration through all phases
---

Initiate a comprehensive research workflow to investigate a topic, analyze findings, and generate actionable outputs.

**Usage**: `/ai-sdlc:research:new [research-question] [--yolo] [--type=TYPE] [--verify] [--integrate]`

**Parameters**:
- `research-question`: The research question or objective (required)
- `--yolo`: Run in continuous mode without pausing between phases (optional)
- `--type=TYPE`: Specify research type - technical|requirements|literature|mixed (optional, auto-detects if not specified)
- `--verify`: Enable verification phase (optional, auto-detects based on complexity if not specified)
- `--integrate`: Enable integration phase (optional, auto-detects based on outputs if not specified)

**Examples**:
```
/ai-sdlc:research:new "How does authentication work in this codebase?"
/ai-sdlc:research:new "What are the requirements for the new reporting feature?" --yolo
/ai-sdlc:research:new "Best practices for implementing real-time notifications" --type=literature --verify
```

**What this does**:
1. Creates research task directory in `.ai-sdlc/tasks/research/YYYY-MM-DD-research-name/`
2. Executes 7-phase research workflow:
   - Phase 0: Research Initialization (define scope, classify type)
   - Phase 1: Research Planning (methodology, source identification)
   - Phase 2: Information Gathering (collect from multiple sources)
   - Phase 3: Analysis & Synthesis (identify patterns, generate insights)
   - Phase 4: Generate Outputs (report, recommendations, knowledge base, specs)
   - Phase 5: Verification (optional - validate accuracy and completeness)
   - Phase 6: Integration (optional - integrate into project docs or workflows)
3. Produces comprehensive research outputs with evidence-based findings

**Execution modes**:
- **Interactive** (default): Pauses after each phase for review and approval
- **YOLO** (--yolo flag): Continuous execution without pauses

**Research types**:
- **Technical**: Understanding codebase implementation, architecture, patterns
- **Requirements**: Gathering user needs, business requirements, constraints
- **Literature**: Best practices, industry standards, recommendations
- **Mixed**: Comprehensive investigations requiring multiple perspectives

**Outputs**:
- `analysis/research-report.md` - Comprehensive research findings (always)
- `outputs/recommendations.md` - Actionable recommendations (conditional)
- `outputs/knowledge-base.md` - Reusable documentation (conditional)
- `outputs/specifications.md` - Technical specs for dev workflows (conditional)
- `verification/verification-report.md` - Validation results (if verification enabled)

**When to use**:
- Need to understand how something works in the codebase
- Gathering requirements before starting development
- Researching best practices or industry approaches
- Deep exploration before making architectural decisions
- Feeding research into feature/enhancement workflows

**Invoke**: ai-sdlc:research-orchestrator skill
