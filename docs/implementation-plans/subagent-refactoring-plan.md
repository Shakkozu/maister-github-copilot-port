# Subagent Refactoring Implementation Plan

**Status:** IN PROGRESS (20% Complete)
**Started:** 2025-10-29
**Last Updated:** 2025-10-29

---

## Executive Summary

This plan outlines the refactoring of three critical analysis components from inline skill execution to isolated subagent execution to prevent context pollution in the main agent. The refactoring creates a cleaner separation of concerns while maintaining full backward compatibility.

**Components to Refactor:**
1. ✅ **task-classifier** - Task type classification and routing (PHASE A - 66% COMPLETE)
2. ⏳ **existing-feature-analyzer** - Feature discovery and analysis (PHASE B - NOT STARTED)
3. ⏳ **gap-analyzer** - Gap identification and impact assessment (PHASE C - NOT STARTED)

**Benefits:**
- ✅ Prevents main agent context pollution
- ✅ Isolated execution with dedicated context windows
- ✅ Better debuggability and testability
- ✅ Consistent architecture across all analysis tasks
- ✅ Self-contained agents (no external file dependencies)

---

## Current Implementation Status

### Phase A: Task Classifier (66% COMPLETE)

| Task | Status | Files Changed | Notes |
|------|--------|---------------|-------|
| 1. Create agent file | ✅ DONE | `agents/task-classifier.md` (NEW, 1,092 lines) | Self-contained with embedded references |
| 2. Simplify skill | ✅ DONE | `skills/task-classifier/SKILL.md` (243 lines, -538 lines) | Thin wrapper, delegates to agent |
| 3. Update /work command | ⏳ TODO | `commands/work/work.md` | Minor clarification needed |
| 4. Update reference headers | ⏳ TODO | `skills/task-classifier/references/*.md` (4 files) | Add design doc headers |
| 5. Test classification | ⏳ TODO | - | Validate agent invocation works |

**Time Invested:** ~3 hours
**Time Remaining:** ~1 hour

### Phase B: Existing Feature Analyzer (0% COMPLETE)

| Task | Status | Files Changed | Notes |
|------|--------|---------------|-------|
| 1. Create agent file | ⏳ TODO | `agents/existing-feature-analyzer.md` (NEW, ~1,200-1,500 lines) | Embed reference content |
| 2. Update orchestrator | ⏳ TODO | `skills/enhancement-orchestrator/SKILL.md` (Phase 0 logic) | Delegate to agent |
| 3. Update reference header | ⏳ TODO | `skills/enhancement-orchestrator/references/existing-feature-analysis.md` | Design doc header |
| 4. Test analyzer | ⏳ TODO | - | Validate Phase 0 works |

**Time Remaining:** ~5-7 hours

### Phase C: Gap Analyzer (0% COMPLETE)

| Task | Status | Files Changed | Notes |
|------|--------|---------------|-------|
| 1. Create agent file | ⏳ TODO | `agents/gap-analyzer.md` (NEW, ~2,000-2,500 lines) | Embed all analysis logic |
| 2. Update orchestrator | ⏳ TODO | `skills/enhancement-orchestrator/SKILL.md` (Phase 1 logic) | Delegate to agent |
| 3. Update reference header | ⏳ TODO | `skills/enhancement-orchestrator/references/gap-analysis.md` | Design doc header |
| 4. Test analyzer | ⏳ TODO | - | Validate Phase 1 works |

**Time Remaining:** ~8-10 hours

### Overall Progress

- **Total Tasks:** 13
- **Completed:** 2 (15%)
- **In Progress:** 0
- **Remaining:** 11 (85%)
- **Estimated Time Remaining:** 14-18 hours

---

## Detailed Task Breakdown

### ✅ COMPLETED TASKS

#### 1. Create `agents/task-classifier.md` ✅

**Completed:** 2025-10-29
**Time Taken:** ~2 hours

