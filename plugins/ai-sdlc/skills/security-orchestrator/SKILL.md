---
name: security-orchestrator
description: Orchestrates security remediation workflows from vulnerability analysis through compliance audit. Identifies security issues, creates prioritized remediation plan, implements fixes incrementally with testing, verifies improvements, and optionally audits compliance (GDPR, HIPAA, SOC 2, PCI DSS).
---

# Security Orchestrator

Systematic security remediation workflow from vulnerability analysis to compliance-ready deployment.

## When to Use This Skill

Use when:
- Security vulnerabilities detected (dependency CVEs, code vulnerabilities)
- Need systematic security remediation workflow
- Want CVSS-scored vulnerability prioritization
- Require compliance audit (GDPR, HIPAA, SOC 2, PCI DSS)
- Security issues reported or discovered

## Core Principles

1. **Evidence-Based**: Every finding backed by scan results or code inspection
2. **CVSS-Scored**: Quantitative severity assessment for all vulnerabilities
3. **Risk-Prioritized**: Critical vulnerabilities fixed first
4. **Incremental**: Small, testable security fixes
5. **Verified**: Prove every fix with before/after scans

## Progress Tracking

Use `TodoWrite` to show real-time progress to the user. Create todos at workflow start, update at each phase transition.

**Phase Todos**:

| Phase | content | activeForm |
|-------|---------|------------|
| 0 | "Analyze vulnerabilities and baseline" | "Analyzing vulnerabilities and baseline" |
| 1 | "Plan security remediation" | "Planning security remediation" |
| 2 | "Implement security fixes" | "Implementing security fixes" |
| 3 | "Verify security improvements" | "Verifying security improvements" |
| 4 | "Audit compliance" | "Auditing compliance" |

**Rules**:
- Create all phase todos at workflow start (pending)
- Mark current phase `in_progress` before execution
- Mark phase `completed` immediately after success
- Optional phases (Phase 4): mark as `completed` if skipped
- State file remains source of truth for resume logic

---

## MANDATORY Initialization (Before Any Phase Work)

**CRITICAL: You MUST complete these steps BEFORE executing any workflow phase:**

### Step 1: Create TodoWrite with All Phases

**Immediately use the TodoWrite tool** to create todos for all phases:

```
Use TodoWrite tool with todos:
[
  {"content": "Analyze vulnerabilities and baseline", "status": "pending", "activeForm": "Analyzing vulnerabilities and baseline"},
  {"content": "Plan security remediation", "status": "pending", "activeForm": "Planning security remediation"},
  {"content": "Implement security fixes", "status": "pending", "activeForm": "Implementing security fixes"},
  {"content": "Verify security improvements", "status": "pending", "activeForm": "Verifying security improvements"},
  {"content": "Audit compliance", "status": "pending", "activeForm": "Auditing compliance"}
]
```

### Step 2: Output Initialization Summary

**Output this summary to the user:**

```
🚀 Security Orchestrator Started

Security Issue: [description]
Mode: [Interactive/YOLO]

Workflow Phases:
0. [ ] Vulnerability Analysis & Security Baseline → security-analyzer subagent
1. [ ] Security Planning & Remediation Strategy → security-planner subagent
2. [ ] Security Implementation with Testing → main orchestrator
3. [ ] Security Verification → security-verifier subagent
4. [ ] Compliance Audit (optional) → compliance-auditor subagent

State file: [task-path]/orchestrator-state.yml

[Interactive mode] You'll be prompted for review after each phase.
[YOLO mode] All phases will run continuously.

Starting Phase 0: Vulnerability Analysis & Security Baseline...
```

### Step 3: Only Then Proceed to Phase 0

After completing Steps 1 and 2, proceed to Phase 0 (Vulnerability Analysis & Security Baseline).

---

## Execution Modes

**Interactive** (default): Pause after each phase for review
**YOLO**: Continuous execution without pauses

## Workflow Overview

4-5 phase workflow (0-4, Phase 4 optional):

