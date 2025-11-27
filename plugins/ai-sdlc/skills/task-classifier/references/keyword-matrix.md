# Keyword Classification Matrix

> **Design Documentation**: This file serves as **design documentation** for developers extending or understanding the classification methodology. The actual runtime classification logic is embedded in the `agents/task-classifier.md` subagent file for path-independence when the plugin runs in user projects. This document explains the patterns and reasoning behind the embedded implementation.

This document provides the complete keyword patterns, matching rules, and confidence calculations for all 8 task types.

## Classification Priority

When multiple types match, use this priority order:

1. **Security** (CRITICAL OVERRIDE) - Always takes precedence
2. **Keyword Count** - Type with most matches wins
3. **Context Analysis** - Component found, error verified, etc.
4. **User Confirmation** - If still ambiguous, ask user

## Task Type Patterns

### 1. Security (CRITICAL)

**Priority**: ALWAYS OVERRIDES OTHER TYPES

**Keywords**:
```
Primary (Critical):
- vulnerability
- CVE-*
- exploit
- SQL injection
- XSS
- CSRF
- security issue
- auth bypass
- authentication bypass
- privilege escalation
- code injection
- command injection

Secondary (High Priority):
- sensitive data
- password leak
- credential exposure
- insecure
- security flaw
- security hole
- backdoor
- malicious
- unsafe

Context Indicators:
- OWASP Top 10 mentions
- CWE numbers
- Security advisory references
- Penetration test findings
```

**Confidence Calculation**:
```
Any primary keyword match → 98% (critical)
Any secondary keyword match → 96% (critical)
Multiple matches → 98% (capped at 98%)

IMPORTANT: Security confidence never falls below 95%
```

**Examples**:
```
"Fix SQL injection in login form" → 98%
"Patch CVE-2024-1234 vulnerability" → 98%
"Resolve XSS security issue" → 97%
"Fix authentication bypass bug" → 97%
```

**Special Rules**:
- ALWAYS show security warning
- ALWAYS require explicit user confirmation
- NEVER auto-proceed without approval
- Flag as critical priority in metadata

---

### 2. Bug Fix

**Priority**: High (after security)

**Keywords**:
```
Primary (Strong):
- fix
- bug
- broken
- error
- crash
- defect
- fault
- regression

Action + Problem:
- resolve issue
- correct problem
- repair
- patch

Error Indicators:
- timeout
- exception
- null pointer
- undefined
- stack trace
- error code
- fails
- doesn't work
- not working

State Descriptions:
- incorrect behavior
- wrong output
- unexpected result
- malfunction
```

**Context Boosters** (+10% each):
- Error message found in code
- Stack trace references existing files
- Exception name found in codebase
- Recent related fixes in git history
- Issue labeled as "bug"

**Confidence Calculation**:
```
Base: 50%

3+ primary keywords → +30% = 80%
2 primary keywords → +25% = 75%
1 primary keyword → +15% = 65%

Each context booster → +10%
Error pattern verified → +10%
Issue label "bug" → +5%

Cap at 94%
```

**Examples**:
```
"Fix login timeout error on mobile"
→ Keywords: fix (15%), timeout (10%), error (5%) = 30%
→ Context: error found in code (+10%)
→ Total: 80% + 10% = 90%

"Bug causing crash in checkout"
→ Keywords: bug (15%), crash (10%) = 25%
→ Total: 75%

"Resolve NullPointerException in UserService"
→ Keywords: resolve (15%), exception (10%) = 25%
→ Context: NullPointerException found in code (+10%)
→ Total: 85%
```

**Anti-Patterns** (NOT bugs):
- "fix by refactoring" → Refactoring (primary intent is restructure)
- "fix performance" → Performance (optimization, not bug)
- "fix security issue" → Security (critical override)

---

### 3. Enhancement

**Priority**: Medium

