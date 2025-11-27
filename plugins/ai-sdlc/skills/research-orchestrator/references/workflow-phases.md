# Research Orchestrator Workflow Phases Reference

This reference provides execution patterns and phase management strategies for the research orchestrator workflow.

## Overview

The research orchestrator executes a 7-phase workflow with 5 required phases and 2 optional phases. Each phase has clear prerequisites, execution patterns, outputs, and success criteria.

---

## Phase Structure

### Phase Numbering

```
Phase 0: Research Initialization (required)
Phase 1: Research Planning (required)
Phase 2: Information Gathering (required)
Phase 3: Analysis & Synthesis (required)
Phase 4: Generate Outputs (required)
Phase 5: Verification (optional)
Phase 6: Integration (optional)
```

---

## Phase 0: Research Initialization

**Type**: Required
**Execution**: Direct (orchestrator code)
**Prerequisites**: None

**Purpose**: Define research scope and classify research type

**Activities**:
1. Gather research question from user
2. Classify research type (technical/requirements/literature/mixed)
3. Determine scope and boundaries
4. Define success criteria
5. Create task structure and state file

**Outputs**:
- `metadata.yml`
- `orchestrator-state.yml`
- `planning/research-brief.md`

**Success Criteria**:
- Research question clearly stated
- Research type classified
- Scope boundaries defined
- Task directory structure created

**Failure Modes**:
- Research question too vague or broad
- Scope unclear

**Auto-Fix Strategy**: Prompt user for clarification (max 2 attempts)

---

## Phase 1: Research Planning

**Type**: Required
**Execution**: Delegate to `research-planner` agent
**Prerequisites**: Phase 0 complete

**Purpose**: Design methodology and identify sources

**Agent**: `research-planner`
**Tools**: Read, Write, Grep, Glob, WebSearch, Bash
**Model**: haiku (fast planning)

**Activities**:
1. Analyze research question and type
2. Select appropriate methodology
3. Identify data sources (codebase, docs, config, external)
4. Create research plan with phases
5. Define success criteria

**Outputs**:
- `planning/research-plan.md`
- `planning/sources.md`

**Success Criteria**:
- Methodology appropriate for research type
- Data sources comprehensive and accessible
- Research phases actionable
- Success criteria measurable

**Failure Modes**:
- No relevant sources found
- Methodology selection unclear
- Sources inaccessible

**Auto-Fix Strategy**: Expand search patterns, try alternative source locations (max 2 attempts)

---

## Phase 2: Information Gathering

**Type**: Required
**Execution**: Delegate to `information-gatherer` agent
**Prerequisites**: Phase 1 complete

**Purpose**: Collect information from all identified sources

**Agent**: `information-gatherer`
**Tools**: Read, Write, Grep, Glob, WebFetch, WebSearch, Bash
**Model**: sonnet (complex analysis)

**Activities**:
1. Execute research plan phases systematically
2. Gather from codebase, documentation, configuration
3. Maintain source citations and evidence
4. Organize findings by source
5. Cross-reference and verify

**Outputs**:
- `analysis/findings/00-summary.md`
- `analysis/findings/codebase-*.md` (multiple files)
- `analysis/findings/docs-*.md`
- `analysis/findings/config-*.md`
- `analysis/findings/external-*.md` (if applicable)

**Success Criteria**:
- All sources from sources.md investigated
- Every finding has source citation
- Findings organized clearly
- Gaps documented

**Failure Modes**:
- Sources not found at expected paths
- Insufficient information gathered
- Poor organization of findings

**Auto-Fix Strategy**: Retry with expanded patterns, use fuzzy search (max 3 attempts)

---

## Phase 3: Analysis & Synthesis

**Type**: Required
**Execution**: Delegate to `research-synthesizer` agent
**Prerequisites**: Phase 2 complete

**Purpose**: Analyze findings and generate insights

**Agent**: `research-synthesizer`
**Tools**: Read, Write
**Model**: sonnet (synthesis requires reasoning)

**Activities**:
1. Read all finding files
2. Cross-reference and validate findings
3. Identify patterns and themes
4. Apply analytical framework
5. Generate synthesis and research report

**Outputs**:
- `analysis/synthesis.md`
- `analysis/research-report.md`

**Success Criteria**:
- Research question answered completely
- Patterns identified and documented
- Insights evidence-based
- Report comprehensive and clear

**Failure Modes**:
- Insufficient findings for synthesis
- Contradictions unresolved
- Insights lack evidence

**Auto-Fix Strategy**: Request additional information gathering for gaps (max 2 attempts)

---

## Phase 4: Generate Outputs

**Type**: Required
**Execution**: Direct (orchestrator code with conditional logic)
**Prerequisites**: Phase 3 complete

**Purpose**: Create output artifacts based on research objectives