1. **Phase 0**: Vulnerability Analysis & Security Baseline → Delegate to `security-analyzer`
2. **Phase 1**: Security Planning & Remediation Strategy → Delegate to `security-planner`
3. **Phase 2**: Security Implementation with Testing → Orchestrator (or delegate complex to `implementation-changes-planner`)
4. **Phase 3**: Security Verification → Delegate to `security-verifier`
5. **Phase 4**: Compliance Audit (Optional) → Delegate to `compliance-auditor`

---

## Phase Execution

### Phase 0: Vulnerability Analysis & Security Baseline

**Delegate to**: `security-analyzer` subagent

**Invoke security-analyzer via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:security-analyzer"
- description: "Analyze vulnerabilities and baseline"
- prompt: |
    You are the security-analyzer agent. Analyze application security and create
    a comprehensive baseline of vulnerabilities.

Security Issue Description: [user description]

Task directory: [task-path]

Please:
1. Scan dependencies for known vulnerabilities (npm audit, pip-audit, etc.)
2. Analyze authentication and authorization code
3. Detect injection vulnerabilities (SQL, XSS, command injection)
4. Find sensitive data exposure (hardcoded secrets, logging)
5. Check for security misconfigurations
6. Identify insecure dependencies
7. Detect business logic vulnerabilities
8. Score each vulnerability using CVSS v3.1
9. Classify by OWASP Top 10 categories
10. Generate comprehensive security baseline report

Save to: analysis/security-baseline.md

Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `analysis/security-baseline.md`, scan artifacts

**Success**: All vulnerability types checked, CVSS scores assigned, evidence documented

**Update State**:
```yaml
orchestrator_state:
  current_phase: 1
  last_completed_phase: 0
  phases_completed: [0]
  vulnerability_count: [from baseline]
  critical_count: [critical vulnerabilities]
```

---

### Phase 1: Security Planning & Remediation Strategy

**Delegate to**: `security-planner` subagent

**Invoke security-planner via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:security-planner"
- description: "Plan security remediation"
- prompt: |
    You are the security-planner agent. Analyze security baseline and create
    prioritized remediation plan.

Task directory: [task-path]

Please:
1. Load security baseline from analysis/security-baseline.md
2. Classify fix types (dependency, code pattern, config, cryptography, etc.)
3. Assess impact and effort for each fix
4. Calculate priority scores (CVSS × 10 + Impact × 2 - Effort)
5. Group fixes by type and dependency
6. Break into incremental steps (max 3 files per increment)
7. Define verification steps for each fix
8. Identify breaking change risks with mitigation
9. Create comprehensive remediation plan

Save to: implementation/security-remediation-plan.md

Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `implementation/security-remediation-plan.md`

**Success**: All vulnerabilities planned, priorities assigned, increments defined

**Update State**:
```yaml
orchestrator_state:
  current_phase: 2
  last_completed_phase: 1
  phases_completed: [0, 1]
  fix_count: [from plan]
  target_risk_reduction: [from plan]
```

---

### Phase 2: Security Implementation with Testing

**Execution**: Main orchestrator (delegates complex fixes to `implementation-changes-planner`)

**Standards Reminder**: Review `.ai-sdlc/docs/INDEX.md` for security standards and secure coding practices before implementing fixes.

**Process**:

For each fix in `security-remediation-plan.md` (in priority order: P0 → P1 → P2 → P3):

**Step 1: Read Fix Details**
```
Load fix details from implementation/security-remediation-plan.md:
- Fix ID
- Type (dependency/code pattern/config/cryptography/etc.)
- Location (file:line)
- Vulnerability (OWASP category, CVSS score)
- Fix strategy
- Implementation increments
```

**Step 2: Security Scan Before**
```bash
# Run relevant scanner for this fix type

# Dependency fix
npm audit --json > implementation/security-scans/fix-[id]-before.json

# Code pattern fix
grep "[vulnerability-pattern]" src/file.js | wc -l  # Count occurrences

# Save baseline for this specific fix
```

**Step 3: Implement Fix**

**If Simple** (1-3 file changes):
- Apply changes directly using Edit tool
- Follow implementation increments from plan

**If Complex** (4+ file changes or unclear approach):
- Delegate to `implementation-changes-planner` subagent:
  ```
  Create detailed change plan for security fix:
  [fix details]

  Return change plan with file modifications.
  Do NOT apply changes, only plan them.
  ```
