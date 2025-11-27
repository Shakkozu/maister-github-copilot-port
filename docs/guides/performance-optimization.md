# Performance Optimization Workflow

Guide to optimizing performance using benchmark-driven optimization with the AI SDLC plugin.

## Overview

Performance optimization workflow uses profiling, bottleneck detection, incremental optimization with benchmarks, and load testing to improve application speed and efficiency.

**When to use:**
- Application slow (response time >1000ms)
- High resource usage (CPU >70%, memory growing)
- Database bottlenecks (N+1 queries, missing indexes)
- Need production-ready performance verification

## Quick Start

```bash
/ai-sdlc:performance:new "Optimize dashboard loading time"
```

## Workflow Phases (5 Phases)

### Phase 1: Performance Baseline & Profiling
- Measure response time (p50/p95/p99)
- Measure throughput, CPU, memory
- Count database queries
- Identify hotspots

### Phase 2: Bottleneck Analysis & Planning
- Detect N+1 queries, missing indexes
- Find inefficient algorithms
- Identify memory leaks, blocking I/O
- Prioritize by impact vs effort

### Phase 3: Implementation with Benchmarking
- Optimize incrementally (one at a time)
- Benchmark after EACH optimization
- Prove every improvement with metrics
- Document before/after results

### Phase 4: Performance Verification
- Re-measure all baseline metrics
- Compare before/after
- Calculate improvement percentages
- Verify targets met

### Phase 5: Load Testing & Production Readiness
- Stress test under production load
- Verify scalability
- Check resource limits
- Generate load test report

## Key Feature: Benchmark-Driven

Every optimization must be proven with benchmarks:

```
Baseline: Dashboard load = 3.2s

Optimization 1: Add database index
→ Benchmark: Dashboard load = 2.1s (34% improvement) ✅

Optimization 2: Cache user data
→ Benchmark: Dashboard load = 0.8s (62% improvement from previous) ✅

Final: 3.2s → 0.8s (75% total improvement)
```

## Optimization Types

- **Database**: N+1 queries → batch loading, missing indexes → add indexes
- **Caching**: Redis/Memcached for frequently accessed data
- **Algorithms**: Replace O(n²) with O(n log n)
- **Resources**: Reduce allocations, async I/O, parallelization
- **Frontend**: Code splitting, lazy loading, image optimization

## Best Practices

1. **Measure First**: Always establish baseline before optimizing
2. **One at a Time**: Optimize incrementally, benchmark each change
3. **Prove Improvements**: Numbers don't lie - show before/after metrics
4. **Focus on Hotspots**: Optimize what matters (80/20 rule)
5. **Load Test**: Verify performance under realistic load

## Related Resources

- [Command Reference](../../commands/performance/new.md)
- [Skill Documentation](../../skills/performance-orchestrator/SKILL.md)
- [Performance Profiler Agent](../../agents/performance-profiler.md)
- [Bottleneck Analyzer Agent](../../agents/bottleneck-analyzer.md)

**Next Steps**: `/ai-sdlc:performance:new [description]`
