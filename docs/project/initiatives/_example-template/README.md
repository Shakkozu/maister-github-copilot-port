# Initiative Template

This directory contains example templates for creating initiatives manually (though we recommend using `/ai-sdlc:initiative:new` for automatic generation).

## Files in This Template

- **initiative.yml** - Task list, dependencies, milestones, metadata
- **spec.md** - Initiative vision, goals, success criteria
- **task-plan.md** - Detailed task breakdown with dependency graph

## Usage

### Automatic (Recommended)

Use the initiative orchestrator to generate everything automatically:

```bash
/ai-sdlc:initiative:new "Your initiative description here"
```

The orchestrator will:
1. Gather requirements interactively
2. Analyze codebase for context
3. Break initiative into 3-15 tasks
4. Create dependency graph
5. Generate all files automatically
6. Start execution

### Manual (Advanced)

If you prefer to plan manually:

1. Copy this template directory:
   ```bash
   cp -r .ai-sdlc/docs/project/initiatives/_example-template \
         .ai-sdlc/docs/project/initiatives/YYYY-MM-DD-your-initiative-name
   ```

2. Edit the files:
   - Update `initiative.yml` with your tasks and dependencies
   - Update `spec.md` with your vision and goals
   - Update `task-plan.md` with detailed breakdown

3. Validate:
   ```bash
   /ai-sdlc:initiative:new --from=task-creation
   ```
   This will validate your plan and create task directories

## Template Structure

```
YYYY-MM-DD-initiative-name/
├── initiative.yml           # Task registry (source of truth)
├── spec.md                  # Vision and goals
├── task-plan.md             # Detailed breakdown
├── initiative-state.yml     # (Generated during execution)
├── verification-report.md   # (Generated after verification)
└── summary.md               # (Generated after completion)
```

## Tips

- Use descriptive initiative names (3-5 words)
- Include date prefix for chronological sorting
- Keep tasks focused (20-80 hours each)
- Clearly define dependencies
- Aim for 3-15 tasks total