**What was done:**
- Created self-contained agent file with 1,092 lines
- Embedded all reference content:
  - Keyword classification matrix (~300 lines from `references/keyword-matrix.md`)
  - Context analysis strategies (~200 lines from `references/context-analysis.md`)
  - Issue fetching patterns (~150 lines from `references/issue-fetching.md`)
- Added comprehensive frontmatter:
  ```yaml
  name: task-classifier
  description: Analyzes task descriptions and issue references...
  capabilities: [5 capabilities listed]
  tools: Read, Grep, Bash, WebFetch, AskUserQuestion
  model: inherit
  color: purple
  ```
- Organized into 5-phase classification workflow
- Included examples and success criteria

**Result:** Agent is fully self-contained and path-independent

---

#### 2. Simplify `skills/task-classifier/SKILL.md` ✅

**Completed:** 2025-10-29
**Time Taken:** ~1 hour

**What was done:**
- Reduced skill from 781 lines to 243 lines (69% reduction)
- Converted to thin wrapper that delegates to subagent
- Documented delegation pattern clearly
- Kept input/output format specifications
- Referenced agent for implementation details
- Added usage examples showing delegation flow

**Key sections:**
- How It Works (explains delegation)
- Supported Task Types (summary table)
- Classification Workflow (overview)
- Integration Points (with /work command)
- Reference Documentation (points to design docs)

**Result:** Clean separation between interface (skill) and implementation (agent)

---

### ⏳ PENDING TASKS

#### 3. Update `commands/work/work.md` ⏳

**Status:** NOT STARTED
**Estimated Time:** 30 minutes
**Priority:** Medium

**What needs to be done:**
1. Locate Step 2 in work.md (where task-classifier is invoked)
2. Add clarifying comment explaining delegation:
   ```markdown
   ### Step 2: Invoke Task Classifier NOW

   **Use the Skill tool to invoke the task-classifier skill:**

   The skill delegates to the task-classifier subagent which performs all
   classification logic in an isolated context (preventing main agent pollution).

   The subagent:
   1. Detects issue references (GitHub, Jira, etc.)
   2. Fetches issue details if available via MCP
   3. Performs codebase context analysis
   4. Matches keywords and calculates confidence
   5. Confirms classification with user based on confidence level
   6. Returns structured classification result

   Invoke task-classifier skill with:
     prompt: "Classify this task and provide structured output:

     Task: [user's input]

     [... rest of prompt unchanged ...]"

     skill: task-classifier
   ```
3. No functional changes needed, just clarification

**Validation:**
- Verify `/work` command still invokes correctly
- Check that skill name hasn't changed

---

#### 4. Update Reference File Headers ⏳

**Status:** NOT STARTED
**Estimated Time:** 15 minutes
**Priority:** Low

**What needs to be done:**

Add design documentation header to each reference file:

**Files to update:**
1. `skills/task-classifier/references/keyword-matrix.md`
2. `skills/task-classifier/references/classification-workflow.md`
3. `skills/task-classifier/references/context-analysis.md`
4. `skills/task-classifier/references/issue-fetching.md`

**Header to add (at top of each file):**
```markdown
> **Design Documentation**: This file serves as design documentation for developers.
> The actual runtime classification logic is embedded in `agents/task-classifier.md`
> for path-independence when the plugin runs in user projects.

---

[Existing content...]
```

**Purpose:** Clarify that references are design docs, not runtime code

---

#### 5. Test Task Classifier ⏳

**Status:** NOT STARTED
**Estimated Time:** 15-30 minutes
**Priority:** HIGH (blocking Phase B)

**What needs to be tested:**

1. **Test agent invocation directly:**
   ```bash
   # Invoke agent with simple bug description
   Test: "Fix login timeout error"
   Expected: Bug Fix classification, ~88% confidence
   ```

2. **Test via /work command:**
   ```bash
   /work "Fix login timeout error"
   Expected: Classification → routing to bug-fix-orchestrator
   ```

3. **Test security detection:**
   ```bash
   Test: "Fix SQL injection in search"
   Expected: Security classification, ~98% confidence, critical warning
   ```

4. **Test enhancement vs new-feature:**
   ```bash
   Test: "Add sorting to user table"
   Expected: Codebase search → Enhancement if UserTable exists
   ```

