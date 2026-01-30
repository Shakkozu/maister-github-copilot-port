# Delegation Enforcement

Orchestrators must delegate work to skills and subagents instead of executing inline.

## Core Rule

**Always use Skill/Task tools to delegate. Never execute delegated work inline.**

When a phase requires a skill or subagent:
1. Use the `Skill` tool for skills
2. Use the `Task` tool for subagents
3. Wait for completion before continuing

---

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Wrong | Correct Approach |
|--------------|----------------|------------------|
| "I'll analyze the codebase..." | Bypasses codebase-analyzer skill | Use `Skill` tool with `ai-sdlc:codebase-analyzer` |
| "Let me create the specification..." | Bypasses specification-creator | Use `Task` tool with `ai-sdlc:specification-creator` subagent |
| "Looking at the gaps between..." | Bypasses gap-analyzer subagent | Use `Task` tool with `ai-sdlc:gap-analyzer` |
| "I'll implement this by..." | Bypasses implementer skill | Use `Skill` tool with `ai-sdlc:implementer` |
| Reading a SKILL.md then doing the work | Skill files are instructions FOR skills | Use Skill tool to invoke |
| Spawning Explore agents in orchestrator | Codebase-analyzer manages its own agents | Invoke skill, let IT spawn agents |

---

## When Inline Execution is Acceptable

These do NOT require delegation:

1. **Clarifying questions phases** (1.5, 3.5, 4.5, 5.5) - AskUserQuestion is direct
2. **State updates** - Reading/writing orchestrator-state.yml
3. **Phase announcements** - Outputting status messages
4. **Simple decisions** - Enabling/disabling optional phases
5. **Finalization** - Creating summary, updating metadata

For all analysis, planning, implementation, and verification phases: **ALWAYS DELEGATE**.

---

## Skill Invocation

```
Tool: Skill
Parameters:
  skill: "ai-sdlc:[skill-name]"
```

Wait for skill completion before continuing.

---

## Task (Subagent) Invocation

```
Tool: Task
Parameters:
  subagent_type: "ai-sdlc:[agent-name]"
  description: "[brief description]"
  prompt: |
    [Context and instructions]
    Task path: [task-path]
```

Wait for subagent completion before continuing.

---

## Parallel Task Invocation

For phases requiring multiple parallel agents (e.g., research information gathering):

Launch all agents in a SINGLE message with multiple Task tool calls. Wait for ALL to complete.

---

## Context Passing

All subagent prompts must include context from prior phases:

```
prompt: |
  [Task instructions]
  Task path: [path]

  ## RESEARCH CONTEXT (if research_reference exists)
  Research question: [research_reference.research_question]
  Confidence: [research_reference.confidence_level]
  Summary: [phase_summaries.research.summary]

  ## CONTEXT FROM PRIOR PHASES
  [Key state fields from orchestrator-state.yml]
  [Summaries of completed phases from phase_summaries]

  ## ARTIFACTS TO READ
  [List relevant files for full details]
```

**Why**: Subagents run in isolated context. Without summaries, they must re-parse entire files and miss prior decisions.

---

## Context Extraction

After each phase, extract key findings into `[domain]_context.phase_summaries`:

1. Parse subagent output for key fields
2. Create 1-2 sentence summary
3. Update state: `[domain]_context.phase_summaries.[phase_name]`

This enables context passing to downstream phases and supports resume.
