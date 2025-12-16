---
name: ai-sdlc:quick:dev
description: Implement task directly with AI SDLC standards awareness (no planning mode)
---

# Quick Development with Standards Awareness

Implement a task directly without entering planning mode, while still applying project standards from `.ai-sdlc/docs/`.

## Usage

```bash
/ai-sdlc:quick:dev [task description]
```

## Examples

```bash
/ai-sdlc:quick:dev "Add a logout button to the navbar"
/ai-sdlc:quick:dev "Fix the typo in the error message"
/ai-sdlc:quick:dev "Update the API endpoint to accept JSON"
```

---

## When to Use

**Use `/ai-sdlc:quick:dev` when:**
- Task is clear and well-defined
- You know what needs to be done
- No architectural decisions needed
- Quick fixes, small features, or straightforward changes

**Use `/ai-sdlc:quick:plan` instead when:**
- Task scope is uncertain
- Multiple implementation approaches possible
- Architectural decisions required
- You want user approval before coding

---

## Workflow

### Step 1: Parse Input

**Get the task description:**

- If provided as argument, use it directly
- If not provided, use AskUserQuestion to prompt:
  ```
  "What would you like to implement? Please describe the task."
  ```

### Step 2: Discover Standards

**Check if `.ai-sdlc/docs/INDEX.md` exists:**

**If exists:**
1. Read INDEX.md to discover available documentation and standards
2. Identify which standards are relevant based on:
   - The categories and files listed in INDEX.md
   - The nature of the task
   - Keywords in the task description
3. Read the applicable standard files to extract key guidelines

**If not exists:**
- Note that no standards are available
- Suggest running `/init-sdlc` in completion message

### Step 3: Implement with Standards

**Proceed directly to implementation:**

1. Explore the codebase to understand context (using Glob, Grep, Read)
2. Apply the discovered standards during implementation
3. Make the necessary code changes
4. Run relevant tests if applicable

### Step 4: Verify Standards Compliance

**After implementation, verify:**

1. Review changes against applicable standards
2. Confirm key guidelines were followed
3. Note any standards that were applied

### Step 5: Summary

**Provide completion summary:**

- What was implemented
- Which standards from INDEX.md were applied
- Any tests run and their results
- Suggestions for follow-up (if any)

---

## What This Does

1. **Parses** task description from user input
2. **Discovers** applicable standards from `.ai-sdlc/docs/INDEX.md`
3. **Implements** directly without planning mode approval
4. **Verifies** standards were followed
5. **Summarizes** what was done and which standards applied

## Graceful Fallback

**If `.ai-sdlc/docs/` does not exist:**

Proceed with implementation normally, then note:

```
"No AI SDLC standards found. Consider running `/init-sdlc` to initialize
project documentation and coding standards for better consistency."
```
