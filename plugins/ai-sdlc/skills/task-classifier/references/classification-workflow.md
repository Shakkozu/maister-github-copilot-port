# Task Classification Workflow - Detailed Reference

> **Design Documentation**: This file serves as **design documentation** for developers extending or understanding the classification workflow. The actual runtime workflow logic is embedded in the `agents/task-classifier.md` subagent file for path-independence when the plugin runs in user projects. This document explains the workflow phases and reasoning behind the embedded implementation.

This document provides a comprehensive, step-by-step guide for the task classification process.

## Overview

The classification workflow has 5 main phases:
1. **Input Processing & Issue Fetching** - Parse input, detect and fetch external issues
2. **Context Analysis** - Analyze codebase and project context
3. **Keyword Classification** - Match keywords against patterns
4. **User Confirmation** - Confidence-based confirmation flow
5. **Output Classification** - Generate structured result

## Phase 1: Input Processing & Issue Fetching

### Step 1.1: Parse Input

Extract the task description or identifier from the invocation:

**Direct Description**:
```
Input: "Fix login timeout error on mobile devices"
→ Parse as plain text description
→ Proceed to keyword classification
```

**GitHub Identifiers**:
```
Patterns:
- #123
- GH-123
- github.com/owner/repo/issues/123
- https://github.com/owner/repo/issues/123

Input: "https://github.com/acme/app/issues/456"
→ Detected: GitHub issue
→ Extract: owner=acme, repo=app, issue=456
→ Proceed to issue fetching
```

**Jira Identifiers**:
```
Patterns:
- PROJ-123
- KEY-456
- company.atlassian.net/browse/PROJ-123

Input: "PROJ-456"
→ Detected: Jira ticket
→ Extract: project=PROJ, issue=456
→ Proceed to issue fetching
```

**Generic Issue URLs**:
```
Patterns:
- URLs containing: "issue", "ticket", "bug", "task"
- Custom issue tracker patterns

Input: "https://company.com/tracker/issue/789"
→ Detected: Generic issue URL
→ Attempt to fetch if MCP available
→ Otherwise, prompt user for details
```

### Step 1.2: Check Available MCPs

Before fetching, determine what integration tools are available:

```bash
# List all MCP tools
Check available tools for patterns:
- mcp__github__*
- mcp__jira__*
- Any custom issue tracker MCPs

# Check project documentation
Read .ai-sdlc/docs/INDEX.md:
- Look for "Issue Tracking" or "External Integrations"
- Check for API endpoints or credentials
- Note any custom integration patterns

# Check standards
Read .ai-sdlc/docs/standards/:
- Look for integration standards
- Check for API usage patterns
- Note authentication requirements
```

**Result Examples**:
```
Scenario A: GitHub MCP available
→ Can fetch GitHub issues directly
→ Use mcp__github__get_issue tool

Scenario B: No MCP, but project docs mention GitHub
→ Cannot fetch automatically
→ Prompt user to manually provide details
→ Guide user to paste relevant information

Scenario C: No integration available
→ Skip issue fetching
→ Use provided description only
→ Proceed to keyword classification
```

### Step 1.3: Fetch Issue Details

#### GitHub Issue Fetching

If GitHub MCP available and GitHub issue detected:

```
1. Extract components:
   URL: https://github.com/acme/app/issues/456
   → owner: acme
   → repo: app
   → issue_number: 456

2. Invoke GitHub MCP:
   Tool: mcp__github__get_issue
   Parameters:
     - owner: acme
     - repo: app
     - issue_number: 456

3. Extract from response:
   - title: "Login timeout on mobile"
   - body: Full issue description
   - labels: ["bug", "mobile", "authentication"]
   - state: "open"
   - created_at: timestamp
   - comments: Array of comments (optional)

4. Build enhanced description:
   Title: [title]
   Description: [body]
   Labels: [labels]

   Classification hints:
   - "bug" label → Strong bug-fix indicator
   - "enhancement" label → Enhancement indicator
   - "feature" label → New feature indicator
```

#### Jira Ticket Fetching

If Jira MCP available and Jira ticket detected:

```
1. Extract components:
   Ticket: PROJ-456
   → project: PROJ
   → issue: 456

2. Invoke Jira MCP (if available):
   Tool: mcp__jira__get_issue (or equivalent)
   Parameters:
     - issue_key: PROJ-456

3. Extract from response:
   - summary: "Optimize database queries"
   - description: Full ticket details
   - issueType: "Task" | "Bug" | "Story"
   - priority: "High" | "Medium" | "Low"
   - labels: Array of labels
   - comments: Array of comments

4. Build enhanced description:
   Summary: [summary]
   Description: [description]
   Type: [issueType]

   Classification hints:
   - issueType "Bug" → Bug-fix
   - issueType "Story" → New feature or enhancement
   - issueType "Task" → Context-dependent
   - "Performance" label → Performance task
```

