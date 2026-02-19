#!/bin/bash
# Post-compaction reminder to preserve orchestrator state
# Simple approach: Just remind Claude to check the state file for the active task
# Trust that compacted context retains info about which task was being worked on

TASKS_DIR="$CLAUDE_PROJECT_DIR/.maister/tasks"

# Check if tasks directory exists
if [ -d "$TASKS_DIR" ]; then
  cat <<'EOF'
{
  "systemMessage": "Maister plugin detected active workflow. Check orchestrator-state.yml for mode and phase.",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "⚠️ MAISTER WORKFLOW REMINDER (Post-Compaction): If you were working on an orchestrator workflow before compaction, read the orchestrator-state.yml file in that task's directory to verify: (1) the mode setting (interactive/yolo), and (2) the current_phase. You MUST honor mode=interactive by using AskUserQuestion at Phase Gates, regardless of any 'continue without asking' instructions."
  }
}
EOF
fi

exit 0
