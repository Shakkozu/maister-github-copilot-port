# Targeted Regression Testing Reference

**Purpose:** Guide for selecting and running targeted regression tests during implementation and verification

This reference provides strategies for intelligent test selection that balances thoroughness with efficiency.

---

## Overview

Targeted regression testing runs a carefully selected subset of tests (30-70% of full suite) that are most likely to catch regressions caused by the enhancement. This is more efficient than running the full suite after every change while maintaining high confidence.

### Why Targeted Testing?

**Full Suite Every Time:**
- ❌ Slow (2-5 minutes typical)
- ❌ Wastes time on unrelated tests
- ❌ Discourages frequent testing
- ✅ Maximum confidence

**No Regression Testing:**
- ✅ Fast
- ❌ Zero confidence in unchanged code
- ❌ High risk of undetected regressions
- ❌ Unacceptable for enhancements

**Targeted Regression Testing:**
- ✅ Fast (30-60 seconds typical)
- ✅ High confidence for affected areas
- ✅ Encourages frequent testing
- ✅ Catches 90-95% of regressions
- ⚠️ Full suite still run before commit

---

## Test Selection Strategy

### Three-Tier Selection

```python
def select_targeted_tests(enhanced_files, enhancement_scope):
    """
    Select targeted test subset based on three tiers.

    Tiers:
    1. Direct tests - MUST RUN (always)
    2. Integration tests - RUN if scope > small (usually)
    3. Related domain tests - RUN if scope = large (sometimes)

    Args:
        enhanced_files (list): Files modified
        enhancement_scope (str): 'small', 'medium', 'large'

    Returns:
        dict: Test selection with rationale
    """

    selection = {
        'tier1_direct': [],
        'tier2_integration': [],
        'tier3_domain': [],
        'total_selected': 0,
        'total_project': 0,
        'percentage': 0,
        'rationale': {}
    }

    # Tier 1: Direct tests (ALWAYS RUN)
    for enhanced_file in enhanced_files:
        # Find direct test file
        direct_test = find_direct_test_file(enhanced_file)

        if direct_test:
            selection['tier1_direct'].append({
                'test_file': direct_test,
                'tests_for': enhanced_file,
                'reason': 'Direct modification',
                'priority': 'critical'
            })

        # Find tests that import this file
        importing_tests = find_tests_importing_file(enhanced_file)

        for test in importing_tests:
            if test not in [t['test_file'] for t in selection['tier1_direct']]:
                selection['tier1_direct'].append({
                    'test_file': test,
                    'tests_for': enhanced_file,
                    'reason': 'Imports modified file',
                    'priority': 'high'
                })

    # Tier 2: Integration tests (RUN if scope > small)
    if enhancement_scope in ['medium', 'large']:
        # Find integration tests mentioning enhanced features
        feature_keywords = extract_feature_keywords(enhanced_files)

        for keyword in feature_keywords:
            integration_tests = find_integration_tests_for_feature(keyword)

            for test in integration_tests:
                if test not in [t['test_file'] for t in selection['tier2_integration']]:
                    selection['tier2_integration'].append({
                        'test_file': test,
                        'feature': keyword,
                        'reason': 'Integration test for modified feature',
                        'priority': 'medium'
                    })

    # Tier 3: Domain-related tests (RUN if scope = large)
    if enhancement_scope == 'large':
        # Find all tests in same domain
        domains = extract_domains_from_files(enhanced_files)

        for domain in domains:
            domain_tests = find_tests_in_domain(domain)

            for test in domain_tests:
                # Skip if already in tier 1 or 2
                if test in [t['test_file'] for t in selection['tier1_direct'] + selection['tier2_integration']]:
                    continue

                selection['tier3_domain'].append({
                    'test_file': test,
                    'domain': domain,
                    'reason': 'Same domain as modification',
                    'priority': 'low'
                })

    # Calculate totals
    selection['total_selected'] = (
        len(selection['tier1_direct']) +
        len(selection['tier2_integration']) +
        len(selection['tier3_domain'])
    )

    selection['total_project'] = count_total_project_tests()
    selection['percentage'] = (selection['total_selected'] / selection['total_project']) * 100

    # Rationale
    selection['rationale'] = {
        'tier1_count': len(selection['tier1_direct']),
        'tier1_reason': 'Direct tests for modified files (always run)',
        'tier2_count': len(selection['tier2_integration']),
        'tier2_reason': f'Integration tests (scope: {enhancement_scope})',
        'tier3_count': len(selection['tier3_domain']),
        'tier3_reason': f'Domain tests (scope: {enhancement_scope})',
        'time_saved': estimate_time_saved(selection)
    }

    return selection


def find_direct_test_file(source_file):
    """Find test file directly testing source file."""

    test_patterns = [
        source_file.replace('.ts', '.test.ts'),
        source_file.replace('.tsx', '.test.tsx'),
        source_file.replace('.js', '.test.js'),
        source_file.replace('.jsx', '.test.jsx'),
        source_file.replace('.py', '_test.py'),
        source_file.replace('.py', '.test.py'),
    ]

    for pattern in test_patterns:
        if os.path.exists(pattern):
            return pattern

    return None


def find_tests_importing_file(source_file):
    """Find test files that import the source file."""

    file_name = os.path.basename(source_file).split('.')[0]

    # Search test directories for imports
    test_results = grep(
        pattern=f"import.*{file_name}",
        path="tests/",
        output_mode="files_with_matches"
    )

    # Also search co-located tests
    src_dir = os.path.dirname(source_file)
    src_results = grep(
        pattern=f"import.*{file_name}",
        path=src_dir,
        glob="*.test.*",
        output_mode="files_with_matches"
    )

    return list(set(test_results + src_results))


def find_integration_tests_for_feature(feature_keyword):
    """Find integration tests mentioning feature."""

    # Search integration test directory
    integration_tests = grep(
        pattern=feature_keyword,
        path="tests/integration",
        output_mode="files_with_matches",
        i=True  # Case insensitive
    )

    # Also search for E2E tests
    e2e_tests = grep(
        pattern=feature_keyword,
        path="tests/e2e",
        output_mode="files_with_matches",
        i=True
    )

    return list(set(integration_tests + e2e_tests))
```

