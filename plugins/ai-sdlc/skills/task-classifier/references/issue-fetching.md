# Issue Fetching Integration Guide

> **Design Documentation**: This file serves as **design documentation** for developers extending or understanding the issue fetching methodology. The actual runtime issue fetching logic is embedded in the `agents/task-classifier.md` subagent file for path-independence when the plugin runs in user projects. This document explains the integration patterns and reasoning behind the embedded implementation.

This document provides comprehensive guidance for dynamically integrating with external issue tracking systems (GitHub, Jira, etc.) to fetch task details for classification.

## Overview

The task classifier can automatically fetch issue details from external systems when:
1. User provides an issue identifier (GH-123, PROJ-456, URL)
2. Appropriate MCP tools are available
3. Project documentation indicates integration

## Dynamic Detection Strategy

### Step 1: Parse Input for Issue Identifiers

Check input string for recognizable patterns:

```regex
GitHub Patterns:
- #(\d+)                              → #123
- GH-(\d+)                            → GH-123
- github\.com/([^/]+)/([^/]+)/issues/(\d+)  → Full URL

Jira Patterns:
- ([A-Z]+-\d+)                        → PROJ-123, KEY-456
- atlassian\.net/browse/([A-Z]+-\d+)  → Full URL

GitLab Patterns:
- gitlab\.com/([^/]+)/([^/]+)/-/issues/(\d+)

Bitbucket Patterns:
- bitbucket\.org/([^/]+)/([^/]+)/issues/(\d+)

Generic Patterns:
- /issue[s]?/(\d+)                    → Any URL with /issues/
- /ticket[s]?/(\d+)                   → Any URL with /tickets/
- /bug[s]?/(\d+)                      → Any URL with /bugs/
```

**Implementation**:
```javascript
function detectIssueSource(input) {
  // GitHub
  if (input.match(/github\.com\/([^\/]+)\/([^\/]+)\/issues\/(\d+)/)) {
    return {
      type: 'github',
      owner: match[1],
      repo: match[2],
      issue: match[3]
    };
  }

  // Short GitHub
  if (input.match(/#(\d+)/) || input.match(/GH-(\d+)/)) {
    return {
      type: 'github-short',
      issue: match[1],
      needsRepo: true  // Need to determine repo from context
    };
  }

  // Jira
  if (input.match(/([A-Z]+-\d+)/)) {
    return {
      type: 'jira',
      key: match[1]
    };
  }

  // Generic
  if (input.match(/https?:\/\/[^\/]+\/.*\/(issue|ticket|bug)[s]?\/(\d+)/)) {
    return {
      type: 'generic',
      url: input,
      id: match[2]
    };
  }

  return { type: 'none' };
}
```

### Step 2: Check Available MCPs

Determine what integration tools are available:

```
1. List Available MCP Tools:
   - Check for tool names starting with "mcp__"
   - Common patterns:
     - mcp__github__*
     - mcp__jira__*
     - mcp__gitlab__*
     - Custom MCPs

2. Check Project Documentation:
   Read .ai-sdlc/docs/INDEX.md:
   - Look for "Issue Tracking" section
   - Check for "Integrations" or "External Systems"
   - Note API endpoints, credentials, configurations

3. Check Standards:
   Read .ai-sdlc/docs/standards/:
   - Check for integration patterns
   - Look for API authentication methods
   - Note rate limiting or usage guidelines

4. Check Environment:
   - Environment variables (GITHUB_TOKEN, JIRA_API_TOKEN)
   - Configuration files (.github/, .jira/, etc.)
```

**Implementation**:
```python
def check_available_mcps():
  """Check which MCP tools are available."""
  available = {
    'github': False,
    'jira': False,
    'gitlab': False,
    'custom': []
  }

  # List all available tools
  all_tools = list_available_tools()

  # Check for GitHub MCP
  if any('mcp__github' in tool for tool in all_tools):
    available['github'] = True

  # Check for Jira MCP
  if any('mcp__jira' in tool for tool in all_tools):
    available['jira'] = True

  # Check for GitLab MCP
  if any('mcp__gitlab' in tool for tool in all_tools):
    available['gitlab'] = True

  # Check for custom MCPs
  custom = [tool for tool in all_tools if 'issue' in tool.lower() or 'ticket' in tool.lower()]
  available['custom'] = custom

  return available

def check_project_integration_docs():
  """Check project documentation for integration info."""
  # Read .ai-sdlc/docs/INDEX.md
  index = read_file('.ai-sdlc/docs/INDEX.md')

  integration_info = {
    'issue_tracker': None,
    'repository': None,
    'project_key': None,
    'api_endpoint': None
  }

  # Parse for integration mentions
  if 'github.com' in index:
    # Extract GitHub repo from docs
    match = re.search(r'github\.com/([^\/]+)/([^\/]+)', index)
    if match:
      integration_info['issue_tracker'] = 'github'
      integration_info['repository'] = f"{match[1]}/{match[2]}"

  if 'atlassian.net' in index or 'jira' in index.lower():
    integration_info['issue_tracker'] = 'jira'
    # Extract project key if mentioned

  return integration_info
```