**Keywords**:
```
Primary (Must have "existing" context):
- improve
- enhance
- better
- upgrade existing
- extend existing
- augment existing
- add to existing
- update existing

Quality Improvements:
- optimize existing
- refine existing
- polish existing
- strengthen existing

Scope Expansion:
- expand existing
- extend capability
- add feature to
- more features for

Modernization:
- modernize existing
- update to latest
- bring up to date
```

**CRITICAL REQUIREMENT**:
Must have evidence of existing component:
- Component found in codebase (Grep search)
- Mentioned in documentation
- Referenced in recent commits
- User confirms it exists

**Context Boosters** (+10% each):
- Component found with high confidence (4+ matches)
- Component in docs/INDEX.md
- Recent work on same component
- Issue label "enhancement"

**Confidence Calculation**:
```
Base: 50%

WITH component found:
2+ keywords + component found → +35% = 85%
1 keyword + component found → +28% = 78%

WITHOUT component found:
→ LOW confidence (ask user)
→ or reclassify as new-feature

Each context booster → +10%
Component in docs → +5%
Issue label "enhancement" → +5%

Cap at 94%
```

**Examples**:
```
"Improve existing user dashboard with filters"
→ Keywords: improve (15%), existing (10%), filters (5%) = 30%
→ Context: Dashboard found in codebase (+10%)
→ Total: 80% + 10% = 90%

"Add sorting to existing user table"
→ Keywords: add (15%), existing (10%), sorting (5%) = 30%
→ Context: UserTable component found (+10%)
→ Total: 80% + 10% = 90%

"Enhance authentication flow"
→ Keywords: enhance (15%), authentication (5%) = 20%
→ Context: Auth flow found (+10%)
→ Total: 70% + 10% = 80%
```

**Disambiguation from New Feature**:
```
"Add dark mode to app"
→ Check if theme system exists
→ If yes: Enhancement (adding to existing theme system) → 82%
→ If no: New Feature (creating theme system) → 70%

Always perform codebase search to distinguish!
```

---

### 4. New Feature

**Priority**: Medium (often ambiguous with enhancement)

**Keywords**:
```
Primary (WITHOUT "existing" context):
- add
- new
- create
- build
- implement
- develop

Scope Indicators:
- new feature
- new capability
- new functionality
- from scratch
- initial

System Additions:
- introduce
- bring in
- incorporate
- integrate new

Construction:
- build out
- set up
- establish
- scaffold
```

**CRITICAL REQUIREMENT**:
Must NOT have evidence of existing component:
- Component not found in codebase
- Not mentioned in current docs
- No recent related work
- User confirms it's new

**Context Indicators** (+10% each):
- Component definitely not found (0 matches)
- Mentioned in roadmap as planned
- Large scope (multiple components)
- Issue label "feature" or "new"

**Confidence Calculation**:
```
Base: 50%

WITHOUT component found:
2+ keywords + component NOT found → +20% = 70%
1 keyword + component NOT found → +15% = 65%

WITH component found:
→ Likely Enhancement, not New Feature
→ Ask user for clarification

Roadmap mention → +10%
Large scope → +5%
Issue label "feature" → +5%

Cap at 85% (often ambiguous)
```

**Examples**:
```
"Build shopping cart functionality"
→ Keywords: build (15%), functionality (5%) = 20%
→ Context: Cart component not found (+10%)
→ Total: 70% + 10% = 80%

"Create new payment processing system"
→ Keywords: create (15%), new (10%), system (5%) = 30%
→ Context: Payment system not found (+10%)
→ Total: 80% + 10% = 90%

"Add dark mode"
→ Keywords: add (15%) = 15%
→ Context: Theme system not found (+10%)
→ Total: 65% + 10% = 75%
→ Note: Medium confidence, may need confirmation
```

**Disambiguation from Enhancement**:
```
"Add user profiles"
→ Check codebase for profile-related components
→ If Profile component found: Enhancement (85%)
→ If not found: New Feature (75%)
→ If partial match: Ask user for clarification

"Implement authentication"
→ Check for existing auth system
→ If found: Enhancement (improving auth)
→ If not found: New Feature (creating auth)
```

