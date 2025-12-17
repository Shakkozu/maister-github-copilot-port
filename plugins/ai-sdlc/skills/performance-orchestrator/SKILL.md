---
name: performance-orchestrator
description: Orchestrates performance optimization workflows with profiling, benchmarking, and load testing. Measures baseline, identifies bottlenecks, implements optimizations incrementally with benchmarks, and verifies production readiness.
---

# Performance Orchestrator

Systematic performance optimization workflow from profiling to production-ready deployment.

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Profile and establish baseline", "status": "pending", "activeForm": "Profiling and establishing baseline"},
  {"content": "Analyze bottlenecks and plan", "status": "pending", "activeForm": "Analyzing bottlenecks and planning"},
  {"content": "Implement with benchmarking", "status": "pending", "activeForm": "Implementing with benchmarking"},
  {"content": "Verify performance improvements", "status": "pending", "activeForm": "Verifying performance improvements"},
  {"content": "Load test and check readiness", "status": "pending", "activeForm": "Load testing and checking readiness"}
]
```

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Performance Orchestrator Started

Task: [performance issue description]
Mode: [Interactive/YOLO]
Directory: [task-path]

Workflow phases:
[Todos list with status]

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Profile and establish baseline...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Performance Baseline & Profiling).

---

## When to Use This Skill

Use when:
- Application slow (response time >1s, high latency)
- Need systematic optimization workflow
- Want benchmarking and verification
- Require load testing before production
- Performance issues reported

## Core Principles

1. **Measure First**: Never optimize without baseline metrics
2. **Benchmark-Driven**: Prove every optimization with benchmarks
3. **Incremental**: One optimization at a time (attribute improvements)
4. **Production-Realistic**: Test with real data volumes and traffic patterns
5. **Quantitative**: Use objective metrics, not subjective feelings

---

## Framework Patterns

This orchestrator follows shared patterns. See:

- **Phase Execution**: `../orchestrator-framework/references/phase-execution-pattern.md`
- **State Management**: `../orchestrator-framework/references/state-management.md`
- **Interactive Mode**: `../orchestrator-framework/references/interactive-mode.md`
- **Initialization**: `../orchestrator-framework/references/initialization-pattern.md`

## Local References

Read these during relevant phases:

| File | When to Use | Purpose |
|------|-------------|---------|
| `references/performance-optimization-guide.md` | Phase 1-2 | Optimization patterns, bottleneck classifications, benchmarking strategies |

---

## Phase Configuration

| Phase | content | activeForm | Agent/Skill |
|-------|---------|------------|-------------|
| 0 | "Profile and establish baseline" | "Profiling and establishing baseline" | performance-profiler |
| 1 | "Analyze bottlenecks and plan" | "Analyzing bottlenecks and planning" | bottleneck-analyzer |
| 2 | "Implement with benchmarking" | "Implementing with benchmarking" | orchestrator |
| 3 | "Verify performance improvements" | "Verifying performance improvements" | performance-verifier |
| 4 | "Load test and check readiness" | "Load testing and checking readiness" | orchestrator |

**Workflow Overview**: 5 phases (0-4)

**CRITICAL TodoWrite Usage**:
1. At workflow start: Create todos for ALL phases using the Phase Configuration table above (all status=pending)
2. Before each phase: Update that phase to status=in_progress
3. After each phase: Update that phase to status=completed

---

## Workflow Phases

### Phase 0: Performance Baseline & Profiling

**Delegate to**: `performance-profiler` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:performance-profiler"
description: "Profile and establish baseline"
prompt: |
  You are the performance-profiler agent. Analyze application performance
  and create a comprehensive baseline report.

  Performance Issue: [user description]
  Task directory: [task-path]

  Please:
  1. Identify performance target from description
  2. Measure response time (p50, p95, p99) using load testing
  3. Measure throughput (req/sec, saturation point)
  4. Profile CPU usage (hot functions)
  5. Profile memory usage (heap size, growth, leaks)
  6. Count database queries (N+1 patterns, slow queries)
  7. Identify performance hotspots
  8. Generate comprehensive baseline report

  Save to: analysis/performance-baseline.md
  Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `analysis/performance-baseline.md`, profiling artifacts

**Success**: All metrics measured, hotspots identified, baseline documented

**State Update**: After performance-profiler completes:
- Update `performance_context.baseline_p95` from output p95 response time (milliseconds)
- Update `performance_context.target_p95` from output optimization target (if specified)

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 1.

---

### Phase 1: Bottleneck Analysis & Optimization Planning

**Delegate to**: `bottleneck-analyzer` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:bottleneck-analyzer"
description: "Analyze bottlenecks and plan"
prompt: |
  You are the bottleneck-analyzer agent. Analyze performance baseline
  data and create prioritized optimization plan.

  Task directory: [task-path]

  Please:
  1. Load performance baseline from analysis/performance-baseline.md
  2. Analyze database performance (detect N+1 queries, missing indexes)
  3. Review CPU hotspots (identify inefficient algorithms)
  4. Detect memory issues (leaks, excessive allocations)
  5. Identify I/O bottlenecks (blocking operations, slow APIs)
  6. Classify bottlenecks by type
  7. Assess impact and effort for each bottleneck
  8. Create prioritized optimization plan (P0/P1/P2/P3)

  Save to: implementation/optimization-plan.md
  Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `implementation/optimization-plan.md`

**Success**: Bottlenecks identified, priorities assigned, implementation steps documented

**State Update**: After bottleneck-analyzer completes:
- Update `performance_context.optimizations_planned` from output total optimization count

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 2.

---

### Phase 2: Implementation with Benchmarking

**Execution**: Main orchestrator (delegates complex optimizations to `implementation-changes-planner`)

**Standards Reminder**: Review `.ai-sdlc/docs/INDEX.md` for performance standards before implementing.

**Process** (for each optimization in priority order P0 → P1 → P2 → P3):

1. **Read Optimization Details** from `implementation/optimization-plan.md`
2. **Benchmark Before** - Measure current performance for target endpoint
3. **Implement Optimization** - Simple: Edit directly. Complex: Delegate to `implementation-changes-planner`
4. **Benchmark After** - Re-measure performance
5. **Verify Improvement** - Calculate percentage improvement vs target
6. **Run Tests** - Ensure no regressions
7. **Update Plan** - Mark optimization complete/failed, document results
8. **State Update** - After each optimization completes: Increment `performance_context.optimizations_completed`

**Outputs**:
- Modified code files
- `implementation/benchmarks/*.txt` - Before/after benchmarks
- Updated `implementation/optimization-plan.md`

**Success**: All optimizations implemented (or attempted), benchmarked, documented

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 3.

---

### Phase 3: Performance Verification

**Delegate to**: `performance-verifier` subagent

**Task tool invocation**:
```
subagent_type: "ai-sdlc:performance-verifier"
description: "Verify performance improvements"
prompt: |
  You are the performance-verifier agent. Verify performance optimizations
  achieved target improvements.

  Task directory: [task-path]

  Please:
  1. Load baseline metrics from analysis/performance-baseline.md
  2. Load optimization targets from implementation/optimization-plan.md
  3. Re-measure all performance metrics (same methodology as baseline)
  4. Compare baseline vs optimized (calculate improvement percentages)
  5. Verify optimization targets met
  6. Check for regressions (other endpoints slower)
  7. Generate verification report with PASS/FAIL verdict

  Save to: verification/performance-verification.md
  Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.

  Verdict Criteria:
  - PASS: All critical targets met, no critical regressions
  - PASS with Concerns: Most targets met (>80%), minor regressions only
  - FAIL: Critical targets not met (<80%) or critical regressions
```

**Outputs**: `verification/performance-verification.md` with verdict

**Gate**: Cannot proceed to Phase 4 if verdict = FAIL

**State Update**: After performance-verifier completes:
- Update `performance_context.verification_verdict` from output verdict ("PASS", "PASS with Concerns", or "FAIL")
- Update `performance_context.overall_improvement` from output percentage (e.g., "65%")

**⏸️ INTERACTIVE MODE: STOP HERE** - After this phase completes, use `AskUserQuestion` before proceeding to Phase 4.

---

### Phase 4: Load Testing & Production Readiness

**State Update**: When deciding which optional checks to run (Interactive or YOLO):
- Set `options.skip_load_testing` based on user choice or auto-decision (default: false)
- Set `options.skip_production_check` based on user choice or auto-decision (default: false for production deployments)

**Execution**: Main orchestrator (optionally delegates to `production-readiness-checker`)

**Prerequisites**: Phase 3 verdict = PASS or PASS with Concerns

**Process**:

1. **Configure Load Tests** - Define scenarios (ramp-up, sustained, spike)
2. **Run Load Tests** - Execute using k6 or similar tool
3. **Monitor Resources** - CPU (<90%), memory (stable), connections, error rates (<1%)
4. **Analyze Results** - Response times under load, throughput capacity
5. **Production Readiness** (optional) - Delegate to `production-readiness-checker`
6. **Generate Report** - Create `verification/load-test-results.md`

**Load Test Scenarios**:
- Ramp-up: Gradually increase to 200 VUs over 10 minutes
- Sustained: 500 VUs for 30 minutes
- Spike: 10x sudden increase to 1000 VUs

**Outputs**:
- `verification/load-test-results.md`
- `verification/production-readiness-report.md` (optional)

**Success**: Load tests pass, production readiness verified

---

## Domain Context (State Extensions)

Performance-specific fields in `orchestrator-state.yml`:

```yaml
performance_context:
  baseline_p95: [milliseconds]
  target_p95: [milliseconds]
  optimizations_planned: [number]
  optimizations_completed: [number]
  verification_verdict: "PASS" | "PASS with Concerns" | "FAIL"
  overall_improvement: "[percentage]%"

options:
  skip_load_testing: false
  skip_production_check: false
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| 0 | 2 | Expand profiling, try alternatives, prompt user |
| 1 | 2 | Prompt user if bottleneck unclear, use conservative estimates |
| 2 | 3 | Fix syntax errors, retry benchmarks, rollback failed optimizations |
| 3 | 0 | Read-only, report only |
| 4 | 1 | Retry failed load tests, adjust parameters |

---

## Command Integration

Invoked via:
- `/ai-sdlc:performance:new [description] [--yolo]`
- `/ai-sdlc:performance:resume [task-path]`

Task directory: `.ai-sdlc/tasks/performance/YYYY-MM-DD-task-name/`

---

## Success Criteria

Workflow successful when:

- Performance baseline documented with all metrics
- Bottlenecks identified and prioritized
- All P0 optimizations implemented and verified
- Verification verdict = PASS (targets met, no critical regressions)
- Load tests pass under production-like load
- Overall performance improvement 50-70%+
- Ready for production deployment