### Step 3: Determine Fetch Strategy

Based on detected issue and available tools:

```
Decision Matrix:

┌────────────────────┬─────────────────┬────────────────────────┐
│ Issue Detected     │ MCP Available   │ Strategy               │
├────────────────────┼─────────────────┼────────────────────────┤
│ GitHub URL/ID      │ GitHub MCP ✓    │ Fetch via GitHub MCP   │
│ GitHub URL/ID      │ No MCP ✗        │ Manual user prompt     │
│ Short GitHub (#123)│ GitHub MCP ✓    │ Fetch (infer repo)     │
│ Short GitHub (#123)│ No MCP ✗        │ Manual user prompt     │
│ Jira ticket        │ Jira MCP ✓      │ Fetch via Jira MCP     │
│ Jira ticket        │ No MCP ✗        │ Manual user prompt     │
│ Generic URL        │ Custom MCP ✓    │ Try custom MCP         │
│ Generic URL        │ No MCP ✗        │ Manual user prompt     │
│ No identifier      │ Any             │ Use provided text only │
└────────────────────┴─────────────────┴────────────────────────┘
```

---

## GitHub Integration

### Fetching with GitHub MCP

When GitHub MCP is available (`mcp__github__*` tools detected):

```
1. Parse GitHub identifier:
   URL: https://github.com/acme/app/issues/456
   → owner: acme
   → repo: app
   → issue_number: 456

   Short form: #456 or GH-456
   → issue_number: 456
   → Infer owner/repo from project docs

2. Invoke GitHub MCP tool:
   Tool name: mcp__github__get_issue
   (or similar, check actual tool name)

   Parameters:
     owner: "acme"
     repo: "app"
     issue_number: 456

3. Handle response:
   Response structure (typical):
   {
     "number": 456,
     "title": "Login timeout on mobile devices",
     "body": "Users report that login times out...",
     "state": "open",
     "labels": [
       { "name": "bug", "color": "d73a4a" },
       { "name": "mobile", "color": "0e8a16" },
       { "name": "authentication", "color": "fbca04" }
     ],
     "created_at": "2024-01-15T10:30:00Z",
     "updated_at": "2024-01-16T14:20:00Z",
     "user": { "login": "reporter" },
     "assignee": { "login": "dev" },
     "comments": 5,
     "comments_url": "..."
   }

4. Extract classification hints:
   Labels → Direct classification indicators:
     "bug" → Bug Fix
     "enhancement" → Enhancement
     "feature" → New Feature
     "documentation" → Documentation
     "performance" → Performance
     "security" → Security (CRITICAL)
     "refactor" → Refactoring

   Title → Keyword extraction:
     "Login timeout" → bug keywords (timeout, error implied)

   Body → Full description:
     Parse for keywords, error messages, context

   State:
     "open" → Active task
     "closed" → Might be reopening or related work
```

### GitHub Fetching Examples

#### Example 1: Full URL

```
Input: "https://github.com/acme/app/issues/456"

Steps:
1. Parse URL:
   - owner: acme
   - repo: app
   - issue: 456

2. Check GitHub MCP:
   ✓ mcp__github__get_issue available

3. Fetch issue:
   mcp__github__get_issue(owner="acme", repo="app", issue_number=456)

4. Response:
   {
     "title": "Fix SQL injection in search",
     "body": "The search endpoint is vulnerable to SQL injection...",
     "labels": [{"name": "security"}, {"name": "critical"}]
   }

5. Classification:
   - Keywords from title: "fix", "SQL injection"
   - Labels: "security" → SECURITY TYPE
   - Confidence: 98% (critical)

Output: Security Fix (98% confidence)
```

#### Example 2: Short Form with Repo Context

```
Input: "#456"

Steps:
1. Parse short form:
   - issue: 456
   - owner/repo: Unknown

2. Infer repository:
   - Read .ai-sdlc/docs/INDEX.md
   - Found: "Repository: github.com/acme/app"
   - owner: acme, repo: app

3. Fetch issue:
   mcp__github__get_issue(owner="acme", repo="app", issue_number=456)

4. Continue as Example 1...
```

#### Example 3: No MCP Available (Fallback)