5. **Test GitHub issue (if MCP available):**
   ```bash
   Test: "https://github.com/owner/repo/issues/123"
   Expected: Fetch issue → Classify based on content
   ```

**Pass criteria:**
- All 5 tests return correct classification
- No errors during agent invocation
- Main agent context remains clean
- Subagent returns structured YAML

**If tests fail:** Debug agent logic, fix issues, retest

---

#### 6. Create `agents/existing-feature-analyzer.md` ⏳

**Status:** NOT STARTED
**Estimated Time:** 3-4 hours
**Priority:** HIGH (Phase B)

**What needs to be done:**

1. **Read reference file:**
   - `skills/enhancement-orchestrator/references/existing-feature-analysis.md`
   - Extract all patterns, algorithms, strategies

2. **Create agent file structure:**
   ```yaml
   ---
   name: existing-feature-analyzer
   description: Analyzes existing features in the codebase before enhancement...
   capabilities:
     - "Feature file auto-detection with confidence scoring"
     - "Multi-strategy search (filename patterns + code patterns)"
     - "Dependency mapping and impact analysis"
     - "Test coverage assessment"
     - "Complexity scoring and effort estimation"
   tools: Read, Glob, Grep, Bash
   model: inherit
   color: blue
   ---
   ```

3. **Embed content (~1,200-1,500 lines):**
   - Core Mission (50 lines)
   - Feature Context Extraction (150 lines from reference)
   - Search Strategy (300 lines from reference)
   - File Scoring Pattern (200 lines from reference)
   - Match Presentation (100 lines from reference)
   - Feature Analysis Workflow (200 lines from reference)
   - Complexity Assessment (150 lines from reference)
   - Analysis Report Structure (100 lines from reference)
   - Failure Handling (100 lines from reference)
   - Examples (100 lines)

4. **Input/Output specification:**
   ```yaml
   Input:
     task_description: "Add sorting to user table"
     task_path: ".ai-sdlc/tasks/enhancements/2025-10-29-add-sorting"

   Output:
     analysis:
       feature_found: true
       confidence: 92
       primary_files: [...]
       dependencies: [...]
       complexity: "medium"
       test_coverage: "good"
       report_path: "planning/existing-feature-analysis.md"
   ```

**Result:** Self-contained agent for Phase 0 of enhancement workflow

---

#### 7. Update Enhancement Orchestrator Phase 0 ⏳

**Status:** NOT STARTED
**Estimated Time:** 1 hour
**Priority:** HIGH (Phase B)

**What needs to be done:**

1. **Locate Phase 0 logic in orchestrator:**
   - File: `skills/enhancement-orchestrator/SKILL.md`
   - Section: Phase 0 execution (around line 460-465)

2. **Replace inline logic with agent invocation:**

   **Current (inline):**
   ```markdown
   **For Phases 0-1** (Direct execution in orchestrator):
   Execute phase logic directly:
   - Phase 0: Feature auto-detection and analysis
   ```

   **New (delegate to agent):**
   ```markdown
   **For Phase 0** (Delegate to subagent):

   Invoke existing-feature-analyzer via Task tool:
     subagent_type: "existing-feature-analyzer"
     prompt: "Analyze existing feature for enhancement:

     Description: [task description]
     Task Path: [task path]

     Please:
     1. Extract feature context from description
     2. Auto-detect feature files using multi-strategy search
     3. Analyze current functionality and dependencies
     4. Assess test coverage and complexity
     5. Create analysis report at planning/existing-feature-analysis.md
     6. Return structured analysis result"

   Capture analysis result from subagent.
   Update state with feature_found and confidence.
   ```

3. **No other changes needed** - Phase 1-8 remain unchanged

**Validation:**
- Run enhancement workflow
- Verify Phase 0 completes successfully
- Check analysis report generated correctly

---

#### 8. Update Reference Header (existing-feature-analysis) ⏳

**Status:** NOT STARTED
**Estimated Time:** 5 minutes
**Priority:** Low