**Activities** (conditional):
1. **Always**: Research report already created in Phase 3
2. **If decision needed**: Generate recommendations.md
3. **If knowledge base requested**: Generate knowledge-base.md
4. **If feeding into dev workflow**: Generate specifications.md

**Outputs** (conditional):
- `outputs/recommendations.md` (if applicable)
- `outputs/knowledge-base.md` (if requested)
- `outputs/specifications.md` (if dev workflow integration)

**Success Criteria**:
- All requested outputs generated
- Outputs match research objectives
- Actionable and clear

**Failure Modes**:
- Output type unclear
- Insufficient information for recommendations

**Auto-Fix Strategy**: Use synthesis from Phase 3, simplify recommendations if needed (max 2 attempts)

---

## Phase 5: Verification (Optional)

**Type**: Optional
**Execution**: User review (interactive mode) or automated checks (YOLO mode)
**Prerequisites**: Phase 4 complete

**Purpose**: Validate findings accuracy and completeness

**Activities**:
1. Validate source credibility
2. Check findings accuracy against evidence
3. Assess completeness (all questions answered)
4. Identify gaps or inconsistencies

**Outputs**:
- `verification/verification-report.md`

**Success Criteria**:
- Sources validated as credible
- Findings match evidence
- Research question fully answered
- No critical gaps

**When to Enable**:
- **Auto-detect**: For complex or high-stakes research
- **Explicit**: User passes `--verify` flag
- **Skip**: Simple, low-stakes research

**Decision Factors**:
- Research complexity (complex → enable)
- Research type (mixed → enable, technical → optional)
- Finding confidence (low confidence → enable)

**Failure Modes**:
- Sources not credible
- Findings don't match evidence
- Critical gaps in research

**Auto-Fix Strategy**: Flag issues for user review, don't auto-fix verification failures (max 1 attempt)

---

## Phase 6: Integration (Optional)

**Type**: Optional
**Execution**: Direct (orchestrator code)
**Prerequisites**: Phase 4 (or Phase 5 if enabled) complete

**Purpose**: Integrate research into project documentation or workflows

**Activities**:
1. Update `.ai-sdlc/docs/` with relevant findings
2. Feed specifications into specification-creator (if applicable)
3. Archive research artifacts
4. Update project knowledge base

**Outputs**:
- Updated project documentation (various locations)
- Integration manifest documenting what was updated

**Success Criteria**:
- Relevant docs updated
- Changes documented in manifest
- Specifications ready for dev workflow (if applicable)

**When to Enable**:
- **Auto-detect**: If research generates actionable specs or knowledge for docs
- **Explicit**: User passes `--integrate` flag
- **Skip**: Exploratory research not intended for docs

**Decision Factors**:
- Research output type (specs/knowledge-base → enable)
- Project documentation exists (yes → enable)
- User intent (feeding into dev workflow → enable)

**Failure Modes**:
- Documentation structure unclear
- Integration targets not found

**Auto-Fix Strategy**: Skip integration and notify user where to manually integrate (max 1 attempt)

---

## Phase Dependencies

```
Phase 0 (Init)
    ↓
Phase 1 (Planning) ← requires research brief from Phase 0
    ↓
Phase 2 (Gathering) ← requires research plan from Phase 1
    ↓
Phase 3 (Synthesis) ← requires findings from Phase 2
    ↓
Phase 4 (Outputs) ← requires research report from Phase 3
    ↓
Phase 5 (Verification) [optional] ← requires outputs from Phase 4
    ↓
Phase 6 (Integration) [optional] ← requires outputs from Phase 4/5
```

**Critical Path**: Phases 0-4 (required)
**Optional Path**: Phases 5-6 (conditional)

---

## Phase Execution Patterns

### Sequential Execution (Standard)

**Pattern**: Execute phases in order, one at a time

**Flow**:
1. Execute Phase N
2. Check success
3. If success → Phase N+1
4. If failure → Auto-fix
5. If auto-fix fails → Halt and save state

**Use Case**: Most research workflows

---

### Conditional Phase Execution (Optional Phases)

**Pattern**: Decide whether to execute optional phases

**Decision Logic**:

**Phase 5 (Verification)**:
```
if (user_flag === '--verify') → enable
else if (mode === 'yolo' && complexity === 'high') → enable
else if (mode === 'yolo' && confidence === 'low') → enable
else if (mode === 'interactive') → ask user
else → skip
```

**Phase 6 (Integration)**:
```
if (user_flag === '--integrate') → enable
else if (outputs includes specifications) → enable
else if (outputs includes knowledge-base) → enable
else if (mode === 'interactive') → ask user
else → skip
```

---

### Resume Execution (Interrupted Workflow)

**Pattern**: Resume from last incomplete phase

**Flow**:
1. Load `orchestrator-state.yml`
2. Identify current_phase and completed_phases
3. Validate prerequisites complete
4. Resume from current_phase
5. Continue sequential execution

