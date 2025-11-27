# Context Analysis Strategies

> **Design Documentation**: This file serves as **design documentation** for developers extending or understanding the context analysis methodology. The actual runtime analysis logic is embedded in the `agents/task-classifier.md` subagent file for path-independence when the plugin runs in user projects. This document explains the strategies and reasoning behind the embedded implementation.

This document provides comprehensive strategies for analyzing project context and codebase to improve task classification accuracy, especially for distinguishing between enhancement, new feature, bug, and other ambiguous cases.

## Overview

Context analysis enhances keyword-based classification by:
1. **Codebase Search** - Determining if components exist (enhancement vs new feature)
2. **Error Pattern Analysis** - Verifying bugs through error messages/stack traces
3. **Git History** - Understanding recent changes and patterns
4. **Documentation Review** - Project context and roadmap
5. **Architecture Analysis** - Understanding system structure

---

## 1. Codebase Search (Enhancement vs New Feature)

**Critical for**: Distinguishing enhancement from new feature

### Purpose

Determine if a mentioned component/feature already exists in the codebase.

### Strategy

#### Step 1: Extract Component Names

From task description, extract potential component identifiers:

```
Examples:

"Add sorting to user table"
→ Components: ["user table", "UserTable", "user-table", "users", "table"]

"Improve authentication flow"
→ Components: ["authentication", "auth", "Auth", "login", "Login"]

"Build shopping cart"
→ Components: ["shopping cart", "ShoppingCart", "cart", "Cart"]

"Add dark mode"
→ Components: ["dark mode", "theme", "Theme", "ThemeProvider"]
```

**Extraction Rules**:
- Take noun phrases
- Generate common naming variations (camelCase, PascalCase, kebab-case, snake_case)
- Include singular and plural forms
- Consider abbreviations (authentication → auth)

#### Step 2: Search Strategies

Use Grep tool to search for components in order of confidence:

**Priority 1: Component/Class Definitions**
```bash
# Search for class/component definitions
grep -r "class UserTable" --include="*.{ts,tsx,js,jsx,py,java}"
grep -r "function UserTable" --include="*.{ts,tsx,js,jsx}"
grep -r "const UserTable" --include="*.{ts,tsx,js,jsx}"
grep -r "def UserTable" --include="*.py"

Confidence if found: HIGH (90%)
```

**Priority 2: File Names**
```bash
# Search for files with component name
Glob: "**/UserTable.*"
Glob: "**/*user-table.*"
Glob: "**/*user_table.*"

Confidence if found: HIGH (85%)
```

**Priority 3: Imports/Exports**
```bash
# Search for imports/exports
grep -r "import.*UserTable" --include="*.{ts,tsx,js,jsx}"
grep -r "export.*UserTable" --include="*.{ts,tsx,js,jsx}"
grep -r "from.*UserTable" --include="*.{ts,tsx,js,jsx,py}"

Confidence if found: MEDIUM-HIGH (75%)
```

**Priority 4: Component Usage**
```bash
# Search for component usage in code
grep -r "<UserTable" --include="*.{tsx,jsx}"  # React/JSX
grep -r "UserTable(" --include="*.{ts,tsx,js,jsx,py}"  # Function calls

Confidence if found: MEDIUM (65%)
```

**Priority 5: Related Terms**
```bash
# Broader search for related functionality
grep -r "user.*table" -i --include="*.{ts,tsx,js,jsx}"
grep -r "table.*user" -i --include="*.{ts,tsx,js,jsx}"

Confidence if found: LOW (40% - might be unrelated)
```

#### Step 3: Count and Assess Matches

```
Match Count Assessment:

0 matches → Component does NOT exist (New Feature)
  Confidence: 90%

1-2 matches → Component MIGHT exist (Low confidence)
  Confidence: 50%
  Action: Check if matches are relevant
  If relevant: Enhancement (70%)
  If not relevant: New Feature (60%)
  If unsure: Ask user

3-5 matches → Component LIKELY exists (Medium-High confidence)
  Confidence: 75%
  Action: Enhancement (80%)

6+ matches → Component DEFINITELY exists (High confidence)
  Confidence: 90%
  Action: Enhancement (90%)
```