- Apply changes from returned plan using Edit tool

**Step 4: Security Scan After**
```bash
# Re-run scanner
npm audit --json > implementation/security-scans/fix-[id]-after.json

# Or re-count pattern occurrences
grep "[vulnerability-pattern]" src/file.js | wc -l
```

**Step 5: Verify Fix**
```
Compare before/after scan results:
- Before: [vulnerability count/CVSS score]
- After: [vulnerability count/CVSS score]
- Fixed: [yes/no/partial]

If vulnerability eliminated: ✅ Success
If vulnerability reduced: ⚠️ Improvement (document gap)
If no change: ❌ Failed
```

**Step 6: Run Tests**
```bash
# Run relevant test suite
npm test  # or appropriate test command

If tests fail:
  - Rollback fix using git checkout
  - Mark as failed in security-remediation-plan.md
  - Continue to next fix
```

**Step 7: Update Plan**
```
Update implementation/security-remediation-plan.md:
- Mark fix as complete/failed
- Document actual result (vulnerability eliminated/reduced/unchanged)
- Note issues encountered
```

**Outputs**:
- Fixed code files
- `implementation/security-scans/*.json` - Before/after scan results
- `implementation/security-remediation-plan.md` - Updated with results

**Success**: All fixes implemented (or attempted), scanned, documented

**Update State**:
```yaml
orchestrator_state:
  current_phase: 3
  last_completed_phase: 2
  phases_completed: [0, 1, 2]
  fixes_completed: [list]
  fixes_failed: [list]
```

---

### Phase 3: Security Verification

**Delegate to**: `security-verifier` subagent

**Invoke security-verifier via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:security-verifier"
- description: "Verify security improvements"
- prompt: |
    You are the security-verifier agent. Verify security fixes resolved
    vulnerabilities without regressions.

Task directory: [task-path]

Please:
1. Load baseline from analysis/security-baseline.md
2. Load remediation plan from implementation/security-remediation-plan.md
3. Re-run all dependency vulnerability scans (same tools as baseline)
4. Re-scan code for vulnerability patterns
5. Verify each fix individually (check code, compare scans)
6. Check for new vulnerabilities introduced
7. Calculate security improvement metrics:
   - Vulnerability count reduction
   - Risk score reduction
   - CVSS score improvement
8. Generate verification report with PASS/FAIL verdict

Save to: verification/security-verification-report.md

Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.

Verdict Criteria:
- PASS: All P0 (Critical/High CVSS >7.0) fixed, no critical new vulnerabilities, risk reduction >70%
- PASS with Issues: Most P0 fixed (>80%), no critical new vulnerabilities, risk reduction >50%
- FAIL: Critical vulnerabilities remain or critical new vulnerabilities introduced
```

**Outputs**: `verification/security-verification-report.md` with verdict

**Success**: Verification complete, verdict determined

**Update State**:
```yaml
orchestrator_state:
  current_phase: 4 (if PASS) or halt (if FAIL)
  last_completed_phase: 3
  phases_completed: [0, 1, 2, 3]
  verification_verdict: [PASS/PASS with Issues/FAIL]
  risk_reduction: [percentage]
  vulnerabilities_fixed: [count]
```

**Gate**: Cannot proceed to Phase 4 if verdict = FAIL

---

### Phase 4: Compliance Audit (Optional)

**Delegate to**: `compliance-auditor` subagent

**Prerequisites**: Phase 3 verdict = PASS or PASS with Issues

**Invoke compliance-auditor via Task tool:**
```
Use Task tool with parameters:
- subagent_type: "ai-sdlc:compliance-auditor"
- description: "Audit compliance"
- prompt: |
    You are the compliance-auditor agent. Audit application compliance with
    regulatory frameworks.

Task directory: [task-path]

Please:
1. Determine applicable frameworks (GDPR, HIPAA, SOC 2, PCI DSS)
2. If GDPR applicable:
   - Audit data privacy & consent
   - Verify right to access and erasure
   - Check data minimization
   - Verify breach notification process
3. If HIPAA applicable:
   - Audit access controls
   - Verify audit logging (6-year retention)
   - Check transmission security (TLS 1.2+)
   - Verify encryption at rest
