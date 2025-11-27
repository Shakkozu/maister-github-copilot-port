# Auto-Fix Strategies Reference

This reference provides recovery patterns and failure handling strategies for the research orchestrator workflow.

## Purpose

Auto-fix strategies enable the orchestrator to recover from common failures automatically without user intervention. This reference defines when to apply auto-fix, max attempt limits, and escalation paths.

---

## Auto-Fix Philosophy

### Core Principles

**1. Attempt Recovery First**
- Try to resolve failures automatically when reasonable
- Don't immediately halt on recoverable errors

**2. Limit Attempts**
- Set maximum attempts per phase to prevent infinite loops
- Track attempts in state file

**3. Escalate When Needed**
- If auto-fix fails after max attempts, save state and halt
- Provide clear guidance for manual intervention

**4. Different Strategies for Different Phases**
- Analysis phases: Expand search, try alternatives
- Execution phases: Retry with adjustments
- Verification phases: Don't auto-fix, flag for user

---

## Max Attempts by Phase

| Phase | Max Attempts | Auto-Fix Strategy | Escalation |
|-------|--------------|-------------------|------------|
| Phase 0: Init | 2 | Prompt for clarification | Ask user to refine question |
| Phase 1: Planning | 2 | Expand search, try alternatives | User must specify sources |
| Phase 2: Gathering | 3 | Retry with broader patterns | User must identify sources |
| Phase 3: Synthesis | 2 | Request more gathering | User must provide more info |
| Phase 4: Outputs | 2 | Simplify outputs, use existing | User must clarify requirements |
| Phase 5: Verification | 1 | Flag issues, don't fix | User must review manually |
| Phase 6: Integration | 1 | Skip integration, notify user | User must integrate manually |

---

## Phase 0: Research Initialization Auto-Fix

### Common Failures

**Failure**: Research question too vague or broad

**Auto-Fix Attempts**:

**Attempt 1**: Prompt user for clarification
- Ask specific questions to narrow scope
- Suggest breaking into sub-questions
- Provide examples of well-formed questions

**Attempt 2**: Suggest alternative question formulations
- Rephrase question for clarity
- Propose narrower scope
- Ask user to confirm intent

**Escalation**: If still unclear after 2 attempts, save state and request user to reformulate question manually

---

**Failure**: Research type unclear

**Auto-Fix Attempts**:

**Attempt 1**: Ask user to specify type
- Present type options (technical/requirements/literature/mixed)
- Explain what each type means
- Ask user to select

**Attempt 2**: Default to "mixed" if ambiguous
- Use mixed methodology
- Document assumption in research brief

**Escalation**: Rarely needed - mixed type works for ambiguous cases

---

## Phase 1: Research Planning Auto-Fix

### Common Failures

**Failure**: No relevant sources found

**Auto-Fix Attempts**:

**Attempt 1**: Expand search patterns
- Broaden file patterns (e.g., `**/*auth*` → `**/*`)
- Search additional directories
- Try alternative naming conventions
- Check standard documentation locations

**Attempt 2**: Use fallback sources
- Search entire codebase without filters
- Use project root README
- Check package files for dependencies
- Suggest web research if codebase insufficient

**Escalation**: If no sources found after 2 attempts, halt and ask user to:
- Confirm research question is appropriate for this codebase
- Manually identify source locations
- Consider external research sources

---

**Failure**: Methodology selection unclear

**Auto-Fix Attempts**:

**Attempt 1**: Use mixed methodology as fallback
- Combine technical, requirements, and literature approaches
- Document decision in research plan

**Escalation**: Mixed methodology should work for most cases

---

## Phase 2: Information Gathering Auto-Fix

### Common Failures

**Failure**: Sources not found at expected paths

**Auto-Fix Attempts**:

**Attempt 1**: Try fuzzy search
- Use broader Glob patterns
- Search parent directories
- Try alternative file extensions
- Check for renamed or moved files

**Attempt 2**: Use alternative source types
- If code files not found, use documentation
- If docs not found, use configuration
- If local sources insufficient, try web sources (if applicable)

**Attempt 3**: Continue with available sources
- Document missing sources as gaps
- Proceed with sources that were found
- Flag missing sources in findings summary

**Escalation**: If critical sources missing after 3 attempts:
- Save state with partial findings
- Ask user to locate missing sources
- Provide resume capability

---

**Failure**: Insufficient information gathered

**Auto-Fix Attempts**:

**Attempt 1**: Expand search scope
- Search related directories
- Include test files
- Check additional documentation

**Attempt 2**: Try alternative keywords
- Use synonyms or related terms
- Search for patterns instead of exact matches
- Broaden search terms

**Attempt 3**: Document as information gap
- Continue with available information
- Mark as low-confidence findings
- Recommend additional research in gaps section

**Escalation**: If insufficient after 3 attempts:
- Proceed with available information
- Clearly mark low-confidence areas
- Suggest follow-up research in verification

---

**Failure**: Agent execution timeout or error

**Auto-Fix Attempts**:

**Attempt 1**: Retry agent invocation
- Same parameters, fresh execution
- May resolve transient errors

**Attempt 2**: Retry with reduced scope
- Limit sources to highest priority
- Reduce search patterns
- Focus on core areas

**Attempt 3**: Execute simplified gathering
- Use direct execution instead of agent
- Gather from most obvious sources only
- Document scope reduction

**Escalation**: If agent consistently fails:
- Switch to direct execution
- Gather minimal viable findings
- Continue workflow with reduced scope

---

## Phase 3: Analysis & Synthesis Auto-Fix

### Common Failures

**Failure**: Insufficient findings for synthesis

**Auto-Fix Attempts**:

**Attempt 1**: Request additional gathering
- Identify specific gaps in findings
- Re-invoke information-gatherer for targeted collection
- Focus on missing areas

**Attempt 2**: Synthesize with available information
- Proceed with partial findings
- Mark low-confidence areas clearly
- Document information gaps

**Escalation**: If findings still insufficient:
- Create partial synthesis
- Clearly document limitations
- Recommend follow-up research

---

**Failure**: Contradictions unresolved

**Auto-Fix Attempts**:

**Attempt 1**: Request verification
- Re-examine contradictory sources
- Look for additional evidence
- Check source timestamps (newer likely more accurate)

**Attempt 2**: Present contradictions as findings
- Document both sides of contradiction
- Note which sources support each view
- Mark as medium-confidence finding

**Escalation**: If contradictions remain:
- Document unresolved contradictions
- Recommend user investigation
- Provide evidence for both sides

---

**Failure**: Agent execution error

**Auto-Fix Attempts**:

**Attempt 1**: Retry agent invocation
- Same parameters, fresh execution

**Attempt 2**: Execute direct synthesis
- Orchestrator performs basic synthesis
- Simpler analysis than agent would provide
- Focus on most obvious patterns

**Escalation**: If synthesis consistently fails:
- Create minimal research report
- List findings without deep analysis
- Mark as preliminary synthesis

---

## Phase 4: Generate Outputs Auto-Fix

### Common Failures

**Failure**: Output type unclear

**Auto-Fix Attempts**:

**Attempt 1**: Generate standard outputs
- Always: Research report (from Phase 3)
- If decision-oriented research: Add recommendations
- If exploratory research: Add knowledge base

**Attempt 2**: Ask user in interactive mode
- Present output options
- User selects desired outputs

**Escalation**: If still unclear (YOLO mode):
- Generate research report only
- User can extract other outputs manually

---

**Failure**: Insufficient information for recommendations

**Auto-Fix Attempts**:

**Attempt 1**: Generate partial recommendations
- Base on available evidence
- Mark as preliminary
- Note information gaps

**Attempt 2**: Skip recommendations
- Focus on descriptive findings
- User can formulate recommendations from findings

**Escalation**: Rarely needed - partial recommendations acceptable

---

## Phase 5: Verification Auto-Fix

### Common Failures

**Failure**: Sources not credible

**Auto-Fix Strategy**: **DO NOT AUTO-FIX**
- Flag sources as questionable
- Document credibility concerns
- Recommend user review

**Rationale**: Verification failures indicate quality issues that require human judgment

---

**Failure**: Findings don't match evidence

**Auto-Fix Strategy**: **DO NOT AUTO-FIX**
- Document discrepancies
- Mark findings as low-confidence
- Recommend user investigation

**Rationale**: Accuracy issues require manual correction, not automated fixes

---

**Failure**: Critical gaps in research

**Auto-Fix Strategy**: **DO NOT AUTO-FIX**
- Document gaps clearly
- Recommend additional research
- Mark research as incomplete

**Rationale**: Gaps represent missing information that auto-fix can't create

---

