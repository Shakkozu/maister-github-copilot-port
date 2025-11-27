# Quality Metrics Reference

This reference defines code quality metrics used for refactoring baseline and improvement measurement.

## Purpose

Quantitative metrics enable objective assessment of code quality before and after refactoring. This reference explains how to calculate, interpret, and compare metrics.

---

## Metric Categories

### 1. Complexity Metrics
### 2. Duplication Metrics
### 3. Code Smell Metrics
### 4. Test Coverage Metrics
### 5. Maintainability Metrics

---

## 1. Complexity Metrics

### Cyclomatic Complexity

**Definition**: Count of independent paths through code

**Calculation**: Decision points + 1

**Decision Points**:
- `if`, `else if`, `while`, `for`, `for each`
- `case` in `switch`
- `catch` in try-catch
- `&&` and `||` (logical operators)
- Ternary operators `? :`

**Formula**:
```
Complexity = 1 + (if count) + (else if count) + (while count) + (for count)
            + (case count) + (catch count) + (&& count) + (|| count) + (? count)
```

**Example**:
```javascript
function validateUser(user) {  // Start: 1
  if (!user) return false;  // +1 = 2
  if (!user.email) return false;  // +1 = 3
  if (user.age < 18) return false;  // +1 = 4
  return true;
}
// Complexity = 4
```

**Interpretation**:
- 1-5: **Simple** (low complexity, easy to understand)
- 6-10: **Moderate** (reasonable complexity)
- 11-20: **Complex** (consider simplifying)
- 21+: **Very Complex** (refactoring recommended)

**Tools**:
- JavaScript: `eslint` with complexity rule, `plato`
- Python: `radon`, `mccabe`
- Java: `checkstyle`, `PMD`
- Manual: Count decision points

---

### Nesting Depth

**Definition**: Maximum level of nested blocks

**Calculation**: Count indentation levels

**Example**:
```javascript
function process(data) {  // Level 0
  if (data) {  // Level 1
    if (data.valid) {  // Level 2
      if (data.complete) {  // Level 3
        // Max depth = 3
      }
    }
  }
}
```

**Interpretation**:
- 0-2: **Good** (flat structure)
- 3-4: **Moderate** (acceptable)
- 5+: **Deep** (consider flattening with guard clauses)

**Tools**:
- Manual: Count indentation
- Code analysis tools track nesting

---

### Function Length

**Definition**: Lines of code in function

**Calculation**: Count lines from function start to end (exclude comments/blank lines)

**Interpretation**:
- 1-20: **Short** (ideal)
- 21-50: **Medium** (acceptable)
- 51-100: **Long** (consider extracting)
- 101+: **Very Long** (refactoring recommended)

---

## 2. Duplication Metrics

### Duplication Percentage

**Definition**: Percentage of code that appears more than once

**Calculation**:
```
Duplication % = (Duplicated Lines / Total Lines) * 100
```

**Detection Methods**:

**Exact Duplication**: Identical lines
```bash
# Find repeated code blocks
sort file.js | uniq -c | sort -rn
```

**Similar Duplication**: Near-identical with minor variations

**Tools**:
- JavaScript: `jscpd`
- Python: `pylint` with duplicate-code check
- Manual: Visual inspection + grep for patterns

**Interpretation**:
- 0-5%: **Acceptable** (minimal duplication)
- 6-10%: **Moderate** (some DRY violations)
- 11-20%: **High** (significant duplication)
- 21%+: **Critical** (major refactoring needed)

---

### Duplication Instances

**Definition**: Count of duplicated code blocks

**Calculation**: Number of times code appears >1 time

**Example**:
```
Block 1: Appears 3 times (15 lines each) = 1 instance, 30 duplicated lines
Block 2: Appears 2 times (8 lines each) = 1 instance, 8 duplicated lines
Total: 2 instances, 38 duplicated lines
```

**Interpretation**:
- 0-2: **Few** duplications
- 3-5: **Some** duplications
- 6-10: **Many** duplications
- 11+: **Excessive** duplications

---

## 3. Code Smell Metrics

### Long Methods

**Threshold**: >50 lines = Moderate, >100 lines = High, >200 lines = Critical

