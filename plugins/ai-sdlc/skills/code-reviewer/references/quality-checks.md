# Code Quality Analysis Patterns

This guide provides detailed patterns and thresholds for code quality analysis in the code-reviewer skill.

---

## 1. Complexity Metrics

### Cyclomatic Complexity

**Definition**: Number of linearly independent paths through code.

**Calculation Guidelines**:
- Start with 1 for each function
- Add 1 for each: if, else, for, while, case, catch, &&, ||, ?:, ??

**Thresholds**:
- **1-10**: ✅ Simple, easy to test
- **11-20**: ⚠️ Moderate complexity, consider refactoring
- **21-50**: ❌ High complexity, should refactor
- **50+**: ❌ Very high complexity, must refactor

**Detection Patterns**:
```bash
# Count conditional statements
grep -E "(if|else|for|while|switch|case|catch|\|\||&&|\?:)" file.ts | wc -l

# Find deeply nested conditions
grep -B2 -A2 "if.*{" file.ts
```

**Example - High Complexity**:
```typescript
// Cyclomatic Complexity: 15 (too high)
function validateUser(user, options) {
  if (!user) return false;
  if (!user.email) return false;
  if (!validateEmail(user.email)) return false;
  if (options?.requirePhone) {
    if (!user.phone) return false;
    if (!validatePhone(user.phone)) return false;
  }
  if (user.age && user.age < 18) return false;
  if (options?.requireAddress) {
    if (!user.address) return false;
    if (!user.address.city) return false;
    if (!user.address.country) return false;
  }
  return true;
}
```

**Recommendation**: Extract validation logic into focused functions
```typescript
// Refactored: Multiple simple functions
function validateUser(user, options) {
  return validateBasicFields(user) &&
         validateOptionalPhone(user, options) &&
         validateAge(user) &&
         validateOptionalAddress(user, options);
}
```

---

### Cognitive Complexity

**Definition**: Measure of how difficult code is to understand (considers nesting).

**What Increases Cognitive Complexity**:
- Nesting (each level +1)
- Logical operators in conditions
- Recursion
- Jumps (break, continue, goto)

**Thresholds**:
- **0-5**: ✅ Very readable
- **6-10**: ✅ Acceptable
- **11-15**: ⚠️ Getting complex
- **15+**: ❌ Hard to understand

**Detection Patterns**:
```bash
# Count nesting levels (look for deeply nested blocks)
grep -E "^\s{8,}(if|for|while)" file.ts  # 4+ indentation levels

# Find complex boolean expressions
grep -E "(&&|\|\|).*&&|\|\|" file.ts
```

**Example - High Cognitive Complexity**:
```typescript
// Cognitive Complexity: 18 (too high)
function processOrder(order) {
  if (order.isPaid) {  // +1
    if (order.items.length > 0) {  // +2 (nesting)
      for (const item of order.items) {  // +3 (nesting)
        if (item.inStock) {  // +4 (nesting)
          if (item.requiresShipping) {  // +5 (nesting)
            if (calculateShippingCost(item) > 0) {  // +6 (nesting)
              addToShipmentQueue(item);
            }
          } else {
            if (item.isDigital) {  // +6 (nesting)
              sendDigitalDownload(item);
            }
          }
        } else {
          notifyOutOfStock(item);
        }
      }
    }
  }
}
```

**Recommendation**: Extract nested logic
```typescript
// Refactored: Lower cognitive complexity
function processOrder(order) {
  if (!order.isPaid) return;

  order.items
    .filter(item => item.inStock)
    .forEach(item => processOrderItem(item));
}

function processOrderItem(item) {
  if (item.requiresShipping) {
    scheduleShipment(item);
  } else if (item.isDigital) {
    sendDigitalDownload(item);
  }
}
```

---

### Function Length

**Thresholds**:
- **1-20 lines**: ✅ Ideal
- **21-50 lines**: ✅ Acceptable
- **51-100 lines**: ⚠️ Long, consider splitting
- **100+ lines**: ❌ Too long, should split

**Detection**:
```bash
# Find long functions (example for TypeScript/JavaScript)
awk '/^function|^const.*=.*=>/ {start=NR; name=$2} /^}/ && start {if(NR-start>50) print name": "NR-start" lines"; start=0}' file.ts
```

