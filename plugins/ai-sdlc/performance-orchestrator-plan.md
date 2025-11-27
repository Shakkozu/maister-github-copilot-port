# Performance Orchestrator Implementation Plan

## Overview

**Purpose**: Orchestrate performance optimization workflows with benchmarking, profiling, and load testing.

**Task Type**: Performance optimization (5 stages)
**Classification Keywords**: "slow", "optimize", "speed up", "faster", "performance"

**Total Files to Create**: 10 files
**Estimated Time**: 3-4 hours

---

## Workflow Phases (5 phases)

1. **Phase 0: Performance Baseline & Profiling**
   - Measure current performance metrics (response time, throughput, CPU, memory, query count)
   - Profile application to identify hotspots
   - Document baseline for comparison

2. **Phase 1: Bottleneck Analysis & Optimization Planning**
   - Analyze profiling data to identify bottlenecks
   - Classify performance issues (N+1 queries, missing indexes, inefficient algorithms, memory leaks)
   - Create incremental optimization plan with target improvements
   - Prioritize optimizations by impact vs effort

3. **Phase 2: Implementation with Benchmarking**
   - Implement optimizations incrementally
   - Benchmark after each optimization
   - Verify improvement meets targets
   - Standards-compliant implementation

4. **Phase 3: Performance Verification**
   - Re-run performance tests to measure improvement
   - Compare baseline vs optimized metrics
   - Verify no regressions introduced
   - Calculate improvement percentages

5. **Phase 4: Load Testing & Production Readiness**
   - Conduct load testing under production-like conditions
   - Verify performance holds under stress
   - Check resource utilization (CPU, memory, connections)
   - Validate production readiness

---

## Files to Create

### Subagents (3 files)

#### 1. `agents/performance-profiler.md` (~600 lines)

**Purpose**: Baseline performance metrics collection and profiling

**Capabilities**:
- Measure response time (p50, p95, p99)
- Measure throughput (requests/sec)
- Profile CPU usage
- Profile memory usage
- Count database queries
- Identify slow endpoints/functions
- Generate performance baseline report

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `analysis/performance-baseline.md` with quantitative metrics

**Key Sections**:
- Agent metadata (YAML frontmatter)
- Purpose and responsibilities
- 7-phase workflow (Identify target → Measure response time → Profile CPU/memory → Count queries → Identify hotspots → Generate baseline → Output)
- Metric definitions (what to measure, how to measure)
- Profiling tools (per language/framework)
- Baseline report structure

---

#### 2. `agents/bottleneck-analyzer.md` (~700 lines)

**Purpose**: Analyze profiling data and identify performance bottlenecks

**Capabilities**:
- Detect N+1 query patterns
- Identify missing database indexes
- Find inefficient algorithms (O(n²) loops, etc.)
- Detect memory leaks
- Identify blocking I/O operations
- Classify bottleneck types
- Prioritize by impact vs effort

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `implementation/optimization-plan.md` with prioritized optimizations

**Key Sections**:
- Agent metadata
- Bottleneck detection algorithms
- Classification framework (database, algorithm, memory, I/O, caching)
- 8-phase workflow (Load baseline → Analyze queries → Check indexes → Review algorithms → Detect memory issues → Classify bottlenecks → Prioritize → Create plan)
- Impact scoring (high/medium/low)
- Effort estimation (hours)
- Priority matrix (impact vs effort)

---

#### 3. `agents/performance-verifier.md` (~650 lines)

**Purpose**: Verify performance improvements meet targets

**Capabilities**:
- Re-measure all baseline metrics
- Compare baseline vs optimized
- Calculate improvement percentages
- Verify targets met
- Check for regressions
- Generate verification report with verdict

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `verification/performance-verification.md` with PASS/FAIL verdict

**Key Sections**:
- Agent metadata
- 7-phase workflow (Load baseline → Re-measure → Compare metrics → Calculate improvement → Verify targets → Check regressions → Generate report)
- Comparison structure (baseline vs optimized table)
- Improvement calculation formulas
- Verdict criteria (PASS if targets met, FAIL if not)
- Read-only philosophy (reports issues, never fixes)

---

### References (5 files)

#### 4. `skills/performance-orchestrator/references/performance-metrics.md` (~500 lines)

**Purpose**: Define performance metrics and measurement approaches

**Content**:
- **Response Time Metrics**: p50, p95, p99, max, avg
  - Measurement tools (ApacheBench, wrk, k6)
  - Interpretation thresholds (<100ms excellent, 100-500ms good, 500-1000ms acceptable, >1000ms slow)