---

### 5. Refactoring

**Priority**: Medium

**Keywords**:
```
Primary:
- refactor
- clean up
- restructure
- reorganize
- simplify code
- improve structure
- reduce complexity

Code Quality:
- remove duplication
- extract method/class
- rename for clarity
- consolidate
- modularize

Architecture:
- decouple
- separate concerns
- improve architecture
- redesign structure

Cleanup:
- remove dead code
- eliminate
- prune
- tidy up
```

**Context Indicators** (+10% each):
- Code smell terms mentioned (duplication, complexity, coupling)
- Metrics mentioned (cyclomatic complexity, LOC)
- Architecture patterns mentioned (MVC, layered, microservices)
- NO behavior change intended
- Issue label "refactoring" or "tech-debt"

**Confidence Calculation**:
```
Base: 50%

2+ keywords → +34% = 84%
1 keyword + code smell → +26% = 76%
1 keyword only → +20% = 70%

Each context indicator → +10%
Metrics mentioned → +5%
Issue label "refactoring" → +5%

Cap at 94%
```

**Examples**:
```
"Refactor and clean up authentication code"
→ Keywords: refactor (15%), clean up (10%), authentication (5%) = 30%
→ Total: 80%

"Simplify complex user service structure"
→ Keywords: simplify (15%), complex (10%), structure (5%) = 30%
→ Context: Code smell "complex" mentioned (+10%)
→ Total: 80% + 10% = 90%

"Remove duplication in API handlers"
→ Keywords: remove duplication (15%), handlers (5%) = 20%
→ Context: Code smell "duplication" (+10%)
→ Total: 70% + 10% = 80%
```

**Anti-Patterns** (NOT refactoring):
- "Refactor to add new feature" → New Feature (adding functionality)
- "Refactor to fix bug" → Bug Fix (primary goal is fixing)
- "Refactor to improve performance" → Performance (optimization focus)

**Key Distinction**:
Refactoring = No behavior change (structure only)
If behavior changes → It's NOT refactoring

---

### 6. Performance

**Priority**: Medium

**Keywords**:
```
Primary:
- slow
- performance
- optimize
- speed up
- faster
- bottleneck
- latency

Measurement:
- load time
- response time
- throughput
- reduce time
- improve speed

Resource:
- memory usage
- CPU usage
- resource consumption
- efficiency

Scaling:
- scalability
- handle more load
- capacity
- concurrent users

Specific Optimizations:
- caching
- lazy loading
- pagination
- indexing
- query optimization
```

**Context Indicators** (+10% each):
- Performance metrics mentioned (5s load, 200ms response)
- Profiling tools mentioned
- Benchmarks mentioned
- Load testing mentioned
- Issue label "performance"

**Confidence Calculation**:
```
Base: 50%

2+ keywords → +36% = 86%
1 keyword + metrics → +28% = 78%
1 keyword only → +20% = 70%

Each metric mentioned → +10%
Benchmark mentioned → +5%
Issue label "performance" → +5%

Cap at 94%
```

**Examples**:
```
"Optimize slow database queries for faster loading"
→ Keywords: optimize (15%), slow (10%), faster (5%), queries (5%) = 35%
→ Total: 85%

"Improve page load time from 5s to 1s"
→ Keywords: improve (15%), load time (10%) = 25%
→ Context: Metrics "5s to 1s" mentioned (+10%)
→ Total: 75% + 10% = 85%

"Fix performance bottleneck in search"
→ Keywords: fix (15%), performance (10%), bottleneck (5%) = 30%
→ Total: 80%
```

**Disambiguation from Bug Fix**:
```
"Fix slow query"
→ Could be bug or performance
→ If "slow" is unexpected → Bug (broken functionality)
→ If "slow" is optimization → Performance (improvement)
→ Check context: Error mentioned? → Bug
→ No error, just "too slow"? → Performance
```

---

