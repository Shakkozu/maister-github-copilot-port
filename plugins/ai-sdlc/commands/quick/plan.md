---
name: ai-sdlc:quick:plan
description: Enter planning mode with AI SDLC standards awareness
---

# Planning Mode with Standards Awareness

Enter Claude Code's planning mode for a task, with automatic discovery of project standards from `.ai-sdlc/docs/`.

## Usage

```bash
/ai-sdlc:quick:plan [task description]
```

## Examples

```bash
/ai-sdlc:quick:plan "Add user authentication with email/password"
/ai-sdlc:quick:plan "Refactor the payment processing module"
/ai-sdlc:quick:plan
```

---

## Workflow

### Step 1: Parse Input

**Get the task description:**

- If provided as argument, use it directly
- If not provided, use AskUserQuestion to prompt:
  ```
  "What would you like to plan? Please describe the task or feature."
  ```

### Step 2: Check for Standards

**Check if `.ai-sdlc/docs/INDEX.md` exists:**

- **If exists**: Read INDEX.md to understand available standards
- **If not exists**: Note that no standards are available

### Step 3: Enter Planning Mode

**Use the `EnterPlanMode` tool to trigger Claude Code's builtin planning mode.**

The planning mode will:
1. Launch Explore agents to understand the codebase
2. Launch Plan agents to design implementation approach
3. Review and verify alignment with user intent
4. Write final plan to plan file
5. Call ExitPlanMode for user approval

### Step 4: Standards-Aware Planning

**When in planning mode, apply standards awareness:**

During Phase 1 (Explore) and Phase 2 (Plan), instruct agents to:

1. Read `.ai-sdlc/docs/INDEX.md` to discover available documentation and standards
2. Dynamically identify which standards are relevant based on:
   - The categories and files listed in INDEX.md
   - The nature of the task being planned
   - Keywords and patterns in the task description

3. Include in the final plan:
   - Which standards from INDEX.md apply to this task
   - Key guidelines extracted from applicable standard files
   - Standards compliance checklist for verification after implementation
   - Post-implementation verification steps to confirm standards adherence

### Graceful Fallback

**If `.ai-sdlc/docs/` does not exist:**

Continue with planning mode normally, but note in the plan:

```
"No AI SDLC standards found. Consider running `/init-sdlc` to initialize
project documentation and coding standards for better consistency."
```

## What This Does

1. **Parses** task description from user input
2. **Checks** for project standards in `.ai-sdlc/docs/INDEX.md`
3. **Enters** Claude Code's builtin planning mode via `EnterPlanMode`
4. **Guides** the planning process with standards awareness
5. **Produces** a plan file with implementation approach and applicable standards

## Benefits Over Manual Planning

- Automatic standards discovery and integration
- Structured approach to understanding codebase
- Plan file for review before implementation
- Standards compliance built into the plan

## After Planning

Once the plan is approved:
- Implementation begins based on the plan
- Standards are applied during coding

## Post-Implementation Verification

After implementation is complete, verify standards compliance using the checklist from the plan:

1. **Review the "Applicable Standards" section** in the plan file
2. **For each standard listed**:
   - Re-read the standard file from `.ai-sdlc/docs/`
   - Verify implementation follows the key guidelines
   - Check any specific patterns or conventions mentioned
3. **Document verification results** (pass/fail for each standard)
4. **Address any violations** before marking task complete

This ensures the discovered standards are actually enforced, not just documented.