**Exceptions** (when longer functions are OK):
- Configuration objects
- Large switch statements for state machines
- Generated code
- Initialization code with many simple assignments

**Example - Too Long**:
```typescript
// 120 lines - doing too much
function handleUserRegistration(userData) {
  // Validation (20 lines)
  // Database operations (30 lines)
  // Email sending (20 lines)
  // Logging (10 lines)
  // Analytics (15 lines)
  // Webhook notifications (25 lines)
}
```

**Recommendation**: Single Responsibility Principle
```typescript
function handleUserRegistration(userData) {
  const user = validateAndCreateUser(userData);
  sendWelcomeEmail(user);
  trackRegistrationAnalytics(user);
  notifyWebhooks('user.registered', user);
  return user;
}
```

---

### Nesting Depth

**Thresholds**:
- **1-2 levels**: ✅ Clear and readable
- **3 levels**: ✅ Acceptable
- **4 levels**: ⚠️ Getting hard to follow
- **5+ levels**: ❌ Too deeply nested

**Detection**:
```bash
# Find deeply nested code (5+ levels of indentation)
grep -E "^\s{20,}" file.ts  # Assuming 4-space indentation
```

**Example - Too Deeply Nested**:
```python
# 6 levels of nesting
def process_data(data):
    if data:  # Level 1
        for item in data:  # Level 2
            if item.is_valid:  # Level 3
                for subitem in item.children:  # Level 4
                    if subitem.status == 'active':  # Level 5
                        for detail in subitem.details:  # Level 6
                            process(detail)
```

**Recommendation**: Early returns and extraction
```python
# Reduced to 2 levels max
def process_data(data):
    if not data:
        return

    valid_items = [item for item in data if item.is_valid]
    for item in valid_items:
        process_valid_item(item)

def process_valid_item(item):
    active_subitems = [s for s in item.children if s.status == 'active']
    for subitem in active_subitems:
        for detail in subitem.details:
            process(detail)
```

---

### Long Parameter Lists

**Thresholds**:
- **0-3 parameters**: ✅ Ideal
- **4-5 parameters**: ⚠️ Consider options object
- **6+ parameters**: ❌ Too many, refactor

**Detection**:
```bash
# Find functions with many parameters
grep -E "(function|def)\s+\w+\([^)]{60,}\)" file.ts
```

**Example - Too Many Parameters**:
```javascript
// 8 parameters - too many
function createUser(firstName, lastName, email, phone, address, city, country, zipCode) {
  // ...
}
```

**Recommendation**: Use options object
```javascript
// Better: Options object
function createUser(userData) {
  const { firstName, lastName, email, phone, address, city, country, zipCode } = userData;
  // ...
}

// Usage
createUser({
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  address: '123 Main St',
  city: 'Portland',
  country: 'US',
  zipCode: '97201'
});
```

---

## 2. Code Duplication Detection

### Types of Duplication

**Exact Duplication**: Identical code blocks
- **Threshold**: 6+ identical lines should be extracted

**Structural Duplication**: Similar structure, different values
- **Example**: Multiple similar validation functions

**Semantic Duplication**: Same functionality, different implementation
- **Example**: Two functions doing the same calculation differently

### Detection Strategies

**Manual Detection Patterns**:
```bash
# Find similar function names (often indicates duplication)
grep -r "function validate" src/

# Find repeated imports (may indicate duplicated logic)
grep -r "^import.*from" src/ | sort | uniq -c | sort -rn

# Find similar code patterns
grep -r "if.*&&.*&&" src/
```

**What to Look For**:
- Copy-pasted code with minor variations
- Similar validation logic across files
- Repeated error handling patterns
- Duplicated business logic

### When Duplication is Acceptable

**OK to duplicate**:
- Test setup code (each test should be independent)
- Configuration values (different contexts)
- Small utilities (<5 lines)
- Code that will diverge in the future

**Should extract**:
- Business logic (>10 lines)
- Complex algorithms
- Validation rules
- Data transformations

### Example - Problematic Duplication

