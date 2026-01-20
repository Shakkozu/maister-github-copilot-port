# Initialization Pattern

All orchestrators follow this initialization sequence before executing any workflow phases.

---

## Initialization Steps

1. **Parse Command Arguments**: Extract description, mode (`--yolo`), type, entry point (`--from`), optional flags
2. **Determine Starting Phase**: New task starts Phase 0; resume reads state and finds first incomplete phase
3. **Create Task Directory**: Standard structure with analysis/, implementation/, verification/, documentation/
4. **Create State File**: `orchestrator-state.yml` (see state-management.md for schema)
5. **Create TodoWrite**: All phases as pending todos for progress visibility
6. **Output Summary**: Show task info, mode, phases, and starting message

---

## Task Directory Structure

```
.ai-sdlc/tasks/[type]/YYYY-MM-DD-task-name/
├── analysis/           # Analysis and planning artifacts
├── implementation/     # Specs, plans, work logs
├── verification/       # Test reports, verification results
└── documentation/      # User-facing docs (if applicable)
```

**Task Type Directories**:

| Task Type | Directory |
|-----------|-----------|
| Bug fixes | `.ai-sdlc/tasks/bug-fixes/` |
| Enhancements | `.ai-sdlc/tasks/enhancements/` |
| New features | `.ai-sdlc/tasks/new-features/` |
| Performance | `.ai-sdlc/tasks/performance/` |
| Security | `.ai-sdlc/tasks/security/` |
| Migrations | `.ai-sdlc/tasks/migrations/` |
| Refactoring | `.ai-sdlc/tasks/refactoring/` |
| Research | `.ai-sdlc/tasks/research/` |
| Documentation | `.ai-sdlc/tasks/documentation/` |

---

## Task Name Generation

Generate task directory name from description:

1. Extract 3-5 key words from description
2. Convert to lowercase kebab-case
3. Prepend current date in YYYY-MM-DD format

**Examples**:
- "Fix login timeout bug" → `2025-12-17-fix-login-timeout`
- "Add user authentication" → `2025-12-17-user-authentication`
- "Optimize database queries" → `2025-12-17-optimize-database-queries`

---

## Initialization Summary Output

Output this summary before starting Phase 0:

```
🚀 [Orchestrator Name] Started

Task: [description]
Mode: [Interactive/YOLO]
Directory: [task-path]

Starting Phase 0: [Phase Name]...
```

---

## Handling Prerequisites Missing

If starting mid-workflow with missing prerequisites:

1. List required files with status (missing/found)
2. Use AskUserQuestion with options:
   - "Start from Phase 0"
   - "Specify different phase"
   - "Exit"

---

## Common Mistakes

| Mistake | Why It's Wrong |
|---------|----------------|
| Skipping TodoWrite | No progress visibility for user |
| Not creating state file | Resume capability breaks |
| Wrong task type directory | Organization confusion (don't put bugs in new-features/) |
| Starting execution before summary | User doesn't see full workflow plan |
