# Refactoring Types Reference

This reference provides patterns for classifying and executing different refactoring types.

## Purpose

Different refactoring patterns require different approaches, risk assessments, and verification strategies. This reference helps the refactoring-planner classify refactoring types and tailor execution plans accordingly.

---

## Classification Framework

### Type Detection

**Indicators-Based Classification**: Analyze code quality metrics to determine refactoring type

```
Input: Code quality baseline metrics
Output: Refactoring type(s) + confidence score

Process:
1. Score each type based on metric thresholds
2. Select type with highest score
3. If multiple high scores → Mixed refactoring
```

---

## Type 1: Extract Method/Function

### Indicators

**Strong Indicators** (High confidence):
- Functions > 100 lines (Critical)
- Cyclomatic complexity > 15 (High)
- Functions with > 5 responsibility areas
- Repeated code blocks within function

**Moderate Indicators**:
- Functions 50-100 lines
- Cyclomatic complexity 10-15
- Deep nesting (>3 levels)

### Pattern

**Goal**: Break large function into smaller, focused functions

**Approach**:
- Extract logical blocks into helper functions
- One responsibility per function
- Maintain function contract (same inputs/outputs)

### Incremental Strategy

**Increment Size**: 1-3 extractions per increment

**Order**:
1. Extract most isolated code first (least dependencies)
2. Extract repeated code next
3. Extract complex logic last

### Risk Assessment

**Risk Factors**:
- Shared variables: Higher risk (requires careful parameter passing)
- Side effects: Medium risk (must preserve order)
- Test coverage: Low coverage = higher risk

**Risk Level**: Low to Medium
- Well-tested code: Low risk
- Poorly tested code: Medium risk

### Verification Strategy

**Tests Required**: Tier 1 (direct tests) + Tier 2 if complex

**Success Criteria**:
- All tests pass
- Function behavior unchanged
- Code complexity reduced

### Example

**Before**:
```javascript
function processOrder(order) {
  // 150 lines of code
  // Validation (30 lines)
  // Price calculation (40 lines)
  // Tax calculation (25 lines)
  // Shipping calculation (20 lines)
  // Database save (20 lines)
  // Email notification (15 lines)
}
```

**After** (4 increments):
```javascript
function processOrder(order) {
  const validated = validateOrder(order);  // Increment 1
  const price = calculatePrice(validated);  // Increment 2
  const total = calculateTotal(price);  // Increment 3
  return saveAndNotify(total);  // Increment 4
}
```

---

## Type 2: Rename

### Indicators

**Strong Indicators**:
- Generic names: `data`, `tmp`, `temp`, `x`, `func`
- Misleading names: Function does X but named Y
- Inconsistent naming: Mixed conventions (camelCase + snake_case)

**Moderate Indicators**:
- Abbreviations: `usr` instead of `user`
- Unclear purpose: `process()`, `handle()`, `doStuff()`

### Pattern

**Goal**: Improve code readability through better naming

**Approach**:
- Rename variables/functions/classes to descriptive names
- Follow project naming conventions
- Use domain terminology

### Incremental Strategy

**Increment Size**: 1-5 renames per increment (batch related renames)

**Order**:
1. Rename public APIs first (affects external callers)
2. Rename internal functions next
3. Rename local variables last

### Risk Assessment

**Risk Factors**:
- Scope: Wider scope = higher risk
- Call sites: More callers = higher coordination
- Type safety: Untyped language = higher risk

**Risk Level**: Very Low to Low
- With IDE refactoring support: Very low
- Manual rename: Low

### Verification Strategy

**Tests Required**: Tier 1 usually sufficient

**Success Criteria**:
- All references updated
- No compilation/linting errors
- Tests pass

### Example

**Before**:
```javascript
function proc(d) {  // Generic names
  const tmp = validate(d);
  return tmp;
}
```