### 7. Migration

**Priority**: Medium

**Keywords**:
```
Primary:
- migrate
- migration
- move from X to Y
- upgrade to
- switch from
- port to
- convert from/to
- replace X with Y

Technology Change:
- adopt new
- transition to
- change to
- shift to
- move to

Version Upgrade:
- upgrade from version X to Y
- update to latest
- migrate to v2

Platform Change:
- move to cloud
- migrate to AWS/Azure
- containerize
- dockerize
```

**Context Indicators** (+10% each):
- Technology names mentioned (React, Vue, Python, Java)
- Version numbers mentioned (v1 to v2, Node 14 to Node 18)
- Framework names mentioned
- Architecture shift mentioned
- Issue label "migration"

**Confidence Calculation**:
```
Base: 50%

2+ keywords + tech names → +37% = 87%
1 keyword + tech names → +30% = 80%
1 keyword only → +20% = 70%

Each tech name pair → +10%
Version numbers → +5%
Issue label "migration" → +5%

Cap at 94%
```

**Examples**:
```
"Migrate from Redux to Zustand state management"
→ Keywords: migrate (15%), from to (10%), state management (5%) = 30%
→ Context: Two tech names (Redux, Zustand) (+10%)
→ Total: 80% + 10% = 90%

"Upgrade from React 17 to React 18"
→ Keywords: upgrade (15%), from to (10%) = 25%
→ Context: Version numbers (+5%)
→ Total: 75% + 5% = 80%

"Move API from REST to GraphQL"
→ Keywords: move (15%), from to (10%), API (5%) = 30%
→ Context: Two tech patterns (REST, GraphQL) (+10%)
→ Total: 80% + 10% = 90%
```

