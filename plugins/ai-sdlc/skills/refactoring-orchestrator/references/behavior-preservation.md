# Behavior Preservation Reference

This reference defines behavior preservation requirements and verification strategies for refactoring workflows.

## Purpose

Refactoring must preserve behavior exactly - zero functional changes allowed. This reference defines what "behavior preservation" means and how to verify it.

---

## Core Principle

**Refactoring Definition**: "A change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior." - Martin Fowler

**Zero Functional Changes**: Refactoring changes HOW code works internally, not WHAT it does externally.

---

## What Constitutes "Behavior"?

### 1. Function Contracts

**Definition**: The public interface and guarantees of a function

**Components**:
- **Signature**: Function name, parameters, return type
- **Inputs**: Accepted parameter values and types
- **Outputs**: Return values for given inputs
- **Exceptions**: What errors are thrown and when

**Preservation Requirement**: ✅ Contracts must remain identical

**Allowed Changes**: ❌ None (unless explicit rename documented in plan)

**Example**:
```javascript
// PRESERVED ✅
// Before: function validateUser(user: User): ValidationResult
// After:  function validateUser(user: User): ValidationResult

// VIOLATED ❌
// Before: function validateUser(user: User): ValidationResult
// After:  function validateUser(user: User, options: Options): ValidationResult
```

---

### 2. Input-Output Mapping

**Definition**: For identical inputs, outputs must be identical

**Components**:
- **Deterministic functions**: Same input → Same output (always)
- **Non-deterministic functions**: Same input → Same output category (e.g., UUID format preserved)

**Preservation Requirement**: ✅ All test inputs must produce identical outputs

**Verification Method**: Compare test results before and after refactoring

**Example**:
```javascript
// Input: validateUser({ name: "John", age: 30 })
// Before output: { valid: true, errors: [] }
// After output:  { valid: true, errors: [] }  ✅ PRESERVED

// Before output: { valid: true }
// After output:  { valid: true, errors: [] }  ❌ VIOLATED (added field)
```

---

### 3. Side Effects

**Definition**: Observable effects beyond return value

**Types**:
- **Database operations**: Queries executed (INSERT, UPDATE, DELETE, SELECT)
- **External API calls**: HTTP requests made
- **File system operations**: Files read/written
- **Logging**: Log statements and levels
- **State changes**: Global state, singletons, caches modified
- **Network operations**: Sockets, connections opened

**Preservation Requirement**: ✅ All side effects must remain identical

**Verification Method**: Static code analysis + test observation

**Example**:
```javascript
// PRESERVED ✅
// Before: INSERT INTO users (name, email) VALUES (?, ?)
// After:  INSERT INTO users (name, email) VALUES (?, ?)

// VIOLATED ❌
// Before: INSERT INTO users (name, email) VALUES (?, ?)
// After:  INSERT INTO users (name, email, created_at) VALUES (?, ?, NOW())
```

---

### 4. Execution Order

**Definition**: Order of operations and side effects

**Requirement**: ✅ Must preserve order of observable side effects

**Why It Matters**: Changing order can change behavior even if all side effects present

**Example**:
```javascript
// PRESERVED ✅
// Before: 1. Validate, 2. Save, 3. Log, 4. Notify
// After:  1. Validate, 2. Save, 3. Log, 4. Notify

// VIOLATED ❌
// Before: 1. Validate, 2. Save, 3. Notify
// After:  1. Validate, 2. Notify, 3. Save  // User notified before save!
```

---

### 5. Error Handling

**Definition**: What errors are thrown and when

**Components**:
- **Error types**: Same exception types thrown
- **Error conditions**: Thrown under same conditions
- **Error messages**: Same error messages (exact match not required, but must convey same info)

**Preservation Requirement**: ✅ Error behavior must be identical

**Example**:
```javascript
// PRESERVED ✅
// Before: throws ValidationError when email invalid
// After:  throws ValidationError when email invalid

// VIOLATED ❌
// Before: throws ValidationError when email invalid
// After:  returns { valid: false } when email invalid  // Changed from throw to return
```

---

### 6. Performance Characteristics

**Definition**: Execution time and resource usage

**Requirement**: ⚠️ **Similar** performance acceptable (not identical)

**Tolerance**: ±10% acceptable (within measurement noise)

**Why Flexible**: Refactoring often changes performance slightly
- Minor overhead acceptable for improved code quality
- Significant degradation (>10%) requires investigation

**Example**:
```javascript
// ACCEPTABLE ✅
// Before: 100ms execution time
// After:  105ms execution time (5% slower, acceptable)

// INVESTIGATE ⚠️
// Before: 100ms execution time
// After:  150ms execution time (50% slower, why?)

// REGRESSION ❌
// Before: 100ms execution time
// After:  500ms execution time (5x slower, unacceptable)
```