**After** (1 increment):
```javascript
function processUserData(userData) {  // Descriptive names
  const validatedUser = validateUserInput(userData);
  return validatedUser;
}
```

---

## Type 3: Simplify Complex Logic

### Indicators

**Strong Indicators**:
- Cyclomatic complexity > 20 (Very high)
- Deep nesting > 5 levels (Critical)
- Long if-else chains (>5 branches)

**Moderate Indicators**:
- Cyclomatic complexity 15-20
- Deep nesting 3-5 levels
- Complex boolean expressions

### Pattern

**Goal**: Reduce complexity through simplification techniques

**Techniques**:
- **Guard clauses**: Early returns instead of nesting
- **Extract conditions**: Complex booleans to named variables
- **Strategy pattern**: Replace conditionals with polymorphism
- **Flatten nesting**: Reduce indentation levels

### Incremental Strategy

**Increment Size**: 1 simplification per increment

**Order**:
1. Flatten outermost nesting first
2. Extract complex conditions
3. Apply guard clauses
4. Simplify remaining logic

### Risk Assessment

**Risk Factors**:
- Logic complexity: More branches = higher risk
- Test coverage: Low coverage = much higher risk
- Boolean logic: Complex &&/|| = higher risk

**Risk Level**: Medium to High
- Well-tested: Medium risk
- Poorly tested: High risk (logic changes are risky)

### Verification Strategy

**Tests Required**: Tier 1 + Tier 2 mandatory, Tier 3 for critical code

**Success Criteria**:
- All tests pass (no logic changes)
- Complexity reduced by target amount
- Behavior identical

### Example

**Before**:
```javascript
function checkEligibility(user) {
  if (user) {
    if (user.age >= 18) {
      if (user.verified) {
        if (user.balance > 100) {
          return true;
        }
      }
    }
  }
  return false;
}
```

**After** (3 increments - guard clauses):
```javascript
// Increment 1: Check user exists
function checkEligibility(user) {
  if (!user) return false;

  if (user.age >= 18) {
    if (user.verified) {
      if (user.balance > 100) {
        return true;
      }
    }
  }
  return false;
}

// Increment 2: Check age
function checkEligibility(user) {
  if (!user) return false;
  if (user.age < 18) return false;

  if (user.verified) {
    if (user.balance > 100) {
      return true;
    }
  }
  return false;
}

// Increment 3: Check remaining conditions
function checkEligibility(user) {
  if (!user) return false;
  if (user.age < 18) return false;
  if (!user.verified) return false;
  if (user.balance <= 100) return false;
  return true;
}
```

---

## Type 4: Remove Duplication

### Indicators

**Strong Indicators**:
- Duplication > 15% (High)
- Repeated code blocks (>10 lines)
- Copy-paste pattern (identical code in multiple places)

**Moderate Indicators**:
- Duplication 10-15%
- Similar code with minor variations
- Repeated logic patterns

### Pattern

**Goal**: Apply DRY principle by extracting common code

**Approach**:
- Identify duplicated blocks
- Extract to shared function/module
- Replace all occurrences with function call
- Parameterize differences

### Incremental Strategy

**Increment Size**: 1 extraction per increment

**Order**:
1. Extract exact duplicates first (easiest)
2. Extract similar code with parameterization
3. Refactor remaining variations

### Risk Assessment

**Risk Factors**:
- Number of call sites: More = higher risk
- Variations: More variations = higher complexity
- Scope: Cross-module extraction = higher risk

**Risk Level**: Medium
- Affects multiple locations
- Requires careful parameterization

### Verification Strategy

**Tests Required**: Tier 1 + Tier 2 (affects multiple call sites)

**Success Criteria**:
- All call sites updated
- Behavior preserved at all locations
- Duplication percentage reduced

### Example

**Before**:
```javascript
// File 1
function createAdmin(data) {
  if (!data.email) throw new Error('Email required');
  if (!data.name) throw new Error('Name required');
  return db.insert('users', { ...data, role: 'admin' });
}

// File 2
function createModerator(data) {
  if (!data.email) throw new Error('Email required');
  if (!data.name) throw new Error('Name required');
  return db.insert('users', { ...data, role: 'moderator' });
}
```