#### Step 4: Verify Match Relevance

When matches found, verify they're relevant:

```
Read matching files to verify:

1. Is this the component mentioned?
   - Check if it matches domain (user table vs data table)
   - Verify functionality aligns

2. Is component complete or stub?
   - Complete component → Enhancement
   - Stub/placeholder → Could be New Feature

3. Is component active or deprecated?
   - Active → Enhancement
   - Deprecated → Might be replacement (New Feature)
```

### Examples

#### Example 1: Clear Enhancement

```
Task: "Add filtering to user table"

Search: "UserTable"

Results:
✓ src/components/UserTable.tsx (class UserTable)
✓ src/components/UserTable.test.tsx (test file)
✓ src/pages/Users.tsx (imports UserTable)
✓ src/pages/Admin.tsx (uses <UserTable />)

Match count: 4+
Assessment: Component exists, HIGH confidence
Classification: Enhancement (90%)
```

#### Example 2: Clear New Feature

```
Task: "Build shopping cart system"

Search: "ShoppingCart", "Cart", "cart"

Results:
✗ No "ShoppingCart" class found
✗ No cart-related files
✗ No cart imports
✗ No cart usage

Match count: 0
Assessment: Component does NOT exist, HIGH confidence
Classification: New Feature (90%)
```

#### Example 3: Ambiguous (Partial Match)

```
Task: "Add user profile editing"

Search: "UserProfile", "Profile", "profile"

Results:
✓ src/components/ProfileCard.tsx (shows profile)
✗ No profile editing functionality found
✗ No edit profile forms

Match count: 1 (partial)
Assessment: Profile viewing exists, editing does NOT
Classification: Ambiguous

Action: Ask user
"I found profile viewing (ProfileCard) but no editing functionality.
 Is this adding editing to the existing profile system? (Enhancement)
 Or creating profile editing from scratch? (New Feature)"
```

---

## 2. Error Pattern Analysis (Bug Verification)

**Critical for**: Verifying bug-fix classification with evidence

### Purpose

Confirm that mentioned errors/exceptions actually exist in the codebase and locate their source.

### Strategy

#### Step 1: Extract Error Patterns

From task description, extract error indicators:

```
Examples:

"Fix login timeout error"
→ Errors: ["timeout", "TimeoutError", "ERR_TIMEOUT"]

"Resolve NullPointerException in checkout"
→ Errors: ["NullPointerException", "null pointer", "checkout"]

"Fix 404 error on profile page"
→ Errors: ["404", "Not Found", "profile"]

"Crash when submitting form"
→ Errors: ["crash", "exception", "form submit"]
```

**Pattern Types**:
- Error messages: "timeout", "not found", "invalid"
- Exception names: "NullPointerException", "TimeoutError"
- HTTP status codes: 404, 500, 503
- Error codes: ERR_*, ERROR_*
- Crash indicators: "crash", "hang", "freeze"

#### Step 2: Search for Error Locations

Use Grep to find where errors occur:

**Search 1: Error Message Strings**
```bash
# Search for error messages in code
grep -r "timeout" --include="*.{ts,tsx,js,jsx,py,java}"
grep -r "ERR_TIMEOUT" --include="*.{ts,tsx,js,jsx,py,java}"

If found: Note file and line number
```

**Search 2: Exception Handling**
```bash
# Search for exception handling
grep -r "catch.*TimeoutError" --include="*.{ts,tsx,js,jsx}"
grep -r "except TimeoutError" --include="*.py"
grep -r "throw new TimeoutError" --include="*.{ts,tsx,js,jsx}"

If found: Confirms error type exists in codebase
```

