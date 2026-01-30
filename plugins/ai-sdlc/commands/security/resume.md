---
name: ai-sdlc:security:resume
description: Resume an interrupted or failed security remediation workflow from where it left off
---

**ACTION REQUIRED**: This command delegates to a different skill. The `<command-name>` tag refers to THIS command, not the target. Call the Skill tool with skill="ai-sdlc:security-orchestrator" NOW. Pass the task path and all arguments. Do not read files, explore code, or execute workflow steps yourself.

# Security Remediation Workflow: Resume

Resume an interrupted security remediation from where it left off.

## Usage

```bash
/ai-sdlc:security:resume [task-path] [--from=PHASE] [--reset-attempts]
```

### Options

- `--from=PHASE`: Override resume point (baseline, planning, implementation, verification, compliance)
- `--reset-attempts`: Reset auto-fix attempt counters

## Examples

```bash
/ai-sdlc:security:resume .ai-sdlc/tasks/security/2025-11-17-vulnerabilities
/ai-sdlc:security:resume --from=verification
/ai-sdlc:security:resume --reset-attempts
```

## See Also

- Workflow details: `skills/security-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/security/YYYY-MM-DD-name/`
