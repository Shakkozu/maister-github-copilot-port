---
name: maister-performance
description: Optimize code for speed and resource efficiency. Use when tasks involve performance bottlenecks or optimization work.
---

# Maister Performance Skill

Identify and resolve performance bottlenecks.

## When to Use

- Slow API endpoints
- Memory issues
- High CPU usage
- Large data processing
- N+1 query problems

## Workflow

### Phase 1: Identify Bottlenecks

1. Analyze code for common patterns:
   - N+1 queries
   - O(n²) algorithms
   - Missing indexes
   - Blocking I/O
   - Memory leaks

2. Use profiling tools if available

### Phase 2: Document Issues

Create `analysis/bottlenecks.md`:
```markdown
## Bottleneck 1: [Name]
- Location: [file:line]
- Type: [query/algorithm/io/memory]
- Impact: [high/medium/low]
- Suggested fix: [approach]
```

### Phase 3: Plan Optimization

Create optimization plan:
1. Prioritize by impact
2. Identify dependencies
3. Plan testing strategy

### Phase 4: Implement

1. Apply optimizations
2. Benchmark before/after
3. Run tests

### Phase 5: Verify

1. Confirm performance improvement
2. No regressions
3. Document results

## Usage

```bash
gh copilot "Optimize the user search API endpoint"
```

## Output

```
.maister/tasks/performance/YYYY-MM-DD-optimization/
├── orchestrator-state.yml
├── analysis/
│   └── bottlenecks.md
├── implementation/
│   └── optimization-plan.md
└── verification/
    └── benchmark-results.md
```