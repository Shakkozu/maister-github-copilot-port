---
name: ai-sdlc:work
description: Unified entry point - auto-classifies tasks and routes to appropriate workflow
---

# Unified Work Entry Point

Auto-classifies tasks and routes to the appropriate workflow orchestrator. Supports resuming existing tasks or starting new ones.

## Usage

```bash
/work [task description | task folder path | issue identifier]
```

### Input Types

| Input Type | Example |
|------------|---------|
| Task folder path | `.ai-sdlc/tasks/bug-fixes/2025-10-23-login-timeout` |
| Folder name only | `2025-10-26-user-auth` (searches all task types) |
| Task description | `"Fix login timeout error on mobile"` |
| GitHub issue | `#456`, `GH-456`, `https://github.com/owner/repo/issues/456` |
| Jira ticket | `PROJ-456`, `https://company.atlassian.net/browse/PROJ-456` |
| No argument | Prompts for input |

## Examples

```bash
# Resume existing task
/work ".ai-sdlc/tasks/bug-fixes/2025-10-23-login-timeout"
/work "2025-10-26-user-auth"

# New task (auto-classifies)
/work "Fix login timeout error on mobile devices"
/work "Add user authentication with email/password"
/work "Improve dashboard loading performance"

# From issue tracker
/work "#456"
/work "PROJ-123"
```

## How It Works

1. **Detect existing task** - If input is a task folder path, route to resume
2. **Classify new task** - Invoke task-classifier skill to determine type
3. **Route to workflow** - Use SlashCommand to invoke appropriate `:new` or `:resume` command

## Task Type Routing

| Classification | Routes To |
|----------------|-----------|
| bug-fix | `/ai-sdlc:bug-fix:new` |
| new-feature | `/ai-sdlc:feature:new` |
| enhancement | `/ai-sdlc:enhancement:new` |
| refactoring | `/ai-sdlc:refactoring:new` |
| performance | `/ai-sdlc:performance:new` |
| security | `/ai-sdlc:security:new` |
| migration | `/ai-sdlc:migration:new` |
| documentation | `/ai-sdlc:documentation:new` |
| research | `/ai-sdlc:research:new` |
| initiative | `/ai-sdlc:initiative:new` |

---

## Workflow

### Step 1: Parse Input and Detect Task Folder

**Check if input is an existing task folder:**

1. Try path as-is (absolute path)
2. Try prepending `.ai-sdlc/` (relative path)
3. Search `.ai-sdlc/tasks/*/` for folder name match

**If folder exists AND contains `orchestrator-state.yml`:**
- Go to **Step 2: Resume Existing Task**

**If NOT a task folder:**
- Go to **Step 3: Classify & Route New Task**

**If no argument provided:**
- Prompt user: "What would you like to work on?" with input examples
- Then check if input is task folder or description

### Step 2: Resume Existing Task

**When existing task detected:**

1. Read `orchestrator-state.yml` from task folder
2. Determine task type from folder path:

| Folder | Task Type |
|--------|-----------|
| `bug-fixes/` | bug-fix |
| `new-features/` | new-feature |
| `enhancements/` | enhancement |
| `refactoring/` | refactoring |
| `performance/` | performance |
| `security/` | security |
| `migrations/` | migration |
| `documentation/` | documentation |
| `research/` | research |
| `initiatives/` | initiative |

3. Extract status from state file:
   - `completed`: null = in-progress, timestamp = finished
   - `current_phase`: what phase is active
   - `failed_phases`: array of failed attempts

4. Present status to user with AskUserQuestion:

**For In-Progress Tasks:**
```
Options:
1. Resume from current phase ([current_phase])
2. Restart from specific phase
3. Cancel
```

**For Completed Tasks:**
```
Options:
1. View task details
2. Create enhancement to this feature
3. Re-run verification phase
4. Cancel
```

**For Failed Tasks:**
```
Options:
1. Resume with fresh attempts (--reset-attempts --clear-failures)
2. Retry failed phase
3. Restart from specific phase
4. Cancel
```

5. **Route using SlashCommand tool:**

```
Use SlashCommand tool:
  command: "/ai-sdlc:[task-type]:resume [task_path] [flags]"
```

Examples:
- Resume: `/ai-sdlc:bug-fix:resume .ai-sdlc/tasks/bug-fixes/2025-10-23-fix`
- Restart: `/ai-sdlc:feature:resume .ai-sdlc/tasks/new-features/2025-10-26-auth --from=verify`
- Fresh attempts: `/ai-sdlc:migration:resume .ai-sdlc/tasks/migrations/2025-10-20-redux --reset-attempts`