```typescript
// File: src/components/UserForm.tsx
function validateUserForm(data) {
  if (!data.email) return 'Email required';
  if (!/\S+@\S+\.\S+/.test(data.email)) return 'Invalid email';
  if (!data.name) return 'Name required';
  if (data.name.length < 2) return 'Name too short';
  return null;
}

// File: src/components/ProfileForm.tsx
function validateProfileForm(data) {
  if (!data.email) return 'Email required';
  if (!/\S+@\S+\.\S+/.test(data.email)) return 'Invalid email';
  if (!data.name) return 'Name required';
  if (data.name.length < 2) return 'Name too short';
  return null;
}
```

**Recommendation**: Extract to shared utility
```typescript
// File: src/utils/validation.ts
export function validateEmailAndName(data) {
  if (!data.email) return 'Email required';
  if (!/\S+@\S+\.\S+/.test(data.email)) return 'Invalid email';
  if (!data.name) return 'Name required';
  if (data.name.length < 2) return 'Name too short';
  return null;
}

// Usage in both components
import { validateEmailAndName } from '@/utils/validation';
```

---

## 3. Code Smell Patterns

### Long Methods

**Detection**: Functions >50 lines

**Symptoms**:
- Method does multiple things
- Hard to name clearly
- Many comments explaining sections
- Multiple levels of abstraction

**Example**:
```python
# 80 lines - doing too much
def process_order(order_id):
    # Get order (10 lines)
    # Validate inventory (15 lines)
    # Calculate pricing (20 lines)
    # Process payment (15 lines)
    # Send notifications (10 lines)
    # Update analytics (10 lines)
```

**Fix**: Extract methods
```python
def process_order(order_id):
    order = get_order(order_id)
    validate_inventory(order)
    total = calculate_total(order)
    process_payment(order, total)
    send_order_notifications(order)
    track_order_analytics(order)
```

---

### Long Parameter Lists

See "Long Parameter Lists" in Complexity Metrics section above.

---

### God Classes

**Definition**: Classes that know/do too much

**Symptoms**:
- Class with 10+ methods
- Class with 10+ properties
- Class name is vague (Manager, Handler, Service, Util)
- Class touches multiple domains

**Detection**:
```bash
# Count methods in a class
awk '/^class|^export class/ {classname=$2} /^\s*(public|private|protected).*\(/ {count++} /^}/ && classname {print classname": "count" methods"; count=0}' file.ts
```

**Example**:
```typescript
// God class - does everything
class UserManager {
  validateUser()
  createUser()
  deleteUser()
  sendEmail()
  logActivity()
  generateReport()
  exportData()
  importData()
  processPayment()
  calculateMetrics()
}
```

**Fix**: Split by responsibility
```typescript
class UserService {
  createUser()
  deleteUser()
}

class UserValidator {
  validateUser()
}

class UserNotifications {
  sendEmail()
}

class UserAnalytics {
  logActivity()
  generateReport()
  calculateMetrics()
}
```

---

### Magic Numbers

**Definition**: Unexplained numeric/string literals

**Detection**:
```bash
# Find hardcoded numbers (excluding 0, 1, 2 which are usually OK)
grep -E "[^0-9][3-9][0-9]+" src/ | grep -v "const\|let\|var"
```

**Example - Magic Numbers**:
```typescript
// What do these numbers mean?
function processSubscription(user) {
  if (user.age < 18) return false;
  if (user.accountBalance < 9.99) return false;
  if (user.credits > 100) {
    user.credits -= 100;
  }
  setTimeout(renewSubscription, 2592000000);
}
```

**Fix**: Named constants
```typescript
const MINIMUM_AGE = 18;
const SUBSCRIPTION_PRICE = 9.99;
const CREDITS_PER_RENEWAL = 100;
const THIRTY_DAYS_MS = 30 * 24 * 60 * 60 * 1000;

function processSubscription(user) {
  if (user.age < MINIMUM_AGE) return false;
  if (user.accountBalance < SUBSCRIPTION_PRICE) return false;
  if (user.credits > CREDITS_PER_RENEWAL) {
    user.credits -= CREDITS_PER_RENEWAL;
  }
  setTimeout(renewSubscription, THIRTY_DAYS_MS);
}
```

---

### Dead Code

**Types**:
- Commented-out code
- Unused functions
- Unused variables
- Unreachable code