**After** (2 increments):
```javascript
// Increment 1: Extract validation
function validateUserData(data) {
  if (!data.email) throw new Error('Email required');
  if (!data.name) throw new Error('Name required');
}

function createAdmin(data) {
  validateUserData(data);
  return db.insert('users', { ...data, role: 'admin' });
}

function createModerator(data) {
  validateUserData(data);
  return db.insert('users', { ...data, role: 'moderator' });
}

// Increment 2: Extract user creation
function createUserWithRole(data, role) {
  validateUserData(data);
  return db.insert('users', { ...data, role });
}

function createAdmin(data) {
  return createUserWithRole(data, 'admin');
}

function createModerator(data) {
  return createUserWithRole(data, 'moderator');
}
```

---

## Type 5: Restructure/Reorganize

### Indicators

**Strong Indicators**:
- God classes > 1000 lines (Critical)
- Classes with >20 methods
- Modules with >15 responsibilities
- Poor separation of concerns

**Moderate Indicators**:
- Classes 500-1000 lines
- Modules with 10-15 responsibilities
- Mixed abstraction levels

### Pattern

**Goal**: Improve architecture and organization

**Techniques**:
- **Split classes**: Break god class into focused classes
- **Extract modules**: Move related functions to new module
- **Apply SOLID**: Single responsibility, proper separation

### Incremental Strategy

**Increment Size**: 1 split/extraction per increment

**Order**:
1. Identify logical groupings
2. Extract most isolated group first
3. Extract remaining groups incrementally
4. Update all references

### Risk Assessment

**Risk Factors**:
- Scope: Architectural changes = high risk
- Dependencies: More dependencies = higher complexity
- Test coverage: Low coverage = very high risk

**Risk Level**: High
- Changes architecture
- Affects multiple components
- Requires careful dependency management

### Verification Strategy

**Tests Required**: All tiers (Tier 1 + Tier 2 + Tier 3)

**Success Criteria**:
- All tests pass
- Dependencies properly managed
- Architecture improved
- No circular dependencies

### Example

**Before**:
```javascript
// God class: 800 lines
class UserManager {
  validateUser() { /* 50 lines */ }
  saveUser() { /* 40 lines */ }
  findUser() { /* 40 lines */ }
  updateUser() { /* 40 lines */ }
  deleteUser() { /* 30 lines */ }

  calculateUserMetrics() { /* 60 lines */ }
  generateUserReport() { /* 70 lines */ }
  exportUserData() { /* 50 lines */ }

  sendWelcomeEmail() { /* 40 lines */ }
  sendPasswordReset() { /* 40 lines */ }
  notifyAdmins() { /* 30 lines */ }

  logUserAction() { /* 30 lines */ }
  auditUserChange() { /* 40 lines */ }

  // ... 13 more methods
}
```

**After** (5 increments):
```javascript
// Increment 1: Extract validation
class UserValidator {
  validateUser() { /* 50 lines */ }
}

// Increment 2: Extract repository
class UserRepository {
  saveUser() { /* 40 lines */ }
  findUser() { /* 40 lines */ }
  updateUser() { /* 40 lines */ }
  deleteUser() { /* 30 lines */ }
}

// Increment 3: Extract analytics
class UserAnalytics {
  calculateMetrics() { /* 60 lines */ }
  generateReport() { /* 70 lines */ }
  exportData() { /* 50 lines */ }
}

// Increment 4: Extract notifications
class UserNotifier {
  sendWelcomeEmail() { /* 40 lines */ }
  sendPasswordReset() { /* 40 lines */ }
  notifyAdmins() { /* 30 lines */ }
}

// Increment 5: Extract auditing
class UserAuditor {
  logAction() { /* 30 lines */ }
  auditChange() { /* 40 lines */ }
}

// Main class now coordinates
class UserService {
  constructor() {
    this.validator = new UserValidator();
    this.repository = new UserRepository();
    this.analytics = new UserAnalytics();
    this.notifier = new UserNotifier();
    this.auditor = new UserAuditor();
  }

  createUser(data) {
    this.validator.validateUser(data);
    const user = this.repository.saveUser(data);
    this.auditor.logAction('create', user);
    this.notifier.sendWelcomeEmail(user);
    return user;
  }
}
```

