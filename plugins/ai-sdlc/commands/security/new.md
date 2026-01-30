---
name: ai-sdlc:security:new
description: Start a security remediation workflow with vulnerability analysis, prioritized fixes, and compliance audit
---

**ACTION REQUIRED**: Call the Skill tool with skill="ai-sdlc:security-orchestrator" NOW. Pass all arguments. Do not read files, explore code, or enter plan mode first.

# Security Remediation Workflow: New

Start comprehensive security remediation from vulnerability analysis through compliance-ready deployment.

## Usage

```bash
/ai-sdlc:security:new [description] [--yolo] [--from=PHASE]
```

### Options

- `--yolo`: Continuous execution without pauses
- `--from=PHASE`: Start from phase (baseline, planning, implementation, verification, compliance)

## Examples

```bash
/ai-sdlc:security:new "Fix authentication vulnerabilities"
/ai-sdlc:security:new "npm audit shows critical CVEs" --yolo
/ai-sdlc:security:new --from=implementation
```

## See Also

- Workflow details: `skills/security-orchestrator/skill.md`
- Task output: `.ai-sdlc/tasks/security/YYYY-MM-DD-name/`
