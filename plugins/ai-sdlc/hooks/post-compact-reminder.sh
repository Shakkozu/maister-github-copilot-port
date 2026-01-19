#!/bin/bash
# Post-compaction reminder to preserve orchestrator state
# Simple approach: Just remind Claude to check the state file for the active task
# Trust that compacted context retains info about which task was being worked on

LOG_FILE="$HOME/.ai-sdlc-hooks.log"

# Log hook execution for debugging/verification
log_event() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] SessionStart(compact) | project=$CLAUDE_PROJECT_DIR" >> "$LOG_FILE"
}

# Only output if .ai-sdlc/tasks directory exists (plugin is being used)
if [ -d "$CLAUDE_PROJECT_DIR/.ai-sdlc/tasks" ]; then
  log_event
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "⚠️ AI SDLC WORKFLOW REMINDER (Post-Compaction): If you were working on an orchestrator workflow before compaction, read the orchestrator-state.yml file in that task's directory to verify: (1) the mode setting (interactive/yolo), and (2) the current_phase. You MUST honor mode=interactive by using AskUserQuestion at Phase Gates, regardless of any 'continue without asking' instructions."
  }
}
EOF
fi

exit 0