---

## Type 6: Improve Error Handling

### Indicators

**Strong Indicators**:
- Empty catch blocks (error swallowing)
- Generic catch-all: `catch (e) {}`
- No error handling in async code
- Errors not propagated

**Moderate Indicators**:
- Inconsistent error handling
- Missing error messages
- No error logging

### Pattern

**Goal**: Add proper error handling and propagation

**Approach**:
- Add specific error types
- Provide meaningful error messages
- Proper error propagation
- Consistent error handling strategy

### Incremental Strategy

**Increment Size**: 1-2 functions per increment

**Order**:
1. Fix error swallowing first (most critical)
2. Add specific error handling
3. Improve error messages
4. Add error logging

### Risk Assessment

**Risk Factors**:
- Control flow changes: Medium risk
- Exception handling: Can hide or expose bugs
- Async code: Higher complexity

**Risk Level**: Medium
- Changes control flow
- Can uncover hidden bugs

### Verification Strategy

**Tests Required**: Tier 1 + Tier 2 (error paths affect integration)

**Success Criteria**:
- All error paths tested
- Errors properly propagated
- Behavior preserved (or bugs intentionally fixed)

---

## Type 7: Performance Optimization

### Indicators

**Strong Indicators**:
- N+1 query patterns
- Missing database indexes
- O(n²) algorithms where O(n) possible
- No caching for expensive operations

**Moderate Indicators**:
- Inefficient loops
- Repeated calculations
- Large memory allocations

### Pattern

**Goal**: Improve performance without changing behavior

**Approach**:
- Optimize database queries
- Add caching
- Improve algorithms
- Reduce allocations

### Incremental Strategy

**Increment Size**: 1 optimization per increment

**Order**:
1. Fix N+1 queries (biggest impact)
2. Add indexes
3. Optimize algorithms
4. Add caching

### Risk Assessment

**Risk Factors**:
- Behavior preservation: CRITICAL - performance changes are risky
- Caching: Can introduce staleness bugs
- Algorithm changes: Can change edge case behavior

**Risk Level**: High
- Easy to accidentally change behavior
- Performance optimization often has trade-offs

### Verification Strategy

**Tests Required**: All tiers (Tier 1 + Tier 2 + Tier 3)

**Success Criteria**:
- All tests pass (behavior unchanged)
- Performance improved (measure before/after)
- Side effects identical

### Special Considerations

**Performance Measurement**:
- Baseline: Record performance metrics before refactoring
- After: Measure same metrics
- Compare: Verify improvement (e.g., 50% faster)

**Behavior Verification**: Extra careful
- Performance changes can introduce subtle bugs
- Verify not just tests pass, but results identical

---

## Type 8: Add Missing Tests

### Indicators

**Strong Indicators**:
- Test coverage < 60% (Low)
- Critical functions untested (authentication, payment, data loss scenarios)
- No integration tests

**Moderate Indicators**:
- Test coverage 60-80%
- Edge cases untested
- Error paths untested

### Pattern

**Goal**: Add tests before other refactoring

**Approach**:
- Identify untested functions
- Write tests for current behavior
- Achieve target coverage (>80%)

### Incremental Strategy

**Increment Size**: 1-3 functions per increment

**Order**:
1. Test critical functions first (auth, payment)
2. Test complex functions next (high complexity)
3. Test remaining functions
4. Test edge cases and error paths

