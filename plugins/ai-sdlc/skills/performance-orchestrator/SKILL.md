---
name: performance-orchestrator
description: Orchestrates performance optimization workflows with profiling, benchmarking, and load testing. Measures baseline, identifies bottlenecks, implements optimizations incrementally with benchmarks, and verifies production readiness.
---

# Performance Orchestrator

Systematic performance optimization workflow from profiling to production-ready deployment.

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

## Progress Tracking

Use `TodoWrite` to show real-time progress to the user. Create todos at workflow start, update at each phase transition.

**Phase Todos**:

| Phase | content | activeForm |
|-------|---------|------------|
| 0 | "Profile and establish baseline" | "Profiling and establishing baseline" |
| 1 | "Analyze bottlenecks and plan" | "Analyzing bottlenecks and planning" |
| 2 | "Implement with benchmarking" | "Implementing with benchmarking" |
| 3 | "Verify performance improvements" | "Verifying performance improvements" |
| 4 | "Load test and check readiness" | "Load testing and checking readiness" |

**Rules**:
- Create all phase todos at workflow start (pending)
- Mark current phase `in_progress` before execution
- Mark phase `completed` immediately after success
- State file remains source of truth for resume logic

---

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

Performance Issue: [description]
Mode: [Interactive/YOLO]

Workflow Phases:
0. [ ] Performance Baseline & Profiling → performance-profiler subagent
1. [ ] Bottleneck Analysis & Planning → bottleneck-analyzer subagent
2. [ ] Implementation with Benchmarking → main orchestrator
3. [ ] Performance Verification → performance-verifier subagent
4. [ ] Load Testing & Production Readiness → main orchestrator

State file: [task-path]/orchestrator-state.yml

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Performance Baseline & Profiling...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Performance Baseline & Profiling).

---

## Execution Modes

**Interactive** (default): Pause after each phase for review
**YOLO**: Continuous execution without pauses

## Workflow Overview

5-phase workflow (0-4):

1. **Phase 0**: Performance Baseline & Profiling → Delegate to `performance-profiler`
2. **Phase 1**: Bottleneck Analysis & Planning → Delegate to `bottleneck-analyzer`
3. **Phase 2**: Implementation with Benchmarking → Orchestrator (or delegate complex to `implementation-changes-planner`)
4. **Phase 3**: Performance Verification → Delegate to `performance-verifier`
5. **Phase 4**: Load Testing & Production Readiness → Orchestrator (optional delegate to `production-readiness-checker`)

---

## Phase Execution

### Phase 0: Performance Baseline & Profiling

**Delegate to**: `performance-profiler` subagent

**Invoke performance-profiler via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:performance-profiler"
- description: "Profile and establish baseline"
- prompt: |
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

**Update State**:
```yaml
orchestrator_state:
  current_phase: 1
  last_completed_phase: 0
  phases_completed: [0]
```

---

### Phase 1: Bottleneck Analysis & Optimization Planning

**Delegate to**: `bottleneck-analyzer` subagent

**Invoke bottleneck-analyzer via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:bottleneck-analyzer"
- description: "Analyze bottlenecks and plan"
- prompt: |
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

**Update State**:
```yaml
orchestrator_state:
  current_phase: 2
  last_completed_phase: 1
  phases_completed: [0, 1]
  optimization_count: [from plan]
  target_improvement: [from plan]
```

---

### Phase 2: Implementation with Benchmarking

**Execution**: Main orchestrator (delegates complex optimizations to `implementation-changes-planner`)

**Standards Reminder**: Review `.ai-sdlc/docs/INDEX.md` for relevant performance and coding standards before implementing optimizations.

**Process**:

For each optimization in `optimization-plan.md` (in priority order: P0 → P1 → P2 → P3):

**Step 1: Read Optimization Details**
```
Load optimization details from implementation/optimization-plan.md:
- Optimization ID
- Type (database/algorithm/I/O/memory/caching)
- Location (file:line)
- Fix strategy
- Target improvement
- Implementation steps
```

**Step 2: Benchmark Before**
```bash
# Measure current performance for this specific optimization target
# Use same methodology as baseline
wrk -t4 -c100 -d30s http://localhost:3000/[target-endpoint]
# Save to: implementation/benchmarks/opt-[id]-before.txt
```