```
Input: "https://github.com/acme/app/issues/456"

Steps:
1. Parse URL:
   - owner: acme, repo: app, issue: 456

2. Check GitHub MCP:
   ✗ No GitHub MCP found

3. Fallback to manual:
   Display to user:
   ┌──────────────────────────────────────────────────┐
   │ GitHub Issue Detected                            │
   ├──────────────────────────────────────────────────┤
   │ Issue: acme/app#456                              │
   │                                                   │
   │ I don't have GitHub access to fetch this issue. │
   │                                                   │
   │ Please provide:                                  │
   │ 1. Issue title or summary                        │
   │ 2. Brief description of the problem              │
   │ 3. Is this a bug, feature, or improvement?       │
   │                                                   │
   │ You can paste the issue details here:            │
   │ [Text input]                                     │
   └──────────────────────────────────────────────────┘

4. Use user-provided text for classification
```

---

## Jira Integration

### Fetching with Jira MCP

When Jira MCP is available:

```
1. Parse Jira identifier:
   Input: PROJ-456
   → project: PROJ
   → issue: 456
   → key: PROJ-456

   URL: company.atlassian.net/browse/PROJ-456
   → Same extraction

2. Invoke Jira MCP tool:
   Tool name: mcp__jira__get_issue (or equivalent)

   Parameters:
     issue_key: "PROJ-456"
     (or: project="PROJ", issue_id="456")

3. Handle response:
   Response structure (typical):
   {
     "key": "PROJ-456",
     "fields": {
       "summary": "Optimize database queries",
       "description": "Current queries are slow...",
       "issuetype": {
         "name": "Bug" | "Task" | "Story" | "Epic"
       },
       "priority": {
         "name": "High" | "Medium" | "Low"
       },
       "status": {
         "name": "Open" | "In Progress" | "Done"
       },
       "labels": ["performance", "database", "backend"],
       "created": "2024-01-15T10:30:00Z",
       "updated": "2024-01-16T14:20:00Z",
       "reporter": { "displayName": "John Doe" },
       "assignee": { "displayName": "Jane Dev" }
     }
   }

4. Extract classification hints:
   Issue Type → Strong indicator:
     "Bug" → Bug Fix (95%)
     "Story" → New Feature or Enhancement (context-dependent)
     "Task" → Context-dependent
     "Epic" → Large New Feature

   Labels → Classification hints:
     "performance" → Performance
     "security" → Security (CRITICAL)
     "refactor" → Refactoring
     "documentation" → Documentation

   Priority → Urgency indicator (not type):
     "Critical" with security label → Security (CRITICAL)

   Summary → Keyword extraction:
     "Optimize database queries" → Performance keywords
```

### Jira Fetching Examples

#### Example 1: Direct Jira Key

```
Input: "PROJ-456"

Steps:
1. Parse Jira key:
   - key: PROJ-456

2. Check Jira MCP:
   ✓ mcp__jira__get_issue available

3. Fetch issue:
   mcp__jira__get_issue(issue_key="PROJ-456")

4. Response:
   {
     "fields": {
       "summary": "Fix login timeout on mobile",
       "issuetype": {"name": "Bug"},
       "labels": ["mobile", "authentication"]
     }
   }

5. Classification:
   - Issue Type: "Bug" → Strong bug indicator (+30%)
   - Summary: "Fix", "timeout" → Bug keywords (+25%)
   - Confidence: 95% (Bug Fix)

Output: Bug Fix (95% confidence)
```

#### Example 2: Story vs Feature/Enhancement

```
Input: "PROJ-789"

Fetched:
{
  "fields": {
    "summary": "Add sorting to user table",
    "issuetype": {"name": "Story"},
    "labels": ["frontend", "enhancement"]
  }
}

Classification Challenge:
- Issue Type: "Story" → Could be Feature or Enhancement
- Summary: "Add sorting to" → Could be either
- Label: "enhancement" → Enhancement indicator

Additional Context Needed:
→ Perform codebase search for "user table"
→ If found: Enhancement (87%)
→ If not found: New Feature (78%)
```

---

## Generic Issue Fetching

For custom issue trackers or when specific MCP not available:

### Detection

```
URL patterns indicating issue tracker:
- company.com/tracker/issues/123
- internal-tool/tickets/456
- custom-system/bugs/789

Keywords in URL:
- /issue/, /ticket/, /bug/, /task/, /story/
```

### Fetch Strategies

