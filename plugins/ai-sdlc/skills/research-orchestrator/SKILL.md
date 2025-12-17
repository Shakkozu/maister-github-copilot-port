---
name: research-orchestrator
description: Orchestrates comprehensive research workflows from question definition through findings documentation. Handles technical, requirements, literature, and mixed research types with adaptive methodology, multi-source gathering, pattern synthesis, and evidence-based reporting. Supports standalone research tasks and embedded Phase 0 in other workflows.
---

# Research Orchestrator

Systematic research workflow from question definition to evidence-based documentation.

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Initialize research", "status": "pending", "activeForm": "Initializing research"},
  {"content": "Plan research methodology", "status": "pending", "activeForm": "Planning research methodology"},
  {"content": "Gather information", "status": "pending", "activeForm": "Gathering information"},
  {"content": "Analyze and synthesize", "status": "pending", "activeForm": "Analyzing and synthesizing"},
  {"content": "Generate outputs", "status": "pending", "activeForm": "Generating outputs"},
  {"content": "Verify findings", "status": "pending", "activeForm": "Verifying findings"},
  {"content": "Integrate into project", "status": "pending", "activeForm": "Integrating into project"}
]
```

Note: Phases 5-6 (Verify findings, Integrate into project) are optional based on context.

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Research Orchestrator Started

Task: [research question]
Mode: [Interactive/YOLO]
Directory: [task-path]

Workflow phases:
[Todos list with status]

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Initialize research...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Research Initialization).

---

## When to Use This Skill

Use when:
- Need comprehensive research on a topic
- Exploring codebase patterns or architecture
- Gathering requirements or best practices
- Want systematic evidence-based answers
- Research will feed into development workflows

## Core Principles

1. **Evidence-Based**: Every finding must have source citation
2. **Systematic**: Follow structured methodology for consistent results
3. **Multi-Source**: Gather from codebase, docs, config, external sources
4. **Synthesized**: Cross-reference findings, identify patterns
5. **Actionable**: Produce outputs that enable next steps

---

## Framework Patterns

This orchestrator follows shared patterns. See:

- **Phase Execution**: `../orchestrator-framework/references/phase-execution-pattern.md`
- **State Management**: `../orchestrator-framework/references/state-management.md`
- **Interactive Mode**: `../orchestrator-framework/references/interactive-mode.md`
- **Initialization**: `../orchestrator-framework/references/initialization-pattern.md`

---

## Phase Configuration

| Phase | content | activeForm | Agent/Skill |
|-------|---------|------------|-------------|
| 0 | "Initialize research" | "Initializing research" | orchestrator |
| 1 | "Plan research methodology" | "Planning research methodology" | research-planner |
| 2 | "Gather information" | "Gathering information" | information-gatherer |
| 3 | "Analyze and synthesize" | "Analyzing and synthesizing" | research-synthesizer |
| 4 | "Generate outputs" | "Generating outputs" | orchestrator |
| 5 | "Verify findings" | "Verifying findings" | orchestrator (optional) |
| 6 | "Integrate into project" | "Integrating into project" | orchestrator (optional) |

**Workflow Overview**: 5-7 phases (Phases 5-6 optional based on context)

**CRITICAL TodoWrite Usage**:
1. At workflow start: Create todos for ALL phases using the Phase Configuration table above (all status=pending)
2. Before each phase: Update that phase to status=in_progress
3. After each phase: Update that phase to status=completed

---

## Research Types

| Type | Keywords | Focus | Typical Outputs |
|------|----------|-------|-----------------|
| **Technical** | "how does", "where is", "implementation" | Codebase analysis | Knowledge base, architecture docs |
| **Requirements** | "what are requirements", "user needs" | User/business needs | Specifications, requirements doc |
| **Literature** | "best practices", "industry standards" | External research | Recommendations, comparisons |
| **Mixed** | Multiple keywords, broad questions | Comprehensive investigation | All output types |

---

## Workflow Phases

### Phase 0: Research Initialization

**Execution**: Main orchestrator (direct)

**Process**:

1. **Parse Research Question** - Extract from command or prompt user
2. **Classify Research Type** - Auto-detect from keywords or use `--type` flag
3. **Determine Scope** - What's in scope, what's excluded, constraints
4. **Define Success Criteria** - How we know research is complete
5. **Create Research Brief** - Save to `planning/research-brief.md`

**Outputs**: `metadata.yml`, `orchestrator-state.yml`, `planning/research-brief.md`

**Success**: Research question clear, type classified, scope defined

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 1.

---

### Phase 1: Research Planning

**Delegate to**: `research-planner` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:research-planner"
description: "Plan research methodology"
prompt: |
  You are the research-planner agent. Design research methodology
  and identify data sources.

  Task directory: [task-path]
  Input: planning/research-brief.md

  Please:
  1. Analyze research question and type
  2. Select appropriate methodology
  3. Identify all relevant data sources (codebase, docs, config, external)
  4. Create phased research plan
  5. Define success criteria for each phase

  Save to:
  - planning/research-plan.md (methodology, approach)
  - planning/sources.md (data sources with access paths)

  Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `planning/research-plan.md`, `planning/sources.md`

**Success**: Methodology selected, sources identified (at least one), plan documented

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 2.

---

### Phase 2: Information Gathering

**Delegate to**: `information-gatherer` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:information-gatherer"
description: "Gather information"
prompt: |
  You are the information-gatherer agent. Execute systematic
  information gathering from all identified sources.

  Task directory: [task-path]
  Inputs:
  - planning/research-plan.md
  - planning/sources.md

  Please:
  1. Execute research plan phases systematically
  2. Gather from all sources in sources.md
  3. Maintain strict source citations for EVERY finding
  4. Organize findings by source type (one file per type)
  5. Cross-reference findings and identify gaps

  Save to:
  - analysis/findings/00-summary.md (overview)
  - analysis/findings/codebase-*.md
  - analysis/findings/docs-*.md
  - analysis/findings/config-*.md
  - analysis/findings/external-*.md (if applicable)

  CRITICAL: Every finding MUST include source reference, evidence, and context.

  Use only Read, Grep, Glob, WebFetch, and Bash tools. Do NOT modify code.
```