- **Throughput Metrics**: requests/sec, transactions/sec
  - Measurement approaches
  - Target ranges by application type

- **Resource Metrics**: CPU usage, memory usage, connection pool utilization
  - Profiling tools per language
  - Healthy ranges

- **Database Metrics**: Query count, query time, N+1 detection, missing indexes
  - Detection methods
  - Optimization strategies

- **Caching Metrics**: Hit rate, miss rate, cache size
  - Measurement tools
  - Optimal ranges (>80% hit rate)

---

#### 5. `skills/performance-orchestrator/references/profiling-strategies.md` (~550 lines)

**Purpose**: Profiling methods and tools per technology

**Content**:
- **Application Profiling**
  - JavaScript/Node.js: `node --prof`, `clinic.js`, Chrome DevTools
  - Python: `cProfile`, `py-spy`, `memory_profiler`
  - Java: JProfiler, VisualVM, YourKit
  - Go: `pprof`, `go tool trace`

- **Database Profiling**
  - PostgreSQL: `EXPLAIN ANALYZE`, `pg_stat_statements`
  - MySQL: `EXPLAIN`, slow query log
  - MongoDB: `explain()`, profiler

- **Network Profiling**: `tcpdump`, Wireshark, browser dev tools

- **Profiling Best Practices**
  - Production vs development profiling
  - Sampling vs instrumentation
  - Minimizing profiling overhead
  - Interpreting flame graphs

---

#### 6. `skills/performance-orchestrator/references/optimization-patterns.md` (~700 lines)

**Purpose**: Common optimization techniques and patterns

**Content**:
- **Database Optimizations**
  - Add missing indexes (detection, creation, verification)
  - Fix N+1 queries (eager loading, batching, caching)
  - Optimize query complexity (avoid SELECT *, use projections)
  - Connection pooling (configuration, sizing)

- **Caching Strategies**
  - Where to cache (database, API, computed values, static assets)
  - Cache invalidation patterns
  - Cache-aside, read-through, write-through
  - Tools: Redis, Memcached, in-memory caches

- **Algorithm Optimizations**
  - Replace O(n²) with O(n log n)
  - Use hash maps for lookups (O(1) vs O(n))
  - Lazy evaluation
  - Memoization

- **Resource Optimizations**
  - Reduce memory allocations
  - Stream large data instead of loading all
  - Use async/await for I/O
  - Parallelize independent operations

- **Frontend Optimizations**
  - Code splitting, lazy loading
  - Image optimization, compression
  - Minimize bundle size
  - Service workers, caching

---

#### 7. `skills/performance-orchestrator/references/benchmarking.md` (~600 lines)

**Purpose**: Benchmarking approaches and tools

**Content**:
- **Benchmarking Tools**
  - HTTP load testing: ApacheBench (ab), wrk, k6, Gatling
  - Language-specific: pytest-benchmark, JMH, Criterion (Rust)
  - Database: pgbench, sysbench

- **Benchmarking Methodology**
  - Warmup runs (JIT compilation, caching)
  - Statistical significance (run multiple times)
  - Consistent environment (same hardware, isolated)
  - Realistic workloads (production-like data, traffic patterns)

- **Load Testing Patterns**
  - Ramp-up testing (gradually increase load)
  - Sustained load testing (constant load over time)
  - Spike testing (sudden traffic increase)
  - Stress testing (find breaking point)

- **Interpreting Results**
  - Latency percentiles (p50, p95, p99)
  - Throughput limits
  - Resource saturation points
  - Degradation curves

- **Before/After Comparison**
  - Side-by-side metrics tables
  - Improvement percentage calculation
  - Statistical significance testing

---

#### 8. `skills/performance-orchestrator/references/workflow-phases.md` (~650 lines)

**Purpose**: 5-phase workflow with dependencies and execution patterns

**Content**:
- **Phase 0: Performance Baseline & Profiling**
  - Agent: `performance-profiler`
  - Input: Performance issue description
  - Process: Measure metrics → Profile application → Generate baseline
  - Output: `analysis/performance-baseline.md`
  - Success criteria: All metrics measured, baseline documented
  - Auto-fix: Max 2 attempts (expand profiling if tools unavailable)

- **Phase 1: Bottleneck Analysis & Optimization Planning**
  - Agent: `bottleneck-analyzer`
  - Input: Performance baseline
  - Process: Analyze data → Identify bottlenecks → Classify → Prioritize → Create plan
  - Output: `implementation/optimization-plan.md`
  - Success criteria: Bottlenecks identified, optimizations prioritized, targets defined
  - Auto-fix: Max 2 attempts (prompt user if bottlenecks unclear)