**File:** `skills/enhancement-orchestrator/references/existing-feature-analysis.md`

**Add header:**
```markdown
> **Design Documentation**: This file serves as design documentation for developers.
> The actual runtime analysis logic is embedded in `agents/existing-feature-analyzer.md`
> for path-independence when the plugin runs in user projects.

---
```

---

#### 9. Test Existing Feature Analyzer ⏳

**Status:** NOT STARTED
**Estimated Time:** 1-2 hours
**Priority:** HIGH (blocking Phase C)

**What needs to be tested:**

1. **Test agent invocation directly:**
   ```bash
   Task: "Add sorting to user table"
   Expected: Find UserTable component, high confidence
   ```

2. **Test via enhancement workflow:**
   ```bash
   /ai-sdlc:enhancement:new "Add filtering to user table"
   Expected: Phase 0 finds UserTable, analyzes it
   ```

3. **Test feature not found:**
   ```bash
   Task: "Add dashboard"
   Expected: Low confidence, prompt user or expand search
   ```

4. **Test complex feature:**
   ```bash
   Task: "Refactor authentication system"
   Expected: Find multiple auth-related files, analyze dependencies
   ```

**Pass criteria:**
- All 4 tests return correct analysis
- Analysis reports generated correctly
- orchestrator Phase 0 completes successfully
- No errors during agent invocation

---

#### 10. Create `agents/gap-analyzer.md` ⏳

**Status:** NOT STARTED
**Estimated Time:** 5-6 hours
**Priority:** HIGH (Phase C)

**What needs to be done:**

1. **Read reference file:**
   - `skills/enhancement-orchestrator/references/gap-analysis.md`
   - Extract all analysis strategies, patterns

2. **Create agent file structure:**
   ```yaml
   ---
   name: gap-analyzer
   description: Performs gap analysis and impact assessment for enhancements...
   capabilities:
     - "Gap identification (missing, incomplete, behavior changes)"
     - "Enhancement type classification with risk assessment"
     - "User journey impact analysis (reachability, personas, navigation)"
     - "Data entity lifecycle analysis (CRUD completeness, orphan detection)"
     - "UI-heavy work detection for mockup generation"
     - "Compatibility requirements determination"
   tools: Read, Glob, Grep, Bash, AskUserQuestion
   model: inherit
   color: blue
   ---
   ```

3. **Embed content (~2,000-2,500 lines):**
   - Core Mission (50 lines)
   - Desired Functionality Extraction (150 lines from reference)
   - Gap Identification (300 lines from reference)
   - Enhancement Type Classification (400 lines from reference)
   - Impact Assessment (300 lines from reference)
   - **User Journey Impact Analysis (400 lines)** - Critical new section
   - **Data Entity Lifecycle Analysis (500 lines)** - Critical new section
   - UI-Heavy Detection (100 lines)
   - Compatibility Requirements (200 lines from reference)
   - Gap Analysis Workflow (300 lines)
   - Examples (100 lines)

4. **Input/Output specification:**
   ```yaml
   Input:
     task_description: "Add sorting to user table"
     task_path: ".ai-sdlc/tasks/enhancements/2025-10-29-add-sorting"
     existing_analysis_path: "planning/existing-feature-analysis.md"

   Output:
     gap_analysis:
       gaps:
         missing: ["sorting functionality", "sort state management"]
         incomplete: []
         behavioral_changes: []
       enhancement_type: "additive"
       risk_level: "low"
       effort_estimate: "4-6 hours"
       user_journey_impact: {...}
       data_lifecycle_complete: true
       ui_heavy: true
       compatibility_requirement: "strict"
       report_path: "planning/gap-analysis.md"
   ```

**Special attention:**
- User journey analysis is extensive (400 lines)
- Data lifecycle analysis prevents incomplete features (500 lines)
- Both are critical for enhancement quality

**Result:** Self-contained agent for Phase 1 of enhancement workflow

---

#### 11. Update Enhancement Orchestrator Phase 1 ⏳

**Status:** NOT STARTED
**Estimated Time:** 1 hour
**Priority:** HIGH (Phase C)

