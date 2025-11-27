# Compatibility Verification Reference

**Purpose:** Guide for verifying backward compatibility in Phase 5 verification

This reference provides practical patterns and test strategies for ensuring enhancements maintain backward compatibility.

---

## Overview

Backward compatibility verification ensures that enhancements don't break existing functionality or usage patterns. This is critical for enhancements, which modify existing features that may have many consumers.

### Compatibility Levels

**Strict (100% compatible)**
- No breaking changes allowed
- All existing tests pass without modification
- All existing usage patterns work unchanged
- No new warnings or errors
- Default behavior identical when new features not used

**Moderate (managed changes)**
- Some breaking changes allowed with clear migration path
- Migration steps documented
- Deprecation warnings for old patterns
- Version bump required

**Flexible (breaking changes accepted)**
- Rare for enhancements
- Major version bump
- Comprehensive migration guide

---

## Verification Tests

### 1. Default Behavior Test

**Purpose:** Ensure component works identically when new features not used.

```python
def verify_default_behavior(component_name, enhanced_files):
    """
    Test that component behaves identically when new props/features not used.

    Returns:
        dict: Test results with pass/fail status
    """

    # Generate test that mounts component without new props
    test_code = f"""
test('{component_name} works without new features (backward compat)', () => {{
  // Mount component with only original props (no new optional props)
  const originalProps = {{
    // Extract original props from before enhancement
    ...getOriginalPropsFromSpec()
  }};

  const {{ container }} = render(<{component_name} {{...originalProps}} />);

  // Should render without errors
  expect(container).toBeTruthy();

  // Should match snapshot from before enhancement
  expect(container).toMatchSnapshot('before-enhancement');

  // New features should not be visible
  expect(screen.queryByTestId('new-feature-indicator')).not.toBeInTheDocument();
}});
"""

    # Run test
    result = run_test(test_code)

    return {
        'test': 'Default behavior unchanged',
        'status': 'passed' if result.success else 'failed',
        'evidence': result.output,
        'critical': True  # Failure blocks release
    }
```

### 2. API Backward Compatibility

**Purpose:** Verify all existing API usage still works.

```python
def verify_api_compatibility(enhanced_files, existing_analysis):
    """
    Check that API changes don't break existing usage.

    Tests:
    - All files importing enhanced component still compile
    - All existing function signatures still work
    - All existing prop patterns still accepted
    """

    results = []

    for enhanced_file in enhanced_files:
        # Find all files importing this enhanced file
        importers = grep(
            pattern=f"import.*from.*{enhanced_file}",
            path=".",
            output_mode="files_with_matches"
        )

        for importer in importers:
            # Try to compile importer
            compile_result = run_bash(f"tsc --noEmit {importer}")

            if not compile_result.success:
                results.append({
                    'test': f'Compile {importer}',
                    'status': 'failed',
                    'file': importer,
                    'error': compile_result.stderr,
                    'severity': 'critical',
                    'message': f'File no longer compiles after API changes'
                })
            else:
                results.append({
                    'test': f'Compile {importer}',
                    'status': 'passed',
                    'file': importer
                })

    # Summary
    passed = sum(1 for r in results if r['status'] == 'passed')
    total = len(results)

    return {
        'test': 'API backward compatibility',
        'status': 'passed' if passed == total else 'failed',
        'passed_count': passed,
        'total_count': total,
        'failures': [r for r in results if r['status'] == 'failed']
    }
```

### 3. Existing Usage Patterns

**Purpose:** Verify all real-world usage patterns still work.

```python
def verify_existing_usage_patterns(component_name, project_root):
    """
    Find and test all existing usage patterns of enhanced component.

    Approach:
    1. Search codebase for all usages
    2. Extract props used in each usage
    3. Generate tests for each unique pattern
    4. Run tests to verify all patterns still work
    """

    # Find all JSX usages of component
    usages = grep(
        pattern=f"<{component_name}[\\s>]",
        path=project_root,
        output_mode="content",
        type="tsx"
    )

    unique_patterns = extract_unique_prop_patterns(usages)

    test_results = []

    for i, pattern in enumerate(unique_patterns):
        test_code = f"""
test('Existing usage pattern #{i+1}: {pattern.description}', () => {{
  // Exact props from existing usage
  const props = {pattern.props_json};

  // Should render successfully
  const {{ container }} = render(<{component_name} {{...props}} />);
  expect(container).toBeTruthy();

  // Should display expected content
  // (Add specific assertions based on pattern)
}});
"""

        result = run_test(test_code)
        test_results.append({
            'pattern': pattern.description,
            'status': 'passed' if result.success else 'failed',
            'props': pattern.props,
            'evidence': result.output
        })

    passed = sum(1 for r in test_results if r['status'] == 'passed')

    return {
        'test': 'Existing usage patterns work',
        'status': 'passed' if passed == len(test_results) else 'failed',
        'patterns_tested': len(test_results),
        'patterns_passed': passed,
        'results': test_results
    }


def extract_unique_prop_patterns(usages):
    """Extract unique prop patterns from usage examples."""

    patterns = []
    seen_props = set()

    for usage in usages:
        # Parse JSX to extract props
        props = parse_jsx_props(usage.content)
        props_signature = json.dumps(sorted(props.keys()))

        if props_signature not in seen_props:
            seen_props.add(props_signature)
            patterns.append({
                'description': f"Pattern with props: {', '.join(sorted(props.keys()))}",
                'props': props,
                'props_json': json.dumps(props, indent=2),
                'file': usage.file,
                'line': usage.line
            })

    return patterns
```