- **Phase 2: Implementation with Benchmarking**
  - Agent: Main orchestrator (or delegate to `implementation-changes-planner`)
  - Input: Optimization plan
  - Process: For each optimization → Implement → Benchmark → Verify improvement
  - Output: Optimized code, benchmark results per optimization
  - Success criteria: Each optimization shows improvement, benchmarks validate targets
  - Auto-fix: Max 3 attempts (fix syntax, imports, benchmark issues)

- **Phase 3: Performance Verification**
  - Agent: `performance-verifier`
  - Input: Baseline + optimized code
  - Process: Re-measure → Compare → Calculate improvement → Verify targets → Generate report
  - Output: `verification/performance-verification.md`
  - Success criteria: Targets met, no regressions, improvement documented
  - Auto-fix: Max 0 attempts (read-only, reports only)

- **Phase 4: Load Testing & Production Readiness**
  - Agent: Main orchestrator (optionally delegates to `production-readiness-checker`)
  - Input: Verification report (PASS required)
  - Process: Configure load tests → Run stress tests → Check resource limits → Verify production readiness
  - Output: `verification/load-test-results.md`, optional `production-readiness-report.md`
  - Success criteria: Performance holds under load, resources within limits, ready for production
  - Auto-fix: Max 1 attempt (retry failed load tests)

- **Phase Dependencies**: 0 → 1 → 2 → 3 → 4 (sequential, cannot skip)
- **Execution Modes**: Interactive (pause between phases) and YOLO (continuous)
- **State Management**: `orchestrator-state.yml` tracks progress, auto-fix attempts, phase results

---

### Main Skill File

#### 9. `skills/performance-orchestrator/SKILL.md` (~900 lines)

**Purpose**: Main orchestrator with phase execution instructions

**Content Structure**:
- **Skill metadata** (YAML frontmatter)
  ```yaml
  ---
  name: performance-orchestrator
  description: Orchestrates performance optimization workflows with profiling, benchmarking, and load testing
  ---
  ```

- **When to Use This Skill**
  - Performance issues reported (slow response, high latency)
  - Need systematic optimization workflow
  - Want benchmarking and verification
  - Require load testing before production

- **Core Principles**
  - Measure first, optimize second (no premature optimization)
  - Benchmark-driven development (prove improvements)
  - Incremental optimization (one change at a time)
  - Production-realistic testing (load tests with real patterns)

- **Execution Modes** (Interactive vs YOLO)

- **Workflow Phases** (detailed step-by-step for each phase)
  - Phase 0: Performance Baseline & Profiling
  - Phase 1: Bottleneck Analysis & Optimization Planning
  - Phase 2: Implementation with Benchmarking
  - Phase 3: Performance Verification
  - Phase 4: Load Testing & Production Readiness

- **Orchestrator Workflow Execution**
  - Initialization (parse args, determine starting phase, initialize state)
  - Phase execution loop (for each phase)
  - Finalization (generate summary, update metadata)

- **State Management** (`orchestrator-state.yml` format and operations)

- **Auto-Recovery Features** (per phase with max attempts)

- **Integration Points** (docs/INDEX.md, standards, testing)

- **Important Guidelines** (orchestration best practices)

- **Reference Files** (list of references/ directory contents)

- **Example Workflows** (3-4 examples showing different scenarios)

- **Validation Checklist** (before completion)

- **Success Criteria** (10 criteria for successful optimization)

---

### Command Files (2 files)

#### 10. `commands/performance/new.md` (~400 lines)

**Purpose**: Command documentation for starting new performance optimization

**Content**:
- Command frontmatter (YAML)
  ```yaml
  ---
  name: performance:new
  description: Start a performance optimization workflow with profiling, benchmarking, and load testing
  category: Performance Workflows
  ---
  ```

- **Command Usage**
  ```bash
  /ai-sdlc:performance:new [description] [--yolo] [--from=phase]
  ```

- **Arguments and Options**
  - description: Performance issue to optimize
  - --yolo: Continuous execution
  - --from=PHASE: Start from specific phase

- **Examples** (5-6 examples)
  - Example 1: New optimization, interactive mode
  - Example 2: YOLO mode (fast optimization)
  - Example 3: Resume from middle phase
  - Example 4: Database optimization
  - Example 5: Frontend optimization

- **What You Are Doing** (invoke performance-orchestrator skill)

