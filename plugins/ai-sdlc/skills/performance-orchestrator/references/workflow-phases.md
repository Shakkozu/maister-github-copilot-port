# Workflow Phases Reference

5-phase performance optimization workflow with dependencies, state transitions, and execution patterns.

## Workflow Overview

```
Phase 0: Performance Baseline & Profiling
    ↓
Phase 1: Bottleneck Analysis & Optimization Planning
    ↓
Phase 2: Implementation with Benchmarking
    ↓
Phase 3: Performance Verification
    ↓
Phase 4: Load Testing & Production Readiness
```

**Total Phases**: 5 (0-4)
**Execution Modes**: Interactive (pause between phases) or YOLO (continuous)
**Auto-Recovery**: Limited (Phase 0-2: max 2-3 attempts, Phase 3-4: 0-1 attempts)

---

## Phase 0: Performance Baseline & Profiling

**Agent**: `performance-profiler` (read-only subagent)

**Input**: Performance issue description

**Process**:
1. Identify performance target (endpoints, feature areas, or entire app)
2. Measure response time (p50, p95, p99, max)
3. Measure throughput (req/sec, saturation point)
4. Profile CPU usage (hot functions, cumulative time)
5. Profile memory usage (heap size, growth, leaks)
6. Count database queries (N+1 patterns, slow queries)
7. Identify performance hotspots
8. Generate comprehensive baseline report

**Output**: `analysis/performance-baseline.md` with quantitative metrics

**Success Criteria**:
- ✅ All metrics measured (response time, throughput, CPU, memory, database)
- ✅ Hotspots identified and categorized
- ✅ Baseline report complete with targets

**Auto-Fix**: Max 2 attempts
- Expand profiling if tools unavailable (use manual timing, log parsing)
- Use alternative profiling methods

**Failure Handling**: If target code not found or profiling fails after 2 attempts, HALT and ask user

---

## Phase 1: Bottleneck Analysis & Optimization Planning

**Agent**: `bottleneck-analyzer` (read-only subagent)

**Input**: `analysis/performance-baseline.md` from Phase 0

**Process**:
1. Load performance baseline metrics
2. Analyze database performance (detect N+1 queries, missing indexes)
3. Review CPU hotspots (identify inefficient algorithms)
4. Detect memory issues (memory leaks, excessive allocations)
5. Identify I/O bottlenecks (blocking operations, slow external APIs)
6. Classify bottlenecks by type (database, algorithm, I/O, memory, caching)
7. Assess impact and effort for each bottleneck
8. Create prioritized optimization plan

**Output**: `implementation/optimization-plan.md` with prioritized optimizations

**Success Criteria**:
- ✅ All bottlenecks identified and classified
- ✅ Impact and effort scored
- ✅ Optimizations prioritized (P0/P1/P2/P3)
- ✅ Implementation steps documented for each optimization
- ✅ Target improvements defined

**Auto-Fix**: Max 2 attempts
- Prompt user if bottleneck classification unclear
- Use conservative estimates if complexity unclear

**Failure Handling**: If optimization strategy unclear after 2 attempts, HALT and ask user

---

## Phase 2: Implementation with Benchmarking

**Agent**: Main orchestrator (delegates to `implementation-changes-planner` for complex optimizations)

**Input**: `implementation/optimization-plan.md` from Phase 1

**Process**:

**For Each Optimization** (in priority order: P0 → P1 → P2 → P3):

1. **Benchmark Before**: Measure current performance for specific optimization target
   ```bash
   # Example: Benchmark specific endpoint before fixing N+1 query
   wrk -t4 -c100 -d30s http://localhost:3000/api/orders
   ```

2. **Implement Optimization**:
   - Mode 1 (simple): Main orchestrator applies fix directly
   - Mode 2 (complex): Delegate planning to `implementation-changes-planner` subagent
   - Apply code changes from plan

3. **Benchmark After**: Re-measure performance
   ```bash
   # Same test after optimization
   wrk -t4 -c100 -d30s http://localhost:3000/api/orders
   ```

4. **Verify Improvement**: Compare before/after
   - Calculate improvement percentage
   - Check if meets target from optimization plan
   - If improvement < target: Document gap, proceed anyway (user decides)