**Outputs**: `analysis/findings/*.md` (multiple files with source citations)

**Success**: All sources investigated, findings documented with citations

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 3.

---

### Phase 3: Analysis & Synthesis

**Delegate to**: `research-synthesizer` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:research-synthesizer"
description: "Analyze and synthesize"
prompt: |
  You are the research-synthesizer agent. Analyze findings
  and generate comprehensive research report.

  Task directory: [task-path]
  Input: analysis/findings/ (all files)

  Please:
  1. Read all finding files systematically
  2. Cross-reference findings across sources
  3. Identify patterns, themes, relationships
  4. Generate synthesis with pattern analysis
  5. Generate comprehensive research report answering research question
  6. Mark confidence levels (high/medium/low)
  7. Document gaps and uncertainties

  Save to:
  - analysis/synthesis.md (patterns, insights)
  - analysis/research-report.md (comprehensive report)

  CRITICAL: Every insight must trace to findings, every conclusion evidence-based.

  Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `analysis/synthesis.md`, `analysis/research-report.md`

**Success**: Research question answered, patterns identified, confidence documented

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 4.

---

### Phase 4: Generate Outputs

**Execution**: Main orchestrator (direct)

**Conditional Outputs** (based on research type):

| Output | Generate If | Skip If |
|--------|------------|---------|
| **Recommendations** | Decision-oriented research, literature comparing approaches | Purely exploratory |
| **Knowledge Base** | Reusable knowledge, technical patterns/architecture | One-off research |
| **Specifications** | Feeds into dev workflow, embedded Phase 0 | Standalone research |

**Process**:

1. **Determine Output Types** - Based on research type and context
2. **Generate Recommendations** (if applicable) - Prioritized, with rationale and evidence
3. **Generate Knowledge Base** (if applicable) - Overview, components, best practices
4. **Generate Specifications** (if applicable) - Requirements, approach, integration

**Outputs**: `outputs/recommendations.md`, `outputs/knowledge-base.md`, `outputs/specifications.md` (conditional)

**Success**: At least research report exists, conditional outputs match context

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 5.

---

### Phase 5: Verification (Optional)