**Key Distinction**:
Migration = Technology/platform/version change
Not migration = Adding new tech alongside existing (that's New Feature or Enhancement)

---

### 8. Documentation

**Priority**: Low (rarely ambiguous)

**Keywords**:
```
Primary:
- document
- documentation
- docs
- guide
- readme
- tutorial

Creation:
- write documentation
- create guide
- document how
- explain
- describe

Types:
- API documentation
- user guide
- developer guide
- technical documentation
- inline comments

Maintenance:
- update docs
- improve documentation
- fix documentation
- document changes
```

**Context Indicators** (+10% each):
- File types mentioned (.md, README, docs/)
- Documentation tools mentioned (JSDoc, Swagger, Docusaurus)
- Specifically about writing/creating content
- Issue label "documentation"

**Confidence Calculation**:
```
Base: 50%

2+ keywords → +33% = 83%
1 keyword + "write" verb → +25% = 75%
1 keyword only → +18% = 68%

Documentation tool mentioned → +10%
File type mentioned → +5%
Issue label "documentation" → +5%

Cap at 94%
```

**Examples**:
```
"Write API documentation and developer guide"
→ Keywords: write (5%), API documentation (15%), guide (10%) = 30%
→ Total: 80%

"Document authentication flow in README"
→ Keywords: document (15%), README (10%), flow (5%) = 30%
→ Total: 80%

"Update docs for new payment API"
→ Keywords: update (5%), docs (15%), API (5%) = 25%
→ Total: 75%
```

**Anti-Pattern** (NOT documentation):
- "Document issue in tracking system" → Bug Fix (reporting bug)
- "Document causes crash" → Bug Fix (file/document entity causes error)

---

## Multi-Type Resolution Examples

### Example 1: Performance vs Bug Fix

```
Input: "Fix slow database query performance"

Analysis:
- Keywords:
  - fix: bug-fix (15%)
  - slow: performance (15%)
  - performance: performance (10%)
  - query: both (5%)

- Scores:
  - bug-fix: 15% + 5% = 20%
  - performance: 15% + 10% + 5% = 30%

Resolution: Performance wins (higher score)
Confidence: 80%
```

### Example 2: Refactoring vs Bug Fix

```
Input: "Refactor authentication to fix security issue"

Analysis:
- Keywords:
  - refactor: refactoring (15%)
  - fix: bug-fix (15%)
  - security issue: SECURITY (CRITICAL)

Resolution: Security wins (critical override)
Confidence: 97%
```

### Example 3: Enhancement vs New Feature (Ambiguous)

```
Input: "Add user profile editing"

Analysis:
- Keywords:
  - add: enhancement/new-feature (15%)
  - user profile: context-dependent
  - editing: enhancement (5%)

- Context Search:
  Grep for "UserProfile", "user-profile", "profile"

  Scenario A: Profile component found
  → Enhancement: 15% + 10% (component) + 5% = 30% → 80%

  Scenario B: Profile component NOT found
  → New Feature: 15% + 10% (not found) = 25% → 75%

  Scenario C: Partial match (ProfileCard but no editing)
  → Medium confidence (70%) → Ask user

Resolution: Context-dependent
Action: Perform codebase search, then classify
```

### Example 4: Three-Way Tie

```
Input: "Improve API response time by optimizing code structure"

Analysis:
- Keywords:
  - improve: enhancement (15%)
  - response time: performance (10%)
  - optimizing: performance (10%)
  - code structure: refactoring (10%)

- Scores:
  - enhancement: 15%
  - performance: 10% + 10% = 20%
  - refactoring: 10%

Resolution: Performance wins (highest score)
Confidence: 70% (but competing types present)
Action: Present top 3 options, let user choose
```

---

## Confidence Thresholds

| Range | Level | Action | Auto-Proceed |
|-------|-------|--------|--------------|
| 95-98% | Critical | Security warning + confirmation | No |
| 80-94% | High | Quick confirmation with override option | Yes (with confirmation) |
| 60-79% | Medium | Show classification, ask to confirm | No |
| <60% | Low | Present all 8 options | No |

---

## Keyword Matching Best Practices

1. **Case-Insensitive**: Always normalize to lowercase
2. **Multi-Word Phrases**: Match "SQL injection" as single phrase
3. **Word Boundaries**: "fix" should match "fixing", "fixed", "fixes"
4. **Stemming**: Consider stemming (optimize → optimization → optimizing)
5. **Context Matters**: Same keyword means different things in different contexts
6. **Combination Patterns**: Some patterns only meaningful together ("move from X to Y")

---

## Special Keyword Considerations

### Security is ALWAYS Critical

Even if other types have higher keyword counts, security override applies:

```
"Refactor authentication code to fix XSS vulnerability"
- refactoring: 2 keywords
- security: 1 keyword (XSS)
→ Security wins (critical override)
```

### "Fix" Doesn't Always Mean Bug

```
"Fix performance issues" → Performance (optimization)
"Fix by refactoring" → Refactoring (structure change)
"Fix security vulnerability" → Security (critical)
"Fix login error" → Bug Fix (actual bug)
```

Context determines meaning!

### "Add" is Ambiguous

```
"Add sorting to existing table" → Enhancement
"Add new shopping cart" → New Feature
"Add to existing feature" → Enhancement
"Add feature" → New Feature (no "existing")
```

Always check for "existing" context!

---

## Testing the Keyword Matrix

To verify keyword matching works correctly, test with these cases:

1. **Clear Security**: "Fix SQL injection vulnerability" → 98%
2. **Clear Bug**: "Fix login timeout error" → 88%
3. **Clear Enhancement**: "Improve existing dashboard" → 85% (if component found)
4. **Clear New Feature**: "Build shopping cart" → 80% (if component not found)
5. **Clear Refactoring**: "Refactor and clean up code" → 84%
6. **Clear Performance**: "Optimize slow queries" → 86%
7. **Clear Migration**: "Migrate from Redux to Zustand" → 87%
8. **Clear Documentation**: "Write API documentation" → 83%
9. **Ambiguous**: "Work on dashboard" → <60% (ask user)
10. **Multi-type**: "Improve performance by refactoring" → 65-70% (show options)