4. If SOC 2 applicable:
   - Audit security controls (MFA, RBAC, monitoring)
   - Check availability (backups, uptime)
   - Verify confidentiality and privacy
5. If PCI DSS applicable:
   - Verify cardholder data protection
   - Check encryption requirements
   - Audit access logging
6. Generate compliance assessment report with gaps and remediation roadmap

Save to: verification/compliance-assessment-report.md

Use only Read, Grep, Glob, and Bash tools. Do NOT modify code.
```

**Outputs**: `verification/compliance-assessment-report.md`

**Success**: Compliance audit complete, gaps documented

**Update State**:
```yaml
orchestrator_state:
  current_phase: 4
  last_completed_phase: 4
  phases_completed: [0, 1, 2, 3, 4]
  workflow_status: completed
  compliance_status: [Compliant/Partially Compliant/Non-Compliant]
  compliance_gaps: [count]
```

---

## State Management

**State File**: `.ai-sdlc/tasks/security/[dated-name]/orchestrator-state.yml`

```yaml
orchestrator:
  mode: interactive  # or yolo
  started_phase: 0
  current_phase: 3
  completed_phases: [0, 1, 2]
  failed_phases: []

  auto_fix_attempts:
    phase-0: 0
    phase-1: 0
    phase-2: 2
    phase-3: 0
    phase-4: 0

  security_context:
    baseline_vulnerabilities: 24
    critical_vulnerabilities: 5
    fixes_planned: 18
    fixes_completed: 16
    verification_verdict: "PASS"
    risk_reduction: "88%"
    vulnerabilities_fixed: 18

  options:
    skip_compliance_audit: false
    compliance_frameworks: ["GDPR", "HIPAA", "SOC 2"]

  created: 2025-11-17T10:00:00Z
  updated: 2025-11-17T14:30:00Z
  task_path: .ai-sdlc/tasks/security/2025-11-17-fix-vulnerabilities
```

---

## Auto-Recovery

| Phase | Max Attempts | Strategy |
|-------|--------------|----------|
| **Phase 0** | 2 | Try alternative scanners, focus on high-risk areas, prompt user |
| **Phase 1** | 2 | Research OWASP remediation, use conservative estimates, prompt user |
| **Phase 2** | 3 | Fix syntax errors, retry scans, rollback failed fixes |
| **Phase 3** | 0 | Read-only, report only |
| **Phase 4** | 0 | Read-only, report only |

---

## Integration Points

**Documentation System**:
- Read `.ai-sdlc/docs/INDEX.md` for security standards
- Follow secure coding practices from standards

**Testing**:
- Run test suite after each fix
- Ensure no regressions introduced

**Compliance**:
- Optional integration with `compliance-auditor`
- Verify regulatory requirements (GDPR, HIPAA, SOC 2, PCI DSS)

---

## Reference Files

See `references/` directory:
- `workflow-phases.md` - Detailed phase descriptions with dependencies
- `vulnerability-types.md` - OWASP Top 10 2021 categories with detection patterns
- `security-guide.md` - Scanning tools, fix patterns, verification methods, compliance frameworks

---

## Related Skills

**Subagents**:
- `security-analyzer` - Vulnerability analysis and baseline
- `security-planner` - Remediation planning
- `security-verifier` - Fix verification
- `compliance-auditor` - Compliance audit (optional)

**Optional Integration**:
- `implementation-changes-planner` - Complex fix planning

---

## Command Integration

Invoked via:
- `/ai-sdlc:security:new [description] [--yolo]`
- `/ai-sdlc:security:resume [task-path]`

See `commands/security/new.md` and `commands/security/resume.md` for command specifications.

---

## Success Criteria

Workflow successful when:

✅ Security baseline documented with all vulnerabilities CVSS-scored
✅ Remediation plan created with prioritized fixes
✅ All P0 (Critical/High CVSS >7.0) vulnerabilities fixed
✅ Verification verdict = PASS (targets met, no critical regressions)
✅ Risk score reduced by 70-90%+
✅ Compliance gaps identified (if Phase 4 run)
✅ Ready for secure deployment

Security orchestration provides complete, CVSS-scored, evidence-based vulnerability remediation from security issue to compliance-ready deployment.