**Step 3: Implement Optimization**

**If Simple** (1-3 file changes):
- Apply changes directly using Edit tool
- Follow implementation steps from plan

**If Complex** (4+ file changes or unclear approach):
- Delegate to `implementation-changes-planner` subagent:
  ```
  Create detailed change plan for optimization:
  [optimization details]

  Return change plan with file modifications.
  Do NOT apply changes, only plan them.
  ```
- Apply changes from returned plan using Edit tool

**Step 4: Benchmark After**
```bash
# Re-measure performance
wrk -t4 -c100 -d30s http://localhost:3000/[target-endpoint]
# Save to: implementation/benchmarks/opt-[id]-after.txt
```

**Step 5: Verify Improvement**
```
Calculate improvement:
- Before: [metric]
- After: [metric]
- Improvement: [percentage]

If improvement >= target: ✅ Success
If improvement < target: ⚠️ Gap documented, proceed anyway
```

**Step 6: Run Tests**
```bash
# Run relevant test suite
npm test  # or appropriate test command

If tests fail:
  - Rollback optimization using git
  - Mark as failed in optimization-plan.md
  - Continue to next optimization
```

**Step 7: Update Plan**
```
Update implementation/optimization-plan.md:
- Mark optimization as complete
- Document actual improvement
- Note any issues encountered
```

**Outputs**:
- Modified code files
- `implementation/benchmarks/*.txt` - Before/after benchmarks
- `implementation/optimization-plan.md` - Updated with results

**Success**: All optimizations implemented (or attempted), benchmarked, documented

**Update State**:
```yaml
orchestrator_state:
  current_phase: 3
  last_completed_phase: 2
  phases_completed: [0, 1, 2]
  optimizations_completed: [list]
  optimizations_failed: [list]
```

---

### Phase 3: Performance Verification

**Delegate to**: `performance-verifier` subagent

**Invoke performance-verifier via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:performance-verifier"
- description: "Verify performance improvements"
- prompt: |
    You are the performance-verifier agent. Verify performance optimizations
    achieved target improvements.

Task directory: [task-path]

Please:
1. Load baseline metrics from analysis/performance-baseline.md
2. Load optimization targets from implementation/optimization-plan.md
3. Re-measure all performance metrics (same methodology as baseline):
   - Response time (p50, p95, p99)
   - Throughput (req/sec)
   - CPU usage
   - Memory usage
   - Database queries
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

**Success**: Verification complete, verdict determined

**Update State**:
```yaml
orchestrator_state:
  current_phase: 4 (if PASS) or halt (if FAIL)
  last_completed_phase: 3
  phases_completed: [0, 1, 2, 3]
  verification_verdict: [PASS/PASS with Concerns/FAIL]
  overall_improvement: [percentage]
```

**Gate**: Cannot proceed to Phase 4 if verdict = FAIL

---

### Phase 4: Load Testing & Production Readiness

**Execution**: Main orchestrator (optionally delegates to `production-readiness-checker`)

**Prerequisites**: Phase 3 verdict = PASS or PASS with Concerns

**Step 1: Configure Load Tests**

Define test scenarios based on production traffic:
```javascript
// Ramp-up test
stages: [
  { duration: '2m', target: 100 },
  { duration: '5m', target: 100 },
  { duration: '2m', target: 200 },
  { duration: '5m', target: 200 },
]

// Sustained load test
vus: 500,
duration: '30m'

// Spike test
stages: [
  { duration: '10s', target: 100 },
  { duration: '10s', target: 1000 },  // 10x spike
  { duration: '3m', target: 1000 },
]
```

**Step 2: Run Load Tests**
```bash
# Execute load test scenarios
k6 run --vus 100 --duration 5m ramp-up-test.js
k6 run --vus 500 --duration 30m sustained-load-test.js
k6 run spike-test.js
```

**Step 3: Monitor Resources**

During load tests, monitor:
- CPU usage (should stay <90%)
- Memory usage (should be stable, no leaks)
- Database connection pool utilization
- Error rates (<1% acceptable)

**Step 4: Analyze Results**

```
Response time under load:
- Normal load (100 users): p95 = [value]
- Peak load (500 users): p95 = [value]
- Spike (1000 users): p95 = [value], error rate = [value]

Throughput capacity:
- Sustained: [req/s] for 30 minutes
- Peak: [req/s] before errors increase

Resource usage:
- CPU: [average]%, peak [peak]%
- Memory: [size], growth [rate]
- Connections: [used]/[total]
```