5. **Run Tests**: Verify functionality not broken
   - Run relevant test suite
   - If tests fail: Rollback optimization, document failure

6. **Document Results**: Update optimization-plan.md with actual results

**Output**:
- Optimized code (multiple files modified)
- `implementation/benchmarks/*.txt` - Benchmark results per optimization
- `implementation/optimization-plan.md` - Updated with completion status

**Success Criteria (Per Optimization)**:
- ✅ Code changes applied
- ✅ Benchmark shows improvement
- ✅ Tests pass
- ✅ Results documented

**Auto-Fix**: Max 3 attempts
- Fix syntax errors, missing imports
- Retry failed benchmarks
- Adjust optimization if target not met

**Failure Handling**:
- If optimization breaks tests: Rollback, mark as failed, continue to next
- If benchmark shows regression: Rollback, document, continue to next
- If max attempts exceeded: HALT, user must investigate

**Incremental Approach**:
- Implement one optimization at a time
- Benchmark after each
- Don't batch multiple optimizations (can't attribute improvement)

---

## Phase 3: Performance Verification

**Agent**: `performance-verifier` (read-only subagent)

**Input**:
- `analysis/performance-baseline.md` from Phase 0
- `implementation/optimization-plan.md` from Phase 2 (with results)
- Optimized code

**Process**:
1. Load baseline metrics
2. Re-measure all performance metrics (same methodology as Phase 0)
   - Response time (p50, p95, p99)
   - Throughput (req/sec)
   - CPU usage
   - Memory usage
   - Database queries
3. Compare baseline vs optimized
4. Calculate improvement percentages
5. Verify targets met (from optimization plan)
6. Check for regressions (other endpoints slower)
7. Generate verification report with PASS/FAIL verdict

**Output**: `verification/performance-verification.md` with PASS/FAIL verdict

**Success Criteria**:
- ✅ All metrics re-measured using same methodology
- ✅ Improvement percentages calculated
- ✅ Optimization targets verified (met/not met)
- ✅ Regression analysis complete
- ✅ Verdict determined

**Auto-Fix**: Max 0 attempts (read-only, reports only)

**Failure Handling**: If verification shows targets not met or regressions, report in verification document, don't modify code

**Verdict Criteria**:
- ✅ **PASS**: All critical targets met, no critical regressions
- ⚠️ **PASS with Concerns**: Most targets met (>80%), minor regressions only
- ❌ **FAIL**: Critical targets not met (<80%) or critical regressions introduced

**Cannot Proceed to Phase 4 if**: Verdict = FAIL

---

## Phase 4: Load Testing & Production Readiness

**Agent**: Main orchestrator (optionally delegates to `production-readiness-checker`)

**Input**: `verification/performance-verification.md` from Phase 3 (PASS required)

**Process**:
1. **Configure Load Tests**: Define production-like traffic patterns
   - Ramp-up testing (gradual load increase)
   - Sustained load (constant traffic for 10-30 minutes)
   - Spike testing (sudden traffic increase)
   - Stress testing (find breaking point)

2. **Run Load Tests**:
   ```bash
   # Ramp-up test
   k6 run --vus 100 --duration 5m ramp-up-test.js

   # Sustained load test
   k6 run --vus 500 --duration 30m sustained-load-test.js

   # Spike test
   k6 run --vus 1000 --duration 2m spike-test.js
   ```

3. **Monitor Resource Usage**:
   - CPU usage during peak load
   - Memory usage (check for leaks during sustained load)
   - Database connection pool utilization
   - Network bandwidth
   - Disk I/O

4. **Analyze Results**:
   - Response time distribution under load
   - Error rates at different load levels
   - Throughput ceiling (max req/sec before degradation)
   - Resource saturation points

5. **Verify Production Readiness** (Optional):
   - Delegate to `production-readiness-checker` skill
   - Checks configuration, monitoring, error handling, scalability
   - Generates production readiness report

6. **Generate Load Test Report**

**Output**:
- `verification/load-test-results.md` - Comprehensive load testing report
- `verification/production-readiness-report.md` - (Optional) Production readiness assessment