#### Fallback: Manual Details

If no MCP available:

```
Present to user:
┌────────────────────────────────────────────────────┐
│ Issue Reference Detected                           │
├────────────────────────────────────────────────────┤
│ Issue: [identifier]                                │
│                                                     │
│ I don't have access to fetch this issue's details. │
│ Please provide the following information:          │
│                                                     │
│ 1. Brief description of the task:                  │
│    [Text input]                                     │
│                                                     │
│ 2. What needs to be done?                          │
│    ○ Fix a bug or error                            │
│    ○ Improve existing functionality                │
│    ○ Add new feature                               │
│    ○ Other: _______                                │
│                                                     │
│ 3. Any additional context:                         │
│    [Text input]                                     │
└────────────────────────────────────────────────────┘

Use AskUserQuestion to collect this information
```

### Step 1.4: Combine and Normalize Description

Merge all sources into unified description:

```
From issue fetch (if available):
  Title: [issue title]
  Description: [issue body]
  Labels: [labels]
  Type: [issue type]

From user input:
  Description: [provided description]
  Context: [additional context]

Combined description = Title + Description + Context

Normalize:
  - Convert to lowercase for matching
  - Preserve original for display
  - Extract key phrases
  - Identify technical terms
```

## Phase 2: Context Analysis

### Step 2.1: Read Project Documentation

```
Read .ai-sdlc/docs/INDEX.md:

Extract:
1. Project type (new/existing/legacy)
2. Main technologies and frameworks
3. Architecture patterns
4. Available standards
5. Roadmap items (if present)
6. Issue tracker configuration

Note anything relevant for classification:
- If roadmap mentions planned features → Check if task is on roadmap
- If standards mention conventions → Use for context
- If tech stack includes specific frameworks → Note for migration detection
```

### Step 2.2: Codebase Analysis for Enhancement vs New Feature

This is CRITICAL for distinguishing enhancement from new feature.

#### Step 2.2.1: Extract Component Names

From description, extract potential component/feature names:

```
Examples:
"Add sorting to user table"
→ Components: ["user table", "UserTable", "users", "table"]

"Improve authentication flow"
→ Components: ["authentication", "auth", "Auth", "login"]

"Build shopping cart"
→ Components: ["shopping cart", "cart", "Cart", "ShoppingCart"]
```

#### Step 2.2.2: Search Codebase

Use Grep tool to search for each component:

```bash
For each component name:
  1. Search for file names:
     Grep pattern: "[component]" in file paths
     Example: grep -r "UserTable" --include="*.{ts,tsx,js,jsx}"

  2. Search for class/component names:
     Grep pattern: "class [component]" or "function [component]"
     Example: grep -r "class UserTable" or "const UserTable"

  3. Search for imports/exports:
     Grep pattern: "import.*[component]" or "export.*[component]"
     Example: grep -r "import.*UserTable"

  4. Count matches and confidence:
     0 matches → Component doesn't exist (New Feature)
     1-3 matches → Might exist (Medium confidence)
     4+ matches → Definitely exists (High confidence - Enhancement)
```

#### Step 2.2.3: Determine Classification

```
If component found with high confidence:
  → Enhancement (improving existing)
  → Example: "Add sorting to UserTable" → Enhancement
  → Confidence boost: +10%

If component not found:
  → New Feature (creating new)
  → Example: "Build shopping cart" → New Feature
  → Confidence: Use keyword-based only

If ambiguous (partial matches):
  → Ask user for clarification:
    "I found some references to [component] in the codebase.

     Does this feature already exist and you want to improve it? (Enhancement)
     Or are you creating it from scratch? (New Feature)"
```

### Step 2.3: Error Pattern Analysis for Bugs

If description contains error indicators, verify in codebase:

#### Step 2.3.1: Extract Error Patterns

```
From description:
- Error messages: "timeout", "null pointer", "404", "500"
- Exception names: "TimeoutException", "NullReferenceError"
- Stack trace files: "UserController.java:123"
- Error codes: "ERR_CONNECTION_REFUSED"

Examples:
"Fix login timeout error"
→ Error pattern: "timeout"

"Resolve NullPointerException in checkout"
→ Error pattern: "NullPointerException", "checkout"
```

#### Step 2.3.2: Search for Error Locations