### Step 3: Classify & Route New Task

**For new task descriptions:**

1. **Invoke task-classifier skill** to determine task type:

```
Use Skill tool:
  skill: "ai-sdlc:task-classifier"

The skill will:
- Detect issue identifiers (GitHub, Jira)
- Fetch issue details if available
- Analyze codebase context
- Match keywords and calculate confidence
- Confirm with user if needed
- Return classification in YAML format
```

2. **Parse classification result:**
```yaml
classification:
  task_type: [bug-fix|enhancement|new-feature|refactoring|performance|security|migration|documentation|research|initiative]
  confidence: [percentage]
  reasoning: [explanation]
```

3. **Route to appropriate workflow using SlashCommand tool:**

```
Display:
  Task classified as: [task_type] ([confidence]% confidence)
  Routing to [task_type] workflow...

Use SlashCommand tool:
  command: "/ai-sdlc:[task-type]:new [description]"
```

**Routing examples:**
- bug-fix (92%): `/ai-sdlc:bug-fix:new "Fix login timeout error"`
- enhancement (88%): `/ai-sdlc:enhancement:new "Add filtering to user table"`
- new-feature (85%): `/ai-sdlc:feature:new "Add user authentication"`
- security (98%): `/ai-sdlc:security:new "Fix SQL injection in search"`

---

## Error Handling

### Classification Fails

If task-classifier returns error:
```
Display:
"Unable to automatically classify this task. Please select manually:"

Use AskUserQuestion with options:
1. Bug Fix - Fix defects or errors
2. Enhancement - Improve existing features
3. New Feature - Add completely new capability
4. Refactoring - Improve code structure
5. Performance - Optimize speed/efficiency
6. Security - Fix security vulnerabilities
7. Migration - Move to new tech/pattern
8. Documentation - Create/update docs
9. Research - Investigate and document findings
10. Initiative - Epic-level multi-task project

Then route to selected workflow using SlashCommand.
```

### User Cancels

```
Display:
"Task cancelled. You can:
- Run /work again when ready
- Use specific commands directly:
  /ai-sdlc:bug-fix:new, /ai-sdlc:feature:new, etc."
```

---

## Resume Command Reference

| Task Type | Resume Command |
|-----------|----------------|
| bug-fix | `/ai-sdlc:bug-fix:resume [path] [--from=PHASE] [--reset-attempts]` |
| new-feature | `/ai-sdlc:feature:resume [path] [--from=PHASE]` |
| enhancement | `/ai-sdlc:enhancement:resume [path] [--from=PHASE]` |
| refactoring | `/ai-sdlc:refactoring:resume [path] [--from=PHASE]` |
| performance | `/ai-sdlc:performance:resume [path] [--from=PHASE]` |
| security | `/ai-sdlc:security:resume [path] [--from=PHASE]` |
| migration | `/ai-sdlc:migration:resume [path] [--from=PHASE]` |
| documentation | `/ai-sdlc:documentation:resume [path] [--from=PHASE]` |
| research | `/ai-sdlc:research:resume [path] [--from=PHASE]` |
| initiative | `/ai-sdlc:initiative:resume [path] [--from=PHASE]` |

---

## Integration Notes

### With Task Classifier

The `/work` command delegates classification to the task-classifier skill, which:
- Fetches issue details from GitHub/Jira when available
- Analyzes codebase context for better classification
- Uses confidence-based user confirmation
- Returns structured classification result

### With Orchestrators

After classification/detection, this command routes to the appropriate orchestrator via SlashCommand:
- Each orchestrator handles its specific workflow (spec, plan, implement, verify, etc.)
- State is persisted in `orchestrator-state.yml` for pause/resume
- Auto-recovery handles common failures

### With Project Documentation

Uses project documentation for context:
- `.ai-sdlc/docs/INDEX.md` - Project overview and standards
- `.ai-sdlc/tasks/` - Existing task directories

---

## Key Behaviors

1. **Single entry point** - One command for all task types
2. **Auto-classification** - Intelligent routing based on task description
3. **Resume support** - Detects and resumes existing tasks
4. **Issue integration** - Fetches details from GitHub/Jira
5. **Explicit routing** - Uses SlashCommand for reliable orchestrator invocation
6. **Graceful fallback** - Manual selection if classification fails