**Success Criteria**:
- ✅ Load tests pass under production-like traffic
- ✅ Response time acceptable under peak load
- ✅ Error rates low (<1%) under normal load
- ✅ No resource exhaustion (CPU <90%, memory stable)
- ✅ No memory leaks detected during sustained load
- ✅ Production readiness verified (if applicable)

**Auto-Fix**: Max 1 attempt
- Retry failed load tests
- Adjust load test parameters if too aggressive

**Failure Handling**:
- If load tests fail: Document issues, recommend capacity planning or further optimization
- If production readiness not met: Document gaps, recommend fixes before deployment

**Overall Status**:
- ✅ **Ready for Production**: All tests pass, ready to deploy
- ⚠️ **Ready with Monitoring**: Tests mostly pass, deploy with close monitoring
- ❌ **Not Ready**: Significant issues, require fixes before production

---

## Phase Dependencies

**Prerequisite Requirements**:

**Phase 1** requires:
- Phase 0 complete
- `analysis/performance-baseline.md` exists

**Phase 2** requires:
- Phase 1 complete
- `implementation/optimization-plan.md` exists

**Phase 3** requires:
- Phase 2 complete
- At least 1 optimization implemented

**Phase 4** requires:
- Phase 3 complete
- Verification verdict = PASS or PASS with Concerns
- Cannot proceed if verdict = FAIL

---

## State Transitions

**Valid Transitions**:
```
-1 (Start) → 0 → 1 → 2 → 3 → 4 (Complete)
                        ↓
                     HALT (if verification FAIL)
```

**Invalid Transitions**:
- ❌ Cannot skip phases (e.g., 0 → 2)
- ❌ Cannot proceed to Phase 4 if Phase 3 verdict = FAIL
- ❌ Cannot proceed if prerequisite outputs missing

---

## Execution Modes

### Interactive Mode (Default)

**Behavior**: Pause after each phase, prompt user to continue

**User Prompts**:
- After Phase 0: "Baseline complete. Continue to bottleneck analysis?"
- After Phase 1: "Optimization plan created. Review plan before implementing?"
- After Phase 2: "Optimizations implemented. Run verification?"
- After Phase 3: "Verification complete (PASS). Run load testing?"

**User Actions**: Approve to continue, or stop to review

### YOLO Mode

**Behavior**: Continuous execution, no pauses

**Command**: `/ai-sdlc:performance:new [description] --yolo`

**Stops Only If**:
- Phase fails after auto-fix attempts exhausted
- Phase 3 verification verdict = FAIL
- Load tests fail in Phase 4

---

## Error Recovery

### Phase 0-1: Limited Auto-Fix

**Max Attempts**: 2 per phase

**Strategy**:
- Expand search/profiling if tools unavailable
- Try alternative methods
- Prompt user if unresolved

**If Unresolved**: HALT, ask user for input

### Phase 2: Moderate Auto-Fix

**Max Attempts**: 3 per optimization

**Strategy**:
- Fix syntax errors automatically
- Retry failed benchmarks
- Rollback and try alternative approach

**If Unresolved**: Mark optimization as failed, continue to next optimization

### Phase 3-4: Report Only

**Max Attempts**: 0-1

**Strategy**:
- Report issues with evidence
- Don't modify code
- Provide recommendations

**User Action**: Review findings, decide whether to proceed

---

## Workflow Completion

### Success Path

```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ✅ (PASS) → Phase 4 ✅

Final State:
- workflow_status: completed
- overall_status: Success
- All optimizations complete and verified
- Ready for production deployment
```

### Failure Paths

**Failure in Phase 3** (Verification FAIL):
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ❌ (FAIL verdict)
                                          ↓
                                    HALT (cannot proceed to Phase 4)

Final State:
- workflow_status: failed
- failed_phase: phase-3-verification
- Targets not met or critical regressions
- Require additional optimization work
```

**Failure in Phase 4** (Load Testing FAIL):
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ✅ → Phase 4 ❌ (Not Ready)

Final State:
- workflow_status: completed_with_issues
- Performance improved but not production-ready
- Require capacity planning or further optimization
```

---

This workflow ensures systematic, measurable performance optimization with clear quality gates.