```bash
For each error pattern:
  1. Search for error messages in code:
     Grep: "timeout" in .java, .ts files

  2. Search for exception handling:
     Grep: "catch.*[exception name]"
     Grep: "throw new [exception name]"

  3. Search for error logging:
     Grep: "error.*[error message]"
     Grep: "log.*[error pattern]"

If found:
  → Confirms bug-fix classification
  → Increases confidence +10%
  → Note file:line for context
```

### Step 2.4: Git History Analysis

Check recent changes for context:

```bash
1. Search git log for relevant commits:
   git log --oneline -20 --grep="[component]"
   git log --oneline -20 --all --grep="[keyword]"

2. Identify patterns:
   Recent fixes in same area:
     → Likely related bug or follow-up work
     → Confidence boost for bug-fix

   Recent feature work:
     → Possible enhancement
     → Confidence boost for enhancement

   Recent refactoring:
     → Context for current task
     → Note for user

3. Extract relevant commit messages:
   - Note similar issues fixed recently
   - Identify related work
   - Check for recurring problems
```

## Phase 3: Keyword Classification

### Step 3.1: Keyword Extraction

```
From normalized description:

1. Tokenize:
   "Fix login timeout error on mobile"
   → ["fix", "login", "timeout", "error", "mobile"]

2. Extract technical terms:
   - CVE numbers: CVE-2024-1234
   - Framework names: React, Vue, Django
   - Tech terms: SQL, API, REST

3. Identify action verbs:
   - fix, add, improve, refactor, optimize, migrate

4. Note qualifiers:
   - existing, new, broken, slow, secure

5. Multi-word phrases:
   - "SQL injection", "clean up", "move from", "speed up"
```

### Step 3.2: Match Keywords Against Matrix

For each task type, count keyword matches:

#### Security (CRITICAL)

Keywords: `vulnerability`, `security`, `CVE`, `exploit`, `XSS`, `SQL injection`, `CSRF`, `auth bypass`, `sensitive data`

```
Check description for ANY security keyword:

If "SQL injection" found → SECURITY (98%)
If "CVE-" found → SECURITY (98%)
If "vulnerability" found → SECURITY (97%)
If "XSS" found → SECURITY (96%)

IMPORTANT: Security ALWAYS overrides other types
```

#### Bug Fix

Keywords: `fix`, `bug`, `broken`, `error`, `crash`, `issue`, `defect`, `fault`, `not working`, `fails`

```
Count matches:

3+ matches → 88% confidence
  Example: "fix login error crash"

2 matches → 82% confidence
  Example: "fix broken auth"

1 match + error context → 75% confidence
  Example: "fix timeout" + error found in codebase
```

#### Enhancement

Keywords: `improve`, `enhance`, `better`, `upgrade existing`, `extend`, `augment`, `add to existing`, `update existing`

**IMPORTANT**: Must have "existing" context (component found in codebase)

```
2+ matches + component found → 85% confidence
  Example: "improve existing dashboard" + Dashboard found

1 match + component found → 78% confidence
  Example: "add filter to existing table" + Table found

Without component found → LOW confidence (ask user)
```

#### New Feature

Keywords: `add`, `new`, `create`, `build`, `implement`

**WITHOUT** "existing" context (component not found in codebase)

```
2+ matches + component NOT found → 70% confidence
  Example: "build new checkout flow" + no checkout found

1 match + no component found → 65% confidence
  Example: "create payment system" + no payment found

Note: Often ambiguous with enhancement - context analysis critical
```

#### Refactoring

Keywords: `refactor`, `clean up`, `restructure`, `reorganize`, `simplify code`, `improve structure`, `reduce complexity`

```
2+ matches → 84% confidence
  Example: "refactor and clean up auth code"

1 match + code smell terms → 76% confidence
  Example: "refactor complex login logic"
```

#### Performance

Keywords: `slow`, `performance`, `optimize`, `speed up`, `faster`, `bottleneck`, `latency`, `throughput`, `reduce load time`

```
2+ matches → 86% confidence
  Example: "optimize slow queries for faster loading"

1 match + metrics/numbers → 78% confidence
  Example: "improve performance (currently 5s load time)"
```

#### Migration

Keywords: `migrate`, `move from X to Y`, `upgrade to`, `switch from`, `port to`, `convert from`, `replace X with Y`

```
2+ matches → 87% confidence
  Example: "migrate from Redux to Zustand"

1 match + tech names → 80% confidence
  Example: "move to TypeScript" + language names present
```

#### Documentation

Keywords: `document`, `docs`, `guide`, `readme`, `tutorial`, `API docs`, `write documentation`, `update docs`