**What needs to be done:**

1. **Locate Phase 1 logic in orchestrator:**
   - File: `skills/enhancement-orchestrator/SKILL.md`
   - Section: Phase 1 execution (after Phase 0 logic)

2. **Replace inline logic with agent invocation:**

   **Current (inline):**
   ```markdown
   **For Phases 0-1** (Direct execution in orchestrator):
   Execute phase logic directly:
   - Phase 1: Gap identification, classification, user journey analysis, data lifecycle analysis
   ```

   **New (delegate to agent):**
   ```markdown
   **For Phase 1** (Delegate to subagent):

   Read existing feature analysis from Phase 0.

   Invoke gap-analyzer via Task tool:
     subagent_type: "gap-analyzer"
     prompt: "Perform gap analysis for enhancement:

     Description: [task description]
     Task Path: [task path]
     Existing Analysis: [path or content from Phase 0]

     Please:
     1. Extract desired functionality from description
     2. Compare with existing analysis
     3. Identify all gaps (missing, incomplete, behavior changes)
     4. Classify enhancement type (Additive/Modificative/Refactor-based)
     5. Assess implementation impact and risk
     6. Perform user journey impact assessment
     7. Perform data entity lifecycle analysis (if data involved)
     8. Detect UI-heavy work for mockup generation
     9. Determine compatibility requirements
     10. Create gap analysis report at planning/gap-analysis.md
     11. Return structured gap analysis result"

   Capture gap_analysis result from subagent.
   Update state with enhancement_type, risk_level, ui_heavy flag.
   ```

3. **No other changes needed** - Phase 2-9 remain unchanged

**Validation:**
- Run enhancement workflow
- Verify Phase 1 completes successfully
- Check gap analysis report generated correctly
- Verify UI-heavy detection triggers Phase 2

---

#### 12. Update Reference Header (gap-analysis) ⏳

**Status:** NOT STARTED
**Estimated Time:** 5 minutes
**Priority:** Low

**File:** `skills/enhancement-orchestrator/references/gap-analysis.md`

**Add header:**
```markdown
> **Design Documentation**: This file serves as design documentation for developers.
> The actual runtime analysis logic is embedded in `agents/gap-analyzer.md`
> for path-independence when the plugin runs in user projects.

---
```

---

#### 13. Final Integration Testing ⏳

**Status:** NOT STARTED
**Estimated Time:** 2-3 hours
**Priority:** CRITICAL

**What needs to be tested:**

### 1. Task Classifier Integration

**Test 1: Bug classification via /work**
```bash
/work "Fix login timeout error"

Expected:
✅ task-classifier agent invoked
✅ Classifies as bug-fix (85-90% confidence)
✅ Routes to bug-fix-orchestrator
✅ Main agent context clean
```

**Test 2: Security detection**
```bash
/work "Fix SQL injection in search"

Expected:
✅ Security classification (98% confidence)
✅ Critical warning shown
✅ User confirmation required
```

**Test 3: Enhancement classification**
```bash
/work "Add filtering to user table"

Expected:
✅ Codebase search performed
✅ UserTable found → Enhancement (85%)
✅ Routes to enhancement-orchestrator
```

### 2. Enhancement Workflow Integration

**Test 4: Complete enhancement flow**
```bash
/ai-sdlc:enhancement:new "Add sorting to user table"

Expected Phase 0:
✅ existing-feature-analyzer agent invoked
✅ UserTable found with high confidence (90%)
✅ Analysis report created: planning/existing-feature-analysis.md
✅ Orchestrator receives feature_found=true

Expected Phase 1:
✅ gap-analyzer agent invoked
✅ Gaps identified: sorting functionality missing
✅ Enhancement type: Additive
✅ User journey analysis completed
✅ Data lifecycle check: complete
✅ UI-heavy: true (triggers Phase 2)
✅ Gap analysis report created: planning/gap-analysis.md
✅ Orchestrator receives enhancement_type, ui_heavy flag

Expected Phase 2:
✅ UI mockup generation prompted/auto-triggered

Expected Phases 3-9:
✅ Continue normally with enhanced context
```