**Detection**:
```bash
# Find commented-out code
grep -r "^\\s*//.*function\|^\\s*//.*const\|^\\s*#.*def" src/

# Find exports (then check if imported elsewhere)
grep -r "^export" src/

# Find unreachable code after return
grep -A5 "return" src/ | grep -B1 "^\s*[a-z]"
```

**Example - Dead Code**:
```typescript
function processUser(user) {
  if (user.isActive) {
    return processActiveUser(user);
  }
  return null;

  // Dead code - never reached
  console.log('Processing user');
  validateUser(user);
}

// Commented-out code - use git history instead
// function oldProcessUser(user) {
//   // ... 50 lines of old implementation
// }

// Unused function - no imports found
export function unusedHelper() {
  // ...
}
```

**Fix**: Remove dead code
```typescript
function processUser(user) {
  if (user.isActive) {
    return processActiveUser(user);
  }
  return null;
}

// Remove commented-out code
// Remove unused exports
```

---

### TODO/FIXME Comments

**Detection**:
```bash
# Find all TODO/FIXME comments
grep -rn "TODO\|FIXME\|XXX\|HACK\|BUG" src/
```

**When TODO is OK**:
- Documented in issue tracker
- Has owner and deadline
- Non-critical enhancement

**When TODO is a problem**:
- Critical functionality
- Security issue
- Performance problem
- No corresponding issue
- Old TODO (>3 months)

**Example - Problematic TODOs**:
```typescript
// TODO: Add authentication (CRITICAL - should not ship without this!)
app.post('/admin/delete-all', (req, res) => {
  database.dropAllTables();
});

// FIXME: Memory leak here (PERFORMANCE - serious issue)
function loadData() {
  // Loads entire database into memory
}

// TODO: Validate input (added 2 years ago - forgotten)
```

**Recommendation**:
```markdown
**Critical TODOs** (Severity: Critical/Warning):
- Convert to issues
- Assign owner
- Set deadline
- Fix before production

**Enhancement TODOs** (Severity: Info):
- Document in backlog
- Add issue reference in comment
- Example: `// TODO: Add pagination - See issue #123`
```

---

## 4. Project-Specific Considerations

### Language-Specific Patterns

**JavaScript/TypeScript**:
- Avoid var (use const/let)
- Use async/await over callbacks
- Prefer optional chaining (?.)
- Use TypeScript types properly

**Python**:
- Follow PEP 8 (line length, naming)
- Use list comprehensions appropriately
- Avoid deeply nested comprehensions
- Use context managers (with statements)

**Go**:
- Follow effective Go guidelines
- Keep functions small
- Error handling not ignored
- Use defer appropriately

### Framework Patterns

**React**:
- Components <200 lines
- Custom hooks for logic reuse
- Proper dependency arrays
- Avoid inline functions in render

**Express/Node**:
- Middleware is focused
- Route handlers are thin
- Business logic in services
- Proper error handling middleware

---

## 5. Reporting Format

### Finding Template

```markdown
### [Category] - [Brief Description]

**Location**: `file.ts:123`
**Severity**: [Critical/Warning/Info]

**Issue**:
[Clear description of what's wrong]

**Current Code**:
```[language]
[Code snippet showing the issue]
```

**Why This Matters**:
[Explain the impact]

**Recommendation**:
[How to fix it]

**Example**:
```[language]
[Code showing the fix]
```

**Effort**: [Low/Medium/High]
```

### Metrics Summary Template

```markdown
## Code Quality Metrics

**Complexity**:
- Functions analyzed: [N]
- High complexity (>15): [N] functions
- Average complexity: [N]
- Max complexity: [N] in `file.ts:line`

**Size**:
- Average function length: [N] lines
- Long functions (>50 lines): [N]
- Longest function: [N] lines in `file.ts:line`

**Maintainability**:
- Code duplication instances: [N]
- TODO/FIXME comments: [N]
- Dead code instances: [N]
```

---

## Summary

This guide provides comprehensive patterns for detecting code quality issues. Use these patterns during Phase 2 of the code-reviewer skill to identify complexity, duplication, and code smells. Always provide specific locations, clear explanations, and actionable recommendations.