```
2+ matches → 83% confidence
  Example: "write guide and API docs"

1 match + "write" verb → 75% confidence
  Example: "document API endpoints"
```

### Step 3.3: Calculate Total Confidence

```python
# Pseudo-code for confidence calculation

base_confidence = 50

for match in keyword_matches:
    if match_count == 1:
        confidence += 15
    elif match_count == 2:
        confidence += 10
    else:  # 3+
        confidence += 5

if strong_context_present:
    confidence += 10  # codebase search confirms, error found, etc.

if issue_fetched_with_matching_labels:
    confidence += 5

if multiple_types_competing:
    confidence -= (10 * number_of_competing_types)

if security_keywords_present:
    confidence = max(confidence, 95)  # Security override

# Cap at 98%
final_confidence = min(confidence, 98)
```

### Step 3.4: Resolve Multi-Type Matches

When multiple task types have similar match counts:

```
Priority Rules:
1. Security ALWAYS wins (critical override)
2. Highest keyword count wins
3. Context analysis breaks ties (component found, error verified)
4. User confirmation if still ambiguous

Example 1:
"Improve performance by fixing slow query"
- performance: 2 keywords (improve, performance, slow)
- bug-fix: 1 keyword (fixing)
→ Performance wins (higher count)
→ Confidence: 82%

Example 2:
"Refactor auth to fix security issue"
- security: 2 keywords (security, issue) → CRITICAL
- refactoring: 1 keyword (refactor)
→ Security wins (critical override)
→ Confidence: 97%

Example 3:
"Add sorting to table"
- new-feature: 1 keyword (add)
- enhancement: 1 keyword (add to existing)
→ TIE - Use codebase search
→ If table found: Enhancement (85%)
→ If not found: New Feature (70%)
```

## Phase 4: User Confirmation

### Step 4.1: Determine Confirmation Level

```
Based on final confidence:

Critical (95%+):
  → Security tasks
  → Always show warning
  → Require explicit confirmation

High (80-94%):
  → Clear classification
  → Quick confirmation with override option
  → Default to proceeding

Medium (60-79%):
  → Some ambiguity
  → Show classification, ask to confirm or choose manually
  → Present top 2-3 likely types

Low (<60%):
  → Very ambiguous
  → Present all 8 options
  → Let user choose with descriptions
```

### Step 4.2: Critical Confirmation (Security)

```
Display:
┌──────────────────────────────────────────────────────┐
│ ⚠️  SECURITY ISSUE DETECTED ⚠️                        │
├──────────────────────────────────────────────────────┤
│ Classification: Security Fix                         │
│ Keywords matched: SQL injection, vulnerability       │
│ Confidence: 98%                                      │
│                                                       │
│ [If issue fetched]                                   │
│ Issue: #456 "Fix SQL injection in search"           │
│ Labels: security, critical, backend                  │
│                                                       │
│ This appears to be a SECURITY vulnerability          │
│ requiring immediate attention.                       │
│                                                       │
│ Security workflow includes:                          │
│ - Vulnerability assessment and exploit analysis      │
│ - Security-focused fix planning                      │
│ - Comprehensive security validation                  │
│ - Responsible disclosure documentation               │
│                                                       │
│ Proceed with security fix workflow?                  │
└──────────────────────────────────────────────────────┘

Use AskUserQuestion:
Options:
1. "Yes, this is a security issue" (proceed)
2. "No, choose different type" (show all options)
```

### Step 4.3: High Confidence Confirmation

```
Display:
┌──────────────────────────────────────────────────────┐
│ Classification: Bug Fix                              │
│ Keywords matched: fix, error, crash                  │
│ Confidence: 88%                                      │
│                                                       │
│ [If issue fetched]                                   │
│ Issue: #123 "Login timeout on mobile"               │
│ Source: GitHub                                        │
│ Labels: bug, mobile, authentication                  │
│                                                       │
│ [If context analysis]                                │
│ Context analysis:                                    │
│ - Error pattern "timeout" found in auth code         │
│ - Recent similar fixes in login flow                 │
│                                                       │
│ This task will follow the bug fix workflow:          │
│ 1. Bug analysis & reproduction                       │
│ 2. Fix implementation                                │
│ 3. Testing & verification                            │
│ 4. Documentation                                     │
│                                                       │
│ Proceed with bug fix workflow?                       │
└──────────────────────────────────────────────────────┘

Use AskUserQuestion:
Options:
1. "Yes, proceed with bug fix" (accept)
2. "No, let me choose different type" (show all options)
```

### Step 4.4: Medium/Low Confidence Confirmation