**Detection**:
```bash
# Count lines per function (simplified)
awk '/^function|^def/ {start=NR; name=$0} /^}/ && start {print name, NR-start; start=0}' file.js
```

**Severity**:
- 50-100: Moderate smell (consider extracting)
- 101-200: High smell (should extract)
- 201+: Critical smell (must extract)

---

### God Classes

**Threshold**: >500 lines = Moderate, >1000 lines = High

**Detection**: Count lines in class definition

**Severity**:
- 500-1000: Moderate (potentially too many responsibilities)
- 1001-2000: High (definitely too many responsibilities)
- 2001+: Critical (major restructuring needed)

**Method Count**: >10 methods = Potential god class

---

### Magic Numbers

**Definition**: Hardcoded numbers (not 0, 1, -1)

**Detection**:
```bash
# Find numeric literals
grep -E '\b[0-9]{2,}\b' file.js | grep -v '0\|1\|-1'
```

**Interpretation**:
- 0-3: Few magic numbers
- 4-10: Some magic numbers (consider constants)
- 11+: Many magic numbers (should extract to constants)

---

### Dead Code

**Definition**: Unused functions, variables, imports

**Detection**:
```bash
# Find functions with no callers
for func in $(grep -E '^function \w+' file.js | awk '{print $2}'); do
  count=$(grep -r "$func" . | wc -l)
  if [ $count -eq 1 ]; then
    echo "Unused: $func"
  fi
done
```

**Severity**: Any dead code is a smell (remove it)

---

### TODO/FIXME Comments

**Definition**: Technical debt markers

**Detection**:
```bash
grep -i 'TODO\|FIXME' file.js | wc -l
```

**Interpretation**:
- 0-2: Low technical debt
- 3-5: Moderate technical debt
- 6+: High technical debt

---

## 4. Test Coverage Metrics

### Line Coverage

**Definition**: Percentage of code lines executed by tests

**Formula**:
```
Line Coverage % = (Executed Lines / Total Lines) * 100
```

**Tools**:
- JavaScript: `jest --coverage`, `nyc`
- Python: `pytest --cov`
- Java: `JaCoCo`

**Interpretation**:
- 80-100%: **Excellent** (safe to refactor)
- 60-79%: **Good** (add tests for critical paths)
- 40-59%: **Moderate** (significant gaps)
- 0-39%: **Low** (risky to refactor)

---

### Branch Coverage

**Definition**: Percentage of decision branches executed

**Formula**:
```
Branch Coverage % = (Executed Branches / Total Branches) * 100
```

**Example**:
```javascript
if (x > 0) {  // Branch 1: true, Branch 2: false
  // If only true tested → 50% branch coverage
}
```

**Interpretation**:
- 80-100%: Excellent
- 60-79%: Good
- 40-59%: Moderate
- 0-39%: Low

---

### Function Coverage

**Definition**: Percentage of functions with at least one test

**Formula**:
```
Function Coverage % = (Functions with Tests / Total Functions) * 100
```

**Manual Calculation**:
```bash
# Count functions
total=$(grep -E '^function \w+|^def \w+' file.js | wc -l)

# Count functions with tests (search test files)
tested=$(for func in $(grep -E '^function \w+' file.js | awk '{print $2}'); do
  grep -r "$func" tests/ && echo "$func"
done | wc -l)

coverage=$(echo "scale=2; $tested / $total * 100" | bc)
```

---

## 5. Maintainability Metrics

### Maintainability Index

**Formula** (simplified):
```
MI = 171 - 5.2 * ln(HV) - 0.23 * CC - 16.2 * ln(LOC)

Where:
- HV = Halstead Volume (code complexity measure)
- CC = Cyclomatic Complexity
- LOC = Lines of Code
```

**Simplified Estimation**:
```
MI ≈ 100 - (Complexity * 2) - (LOC / 100)
```

**Interpretation**:
- 85-100: **High** maintainability (good code)
- 65-84: **Moderate** maintainability (acceptable)
- 0-64: **Low** maintainability (refactoring recommended)

---

## Baseline vs Post-Refactoring Comparison

### Comparison Structure