**Step 5: Production Readiness (Optional)**

If deploying to production, optionally delegate to `production-readiness-checker`:
```
Check production readiness for optimized application:
- Configuration management
- Monitoring & observability
- Error handling & resilience
- Security hardening
- Deployment considerations

Generate production readiness report.
```

**Step 6: Generate Load Test Report**

Create `verification/load-test-results.md`:
```markdown
# Load Test Results

## Ramp-Up Test
[Results and analysis]

## Sustained Load Test
[Results and analysis]

## Spike Test
[Results and analysis]

## Resource Monitoring
[CPU, memory, connections]

## Overall Status
✅ Ready for Production
⚠️ Ready with Monitoring
❌ Not Ready

Recommendation: [deployment decision]
```

**Outputs**:
- `verification/load-test-results.md`
- `verification/production-readiness-report.md` (optional)

**Success**: Load tests pass, production readiness verified

**Update State**:
```yaml
orchestrator_state:
  current_phase: 4
  last_completed_phase: 4
  phases_completed: [0, 1, 2, 3, 4]
  workflow_status: completed
  overall_status: [Ready/Ready with Monitoring/Not Ready]
```

---

## State Management

**State File**: `.ai-sdlc/tasks/performance/[dated-name]/orchestrator-state.yml`

```yaml
orchestrator:
  mode: interactive  # or yolo
  started_phase: 0
  current_phase: 3
  completed_phases: [0, 1, 2]
  failed_phases: []

  auto_fix_attempts:
    phase-0: 0
    phase-1: 0
    phase-2: 2
    phase-3: 0
    phase-4: 0

  performance_context:
    baseline_p95: 450ms
    target_p95: 200ms
    optimizations_planned: 6
    optimizations_completed: 6
    verification_verdict: "PASS"
    overall_improvement: "60%"

  options:
    skip_load_testing: false
    skip_production_check: false

  created: 2025-11-16T10:00:00Z
  updated: 2025-11-16T14:30:00Z
  task_path: .ai-sdlc/tasks/performance/2025-11-16-optimize-dashboard
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| **Phase 0** | 2 | Expand profiling, try alternatives, prompt user |
| **Phase 1** | 2 | Prompt user if bottleneck unclear, use conservative estimates |
| **Phase 2** | 3 | Fix syntax errors, retry benchmarks, rollback failed optimizations |
| **Phase 3** | 0 | Read-only, report only |
| **Phase 4** | 1 | Retry failed load tests, adjust parameters |

---

## Integration Points

**Documentation System**:
- Read `.ai-sdlc/docs/INDEX.md` for performance standards
- Follow optimization best practices from standards

**Testing**:
- Run test suite after each optimization
- Ensure no regressions introduced

**Production Deployment**:
- Optional integration with `production-readiness-checker`
- Verify monitoring, error handling, scalability

---

## Reference Files

See `references/` directory:
- `workflow-phases.md` - Detailed phase descriptions with dependencies
- `performance-optimization-guide.md` - Metrics, profiling, optimization patterns, benchmarking

---

## Related Skills

**Subagents**:
- `performance-profiler` - Baseline measurement
- `bottleneck-analyzer` - Bottleneck identification
- `performance-verifier` - Optimization verification

**Optional Integration**:
- `implementation-changes-planner` - Complex optimization planning
- `production-readiness-checker` - Deployment readiness

---

## Command Integration

Invoked via:
- `/ai-sdlc:performance:new [description] [--yolo]`
- `/ai-sdlc:performance:resume [task-path]`

See `commands/performance/new.md` and `commands/performance/resume.md` for command specifications.

---

## Success Criteria

Workflow successful when:

✅ Performance baseline documented with all metrics
✅ Bottlenecks identified and prioritized
✅ All P0 optimizations implemented and verified
✅ Verification verdict = PASS (targets met, no critical regressions)
✅ Load tests pass under production-like load
✅ Production readiness verified (if applicable)
✅ Overall performance improvement 50-70%+
✅ Ready for production deployment

Performance optimization orchestration provides complete, quantifiable, benchmark-driven workflow from performance issue to production-ready optimization.
