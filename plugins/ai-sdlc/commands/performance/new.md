---
name: ai-sdlc:performance:new
description: Start a performance optimization workflow with profiling, benchmarking, and load testing
category: Performance Workflows
---

# Performance Optimization Workflow: New

Start comprehensive performance optimization from profiling through production-ready deployment.

## Command Usage

```bash
/ai-sdlc:performance:new [description] [--yolo] [--from=phase]
```

### Arguments

- **description** (optional): Performance issue description
  - Example: "Dashboard page loading slowly"
  - Example: "API response time >1 second"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `baseline`, `analysis`, `implementation`, `verification`, `load-testing`
  - Default: `baseline`

## Examples

### Example 1: Interactive Mode (Default)

```bash
/ai-sdlc:performance:new "Dashboard slow, >2s load time"
```

Workflow: Baseline → Analysis → Planning → Implementation → Verification → Load Testing (pause after each)

### Example 2: YOLO Mode (Fast Execution)

```bash
/ai-sdlc:performance:new "API endpoint GET /users is slow" --yolo
```

All phases run continuously, only stops on failure.

### Example 3: Start from Specific Phase

```bash
/ai-sdlc:performance:new --from=implementation
```

Skips baseline and analysis, starts directly from implementation (requires existing optimization plan).

## What You Are Doing

**Invoke the performance-orchestrator skill NOW using the Skill tool.**

The skill orchestrates 5 phases:

**Phase 0: Performance Baseline & Profiling** → `performance-profiler` agent
- Measure response time (p50, p95, p99), throughput
- Profile CPU usage, memory usage
- Count database queries, identify N+1 patterns
- Generate comprehensive baseline report

**Phase 1: Bottleneck Analysis & Planning** → `bottleneck-analyzer` agent
- Analyze baseline data, identify bottlenecks
- Classify by type (database, algorithm, I/O, memory, caching)
- Prioritize by impact vs effort
- Create optimization plan with implementation steps

**Phase 2: Implementation with Benchmarking** → Orchestrator
- For each optimization: Benchmark before → Implement → Benchmark after
- Verify improvement meets targets
- Run tests to ensure no regressions

**Phase 3: Performance Verification** → `performance-verifier` agent
- Re-measure all baseline metrics
- Compare baseline vs optimized
- Verify targets met, check for regressions
- Generate PASS/FAIL verdict

**Phase 4: Load Testing & Production Readiness** → Orchestrator
- Run load tests (ramp-up, sustained, spike)
- Monitor resources under load
- Verify production readiness
- Generate deployment recommendation

## Outputs

Task directory: `.ai-sdlc/tasks/performance/YYYY-MM-DD-name/`

- `analysis/performance-baseline.md` - Baseline metrics
- `implementation/optimization-plan.md` - Prioritized optimizations
- `implementation/benchmarks/*.txt` - Before/after benchmarks
- `verification/performance-verification.md` - Verification report
- `verification/load-test-results.md` - Load testing results

## Prerequisites

- Application running locally or accessible
- Load testing tools available (wrk, k6, or ApacheBench)
- Profiling tools for your language (node --prof, py-spy, etc.)
- Database access for query analysis

## Execution Modes

**Interactive**: Pause after each phase, review results, continue when ready
**YOLO**: Continuous execution, stops only on failures

## Resume After Interruption

If interrupted:
```bash
/ai-sdlc:performance:resume .ai-sdlc/tasks/performance/2025-11-16-task
```

## Expected Timeline

- **Phase 0** (Baseline): 30-60 minutes
- **Phase 1** (Analysis): 30-60 minutes
- **Phase 2** (Implementation): 2-8 hours (depends on optimization count)
- **Phase 3** (Verification): 30-60 minutes
- **Phase 4** (Load Testing): 1-2 hours

**Total**: 5-12 hours for complete workflow

## Invoke

Invoke the **performance-orchestrator** skill to start systematic performance optimization with profiling, benchmarking, and production readiness verification.