### Selection Examples

**Example 1: Small Enhancement (Single File)**

```yaml
enhancement: "Add tooltip to button"
files_modified:
  - src/components/Button.tsx

targeted_tests:
  tier1_direct:
    - tests: Button.test.tsx (12 tests)
      reason: Direct modification
  tier2_integration: []
  tier3_domain: []

  total_selected: 12
  total_project: 203
  percentage: 5.9%
  estimated_time: 15 seconds (vs 120 seconds full suite)
```

**Example 2: Medium Enhancement (Multiple Files)**

```yaml
enhancement: "Add sorting to UserTable"
files_modified:
  - src/components/UserTable.tsx
  - src/features/users/UserList.tsx

targeted_tests:
  tier1_direct:
    - tests: UserTable.test.tsx (12 tests)
    - tests: UserList.test.tsx (8 tests)
    - tests: Any test importing UserTable (3 files, 15 tests)

  tier2_integration:
    - tests/integration/users/user-management.test.tsx (5 tests)

  tier3_domain: []

  total_selected: 40
  total_project: 203
  percentage: 19.7%
  estimated_time: 35 seconds
```

**Example 3: Large Enhancement (Multiple Areas)**

```yaml
enhancement: "Change pagination from client to server-side"
files_modified:
  - src/components/UserTable.tsx
  - src/components/ProductTable.tsx
  - src/api/users.ts
  - src/api/products.ts

targeted_tests:
  tier1_direct:
    - UserTable.test.tsx (12 tests)
    - ProductTable.test.tsx (10 tests)
    - users.api.test.ts (8 tests)
    - products.api.test.ts (8 tests)
    - Tests importing these (20 tests)

  tier2_integration:
    - tests/integration/users/ (15 tests)
    - tests/integration/products/ (12 tests)
    - tests/e2e/pagination.test.tsx (5 tests)

  tier3_domain:
    - tests/api/**/*.test.ts (25 tests)

  total_selected: 115
  total_project: 203
  percentage: 56.7%
  estimated_time: 90 seconds
```

---

## When to Run Tests

### During Implementation (Incremental)

After each task group completion:

```python
def run_incremental_tests(task_group, implementation_plan):
    """
    Run targeted tests after completing task group.

    Example:
    - Completed: Task Group 1 (Sort State Management)
    - Run: Only tests for files modified in this group
    """

    # Get files modified in this task group
    group_files = get_files_modified_in_group(task_group)

    # Select tests for just these files (tier 1 only)
    tests = select_tier1_tests(group_files)

    # Run tests
    result = run_tests(tests)

    return {
        'task_group': task_group['name'],
        'tests_run': len(tests),
        'passed': result.passed,
        'failed': result.failed,
        'duration': result.duration
    }
```

### During Verification (Comprehensive)

Two-phase approach:

**Phase 1: Targeted Tests**
```python
# Run targeted subset first (fast feedback)
targeted_results = run_targeted_tests(
    enhanced_files=all_modified_files,
    enhancement_scope='medium'
)

if not targeted_results.passed:
    return {
        'status': 'failed',
        'message': 'Targeted tests failed - fix before running full suite'
    }
```

**Phase 2: Full Suite**
```python
# If targeted tests pass, run full suite
full_results = run_full_test_suite()

return {
    'targeted_pass_rate': targeted_results.pass_rate,
    'full_pass_rate': full_results.pass_rate,
    'regressions_caught_by_targeted': calculate_regression_coverage(targeted_results),
    'time_saved': targeted_results.duration - full_results.duration
}
```

---

## Test Execution

### Running Selected Tests

```python
def run_targeted_test_suite(test_selection):
    """
    Execute targeted test suite.

    Args:
        test_selection (dict): Output from select_targeted_tests()

    Returns:
        dict: Test execution results
    """

    results = {
        'by_tier': {},
        'overall': {},
        'failures': []
    }

    # Run Tier 1 tests (critical)
    tier1_results = run_test_list(test_selection['tier1_direct'])
    results['by_tier']['tier1'] = tier1_results

    if not tier1_results['all_passed']:
        # Tier 1 failure is critical - stop here
        return {
            'status': 'failed',
            'message': 'Critical tests failed (Tier 1)',
            'results': results,
            'continue_to_tier2': False
        }

    # Run Tier 2 tests (if included)
    if test_selection['tier2_integration']:
        tier2_results = run_test_list(test_selection['tier2_integration'])
        results['by_tier']['tier2'] = tier2_results

        if not tier2_results['all_passed']:
            # Tier 2 failure is significant but not critical
            results['warnings'] = ['Integration tests failed (Tier 2)']

    # Run Tier 3 tests (if included)
    if test_selection['tier3_domain']:
        tier3_results = run_test_list(test_selection['tier3_domain'])
        results['by_tier']['tier3'] = tier3_results

    # Overall summary
    total_tests = sum(tier['count'] for tier in results['by_tier'].values())
    total_passed = sum(tier['passed'] for tier in results['by_tier'].values())

    results['overall'] = {
        'total_tests': total_tests,
        'passed': total_passed,
        'failed': total_tests - total_passed,
        'pass_rate': (total_passed / total_tests) * 100 if total_tests > 0 else 0,
        'duration_seconds': sum(tier['duration'] for tier in results['by_tier'].values())
    }

    return results


def run_test_list(test_list):
    """Run a list of test files."""

    test_files = [t['test_file'] for t in test_list]
    test_pattern = ' '.join(test_files)

    result = run_bash(
        f"npm test -- {test_pattern}",
        timeout=120000
    )

    # Parse output
    parsed = parse_test_output(result.stdout)

    return {
        'count': len(test_files),
        'passed': parsed['passed'],
        'failed': parsed['failed'],
        'all_passed': parsed['failed'] == 0,
        'duration': parsed['duration'],
        'output': result.stdout
    }
```

---

## Optimization Strategies

### 1. Parallel Execution

```python
def run_tests_in_parallel(test_selection):
    """Run test tiers in parallel when possible."""

    # Tier 1 always runs first (blocking)
    tier1_results = run_test_list(test_selection['tier1_direct'])

    if not tier1_results['all_passed']:
        return tier1_results  # Stop on critical failure

    # Tier 2 and 3 can run in parallel
    tier2_future = async_run_tests(test_selection['tier2_integration'])
    tier3_future = async_run_tests(test_selection['tier3_domain'])

    # Wait for completion
    tier2_results = tier2_future.result()
    tier3_results = tier3_future.result()

    return combine_results([tier1_results, tier2_results, tier3_results])
```

### 2. Smart Caching

```python
def run_tests_with_cache(test_selection, cache_key):
    """
    Use cached results for tests where code hasn't changed.

    Args:
        test_selection (dict): Selected tests
        cache_key (str): Hash of enhanced files

    Returns:
        dict: Results (some from cache, some fresh)
    """

    cache = load_test_cache()
    results = []

    for test in test_selection['tier1_direct']:
        test_file = test['test_file']

        # Check if test file and source file unchanged
        if is_test_unchanged(test_file, cache, cache_key):
            # Use cached result
            cached_result = cache.get(test_file)
            results.append({
                'test': test_file,
                'status': 'passed',
                'source': 'cache',
                'duration': 0
            })
        else:
            # Run test fresh
            result = run_single_test(test_file)
            results.append(result)

            # Update cache
            cache[test_file] = {
                'result': result,
                'cache_key': cache_key,
                'timestamp': datetime.now()
            }

    save_test_cache(cache)

    return results
```