**Search 3: Error Logging**
```bash
# Search for error logging
grep -r "error.*timeout" -i --include="*.{ts,tsx,js,jsx,py,java}"
grep -r "log.*timeout" -i --include="*.{ts,tsx,js,jsx,py,java}"

If found: Indicates where error is tracked
```

**Search 4: Component Context**
```bash
# If component mentioned, search within component
grep -r "timeout" src/components/Login.tsx
grep -r "error" src/services/AuthService.ts

If found in specific file: Strong bug indicator
```

#### Step 3: Analyze Stack Traces

If stack trace provided in task description:

```
Example Stack Trace:
  at AuthService.login (src/services/AuthService.ts:145)
  at LoginForm.handleSubmit (src/components/LoginForm.tsx:67)

Analysis:
1. Check files exist:
   ✓ src/services/AuthService.ts exists
   ✓ src/components/LoginForm.tsx exists

2. Check line numbers approximately correct:
   Read AuthService.ts:145 region
   Look for error-prone code (timeouts, network calls, etc.)

3. Verify functions exist:
   grep "login.*function" src/services/AuthService.ts
   grep "handleSubmit" src/components/LoginForm.tsx

If all verified: STRONG bug evidence (+20% confidence)
```

#### Step 4: Confidence Boost

Error pattern analysis confidence boosts:

```
+20%: Stack trace verified (files, functions exist)
+15%: Error message found in exact file mentioned
+10%: Exception type found in codebase
+10%: Error logging found with matching pattern
+5%: Generic error term found

Example:
"Fix timeout error in authentication"
→ Base bug confidence: 75% (keywords: fix, timeout, error)
→ "timeout" found in AuthService.ts (+10%)
→ "TimeoutError" exception handled (+10%)
→ Final confidence: 95%
```

### Examples

#### Example 1: Verified Bug

```
Task: "Fix login timeout error on mobile"

Error Search:
grep -r "timeout" src/auth/

Results:
✓ src/auth/AuthService.ts:145 - "Request timeout after 5000ms"
✓ src/auth/AuthService.ts:150 - throw new TimeoutError()
✓ src/auth/Login.tsx:67 - catch (TimeoutError) { ... }

Assessment: Error pattern VERIFIED
Confidence boost: +20%
Final classification: Bug Fix (95%)
```

#### Example 2: Unverified Error

```
Task: "Fix payment processing error"

Error Search:
grep -r "payment.*error" -i

Results:
✗ No "payment error" strings found
✗ No payment-related exception handling
✗ Generic "error" found in many places (not specific)

Assessment: Error pattern NOT verified
Confidence: Only keyword-based (70%)
Action: Ask user for more details or stack trace
```

---

## 3. Git History Analysis

**Critical for**: Understanding recent changes, identifying regressions

### Purpose

Analyze recent commits to understand:
- Recent bug fixes (possible regression)
- Recent features (possible enhancement)
- Related work (context)
- Recurring problems (pattern)

### Strategy

#### Step 1: Search Relevant Commits

```bash
# Search commit messages for keywords
git log --oneline -50 --all --grep="[component]" -i
git log --oneline -50 --all --grep="[keyword]" -i

# Search commits affecting specific files
git log --oneline -20 -- src/components/UserTable.tsx

# Search commits by author (if mentioned)
git log --oneline -20 --author="[name]"

# Search recent commits (last 30 days)
git log --oneline --since="30 days ago"
```

#### Step 2: Analyze Commit Patterns

Look for patterns in commit history:

**Recent Bug Fixes in Same Area**
```
Commits found:
- "Fix auth timeout on slow connections"
- "Handle timeout in login flow"
- "Add retry for timeout errors"

Assessment: Recent work on same issue
Classification boost: Bug Fix (+10%)
Possible: Regression or related issue
```

**Recent Feature Work**
```
Commits found:
- "Add user table to admin panel"
- "Implement table sorting"
- "Add table pagination"

Assessment: Recent feature development
Classification boost: Enhancement (+10%)
Context: Building on existing work
```