**Test 5: Enhancement with feature not found**
```bash
/ai-sdlc:enhancement:new "Add dashboard"

Expected Phase 0:
✅ Search performed, dashboard not found
✅ Low confidence (<60%)
⚠️ User prompted: "Is this improving existing or creating new?"
✅ Based on user answer, proceed or reclassify as new-feature
```

### 3. Context Pollution Verification

**Test 6: Verify context isolation**
```bash
# Before refactoring: main agent context ~10K tokens during classification
# After refactoring: main agent context ~3K tokens during classification

Monitor during /work execution:
✅ Main agent context does NOT include:
   - Full keyword matrix
   - Context analysis strategies
   - Issue fetching patterns
   - Feature analysis algorithms
   - Gap analysis logic
✅ Subagent context includes all necessary logic
✅ Only structured results passed back to main agent
```

### 4. Regression Testing

**Test 7: Existing workflows still work**
```bash
/ai-sdlc:feature:new "New feature"
Expected: ✅ Works identically to before

/ai-sdlc:bug-fix:new "Bug fix"
Expected: ✅ Works identically to before

/work "Any task description"
Expected: ✅ Works identically to before
```

### 5. Error Handling

**Test 8: Agent failures**
```bash
# Simulate agent failure
Expected:
✅ Graceful error message
✅ Option to retry or proceed manually
✅ No crash or undefined behavior
```

### Pass Criteria

All tests must pass:
- ✅ Classification accuracy ≥ 90%
- ✅ Context pollution reduced by 50-70%
- ✅ No regressions in existing workflows
- ✅ Error handling graceful
- ✅ Performance acceptable (< 5% slower)

### If Tests Fail

1. **Identify failing test**
2. **Debug specific agent or integration point**
3. **Fix issue in agent or orchestrator**
4. **Retest all tests** (regression check)
5. **Document any changes** in this plan

---

## Files Modified Summary

### New Files Created

```
agents/
├── task-classifier.md                    # ✅ DONE: ~1,092 lines
├── existing-feature-analyzer.md          # ⏳ TODO: ~1,200-1,500 lines
└── gap-analyzer.md                       # ⏳ TODO: ~2,000-2,500 lines
```

### Modified Files

```
skills/
├── task-classifier/
│   └── SKILL.md                          # ✅ DONE: Reduced to ~243 lines
│
└── enhancement-orchestrator/
    └── SKILL.md                          # ⏳ TODO: Update Phase 0 & 1 logic

commands/
└── work/
    └── work.md                           # ⏳ TODO: Minor Step 2 clarification

skills/task-classifier/references/
├── keyword-matrix.md                     # ⏳ TODO: Add header
├── classification-workflow.md            # ⏳ TODO: Add header
├── context-analysis.md                   # ⏳ TODO: Add header
└── issue-fetching.md                     # ⏳ TODO: Add header

skills/enhancement-orchestrator/references/
├── existing-feature-analysis.md          # ⏳ TODO: Add header
└── gap-analysis.md                       # ⏳ TODO: Add header
```

### Unchanged Files

All other orchestrators, skills, and agents remain unchanged.

---

## Timeline & Estimates

### Phase A: Task Classifier
- ✅ Completed: 2 tasks (3 hours)
- ⏳ Remaining: 3 tasks (1 hour)
- **Total Phase A:** 4 hours

### Phase B: Existing Feature Analyzer
- ⏳ All tasks remaining (5-7 hours)

### Phase C: Gap Analyzer
- ⏳ All tasks remaining (8-10 hours)

### Testing & Documentation
- ⏳ Final integration testing (2-3 hours)
- ⏳ Documentation updates (1 hour)

### Overall Timeline
- **Completed:** 3 hours (20%)
- **Remaining:** 17-22 hours (80%)
- **Total Estimate:** 20-25 hours

---

## Risk Assessment

### Low Risk ✅
- Task classifier refactoring (proven pattern, mostly complete)
- Reference file header updates (simple text change)
- Work command clarification (documentation only)