- **Workflow Phases** (brief description of each phase and outputs)

- **Execution Modes** (Interactive vs YOLO behavior)

- **Auto-Recovery Features** (per phase)

- **State Management** (orchestrator-state.yml location and purpose)

- **Prerequisites**

- **When to Use This vs Individual Commands**

- **Resume After Interruption** (pointer to resume command)

- **Tips** (for different optimization scenarios)

- **Next Steps After Completion**

- **Troubleshooting** (common issues and solutions)

- **Related Commands** (link to resume command)

- **Invoke** (call performance-orchestrator skill)

---

#### 11. `commands/performance/resume.md` (~450 lines)

**Purpose**: Command documentation for resuming interrupted performance optimization

**Content**:
- Command frontmatter (YAML)

- **Command Usage**
  ```bash
  /ai-sdlc:performance:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]
  ```

- **Arguments and Options**

- **Examples** (4-5 resume scenarios)
  - Simple resume (use state)
  - Resume from specific phase
  - Resume after manual fixes
  - Resume after benchmark failure

- **What You Are Doing** (resume workflow steps)
  - Step 1: Locate and validate task
  - Step 2: Read and validate state
  - Step 3: Determine resume point
  - Step 4: Validate prerequisites
  - Step 5: Apply state modifications
  - Step 6: Continue workflow

- **Use Cases** (4-5 common scenarios)
  - Computer restarted mid-optimization
  - Auto-fix exhausted, manual fix applied
  - Want to re-run benchmarks
  - Optimization regression detected

- **Common Scenarios** (troubleshooting)
  - Phase keeps failing
  - Want to restart a phase
  - Benchmarks inconsistent
  - Prerequisites missing

- **State Reconstruction** (experimental, if state file lost)

- **Tips** (safe resume, after manual fixes, re-running phases)

- **Troubleshooting** (state file corrupted, can't determine resume point)

- **Related Commands** (link to new command)

- **Invoke** (call performance-orchestrator skill in resume mode)

---

## CLAUDE.md Updates

### Available Skills Section

Add after `enhancement-orchestrator` and before `migration-orchestrator`:

```markdown
### performance-orchestrator
Orchestrates performance optimization workflows with profiling, benchmarking, and load testing. Measures baseline performance, identifies bottlenecks, implements optimizations incrementally with benchmarks, verifies improvements, and conducts load testing for production readiness.

**What Makes It Different**: Benchmark-driven optimization (prove every improvement), incremental approach (one optimization at a time), load testing under production-like conditions, quantitative improvement tracking.

**Key Features**:
- **Baseline Profiling**: Measure response time (p50/p95/p99), throughput, CPU, memory, query count
- **Bottleneck Detection**: N+1 queries, missing indexes, inefficient algorithms, memory leaks
- **Benchmark Validation**: Benchmark after each optimization to prove improvement
- **Load Testing**: Stress tests under production-like traffic patterns
- **Quantitative Reporting**: Before/after metrics with improvement percentages

**5-Phase Workflow**:
1. **Performance Baseline & Profiling**: Measure current metrics and identify hotspots
2. **Bottleneck Analysis & Planning**: Classify issues, prioritize by impact vs effort
3. **Implementation with Benchmarking**: Optimize incrementally, benchmark each change
4. **Performance Verification**: Re-measure, compare, verify targets met
5. **Load Testing & Production Readiness**: Stress test, verify production readiness

**Optimization Types**:
- Database: N+1 queries, missing indexes, connection pooling
- Caching: Redis, Memcached, in-memory caches
- Algorithms: Replace O(n²) with O(n log n), use hash maps
- Resources: Reduce allocations, async I/O, parallelization
- Frontend: Code splitting, lazy loading, image optimization

**Commands**: `/ai-sdlc:performance:new`, `/ai-sdlc:performance:resume`

**Use Cases**:
- Application slow (response time >1000ms)
- High resource usage (CPU >70%, memory growing)
- Database bottlenecks (N+1 queries, missing indexes)
- Need production-ready performance verification

**Related agents**: `performance-profiler`, `bottleneck-analyzer`, `performance-verifier`

**See**: `skills/performance-orchestrator/SKILL.md` for workflow phases, `references/` for metrics, profiling strategies, optimization patterns, benchmarking approaches.
```

### Available Commands Section

Add after `/ai-sdlc:enhancement:resume`:

```markdown
### /ai-sdlc:performance:new
Orchestrates performance optimization workflow with profiling, benchmarking, and load testing. Measures baseline, identifies bottlenecks, implements optimizations incrementally with benchmarks, and verifies production readiness.

**Usage**: `/ai-sdlc:performance:new [description] [--yolo] [--from=phase]`

**Output**: Task directory in `.ai-sdlc/tasks/performance/` with baseline, optimization plan, benchmark results, and verification reports.

**See**: `skills/performance-orchestrator/SKILL.md` for workflow phases and capabilities.

### /ai-sdlc:performance:resume
Resumes interrupted performance optimization workflow from saved state. Can override resume point, reset auto-fix attempts, or reconstruct state from artifacts if state file lost.

**Usage**: `/ai-sdlc:performance:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]`

**See**: `skills/performance-orchestrator/SKILL.md` for state management details.
```