**Execution**: Main orchestrator (user review or automated checks)

**Enable if**: Mixed research, medium/low confidence, critical gaps identified
**Skip if**: Technical research with high confidence, simple exploratory

**Process**:

**Interactive Mode**:
1. Present research report to user
2. Request review: source credibility, finding accuracy, completeness
3. Document feedback

**YOLO Mode**:
1. Automated checks: citations present, evidence provided, question addressed, gaps documented
2. Create verification report

**Outputs**: `verification/verification-report.md`

**Note**: Verification failures are NOT auto-fixed. Document issues clearly.

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 6.

---

### Phase 6: Integration (Optional)

**Execution**: Main orchestrator (direct)

**Enable if**: Specifications generated, knowledge base created, recommendations affecting decisions
**Skip if**: Exploratory research not for documentation

**Process**:

1. **For Specifications** - Save path, provide to parent orchestrator
2. **For Knowledge Base** - Identify location in `.ai-sdlc/docs/`, ask user where to place
3. **For Recommendations** - Ask user if decisions should be documented
4. **Create Integration Manifest** - Document outputs and recommended locations

**Outputs**: `integration-manifest.md`

**Note**: Integration failures are NOT auto-fixed. Provide manual guidance.

---

## Domain Context (State Extensions)

Research-specific fields in `orchestrator-state.yml`:

```yaml
research_context:
  research_type: "technical" | "requirements" | "literature" | "mixed"
  research_question: "[user's question]"
  scope:
    included: []
    excluded: []
    constraints: []
  methodology: []
  sources: []
  confidence_level: "high" | "medium" | "low"

options:
  verification_enabled: null  # null=auto-detect
  integration_enabled: null
```

---

## Task Structure

```
.ai-sdlc/tasks/research/YYYY-MM-DD-research-name/
├── metadata.yml
├── orchestrator-state.yml
├── planning/
│   ├── research-brief.md
│   ├── research-plan.md
│   └── sources.md
├── analysis/
│   ├── findings/
│   │   ├── 00-summary.md
│   │   ├── codebase-*.md
│   │   ├── docs-*.md
│   │   ├── config-*.md
│   │   └── external-*.md
│   ├── synthesis.md
│   └── research-report.md
├── outputs/
│   ├── recommendations.md
│   ├── knowledge-base.md
│   └── specifications.md
└── verification/
    └── verification-report.md
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| 0 | 1 | Prompt user for clarification if question unclear |
| 1 | 2 | Expand search patterns, use fallback mixed methodology |
| 2 | 3 | Retry with expanded patterns, try alternative sources, continue with available |
| 3 | 2 | Request targeted re-gathering for gaps, synthesize with limitations |
| 4 | 2 | Generate standard outputs based on type, ask user in interactive |
| 5 | 0 | Read-only, report only |
| 6 | 0 | Read-only, provide manual guidance |

---

## Integration with Other Workflows

### As Standalone Research

**Command**: `/ai-sdlc:research:new [research-question]`

**Flow**: Complete 7-phase workflow, save all outputs in task directory

### As Embedded Phase 0

**Invoked by**: development-orchestrator (feature, enhancement), migration-orchestrator

**Integration**:
1. Parent orchestrator invokes research-orchestrator
2. Research executes phases 0-4 (skip optional phases 5-6)
3. Specifications output fed into parent's specification phase
4. Research report saved in parent task's `analysis/research/` directory

**Handoff**:
```yaml
research_outputs:
  specifications: "[path to specifications.md]"
  research_report: "[path to research-report.md]"
  findings_directory: "[path to findings/]"
```

---

## Command Integration

Invoked via:
- `/ai-sdlc:research:new [question] [--yolo] [--type=TYPE]`
- `/ai-sdlc:research:resume [task-path]`

Task directory: `.ai-sdlc/tasks/research/YYYY-MM-DD-task-name/`

---

## Success Criteria

Workflow successful when:

- Research question clearly defined and classified
- Methodology selected and sources identified
- Information gathered from multiple sources with citations
- Findings synthesized with pattern identification
- Research report answers original question
- Appropriate conditional outputs generated
- Confidence levels documented
- Ready for integration or handoff to parent workflow
