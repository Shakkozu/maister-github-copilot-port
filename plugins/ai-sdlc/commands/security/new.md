---
name: security:new
description: Start a security remediation workflow with vulnerability analysis, prioritized fixes, and compliance audit
category: Security Workflows
---

# Security Remediation Workflow: New

Start comprehensive security remediation from vulnerability analysis through compliance-ready deployment.

## Command Usage

```bash
/ai-sdlc:security:new [description] [--yolo] [--from=phase]
```

### Arguments

- **description** (optional): Security issue description
  - Example: "Fix security vulnerabilities in authentication"
  - Example: "npm audit shows 15 critical CVEs"
  - If omitted, you'll be prompted

### Options

- `--yolo`: Run in YOLO mode (continuous without pauses)
  - Default: Interactive mode (pause between phases)
- `--from=PHASE`: Start from specific phase
  - Values: `baseline`, `planning`, `implementation`, `verification`, `compliance`
  - Default: `baseline`

## Examples

### Example 1: Interactive Mode (Default)

```bash
/ai-sdlc:security:new "Fix authentication vulnerabilities"
```

Workflow: Baseline → Planning → Implementation → Verification → Compliance (pause after each)

### Example 2: YOLO Mode (Fast Execution)

```bash
/ai-sdlc:security:new "npm audit shows critical CVEs" --yolo
```

All phases run continuously, only stops on failure.

### Example 3: Start from Specific Phase

```bash
/ai-sdlc:security:new --from=implementation
```

Skips baseline and planning, starts directly from implementation (requires existing remediation plan).

## What You Are Doing

**Invoke the security-orchestrator skill NOW using the Skill tool.**

The skill orchestrates 4-5 phases:

**Phase 0: Vulnerability Analysis & Security Baseline** → `security-analyzer` agent
- Scan dependencies for CVEs (npm audit, pip-audit, etc.)
- Detect code vulnerabilities (SQL injection, XSS, hardcoded secrets)
- Score vulnerabilities using CVSS v3.1
- Classify by OWASP Top 10 categories
- Generate comprehensive security baseline report

**Phase 1: Security Planning & Remediation Strategy** → `security-planner` agent
- Classify fix types (dependency, code pattern, config, cryptography)
- Assess impact and effort for each fix
- Prioritize by CVSS score and exploitability
- Break into incremental testable steps
- Create comprehensive remediation plan

**Phase 2: Security Implementation with Testing** → Orchestrator
- For each fix: Scan before → Implement → Scan after
- Verify fix eliminated vulnerability
- Run tests to ensure no regressions

**Phase 3: Security Verification** → `security-verifier` agent
- Re-run all security scans
- Compare baseline vs fixed state
- Calculate risk reduction metrics
- Generate PASS/FAIL verdict

**Phase 4: Compliance Audit (Optional)** → `compliance-auditor` agent
- Audit GDPR compliance (data privacy, consent, erasure)
- Verify HIPAA requirements (PHI protection, audit logs)
- Check SOC 2 controls (security, availability)
- Assess PCI DSS compliance (payment data protection)
- Generate compliance report with gaps

## Outputs

Task directory: `.ai-sdlc/tasks/security/YYYY-MM-DD-name/`

- `analysis/security-baseline.md` - Vulnerability baseline with CVSS scores
- `implementation/security-remediation-plan.md` - Prioritized fixes
- `implementation/security-scans/*.json` - Before/after scan results
- `verification/security-verification-report.md` - Verification with verdict
- `verification/compliance-assessment-report.md` - Compliance audit (optional)

## Prerequisites

- Application code accessible
- Security scanners available (npm audit, pip-audit, etc. based on tech stack)
- Tests executable

## Execution Modes

**Interactive**: Pause after each phase, review results, continue when ready
**YOLO**: Continuous execution, stops only on failures

## Resume After Interruption

If interrupted:
```bash
/ai-sdlc:security:resume .ai-sdlc/tasks/security/2025-11-17-task
```

## Expected Timeline

- **Phase 0** (Baseline): 30-60 minutes
- **Phase 1** (Planning): 30-45 minutes
- **Phase 2** (Implementation): 2-8 hours (depends on vulnerability count)
- **Phase 3** (Verification): 30-60 minutes
- **Phase 4** (Compliance): 1-2 hours (optional)

**Total**: 4-12 hours for complete workflow

## Invoke

Invoke the **security-orchestrator** skill to start systematic security remediation with CVSS-scored prioritization, incremental fixes, and compliance audit.