**Refactoring Activity**
```
Commits found:
- "Refactor auth service"
- "Extract auth utilities"
- "Simplify login logic"

Assessment: Recent refactoring
Classification: Possible follow-up refactoring
or bug introduced by refactoring
```

#### Step 3: Identify Regression Candidates

If bug mentioned and recent changes found:

```
Task: "Fix login timeout after update"

Git history:
- 3 days ago: "Update authentication library to v3.0"
- 2 days ago: "Fix auth imports after update"
- Today: "Fix login timeout after update" (current task)

Assessment: Likely REGRESSION from library update
Classification: Bug Fix (95%)
Context: Regression from recent change
Priority: High (fix for recent change)
```

#### Step 4: Extract Context

From commit messages, extract:
- Related issues (#123, PROJ-456)
- Related pull requests (PR #789)
- Breaking changes
- Migration notes

### Examples

#### Example 1: Regression Detection

```
Task: "Fix search not working after refactor"

Git log:
git log --oneline -20 --grep="search" -i

Results:
- "Refactor search to use new API" (5 days ago)
- "Update search tests" (5 days ago)
- Current: "Fix search not working"

Assessment: REGRESSION from refactor
Classification: Bug Fix (Regression) (92%)
```

#### Example 2: Enhancement Context

```
Task: "Add export to user table"

Git log:
git log --oneline -20 -- src/components/UserTable.tsx

Results:
- "Add user table with pagination" (2 weeks ago)
- "Add sorting to user table" (1 week ago)
- "Add filtering to user table" (3 days ago)
- Current: "Add export to user table"

Assessment: Ongoing enhancement of table features
Classification: Enhancement (88%)
Context: Part of incremental feature additions
```

---

## 4. Documentation Review

**Critical for**: Project context, roadmap alignment

### Purpose

Understand project context by reviewing:
- `.ai-sdlc/docs/INDEX.md` - Master documentation index
- `docs/project/vision.md` - Project goals
- `docs/project/roadmap.md` - Planned features
- `docs/project/tech-stack.md` - Technologies used
- `docs/standards/` - Coding conventions

### Strategy

#### Step 1: Read INDEX.md

```
Read .ai-sdlc/docs/INDEX.md

Extract:
1. Project type (new/existing/legacy)
2. Main technologies and frameworks
3. Architecture patterns
4. Available documentation
5. Issue tracker integration
6. Development priorities

Use for classification:
- If roadmap mentioned → Check if task is planned
- If tech stack specific → Better identify migration tasks
- If architecture documented → Context for refactoring
```

#### Step 2: Check Roadmap

```
Read docs/project/roadmap.md (if exists)

Look for task mentions:
- Planned features matching task description
- Completed features (might be enhancement)
- Known issues / tech debt

Examples:

Roadmap contains: "Add user profile editing - Q2 2024"
Task: "Build user profile editing"
→ Classification: New Feature (90%)
→ Context: Planned on roadmap

Roadmap contains: "Migrate to TypeScript - In Progress"
Task: "Convert auth to TypeScript"
→ Classification: Migration (92%)
→ Context: Part of larger migration effort
```

#### Step 3: Review Tech Stack

```
Read docs/project/tech-stack.md

Extract:
- Frontend: React, Vue, Angular?
- Backend: Node, Python, Java?
- Database: PostgreSQL, MongoDB?
- Infrastructure: AWS, Docker?

Use for:
- Identifying migration tasks
- Understanding architecture for refactoring
- Component naming conventions
```

### Examples

#### Example 1: Roadmap-Aligned Feature

```
Task: "Add dark mode support"

Roadmap check:
✓ Found in roadmap: "Dark mode support - Q1 2024 (planned)"

Assessment: Planned feature
Classification: New Feature (88%)
Priority: Normal (already planned)
```

#### Example 2: Tech Debt Item

```
Task: "Refactor legacy API endpoints"

Roadmap check:
✓ Found in tech debt section: "Refactor old REST endpoints (pre-v2)"

Assessment: Known tech debt
Classification: Refactoring (90%)
Priority: Medium (documented debt)
```

---

## 5. Architecture Analysis

**Critical for**: Refactoring, migration classification

### Purpose

Understand system architecture to better identify:
- Refactoring opportunities
- Migration patterns
- Performance bottlenecks
- Architectural changes

### Strategy

#### Step 1: Identify Architecture Pattern

```
Read docs/project/architecture.md (if exists)
Or infer from codebase structure:

Common Patterns:
- MVC (Model-View-Controller)
- Layered (Presentation, Business, Data)
- Microservices
- Monolith
- Event-driven
- Domain-driven design

Use Glob to analyze structure:
Glob: "src/controllers/**"  → MVC
Glob: "src/services/**"     → Layered
Glob: "services/*/src/**"   → Microservices
```

#### Step 2: Map Components to Layers

```
If task mentions component, identify its layer:

"Refactor user service"
→ Find: src/services/UserService.ts
→ Layer: Business logic
→ Pattern: Service layer refactoring
→ Classification: Refactoring (85%)

"Optimize database queries in user repository"
→ Find: src/repositories/UserRepository.ts
→ Layer: Data access
→ Pattern: Data layer optimization
→ Classification: Performance (88%)
```

#### Step 3: Identify Cross-Cutting Concerns

```
Cross-cutting concerns often indicate refactoring:
- Logging
- Error handling
- Authentication/Authorization
- Validation
- Caching

Task: "Centralize error handling across services"
→ Pattern: Cross-cutting concern
→ Classification: Refactoring (87%)
```

---

## Confidence Calculation with Context

Combine all context analysis for final confidence:

```
Base confidence: 50%

Keyword matching: +30%
Codebase search: +10% (component found)
Error verification: +10% (error found in code)
Git history: +5% (recent related work)
Documentation: +5% (mentioned in roadmap)
Architecture: +5% (aligns with patterns)

Final confidence: 115% → Cap at 98%
```

---

## Context Analysis Checklist

Before finalizing classification, ensure:

- [ ] Codebase searched for mentioned components
- [ ] Component existence assessed (enhancement vs new feature)
- [ ] Error patterns searched if bug suspected
- [ ] Git history checked for recent related work
- [ ] Project documentation reviewed for context
- [ ] Roadmap checked for planned work
- [ ] Architecture considered for refactoring/migration
- [ ] All context incorporated into confidence score

---

## Performance Considerations

Context analysis can be time-consuming. Optimize by:

1. **Parallel Searches**: Run grep searches in parallel
2. **Limit Scope**: Search most likely locations first
3. **Cache Results**: Cache documentation reads
4. **Time Budget**: Allocate max 3-5 seconds for context analysis
5. **Progressive Enhancement**: Start with quick checks, expand if needed

---

## Example: Full Context Analysis

```
Task: "Add sorting to user management table"

Context Analysis:

1. Codebase Search:
   grep -r "UserTable\|user-table" --include="*.{ts,tsx}"
   → Found: src/components/UserTable.tsx (class UserTable)
   → Result: Component EXISTS → Enhancement

2. Git History:
   git log --oneline -20 --grep="user table" -i
   → Found: "Add user table to admin panel" (1 month ago)
   → Found: "Add pagination to user table" (2 weeks ago)
   → Result: Recent enhancements, ongoing work → Enhancement

3. Documentation:
   Read .ai-sdlc/docs/project/roadmap.md
   → Found: "Admin improvements - user table enhancements (Q1)"
   → Result: Planned work → Enhancement

4. Architecture:
   Component location: src/components/ (presentation layer)
   → Pattern: UI component enhancement
   → Result: Enhancement

Final Classification:
- Type: Enhancement
- Confidence: 88%
- Context: Adding functionality to existing component
- Evidence: Component found, recent related work, planned on roadmap
```

This comprehensive context analysis transforms a simple keyword match into a highly confident, evidence-based classification.