### 4. Console Warnings Check

**Purpose:** Ensure no new warnings introduced.

```python
def check_console_warnings(enhanced_files):
    """
    Check for new console warnings after enhancement.

    Approach:
    - Run tests with console capture
    - Filter warnings related to enhanced files
    - Compare to baseline (before enhancement)
    """

    # Run tests and capture console
    result = run_bash(
        "npm test -- --silent 2>&1 | tee test-output.log",
        timeout=120000
    )

    # Parse warnings
    warnings = parse_console_output_for_warnings(result.stdout)

    # Filter to warnings related to enhanced files
    relevant_warnings = []

    for warning in warnings:
        for enhanced_file in enhanced_files:
            file_name = os.path.basename(enhanced_file)
            if file_name in warning['message']:
                relevant_warnings.append(warning)
                break

    return {
        'test': 'No new console warnings',
        'status': 'passed' if len(relevant_warnings) == 0 else 'failed',
        'warnings_count': len(relevant_warnings),
        'warnings': relevant_warnings,
        'severity': 'medium'  # Warnings not critical but should be addressed
    }


def parse_console_output_for_warnings(output):
    """Parse console output for warning messages."""

    warnings = []
    lines = output.split('\n')

    warning_patterns = [
        r'warning[:\s]',
        r'deprecated',
        r'WARN',
        r'Console\.warn'
    ]

    for i, line in enumerate(lines):
        for pattern in warning_patterns:
            if re.search(pattern, line, re.IGNORECASE):
                warnings.append({
                    'line_number': i + 1,
                    'message': line.strip(),
                    'context': lines[max(0, i-1):min(len(lines), i+2)]  # Include surrounding lines
                })
                break

    return warnings
```

### 5. Snapshot Comparison

**Purpose:** Compare behavior before/after enhancement.

```python
def compare_behavioral_snapshots(component_name, enhanced_files):
    """
    Compare component behavior before and after enhancement.

    Requires:
    - Baseline snapshot captured before enhancement
    - Current snapshot after enhancement
    """

    # Generate snapshot test
    test_code = f"""
test('{component_name} behavior snapshot comparison', () => {{
  const props = getDefaultProps();
  const {{ container }} = render(<{component_name} {{...props}} />);

  // Compare to baseline snapshot
  expect(container).toMatchSnapshot('baseline');
}});
"""

    result = run_test(test_code)

    if not result.success:
        # Check if failure is due to intentional change or regression
        diff = extract_snapshot_diff(result.output)

        return {
            'test': 'Snapshot comparison',
            'status': 'needs_review',
            'diff': diff,
            'message': 'Behavior changed - review diff to confirm intentional'
        }

    return {
        'test': 'Snapshot comparison',
        'status': 'passed',
        'message': 'Behavior identical to baseline'
    }
```

---

## Compatibility Test Suite

### Complete Test Suite

```python
def run_complete_compatibility_suite(enhancement_context):
    """
    Run full compatibility verification suite.

    Args:
        enhancement_context (dict): Context with enhanced files, classification, etc.

    Returns:
        dict: Complete compatibility report
    """

    report = {
        'overall_status': None,
        'compatibility_level': enhancement_context['compatibility_level'],
        'tests': [],
        'summary': {}
    }

    enhanced_files = enhancement_context['files_modified']
    component_name = enhancement_context['component_name']

    # Test 1: Default Behavior
    test1 = verify_default_behavior(component_name, enhanced_files)
    report['tests'].append(test1)

    # Test 2: API Compatibility
    test2 = verify_api_compatibility(enhanced_files, enhancement_context['existing_analysis'])
    report['tests'].append(test2)

    # Test 3: Usage Patterns
    test3 = verify_existing_usage_patterns(component_name, '.')
    report['tests'].append(test3)

    # Test 4: Console Warnings
    test4 = check_console_warnings(enhanced_files)
    report['tests'].append(test4)

    # Test 5: Snapshot Comparison
    test5 = compare_behavioral_snapshots(component_name, enhanced_files)
    report['tests'].append(test5)

    # Determine overall status
    critical_tests = [t for t in report['tests'] if t.get('critical', False)]
    critical_passed = all(t['status'] == 'passed' for t in critical_tests)

    all_tests_passed = all(t['status'] == 'passed' for t in report['tests'])

    if all_tests_passed:
        report['overall_status'] = 'passed'
    elif critical_passed:
        report['overall_status'] = 'passed_with_warnings'
    else:
        report['overall_status'] = 'failed'

    # Summary
    report['summary'] = {
        'total_tests': len(report['tests']),
        'passed': sum(1 for t in report['tests'] if t['status'] == 'passed'),
        'failed': sum(1 for t in report['tests'] if t['status'] == 'failed'),
        'warnings': sum(1 for t in report['tests'] if t['status'] == 'needs_review')
    }

    return report
```