### Medium Risk ⚠️
- Existing feature analyzer creation (complex search logic)
- Gap analyzer creation (extensive analysis, user journey, data lifecycle)
- Orchestrator integration (coordination between phases)

### High Risk ⚠️
- Final integration testing (may reveal unexpected issues)
- Context isolation verification (need to measure actual impact)
- Performance impact (agent delegation overhead)

### Mitigation Strategies
- **Incremental testing:** Test each phase before moving to next
- **Backup files:** Keep .backup files for easy rollback
- **Git commits:** Commit after each phase completion
- **Validation scripts:** Create test scripts for each component

---

## Success Metrics

### Performance
- ✅ Context reduction: 50-70% during analysis
- ⏳ Execution time: < 5% slower (acceptable overhead)
- ⏳ Memory usage: Better isolation, lower peaks

### Quality
- ✅ Backward compatibility: 100% (no breaking changes)
- ⏳ Classification accuracy: ≥ 90% maintained
- ⏳ Test coverage: All agents have examples
- ⏳ Error handling: Graceful failure recovery

### Maintainability
- ✅ Code organization: Cleaner separation
- ✅ Debuggability: Easier to trace issues
- ✅ Extensibility: Easier to add new analysis types
- ⏳ Documentation: Complete and accurate

---

## Next Steps

### Immediate (Next Session)
1. ✅ Update `/work` command documentation (~30 min)
2. ✅ Add headers to 4 reference files (~15 min)
3. ✅ Test task-classifier thoroughly (~30 min)
4. Commit Phase A completion

### Short Term (This Week)
5. Create existing-feature-analyzer agent (~4 hours)
6. Update enhancement-orchestrator Phase 0 (~1 hour)
7. Test Phase B thoroughly (~2 hours)
8. Commit Phase B completion

### Medium Term (Next Week)
9. Create gap-analyzer agent (~6 hours)
10. Update enhancement-orchestrator Phase 1 (~1 hour)
11. Test Phase C thoroughly (~2 hours)
12. Commit Phase C completion

### Final (End of Project)
13. Final integration testing (~3 hours)
14. Performance benchmarking (~1 hour)
15. Documentation updates (~1 hour)
16. Final commit and PR

---

## Rollback Plan

If critical issues discovered:

### Rollback Task Classifier
```bash
# Revert agent
rm agents/task-classifier.md

# Restore skill
git checkout HEAD -- skills/task-classifier/SKILL.md

# Test
/work "Fix bug" # Should work with old inline logic
```

### Rollback Feature Analyzer
```bash
# Revert agent
rm agents/existing-feature-analyzer.md

# Restore orchestrator
git checkout HEAD -- skills/enhancement-orchestrator/SKILL.md

# Test
/ai-sdlc:enhancement:new "Test" # Should work with old inline logic
```

### Rollback Gap Analyzer
```bash
# Revert agent
rm agents/gap-analyzer.md

# Restore orchestrator
git checkout HEAD -- skills/enhancement-orchestrator/SKILL.md

# Test
# Phase 1 should work with old inline logic
```

---

## Notes & Observations

### 2025-10-29 - Implementation Start
- Started with task-classifier (Phase A)
- Agent pattern works well, frontmatter format confirmed
- Embedding references avoids path resolution issues
- Skill reduction significant (781 → 243 lines, 69% reduction)
- Next: Complete Phase A testing before moving to Phase B

### Future Observations
_[Add notes as implementation progresses]_

---

## References

- **Main Plan Document:** `subagent-refactoring-plan.md` (this file)
- **Architecture Decisions:** Based on Claude Code best practices for subagents
- **Plugin Documentation:** https://docs.claude.com/en/docs/claude-code/plugins
- **Subagent Documentation:** https://docs.claude.com/en/docs/claude-code/sub-agents
- **Skills Documentation:** https://docs.claude.com/en/docs/claude-code/skills

---

**Last Updated:** 2025-10-29 by Claude (Sonnet 4.5)
**Next Review:** After Phase A completion