### 3. Fail-Fast Mode

```python
def run_tests_fail_fast(test_selection):
    """Stop on first failure for faster feedback."""

    for tier_name in ['tier1_direct', 'tier2_integration', 'tier3_domain']:
        tier_tests = test_selection[tier_name]

        if not tier_tests:
            continue

        for test in tier_tests:
            result = run_single_test(test['test_file'])

            if result['status'] == 'failed':
                return {
                    'status': 'failed',
                    'failed_at': test['test_file'],
                    'tier': tier_name,
                    'message': 'Fail-fast triggered',
                    'error': result['error']
                }

    return {
        'status': 'passed',
        'message': 'All tests passed'
    }
```

---

## Best Practices

### Do's

✅ **Always run Tier 1** - Direct tests are non-negotiable
✅ **Run full suite before commit** - Targeted is for speed, not final verification
✅ **Adjust scope dynamically** - Small change? Less tests. Large? More tests.
✅ **Document exclusions** - Note which tests are skipped and why
✅ **Monitor coverage** - Track % of regressions caught by targeted tests

### Don'ts

❌ **Don't skip full suite** - Always run before committing
❌ **Don't trust targeted tests alone** - They're for speed, not completeness
❌ **Don't include unrelated tests** - Wastes time, reduces value
❌ **Don't hardcode test lists** - Generate dynamically based on changes
❌ **Don't ignore tier 2/3 failures** - Investigate even if not critical

---

## Metrics & Validation

### Effectiveness Metrics

```python
def calculate_targeted_test_effectiveness(targeted_results, full_results):
    """
    Measure how effective targeted test selection was.

    Metrics:
    - Coverage: % of failures caught by targeted tests
    - Efficiency: Time saved vs full suite
    - Precision: % of targeted tests that found issues
    """

    metrics = {}

    # Coverage: Did targeted tests catch all failures?
    failures_in_full = set(full_results['failed_tests'])
    failures_in_targeted = set(targeted_results['failed_tests'])

    caught_failures = failures_in_targeted.intersection(failures_in_full)

    metrics['coverage'] = {
        'ratio': len(caught_failures) / len(failures_in_full) if failures_in_full else 1.0,
        'percentage': (len(caught_failures) / len(failures_in_full)) * 100 if failures_in_full else 100,
        'missed_failures': list(failures_in_full - caught_failures)
    }

    # Efficiency: Time saved
    time_saved = full_results['duration'] - targeted_results['duration']
    time_saved_pct = (time_saved / full_results['duration']) * 100

    metrics['efficiency'] = {
        'time_saved_seconds': time_saved,
        'time_saved_percentage': time_saved_pct,
        'targeted_duration': targeted_results['duration'],
        'full_duration': full_results['duration']
    }

    # Precision: Were targeted tests relevant?
    metrics['precision'] = {
        'tests_run': targeted_results['total_tests'],
        'tests_failed': len(failures_in_targeted),
        'precision_ratio': len(failures_in_targeted) / targeted_results['total_tests'] if targeted_results['total_tests'] > 0 else 0,
        'message': 'Higher = better targeting (more failures found in smaller set)'
    }

    # Overall grade
    if metrics['coverage']['percentage'] >= 95 and metrics['efficiency']['time_saved_percentage'] >= 40:
        metrics['grade'] = 'Excellent'
    elif metrics['coverage']['percentage'] >= 85 and metrics['efficiency']['time_saved_percentage'] >= 30:
        metrics['grade'] = 'Good'
    else:
        metrics['grade'] = 'Needs Improvement'

    return metrics
```

---

## Quick Reference

### Selection Rules

| Enhancement Scope | Tier 1 (Direct) | Tier 2 (Integration) | Tier 3 (Domain) | Typical % |
|-------------------|-----------------|----------------------|-----------------|-----------|
| **Small** (1 file) | ✅ Always | ❌ Skip | ❌ Skip | 5-10% |
| **Medium** (2-5 files) | ✅ Always | ✅ Include | ❌ Skip | 15-30% |
| **Large** (6+ files) | ✅ Always | ✅ Include | ✅ Include | 40-70% |

### When to Run

| Phase | Test Suite | Purpose | Frequency |
|-------|------------|---------|-----------|
| **Implementation** | Tier 1 only | Fast feedback | After each task group |
| **Pre-Verification** | Targeted (all tiers) | Comprehensive check | Before verification phase |
| **Final Verification** | Full suite | Complete regression check | Once before commit |
| **CI/CD** | Full suite | Production gate | Every commit |

---

**End of targeted-regression-testing.md reference**