**Max Attempts**: 1 (flag issues, don't fix)

---

## Phase 6: Integration Auto-Fix

### Common Failures

**Failure**: Documentation structure unclear

**Auto-Fix Attempts**:

**Attempt 1**: Skip integration and notify
- Don't attempt to modify docs
- Provide integration recommendations
- Save outputs for manual integration

**Escalation**: Always escalate to user

**Rationale**: Integration requires understanding of project documentation conventions

---

**Failure**: Integration targets not found

**Auto-Fix Strategy**: **DO NOT AUTO-FIX**
- Document where integration was attempted
- Provide manual integration guide
- Save outputs in research task directory

**Rationale**: Missing targets indicate documentation structure issues that need user guidance

---

**Max Attempts**: 1 (skip and notify)

---

## Attempt Tracking in State

### State Structure for Attempts

```yaml
auto_fix_attempts:
  phase-1-planning: 2
  phase-2-gathering: 1
  phase-3-synthesis: 0

failed_phases:
  - phase: phase-2-gathering
    error: "Critical source file not found: src/auth/AuthService.js"
    attempted_fixes:
      - "Attempt 1: Expanded search to src/**/*auth*"
      - "Attempt 2: Searched for alternative auth files"
    final_resolution: "Continued with available sources, documented gap"
    timestamp: "2025-11-14T12:30:00Z"
```

---

## Auto-Fix Decision Tree

```
Phase Fails
    ↓
Is phase auto-fixable?
    ↓
No → Halt immediately, save state
    ↓
Yes → Check attempt count
    ↓
Attempts < Max?
    ↓
No → Halt, save state, escalate to user
    ↓
Yes → Attempt auto-fix
    ↓
Increment attempt counter
    ↓
Apply auto-fix strategy for this phase
    ↓
Retry phase execution
    ↓
Success? → Continue to next phase
Failure? → Return to "Check attempt count"
```

---

## Escalation Patterns

### Graceful Degradation

**Strategy**: Accept reduced quality to continue workflow

**Examples**:
- Proceed with partial findings (some sources missing)
- Generate simple recommendations (detailed analysis not possible)
- Create synthesis with available information (gaps documented)

**When to use**: Non-critical failures in analysis phases

---

### Halt and Resume

**Strategy**: Save state and require user intervention

**Examples**:
- No sources found after max attempts
- Verification failures (accuracy issues)
- Integration failures (structure unclear)

**When to use**: Critical failures that can't be auto-fixed

---

### User Prompt (Interactive Mode)

**Strategy**: Ask user for guidance before proceeding

**Examples**:
- Optional phase decision
- Output type selection
- Source location when auto-detection fails

**When to use**: Interactive mode, non-critical decisions

---

## Logging Auto-Fix Attempts

**Each auto-fix attempt should log**:

```yaml
phase: phase-name
attempt: N
strategy: "Strategy description"
actions: ["Action 1", "Action 2"]
result: success|failure
timestamp: "2025-11-14T12:30:00Z"
```

**Purpose**:
- Audit trail for debugging
- User understanding of what was tried
- Resume capability (know what was attempted)

---

## Best Practices

### 1. Fail Fast for Critical Errors
- Don't waste attempts on unrecoverable errors
- If error is clearly user configuration issue, escalate immediately

### 2. Progressive Degradation
- Attempt 1: Try to maintain full quality
- Attempt 2: Accept reduced quality
- Attempt 3: Minimal viable outcome

### 3. Clear Communication
- Log what was attempted and why
- Explain what user needs to do if escalated
- Provide context for manual intervention

### 4. State Consistency
- Always save state before halting
- Track all attempts in state file
- Enable resume from any failure point

### 5. User Respect
- Don't retry endlessly (max attempts prevents this)
- Provide clear escalation guidance
- Make resume easy (save complete state)

---

## Common Anti-Patterns

### ❌ Infinite Retry Loops
**Problem**: No max attempt limit
**Fix**: Always set max attempts per phase

### ❌ Silent Failures
**Problem**: Auto-fix fails but workflow continues without noting failure
**Fix**: Log all failures and attempted fixes

### ❌ Over-Aggressive Auto-Fix
**Problem**: Attempting to fix things that need human judgment (verification, integration)
**Fix**: Don't auto-fix quality or structure issues

### ❌ Unclear Escalation
**Problem**: User doesn't know what to do after halt
**Fix**: Provide specific, actionable guidance

### ❌ State Loss on Failure
**Problem**: Failure causes state corruption, can't resume
**Fix**: Save state before every risky operation

---

This reference provides auto-fix patterns. Actual recovery adapts these strategies to specific failure contexts.