```markdown
| Metric | Baseline | Post-Refactoring | Change | Improvement |
|--------|----------|------------------|--------|-------------|
| Average Complexity | 12 | 8 | -4 | 33% ↓ |
| Max Complexity | 25 | 12 | -13 | 52% ↓ |
| Duplication % | 15% | 5% | -10% | 67% ↓ |
| Test Coverage | 70% | 70% | 0% | - |
| Long Methods | 5 | 2 | -3 | 60% ↓ |
```

### Improvement Calculation

**Percentage Improvement**:
```
Improvement % = ((Baseline - Post) / Baseline) * 100
```

**Example**:
```
Baseline complexity: 12
Post-refactoring: 8
Improvement = ((12 - 8) / 12) * 100 = 33.3% improvement
```

---

## Goal Setting

### Refactoring Goals Template

```markdown
## Quality Improvement Goals

Based on baseline analysis:

**Complexity**:
- Baseline: Avg 12, Max 25
- Goal: Avg <10, Max <15
- Target improvement: 17% avg, 40% max

**Duplication**:
- Baseline: 15%
- Goal: <5%
- Target improvement: 67%

**Test Coverage**:
- Baseline: 70%
- Goal: >80%
- Target improvement: 10%

**Code Smells**:
- Baseline: 5 long methods, 2 god classes
- Goal: 0 long methods, 0 god classes
- Target improvement: 100%
```

---

## Metric Collection Tools

### JavaScript/TypeScript

**Complexity**:
```bash
npx eslint --rule 'complexity: ["error", {"max": 0}]' file.js --format json
```

**Duplication**:
```bash
npx jscpd file.js --format json
```

**Coverage**:
```bash
jest --coverage --json --outputFile=coverage.json
```

---

### Python

**Complexity**:
```bash
radon cc file.py --json
```

**Duplication**:
```bash
pylint --disable=all --enable=duplicate-code file.py
```

**Coverage**:
```bash
pytest --cov=module --cov-report=json
```

---

### Java

**Complexity**:
```bash
checkstyle -c google_checks.xml file.java
```

**Coverage**:
```bash
mvn test jacoco:report
```

---

## Manual Metric Collection

### When Tools Unavailable

**Complexity** (Manual):
1. Read function
2. Count decision points (`if`, `while`, `for`, `case`, `catch`, `&&`, `||`, `?`)
3. Add 1
4. Result = Complexity score

**Duplication** (Manual):
1. Visually scan for repeated code blocks
2. Count instances of each repeated block
3. Estimate percentage: `(repeated lines / total lines) * 100`

**Coverage** (Manual):
1. Find test files
2. For each function, search for tests calling it
3. Count: `(functions with tests / total functions) * 100`

---

## Metric Validation

### Quality Baseline Checklist

✅ All target files analyzed
✅ Complexity calculated per function
✅ Average and max complexity recorded
✅ Duplication percentage measured
✅ Code smells identified and counted
✅ Test coverage assessed
✅ Baseline metrics saved for comparison

### Post-Refactoring Checklist

✅ Re-measure all baseline metrics
✅ Compare with baseline
✅ Calculate improvement percentages
✅ Verify goals met
✅ Document final metrics

---

## Best Practices

### 1. Consistent Measurement
- Use same tools before and after
- Same file scope
- Same calculation methods

### 2. Multiple Metrics
- Don't rely on single metric
- Combine complexity + duplication + coverage
- Holistic quality view

### 3. Realistic Goals
- Don't aim for perfection (0 complexity impossible)
- Incremental improvement acceptable
- Focus on high-impact areas

### 4. Context Matters
- Domain complexity affects acceptable metrics
- Legacy code may have higher acceptable thresholds
- New code should meet stricter standards

---

## Summary

**Key Metrics for Refactoring**:
1. **Cyclomatic Complexity**: <10 average, <20 max
2. **Duplication**: <5%
3. **Test Coverage**: >80%
4. **Code Smells**: 0 critical, minimal moderate

**Measurement Approach**: Before + After with identical methods

**Goal**: Demonstrate quantifiable improvement while preserving behavior

These metrics provide objective evidence that refactoring improved code quality.