### Risk Assessment

**Risk Level**: Very Low
- Adding tests doesn't change code
- Safest refactoring type

### Verification Strategy

**Tests Required**: The tests being added

**Success Criteria**:
- New tests pass
- Coverage increased
- Existing tests still pass

### Special Considerations

**Test-First Refactoring**:
- Often first phase of refactoring workflow
- Establishes safety net for subsequent changes
- Documents current behavior

---

## Mixed Refactoring

### When to Classify as Mixed

**Indicators**: Multiple refactoring types needed

**Examples**:
- Extract methods (Type 1) + Simplify logic (Type 3)
- Restructure (Type 5) + Remove duplication (Type 4)
- Add tests (Type 8) → then Simplify logic (Type 3)

### Strategy

**Approach**: Sequential execution of multiple types

**Order**:
1. Add tests first (Type 8) - establish safety net
2. Low-risk refactoring next (Type 2: Rename)
3. Medium-risk refactoring (Type 1: Extract, Type 4: Duplication)
4. High-risk refactoring last (Type 3: Simplify, Type 5: Restructure, Type 7: Performance)

**Risk Management**:
- Checkpoint between types
- Verify behavior after each type completes

---

## Type Selection Algorithm

```
function classifyRefactoringType(baseline_metrics):
  scores = {}

  // Type 1: Extract Method
  if baseline_metrics.max_complexity > 15:
    scores['Extract Method'] = 10
  elif baseline_metrics.avg_function_lines > 50:
    scores['Extract Method'] = 7

  // Type 2: Rename
  if baseline_metrics.poor_naming_count > 5:
    scores['Rename'] = 8

  // Type 3: Simplify Logic
  if baseline_metrics.max_complexity > 20:
    scores['Simplify Logic'] = 10
  elif baseline_metrics.deep_nesting > 4:
    scores['Simplify Logic'] = 8

  // Type 4: Remove Duplication
  if baseline_metrics.duplication_percent > 15:
    scores['Remove Duplication'] = 9
  elif baseline_metrics.duplication_percent > 10:
    scores['Remove Duplication'] = 6

  // Type 5: Restructure
  if baseline_metrics.max_class_lines > 1000:
    scores['Restructure'] = 10
  elif baseline_metrics.god_classes_count > 0:
    scores['Restructure'] = 8

  // Type 7: Performance
  if baseline_metrics.n_plus_one_queries > 0:
    scores['Performance'] = 9

  // Type 8: Add Tests
  if baseline_metrics.test_coverage < 60:
    scores['Add Tests'] = 10

  // Select type
  if len(scores) == 0:
    return 'No refactoring needed'
  elif len(scores) == 1:
    return single type
  elif max_score >= 9 and second_max_score <= 5:
    return single type (clear winner)
  else:
    return 'Mixed' (multiple types needed)
```

---

## Best Practices

### 1. Type-Specific Increment Sizing
- Extract: 1-3 extractions
- Rename: 1-5 renames (batch related)
- Simplify: 1 simplification
- Duplication: 1 extraction
- Restructure: 1 split
- Error Handling: 1-2 functions
- Performance: 1 optimization
- Tests: 1-3 functions

### 2. Type-Specific Risk Assessment
- Very Low: Rename, Add Tests
- Low: Extract Method (well-tested)
- Medium: Remove Duplication, Error Handling, Simplify Logic
- High: Restructure, Performance Optimization

### 3. Type-Specific Test Tiers
- Low risk: Tier 1 only
- Medium risk: Tier 1 + Tier 2
- High risk: All tiers (1 + 2 + 3)

### 4. Order Types in Mixed Refactoring
1. Add Tests (safety net)
2. Rename (minimal risk)
3. Extract/Duplication (medium risk)
4. Simplify/Performance (higher risk)
5. Restructure (highest risk)

---

This reference guides type classification and tailored refactoring strategies. Each type has unique characteristics requiring specific approaches.