**Validation**:
- Check all prerequisite phases in completed_phases
- Verify output files exist for completed phases
- If validation fails → reconstruct state or start earlier phase

---

## State Management During Phases

### Before Phase Execution

**Update state**:
```yaml
current_phase: phase-N-name
```

**Announcement**: "Starting Phase N: [Phase Name]"

---

### During Phase Execution

**For Agent Delegation**:
1. Invoke agent via Task tool
2. Monitor agent execution (passive)
3. Collect agent outputs

**For Direct Execution**:
1. Execute orchestrator code
2. Write output files
3. Validate outputs created

---

### After Phase Execution

**Update state**:
```yaml
completed_phases: [phase-0, phase-1, ..., phase-N]
phase_results:
  phase-N-name:
    status: completed
    outputs: [file1.md, file2.md]
    timestamp: [timestamp]
```

**Success Path**: Move to next phase

**Failure Path**: Attempt auto-fix (if applicable)

---

### After Phase Failure

**Update state**:
```yaml
failed_phases:
  - phase: phase-N-name
    error: "Error description"
    attempted_fixes: 2
    timestamp: [timestamp]
auto_fix_attempts:
  phase-N-name: 2
```

**Decision**:
- If attempts < max_attempts → Retry with auto-fix
- If attempts >= max_attempts → Halt and save state for manual intervention

---

## Phase Transition Logic

### Normal Transition (Success)

```
Phase N Complete
    ↓
Update state (mark N complete)
    ↓
Interactive mode? → Pause for user review
YOLO mode? → Continue immediately
    ↓
Phase N+1 Start
```

---

### Conditional Transition (Optional Phase)

```
Required Phase Complete
    ↓
Optional Phase Decision
    ↓
Enable?
    Yes → Execute optional phase
    No → Skip to next phase
```

---

### Failure Transition

```
Phase N Fails
    ↓
Attempts < Max?
    Yes → Auto-fix → Retry Phase N
    No → Halt → Save state → Exit
    ↓
User can resume later with /ai-sdlc:research:resume
```

---

## Phase Output Validation

**Each phase must validate outputs before marking complete:**

### Phase 0 Validation
- ✅ `planning/research-brief.md` exists
- ✅ Contains research question
- ✅ Contains research type

### Phase 1 Validation
- ✅ `planning/research-plan.md` exists
- ✅ `planning/sources.md` exists
- ✅ Research plan has methodology and phases
- ✅ Sources list has at least one source

### Phase 2 Validation
- ✅ `analysis/findings/00-summary.md` exists
- ✅ At least one finding file exists
- ✅ Findings have source citations

### Phase 3 Validation
- ✅ `analysis/synthesis.md` exists
- ✅ `analysis/research-report.md` exists
- ✅ Research report answers research question

### Phase 4 Validation
- ✅ At least one output generated
- ✅ Research report exists (from Phase 3)

### Phase 5 Validation
- ✅ `verification/verification-report.md` exists
- ✅ Report includes validation results

### Phase 6 Validation
- ✅ Integration manifest created
- ✅ Updated files documented

---

## Phase Timing Estimates

**Estimates for typical research workflows:**

| Phase | Simple | Moderate | Complex |
|-------|--------|----------|---------|
| Phase 0: Init | 1 min | 2 min | 3 min |
| Phase 1: Planning | 2-3 min | 5-7 min | 10-15 min |
| Phase 2: Gathering | 5-10 min | 15-30 min | 30-60 min |
| Phase 3: Synthesis | 3-5 min | 10-15 min | 20-30 min |
| Phase 4: Outputs | 2-3 min | 5-10 min | 10-15 min |
| Phase 5: Verification | 2 min | 5 min | 10 min |
| Phase 6: Integration | 1-2 min | 3-5 min | 5-10 min |
| **Total** | **15-25 min** | **45-75 min** | **90-150 min** |

**Factors affecting timing:**
- Number of sources to investigate
- Codebase size and complexity
- Documentation availability
- Research type (technical usually slower than requirements)

---

## Phase Execution Best Practices

### 1. Clear Phase Boundaries
- Each phase has distinct purpose
- Outputs from phase N feed into phase N+1
- No phase should depend on phase N+2 outputs

### 2. Validate Before Proceeding
- Check all prerequisites before starting phase
- Validate outputs before marking phase complete
- Don't proceed if critical outputs missing

### 3. State Consistency
- Update state before, during, and after phases
- Always save state before agent delegation
- Maintain audit trail of phase executions

### 4. User Communication
- Announce phase start and completion
- In interactive mode, summarize phase results
- Provide clear guidance on next steps

### 5. Error Handling
- Attempt auto-fix when reasonable
- Don't auto-fix verification or integration failures
- Always save state before halting on failure

---

This reference provides phase execution patterns. Actual orchestration adapts these concepts to specific research contexts.