---

## Handling Breaking Changes

### Breaking Change Verification

```python
def verify_breaking_changes_acceptable(breaking_changes, compatibility_level):
    """
    Verify that breaking changes are acceptable for compatibility level.

    Args:
        breaking_changes (list): List of detected breaking changes
        compatibility_level (str): 'strict', 'moderate', or 'flexible'

    Returns:
        dict: Verification result
    """

    if compatibility_level == 'strict' and len(breaking_changes) > 0:
        return {
            'status': 'failed',
            'reason': 'Breaking changes detected but strict compatibility required',
            'breaking_changes': breaking_changes,
            'action_required': 'Remove breaking changes or downgrade to moderate compatibility'
        }

    if compatibility_level == 'moderate':
        # Check that migration path exists for each breaking change
        for change in breaking_changes:
            if not change.get('migration_path'):
                return {
                    'status': 'failed',
                    'reason': f"Breaking change without migration path: {change['description']}",
                    'action_required': 'Provide migration path for all breaking changes'
                }

        return {
            'status': 'passed',
            'message': 'Breaking changes acceptable with migration paths',
            'requires_version_bump': True
        }

    # Flexible - any breaking changes allowed
    return {
        'status': 'passed',
        'message': 'Breaking changes acceptable (flexible compatibility)',
        'requires_major_version_bump': True
    }


def generate_migration_test(breaking_change):
    """Generate test to verify migration path works."""

    test_code = f"""
test('Migration path for {breaking_change['description']}', () => {{
  // Test old usage (should show deprecation warning)
  const oldProps = {breaking_change['old_props_json']};

  console.warn = jest.fn();  // Capture warnings

  const {{ container: oldContainer }} = render(<Component {{...oldProps}} />);

  expect(console.warn).toHaveBeenCalledWith(
    expect.stringContaining('deprecated')
  );

  // Test new usage (no warnings)
  console.warn.mockClear();

  const newProps = {breaking_change['new_props_json']};
  const {{ container: newContainer }} = render(<Component {{...newProps}} />);

  expect(console.warn).not.toHaveBeenCalled();

  // Both should produce same output (migration successful)
  expect(oldContainer.innerHTML).toBe(newContainer.innerHTML);
}});
"""

    return test_code
```

---

## Compatibility Report

### Report Template

```markdown
# Backward Compatibility Verification Report

**Component:** {component_name}
**Compatibility Level:** {level}
**Date:** {date}

## Overall Status: {status}

{status_emoji} All compatibility tests {passed/failed}

## Test Results

### 1. Default Behavior Test
**Status:** {passed/failed}
**Critical:** Yes

{details}

### 2. API Compatibility
**Status:** {passed/failed}
**Files Tested:** {count}

{details}

### 3. Existing Usage Patterns
**Status:** {passed/failed}
**Patterns Tested:** {count}

{details}

### 4. Console Warnings
**Status:** {passed/failed}
**New Warnings:** {count}

{details}

### 5. Snapshot Comparison
**Status:** {passed/failed}

{details}

## Breaking Changes

{list of breaking changes, if any}

## Migration Required

{migration steps, if needed}

## Conclusion

{summary and recommendations}
```

---

## Best Practices

### Do's

✅ **Test default behavior first** - Most critical test
✅ **Capture baseline snapshots** - Before making changes
✅ **Test all usage patterns** - Not just happy path
✅ **Run tests frequently** - After each change
✅ **Document breaking changes** - Clear migration guide

### Don'ts

❌ **Don't skip default behavior test** - Always required
❌ **Don't assume compatibility** - Always verify
❌ **Don't hide breaking changes** - Document clearly
❌ **Don't modify existing tests** - They verify compatibility
❌ **Don't rush verification** - Take time to be thorough

---

## Quick Reference

### Compatibility Checklist

- [ ] Default behavior unchanged (no new props)
- [ ] All importing files compile successfully
- [ ] All existing usage patterns work
- [ ] No new console warnings
- [ ] Snapshot comparison matches baseline
- [ ] Breaking changes documented (if any)
- [ ] Migration path provided (if breaking changes)
- [ ] Version bump planned (if breaking changes)

### Status Criteria

**✅ Passed (100% compatible)**
- All tests pass
- No breaking changes
- No new warnings
- Ready for release

**⚠️ Passed with Warnings**
- All critical tests pass
- Minor warnings present
- No breaking changes
- Review warnings before release

**❌ Failed**
- Critical tests fail
- Breaking changes without migration
- Existing usage broken
- Must fix before release

---

**End of compatibility-verification.md reference**