```
Strategy 1: Custom MCP (if available)
- Check for custom issue MCP tools
- Tool might be named: mcp__custom__get_ticket
- Try invoking with issue ID

Strategy 2: Web Fetch (fallback)
- Use WebFetch tool with URL
- Extract issue details from HTML
- Less reliable but better than nothing

Strategy 3: API Request (if configured)
- Check project docs for API endpoint
- Check for API credentials in environment
- Make direct HTTP request via Bash/curl

Strategy 4: Manual Input (ultimate fallback)
- Prompt user to paste issue details
- Guide them on what information needed
```

### Example: Custom System with MCP

```
Input: "https://company.com/tracker/issue/789"

Steps:
1. Check for custom MCP:
   Found: mcp__company_tracker__get_issue

2. Parse URL for ID:
   - issue_id: 789

3. Invoke custom MCP:
   mcp__company_tracker__get_issue(issue_id=789)

4. Handle custom response structure:
   (Varies by system - adapt to response format)
```

---

## Fallback: Manual Input

When no integration available, provide clear guidance:

```
Display:
┌──────────────────────────────────────────────────────┐
│ Issue Reference Detected                             │
├──────────────────────────────────────────────────────┤
│ Reference: [identifier or URL]                       │
│                                                       │
│ I don't have access to fetch this issue's details.   │
│                                                       │
│ To help classify this task, please provide:          │
│                                                       │
│ 1. Issue Title/Summary:                              │
│    [Text input - required]                           │
│                                                       │
│ 2. What needs to be done?                            │
│    ○ Fix a bug or error                              │
│    ○ Improve existing functionality                  │
│    ○ Add completely new feature                      │
│    ○ Optimize performance                            │
│    ○ Refactor code structure                         │
│    ○ Fix security vulnerability                      │
│    ○ Migrate technology                              │
│    ○ Write documentation                             │
│    [Radio buttons]                                   │
│                                                       │
│ 3. Additional Context (optional):                    │
│    [Text area]                                       │
│                                                       │
│ Or paste the full issue description:                 │
│    [Large text area]                                 │
└──────────────────────────────────────────────────────┘

Use AskUserQuestion to collect structured input
```

---

## Best Practices

### 1. Fail Gracefully

Always provide fallback when integration fails:

```python
try:
    issue_data = fetch_github_issue(owner, repo, issue_number)
except Exception as e:
    # Log error but don't fail classification
    log_error(f"GitHub fetch failed: {e}")
    # Fallback to manual input
    issue_data = prompt_user_for_issue_details()
```

### 2. Cache Issue Data

If fetching multiple times, cache the response:

```python
issue_cache = {}

def get_issue_data(issue_id):
    if issue_id in issue_cache:
        return issue_cache[issue_id]

    data = fetch_issue(issue_id)
    issue_cache[issue_id] = data
    return data
```

### 3. Respect Rate Limits

Be mindful of API rate limits:

```python
if rate_limit_remaining < 10:
    warn_user("GitHub rate limit low, consider manual input")
```

### 4. Validate Fetched Data

Always validate response structure:

```python
def validate_github_response(data):
    required_fields = ['title', 'body', 'labels']
    for field in required_fields:
        if field not in data:
            raise ValueError(f"Missing required field: {field}")
    return True
```

### 5. Provide Clear Feedback

Show user what was fetched:

```
✓ Fetched GitHub issue #456

Title: "Fix login timeout on mobile"
Labels: bug, mobile, authentication
Created: 2024-01-15
Status: Open

Using issue details for classification...
```

---

## Configuration

Projects can configure issue integration in `.ai-sdlc/docs/INDEX.md`:

```markdown
## Issue Tracking

**Issue Tracker**: GitHub
**Repository**: https://github.com/acme/app
**Default Project**: ACME

When referencing issues:
- Use format: #123 (will fetch from acme/app)
- Or full URL: https://github.com/acme/app/issues/123
- Or GH-123

Integration: GitHub MCP configured
```

Or for Jira:

```markdown
## Issue Tracking

**Issue Tracker**: Jira
**Project Key**: PROJ
**Instance**: company.atlassian.net

When referencing tickets:
- Use format: PROJ-123
- Or full URL: https://company.atlassian.net/browse/PROJ-123

Integration: Jira MCP configured (requires API token)
```

---

## Testing Issue Fetching

Test cases to verify integration:

1. **GitHub URL**: `https://github.com/owner/repo/issues/123`
2. **GitHub Short**: `#123` (with repo in docs)
3. **Jira Key**: `PROJ-456`
4. **Jira URL**: `https://company.atlassian.net/browse/PROJ-456`
5. **Generic URL**: `https://tracker.com/issues/789`
6. **No MCP**: Any of above without MCP (test fallback)
7. **Invalid ID**: Non-existent issue (test error handling)
8. **Rate Limit**: Exceed rate limit (test graceful degradation)