```
Display:
┌──────────────────────────────────────────────────────┐
│ I'm not entirely sure which type of task this is.   │
├──────────────────────────────────────────────────────┤
│ Description: "Work on user dashboard"               │
│ Keywords found: work, dashboard                      │
│                                                       │
│ [If context analysis]                                │
│ Context analysis:                                    │
│ - Dashboard component found in codebase              │
│ - Could be improvement or new features               │
│ - Description is vague                               │
│                                                       │
│ Please choose the task type that best fits:          │
│                                                       │
│ 1. Bug Fix - Fix defects or errors                  │
│ 2. Enhancement - Improve existing features           │
│ 3. New Feature - Add completely new capability       │
│ 4. Refactoring - Improve code structure              │
│ 5. Performance - Optimize speed/efficiency           │
│ 6. Security - Fix security vulnerabilities           │
│ 7. Migration - Move to new tech/pattern              │
│ 8. Documentation - Create/update docs                │
│                                                       │
│ Which type best describes your task?                 │
└──────────────────────────────────────────────────────┘

Use AskUserQuestion with all 8 options and descriptions
```

### Step 4.5: Handle User Override

```
If user chooses different type than classified:

1. Accept without question:
   "Got it. Proceeding with [user's choice] workflow."

2. Log the override:
   classification:
     task_type: [user's choice]
     user_overrode: true
     original_classification: [classifier's choice]
     confidence: [original confidence]

3. Update reasoning:
   reasoning: "Originally classified as [original] based on [keywords],
               but user selected [user choice]."

4. Proceed with user-selected workflow:
   Return classification with user's choice as task_type
```

## Phase 5: Output Classification

### Step 5.1: Generate Structured Output

```yaml
classification:
  # Core classification
  task_type: bug-fix
  confidence: 88
  keywords_matched: [fix, error, timeout]

  # Context analysis results
  context_analysis:
    codebase_search_performed: true
    component_found: true
    component_locations: [src/auth/Login.tsx:45, src/auth/AuthService.ts:123]
    error_patterns_found: ["timeout", "ERR_TIMEOUT"]
    error_locations: [src/auth/AuthService.ts:145]
    git_history_relevant: true
    recent_related_commits: [
      "abc123: Fix auth retry logic",
      "def456: Update timeout handling"
    ]

  # Issue integration results
  issue_source:
    type: github
    identifier: "owner/repo#123"
    title: "Login timeout on mobile devices"
    labels: [bug, mobile, authentication, high-priority]
    url: "https://github.com/owner/repo/issues/123"

  # User interaction
  user_interaction:
    confirmation_level: high
    user_confirmed: true
    user_overrode: false
    original_classification: null

  # Reasoning
  reasoning: |
    Classified as bug-fix based on:
    - Keywords: fix (15%), error (10%), timeout (5%) = 30% from keywords
    - Context: Error pattern found in code (+10%)
    - Issue labels: "bug" label from GitHub (+5%)
    - Git history: Recent related fixes in same area (+5%)
    - Base confidence: 50%
    Total: 88% confidence
```

### Step 5.2: Generate Human-Readable Summary

```
✅ Task Classification Complete

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task Type: Bug Fix
Confidence: 88%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Keywords: fix, error, timeout

Source: GitHub Issue #123
Title: "Login timeout on mobile devices"
Labels: bug, mobile, authentication, high-priority

Context Analysis:
✓ Error pattern "timeout" found in authentication code
  Location: src/auth/AuthService.ts:145
✓ Recent related work in login flow
  Commits: "Fix auth retry logic", "Update timeout handling"

Reasoning:
Classified as bug-fix based on strong keyword matches (fix, error, timeout),
verified error pattern in codebase, and GitHub issue labeled as "bug".

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This task will be routed to the bug-fix-orchestrator workflow.

Workflow stages:
1. Bug analysis & reproduction
2. Fix implementation
3. Testing & verification
4. Documentation & completion
```

### Step 5.3: Return to Caller

Return both structured and human-readable formats:

```
return {
  structured: { /* YAML from Step 5.1 */ },
  summary: "/* Markdown from Step 5.2 */",
  task_type: "bug-fix",
  confidence: 88,
  ready_to_route: true
}
```

---

## Workflow Metrics

Track these metrics for continuous improvement:

```yaml
metrics:
  classification_time_ms: 2847
  issue_fetch_time_ms: 1234
  codebase_search_time_ms: 890
  user_confirmation_time_ms: 0  # High confidence, no wait

  accuracy:
    confidence_level: "high"
    user_confirmed: true
    user_overrode: false
```

These metrics can be used to:
- Optimize slow steps
- Track classification accuracy
- Improve confidence scoring
- Identify common override patterns