---

## What Changes Are Allowed?

### Allowed: Internal Structure Changes

**Examples**:
- Extract methods: Break function into smaller functions ✅
- Rename local variables: `tmp` → `validatedUser` ✅
- Reorder internal steps: (if no observable side effects) ✅
- Change data structures: Array → Set (if external behavior same) ✅
- Optimize algorithms: O(n²) → O(n) (if results identical) ✅

**Key**: Changes invisible to callers

---

### Allowed: Code Quality Improvements

**Examples**:
- Reduce complexity: Flatten nesting ✅
- Remove duplication: Extract common code ✅
- Improve readability: Better names, comments ✅
- Add error handling: (if doesn't change existing behavior) ⚠️

**Caution**: Adding error handling is refactoring only if:
- Existing code already had implicit error handling (now explicit)
- New error handling catches same conditions
- If adding NEW error detection → Enhancement, not refactoring

---

### Not Allowed: Functional Changes

**Examples**:
- Add new features: ❌ Not refactoring
- Fix bugs: ❌ Not refactoring (that's a bug fix)
- Change business logic: ❌ Not refactoring
- Add new validations: ❌ Not refactoring (that's an enhancement)
- Change error conditions: ❌ Not refactoring

**Key**: Any change to WHAT code does = Not refactoring

---

## Verification Strategy

### 3-Layer Verification Approach

**Layer 1: Test-Based Verification**
- Run all tests before refactoring
- Run all tests after refactoring
- Compare results: Must be identical
- New failures = Behavior changed ❌

**Layer 2: Side Effect Verification**
- Static code analysis: Scan for DB/API/file operations
- Compare before/after: Must be identical
- Discrepancies = Behavior changed ❌

**Layer 3: Behavioral Fingerprint**
- Generate hash of signatures + test results + side effects
- Compare before/after hashes
- Mismatch = Further investigation required

---

## Test-Based Verification

### Test Coverage Requirements

**Minimum**: All refactored code must have tests
- Direct tests: Functions being refactored must have tests
- Integration tests: Systems using refactored code must have tests

**If Missing Tests**: Add tests in Phase 1 (before refactoring)

### Test Tier Execution

**Tier 1: Direct Tests** (Always run)
- Tests that directly call refactored functions
- Must pass 100% before and after

**Tier 2: Integration Tests** (Run for medium+ risk)
- Tests that call refactored code indirectly
- Must pass 100% before and after

**Tier 3: Domain Tests** (Run for high risk)
- Broader feature tests
- Must pass 100% before and after

### Test Failure Protocol

**If ANY test fails after refactoring**:
1. Immediate rollback to previous checkpoint
2. Stop orchestrator (no auto-fix attempts)
3. Report failure with test details
4. User must investigate and fix manually

**No Exceptions**: Zero tolerance for test failures

---

## Side Effect Verification

### Static Analysis

**Database Operations**:
```bash
# Search for queries
grep -E "SELECT|INSERT|UPDATE|DELETE" [files]
grep -r "query\|execute" [files]

# Compare before/after
diff baseline-queries.txt post-refactoring-queries.txt
```

**API Calls**:
```bash
# Search for HTTP requests
grep -E "fetch|axios|request|http" [files]
grep -r "POST|GET|PUT|DELETE" [files]

# Compare
diff baseline-api-calls.txt post-refactoring-api-calls.txt
```

**File Operations**:
```bash
# Search for file I/O
grep -E "readFile|writeFile|unlink" [files]

# Compare
diff baseline-file-ops.txt post-refactoring-file-ops.txt
```

### Runtime Observation

**Test Execution Monitoring**:
- Run tests with verbose logging
- Capture all side effects during test execution
- Compare before/after side effect logs

**Example**:
```
Test: testCreateUser
Before: [DB: INSERT users, API: POST /notify, Log: info "User created"]
After:  [DB: INSERT users, API: POST /notify, Log: info "User created"]
Status: ✅ MATCH
```

---

## Behavioral Fingerprint

### Purpose

Quick verification that behavior preserved without deep analysis

### Components

**Function Signatures Hash**: Hash all function signatures
**Test Results Hash**: Hash all test pass/fail results
**Side Effects Hash**: Hash all identified side effects

### Combined Hash

```
combined_hash = SHA256(signatures_hash + test_hash + side_effects_hash)
```

### Verification

```
if baseline_hash == post_refactoring_hash:
  # Quick confidence: Likely behavior preserved
  # Still verify with tests
else:
  # Investigate discrepancies
  # Compare individual hashes to find what changed
```

---

## Edge Cases and Handling

### Non-Deterministic Functions

**Challenge**: Functions with randomness (timestamps, UUIDs, random values)

**Strategy**:
- Document non-deterministic aspects
- Verify behavior category preserved (e.g., "returns UUID" not "returns specific UUID")
- Mock non-deterministic parts in tests

**Example**:
```javascript
// Non-deterministic
function createUser(data) {
  return {
    id: generateUUID(),  // Different every call
    createdAt: new Date(),  // Different every call
    ...data
  };
}

// Verification strategy
// ✅ Verify UUID format preserved
// ✅ Verify timestamp type preserved
// ✅ Verify data fields preserved
```

### Performance Optimization Refactoring

**Challenge**: Performance changes intentional but behavior must be identical

**Strategy**:
- Measure baseline performance
- Measure post-refactoring performance
- Verify performance improved (goal achieved)
- Verify behavior unchanged (tests + side effects)

**Success Criteria**:
- ✅ Tests pass identically
- ✅ Side effects identical
- ✅ Performance improved

### Concurrency and Race Conditions

**Challenge**: Refactoring may expose or fix race conditions

**Strategy**:
- If baseline has race condition: Preserve it (refactoring ≠ bug fixing)
- If refactoring fixes race condition unintentionally: ⚠️ Document as side benefit
- If refactoring introduces race condition: ❌ Behavior changed, rollback

---

## Common Pitfalls

### ❌ "Close Enough" Mentality

**Problem**: Accepting minor behavior changes as "insignificant"

**Why Wrong**: Any behavior change violates refactoring definition

**Example**:
```javascript
// ❌ NOT ACCEPTABLE
// Before: Returns { success: true }
// After:  Returns { success: true, timestamp: Date.now() }
// "It's just an extra field, harmless right?"
// WRONG: Behavior changed (output structure changed)
```

### ❌ Ignoring Side Effect Order

**Problem**: Preserving all side effects but changing order

**Why Wrong**: Order matters for observable behavior

**Example**:
```javascript
// ❌ NOT ACCEPTABLE
// Before: 1. Save user, 2. Send welcome email
// After:  1. Send welcome email, 2. Save user
// "Both happen, what's the difference?"
// WRONG: Email sent before user exists in DB (may fail or send wrong data)
```

### ❌ Performance Degradation

**Problem**: Accepting significant slowdown as "refactoring side effect"

**Why Wrong**: Performance is part of behavior

**Example**:
```javascript
// ❌ NOT ACCEPTABLE
// Before: O(n) algorithm, 100ms
// After:  O(n²) algorithm, 10 seconds
// "Still returns correct result"
// WRONG: Unacceptable performance degradation
```

### ❌ Fixing Bugs During Refactoring

**Problem**: Temptation to fix discovered bugs while refactoring

**Why Wrong**: Bug fixes are functional changes, not refactoring

**Solution**: Note bugs, fix separately AFTER refactoring

**Example**:
```javascript
// ❌ WRONG
// Before: if (user.age > 18) return true;  // Bug: should be >=
// After:  if (user.age >= 18) return true;  // Fixed during refactoring
// WRONG: Behavior changed (18-year-olds now pass)

// ✅ CORRECT
// 1. Complete refactoring (preserve bug)
// 2. Commit refactoring
// 3. Separate commit: Fix bug
```

---

## Verification Checklist

Before approving refactoring, verify:

- ✅ All function signatures identical (or explicitly renamed per plan)
- ✅ All tests pass with identical results
- ✅ Test pass/fail counts identical
- ✅ All side effects preserved (DB, API, files, logs, state)
- ✅ Side effect order preserved
- ✅ Error handling behavior identical
- ✅ Performance within acceptable range (±10%)
- ✅ Behavioral fingerprint matches baseline
- ✅ No new bugs introduced
- ✅ No existing bugs "fixed"

**If ANY item fails**: ❌ Behavior not preserved, ROLLBACK

---

## Integration with Workflow

### Phase 2: Behavioral Snapshot

**Purpose**: Establish baseline truth
- Capture current behavior (signatures, tests, side effects)
- Generate behavioral fingerprint
- Document non-deterministic aspects

### Phase 3: Incremental Refactoring

**After Each Increment**:
- Run appropriate test tiers
- Verify tests pass identically
- Quick fingerprint check (optional)

**If Tests Fail**: Immediate rollback

### Phase 4: Behavior Verification

**Purpose**: Final comprehensive verification
- Compare all aspects against baseline
- Generate detailed comparison report
- Clear PASS/FAIL verdict

**If PASS**: Proceed to Phase 5
**If FAIL**: ROLLBACK to main

---

## Summary

**Behavior preservation is non-negotiable in refactoring.**

**Three verification layers**:
1. Tests must pass identically
2. Side effects must be identical
3. Behavioral fingerprint must match

**Zero tolerance policy**: Any behavior change = Failed refactoring

**Rollback strategy**: Git checkpoints enable immediate rollback on failure

This strict approach ensures refactoring is safe and maintains code correctness while improving internal quality.