### Available Subagents Section

Add after `behavioral-verifier`:

```markdown
### performance-profiler
Performance baseline and profiling specialist that measures current performance metrics. Captures response time (p50/p95/p99), throughput, CPU usage, memory usage, database query count, and identifies performance hotspots. Strictly read-only.

**Workflow**: Identify target → Measure response time → Profile CPU/memory → Count queries → Identify hotspots → Generate baseline

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by performance-orchestrator during Phase 0 (Performance Baseline & Profiling)

**Output**: `analysis/performance-baseline.md` with quantitative metrics

**Philosophy**: Objective measurement. Use production-realistic workloads for accurate baselines.

### bottleneck-analyzer
Bottleneck analysis specialist that identifies performance issues from profiling data. Detects N+1 query patterns, missing database indexes, inefficient algorithms, memory leaks, blocking I/O. Classifies bottlenecks and prioritizes by impact vs effort. Strictly read-only.

**Workflow**: Load baseline → Analyze queries → Check indexes → Review algorithms → Detect memory issues → Classify bottlenecks → Prioritize → Create plan

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by performance-orchestrator during Phase 1 (Bottleneck Analysis & Planning)

**Output**: `implementation/optimization-plan.md` with prioritized optimizations

**Philosophy**: Data-driven prioritization. Focus on high-impact, low-effort optimizations first.

### performance-verifier
Performance verification specialist that confirms optimizations meet targets. Re-measures all baseline metrics, compares before/after, calculates improvement percentages, verifies targets met. Generates verification report with PASS/FAIL verdict. Strictly read-only - reports issues, never fixes.

**Workflow**: Load baseline → Re-measure → Compare metrics → Calculate improvement → Verify targets → Check regressions → Generate report

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by performance-orchestrator during Phase 3 (Performance Verification)

**Output**: `verification/performance-verification.md` with PASS/FAIL verdict

**Philosophy**: Quantitative verification. Every optimization must be proven with metrics.
```

---

## Implementation Order

1. **Create subagents** (3 files): performance-profiler.md → bottleneck-analyzer.md → performance-verifier.md
2. **Create references** (5 files): performance-metrics.md → profiling-strategies.md → optimization-patterns.md → benchmarking.md → workflow-phases.md
3. **Create main skill**: SKILL.md
4. **Create commands** (2 files): new.md → resume.md
5. **Update CLAUDE.md**: Add to Available Skills, Available Commands, Available Subagents sections

---

## Key Design Decisions

**Benchmark-Driven Optimization**:
- Every optimization must be validated with benchmarks
- Measure before and after each change
- Prove improvement quantitatively

**Incremental Approach**:
- One optimization at a time (avoid confounding variables)
- Benchmark after each optimization
- Easy to identify which change caused improvement or regression

**Production-Realistic Testing**:
- Load tests with production-like traffic patterns
- Realistic data volumes
- Stress testing to find limits

**Read-Only Verification**:
- Profiler, analyzer, and verifier are read-only
- Report findings, don't modify code
- Main orchestrator or implementer applies changes

**Quantitative Reporting**:
- All metrics measured numerically
- Before/after comparison tables
- Improvement percentages calculated

---

## Success Criteria

Workflow successful when:
1. ✅ Baseline metrics measured and documented
2. ✅ Bottlenecks identified and prioritized
3. ✅ All planned optimizations implemented
4. ✅ Each optimization benchmarked and validated
5. ✅ Performance targets met (verified)
6. ✅ No regressions introduced
7. ✅ Load tests pass under production-like conditions
8. ✅ Resource usage within acceptable limits
9. ✅ Complete documentation with before/after metrics
10. ✅ Production readiness verified

Performance optimization orchestration provides complete, quantifiable, benchmark-driven workflow from performance issue to production-ready optimization.