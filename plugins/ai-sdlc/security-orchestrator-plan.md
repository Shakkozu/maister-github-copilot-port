# Security Orchestrator Implementation Plan

## Overview

**Purpose**: Orchestrate security vulnerability fixing workflows with assessment, penetration testing, and compliance verification.

**Task Type**: Security fixes (4-5 stages)
**Classification Keywords**: "vulnerability", "security", "exploit", "CVE", "penetration test"

**Total Files to Create**: 11 files
**Estimated Time**: 3-4 hours

---

## Workflow Phases (4-5 phases)

1. **Phase 0: Security Assessment & Vulnerability Analysis**
   - Scan for vulnerabilities (OWASP Top 10, dependency vulnerabilities)
   - Classify by severity (Critical, High, Medium, Low based on CVSS)
   - Document affected components and attack vectors
   - Assess potential impact and exploitability

2. **Phase 1: Fix Planning & Impact Analysis**
   - Analyze each vulnerability's root cause
   - Plan fixes addressing root cause (not symptoms)
   - Assess fix impact (breaking changes, dependencies)
   - Prioritize by severity and exploitability
   - Create fix implementation plan

3. **Phase 2: Security Fix Implementation**
   - Implement fixes following security best practices
   - Apply defense-in-depth principles
   - Follow project security standards
   - Add security tests (penetration, fuzzing)
   - Document security decisions

4. **Phase 3: Security Verification & Penetration Testing**
   - Re-scan for vulnerabilities
   - Verify vulnerabilities fixed
   - Conduct penetration testing
   - Test attack scenarios
   - Validate no new vulnerabilities introduced

5. **Phase 4: Compliance Audit (Optional)**
   - Verify compliance requirements met (GDPR, HIPAA, SOC 2, etc.)
   - Check security headers (CSP, HSTS, X-Frame-Options)
   - Validate authentication/authorization
   - Review logging and audit trails
   - Generate compliance report

---

## Files to Create

### Subagents (4 files)

#### 1. `agents/security-analyzer.md` (~750 lines)

**Purpose**: Security assessment and vulnerability analysis

**Capabilities**:
- Scan for OWASP Top 10 vulnerabilities
  - SQL Injection, XSS, CSRF, Authentication flaws, etc.
- Dependency vulnerability scanning (npm audit, pip-audit, OWASP Dependency-Check)
- CVSS scoring (calculate severity)
- Classify vulnerability types
- Identify attack vectors
- Assess exploitability
- Generate vulnerability assessment report

**Tools**: Read, Grep, Glob, Bash (read-only), WebFetch (for CVE lookups)

**Output**: `analysis/security-assessment.md` with vulnerabilities, severity, CVSS scores

**Key Sections**:
- Agent metadata (YAML frontmatter)
- Purpose and responsibilities
- 9-phase workflow (Scan dependencies → Check code patterns → Identify OWASP issues → Calculate CVSS → Classify types → Identify vectors → Assess exploitability → Prioritize → Generate report)
- OWASP Top 10 detection patterns
- Vulnerability classification framework
- CVSS scoring methodology
- Severity levels (Critical/High/Medium/Low)
- Assessment report structure

---

#### 2. `agents/security-planner.md` (~700 lines)

**Purpose**: Security fix planning and impact analysis

**Capabilities**:
- Analyze root cause of vulnerabilities
- Plan fixes addressing root cause
- Assess fix impact (breaking changes, API changes)
- Check for dependency conflicts
- Evaluate defense-in-depth strategies
- Create comprehensive fix plan with priorities
- Document security decisions

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `implementation/security-fix-plan.md` with prioritized fixes and impact analysis

**Key Sections**:
- Agent metadata
- 8-phase workflow (Load assessment → Analyze root causes → Plan fixes → Assess impact → Evaluate defense strategies → Prioritize → Create plan → Document decisions)
- Root cause analysis techniques
- Fix strategy patterns (input validation, parameterized queries, CSP headers, etc.)
- Impact assessment framework
- Defense-in-depth principles
- Priority matrix (severity × exploitability)
- Fix plan structure

---

#### 3. `agents/security-verifier.md` (~700 lines)

**Purpose**: Security verification and penetration testing

**Capabilities**:
- Re-scan for vulnerabilities post-fix
- Verify vulnerabilities remediated
- Conduct penetration testing (automated)
- Test attack scenarios
- Validate security controls
- Check for new vulnerabilities
- Generate verification report with verdict

**Tools**: Read, Grep, Glob, Bash (read-only), WebFetch (for CVE verification)

**Output**: `verification/security-verification.md` with PASS/FAIL verdict

**Key Sections**:
- Agent metadata
- 8-phase workflow (Re-scan dependencies → Check code patterns → Test attack scenarios → Validate controls → Verify fixes → Check new vulns → Pen test → Generate report)
- Penetration testing patterns
- Attack scenario testing
- Security control validation
- Comparison structure (before vs after vulnerabilities)
- Verdict criteria (PASS if all Critical/High fixed, FAIL if any remain)
- Read-only philosophy

---

#### 4. `agents/compliance-auditor.md` (~650 lines)

**Purpose**: Compliance verification (GDPR, HIPAA, SOC 2, etc.)

**Capabilities**:
- Check GDPR compliance (data protection, consent, right to deletion)
- Verify HIPAA requirements (PHI protection, audit logs, encryption)
- Validate SOC 2 controls (access control, encryption, monitoring)
- Check security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- Verify authentication/authorization
- Review logging and audit trails
- Generate compliance report

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: `verification/compliance-report.md` with compliance status

**Key Sections**:
- Agent metadata
- 7-phase workflow (Determine requirements → Check data protection → Verify auth/authz → Review logging → Check headers → Validate encryption → Generate report)
- Compliance frameworks (GDPR, HIPAA, SOC 2, PCI-DSS)
- Security headers checklist
- Authentication/authorization validation
- Logging requirements
- Compliance report structure

---

### References (5 files)

#### 5. `skills/security-orchestrator/references/vulnerability-types.md` (~800 lines)

**Purpose**: OWASP Top 10 and common vulnerability types

**Content**:
- **OWASP Top 10 (2021)**
  1. Broken Access Control
     - Detection patterns (missing authorization checks)
     - Fix strategies (role-based access control, principle of least privilege)
  2. Cryptographic Failures
     - Detection (weak algorithms, hardcoded secrets)
     - Fix (use strong algorithms, secret management)
  3. Injection (SQL, NoSQL, OS command, LDAP)
     - Detection (string concatenation, eval())
     - Fix (parameterized queries, input validation, escaping)
  4. Insecure Design
     - Detection (missing security controls)
     - Fix (threat modeling, secure design patterns)
  5. Security Misconfiguration
     - Detection (default configs, unnecessary features)
     - Fix (hardening guides, minimal configuration)
  6. Vulnerable and Outdated Components
     - Detection (dependency scanners)
     - Fix (update dependencies, monitor CVEs)
  7. Identification and Authentication Failures
     - Detection (weak passwords, no MFA, session issues)
     - Fix (strong auth, MFA, secure sessions)
  8. Software and Data Integrity Failures
     - Detection (unsigned packages, insecure CI/CD)
     - Fix (signed packages, secure pipelines)
  9. Security Logging and Monitoring Failures
     - Detection (no logging, insufficient monitoring)
     - Fix (comprehensive logging, SIEM integration)
  10. Server-Side Request Forgery (SSRF)
      - Detection (user-controlled URLs)
      - Fix (URL allowlists, network segmentation)

- **Additional Vulnerability Types**
  - Cross-Site Scripting (XSS): Stored, Reflected, DOM-based
  - Cross-Site Request Forgery (CSRF)
  - XML External Entities (XXE)
  - Deserialization vulnerabilities
  - Path Traversal
  - Open Redirects

- **Detection Patterns** (code patterns that indicate vulnerabilities)

- **Fix Strategies** (secure coding patterns for each vulnerability type)

---

#### 6. `skills/security-orchestrator/references/security-verification.md` (~700 lines)

**Purpose**: Penetration testing and verification strategies

**Content**:
- **Automated Penetration Testing Tools**
  - OWASP ZAP (web application scanner)
  - Burp Suite (manual + automated testing)
  - sqlmap (SQL injection testing)
  - XSStrike (XSS detection)
  - Nikto (web server scanner)

- **Manual Testing Techniques**
  - Input fuzzing (boundary values, special characters, overflows)
  - Authentication bypass attempts
  - Authorization escalation testing
  - Session hijacking attempts
  - CSRF token validation

- **Attack Scenario Testing**
  - SQL Injection scenarios (union, boolean, time-based)
  - XSS scenarios (stored, reflected, DOM)
  - CSRF scenarios (state-changing operations)
  - Authentication scenarios (brute force, credential stuffing)
  - Authorization scenarios (horizontal, vertical escalation)

- **Security Control Validation**
  - Input validation (whitelist vs blacklist)
  - Output encoding (context-aware escaping)
  - Authentication (password strength, MFA)
  - Authorization (RBAC, ABAC)
  - Session management (secure flags, timeouts)
  - HTTPS enforcement (HSTS, redirect)
  - Security headers (CSP, X-Frame-Options)

- **Verification Checklist**
  - All identified vulnerabilities remediated
  - No new vulnerabilities introduced
  - Security controls functioning
  - Attack scenarios fail (expected behavior)
  - Penetration tests pass

---

#### 7. `skills/security-orchestrator/references/compliance-requirements.md` (~650 lines)

**Purpose**: Compliance frameworks and requirements

**Content**:
- **GDPR (General Data Protection Regulation)**
  - Lawful basis for processing
  - Data subject consent
  - Right to access, rectification, erasure
  - Data portability
  - Privacy by design
  - Data breach notification (72 hours)

- **HIPAA (Health Insurance Portability and Accountability Act)**
  - PHI (Protected Health Information) protection
  - Access control (unique user IDs, automatic logoff)
  - Audit controls (logging all PHI access)
  - Integrity controls (encryption, digital signatures)
  - Transmission security (TLS, VPN)

- **SOC 2 (Service Organization Control 2)**
  - Trust Services Criteria (Security, Availability, Confidentiality, Processing Integrity, Privacy)
  - Access control policies
  - Encryption at rest and in transit
  - Change management procedures
  - Incident response plan
  - Monitoring and logging

- **PCI-DSS (Payment Card Industry Data Security Standard)**
  - Cardholder data protection
  - Encryption of transmission
  - Secure authentication
  - Regular vulnerability scans
  - Penetration testing (annually)

- **Security Headers**
  - Content-Security-Policy (CSP)
  - Strict-Transport-Security (HSTS)
  - X-Frame-Options (clickjacking protection)
  - X-Content-Type-Options (MIME sniffing protection)
  - Referrer-Policy
  - Permissions-Policy

- **Compliance Checklist per Framework**

---

#### 8. `skills/security-orchestrator/references/severity-classification.md` (~550 lines)

**Purpose**: CVSS scoring and severity classification

**Content**:
- **CVSS v3.1 (Common Vulnerability Scoring System)**
  - Base Score Metrics
    - Attack Vector (Network, Adjacent, Local, Physical)
    - Attack Complexity (Low, High)
    - Privileges Required (None, Low, High)
    - User Interaction (None, Required)
    - Scope (Unchanged, Changed)
    - Confidentiality Impact (None, Low, High)
    - Integrity Impact (None, Low, High)
    - Availability Impact (None, Low, High)

  - Temporal Score Metrics (optional)
    - Exploit Code Maturity
    - Remediation Level
    - Report Confidence

  - Environmental Score Metrics (optional)
    - Modified Base Metrics
    - Confidentiality/Integrity/Availability Requirements

- **CVSS Score Calculation**
  - Formula and examples
  - Online calculators (NIST, FIRST)

- **Severity Levels**
  - Critical: 9.0-10.0 (immediate fix required)
  - High: 7.0-8.9 (fix within days)
  - Medium: 4.0-6.9 (fix within weeks)
  - Low: 0.1-3.9 (fix when convenient)

- **Exploitability Assessment**
  - Publicly available exploits (PoC, Metasploit modules)
  - Ease of exploitation (automated, manual)
  - Prerequisites (authentication, special config)

- **Priority Matrix**
  - Severity × Exploitability = Priority
  - Critical + Public Exploit = P0 (drop everything)
  - High + No Exploit = P1 (fix this sprint)
  - Medium + Exploit = P1 (fix this sprint)
  - Low + No Exploit = P2 (backlog)

- **Risk Assessment**
  - Likelihood (how likely to be exploited)
  - Impact (business impact if exploited)
  - Risk = Likelihood × Impact

---

#### 9. `skills/security-orchestrator/references/workflow-phases.md` (~700 lines)

**Purpose**: 4-5 phase workflow with dependencies and execution patterns

**Content**:
- **Phase 0: Security Assessment & Vulnerability Analysis**
  - Agent: `security-analyzer`
  - Input: Security issue description or vulnerability report
  - Process: Scan dependencies → Check code → Identify OWASP → Calculate CVSS → Generate assessment
  - Output: `analysis/security-assessment.md`
  - Success criteria: All vulnerabilities identified, severity scored, attack vectors documented
  - Auto-fix: Max 2 attempts (expand scanning if tools unavailable)

- **Phase 1: Fix Planning & Impact Analysis**
  - Agent: `security-planner`
  - Input: Security assessment
  - Process: Analyze root causes → Plan fixes → Assess impact → Prioritize → Create plan
  - Output: `implementation/security-fix-plan.md`
  - Success criteria: Fix plan complete, impact assessed, priorities set
  - Auto-fix: Max 2 attempts (prompt user if fix strategy unclear)

- **Phase 2: Security Fix Implementation**
  - Agent: Main orchestrator (or delegate to `implementation-changes-planner`)
  - Input: Security fix plan
  - Process: For each fix → Implement securely → Add security tests → Verify locally
  - Output: Fixed code, security tests
  - Success criteria: All planned fixes implemented, security tests pass
  - Auto-fix: Max 3 attempts (fix syntax, imports, test issues)

- **Phase 3: Security Verification & Penetration Testing**
  - Agent: `security-verifier`
  - Input: Assessment + fixed code
  - Process: Re-scan → Verify fixes → Pen test → Test attacks → Generate report
  - Output: `verification/security-verification.md`
  - Success criteria: All Critical/High vulnerabilities fixed, pen tests pass, no new vulns
  - Auto-fix: Max 0 attempts (read-only, reports only)
  - **CRITICAL**: If any Critical/High vulnerabilities remain, verdict = FAIL, cannot proceed to Phase 4

- **Phase 4: Compliance Audit (Optional)**
  - Agent: `compliance-auditor`
  - Input: Verification report (PASS required)
  - Process: Determine requirements → Check compliance → Validate controls → Generate report
  - Output: `verification/compliance-report.md`
  - Success criteria: Compliance requirements met, controls validated
  - Auto-fix: Max 1 attempt (flag issues only)
  - **Conditional**: Only runs if compliance requirements specified (GDPR, HIPAA, etc.)

- **Phase Dependencies**: 0 → 1 → 2 → 3 → (optional 4) (sequential, cannot skip, Phase 4 requires Phase 3 PASS)
- **Execution Modes**: Interactive (pause between phases) and YOLO (continuous)
- **State Management**: `orchestrator-state.yml` tracks progress, severity levels, compliance requirements

---

### Main Skill File

#### 10. `skills/security-orchestrator/SKILL.md` (~950 lines)

**Purpose**: Main orchestrator with phase execution instructions

**Content Structure**:
- **Skill metadata** (YAML frontmatter)
  ```yaml
  ---
  name: security-orchestrator
  description: Orchestrates security vulnerability fixing workflows with assessment, penetration testing, and compliance verification
  ---
  ```

- **When to Use This Skill**
  - Security vulnerability reported or discovered
  - Dependency scan shows vulnerabilities
  - Penetration test findings need remediation
  - Compliance audit required

- **Core Principles**
  - Security first (Critical/High vulnerabilities block deployment)
  - Defense-in-depth (multiple layers of security)
  - Fail securely (secure by default)
  - Least privilege (minimal permissions)
  - Zero trust (verify everything)

- **Execution Modes** (Interactive vs YOLO)

- **Workflow Phases** (detailed step-by-step for each phase)
  - Phase 0: Security Assessment & Vulnerability Analysis
  - Phase 1: Fix Planning & Impact Analysis
  - Phase 2: Security Fix Implementation
  - Phase 3: Security Verification & Penetration Testing
  - Phase 4: Compliance Audit (Optional, conditional)

- **Orchestrator Workflow Execution**
  - Initialization (parse args, determine starting phase, initialize state with severity tracking)
  - Phase execution loop (for each phase)
  - Critical gate: Phase 3 must be PASS before Phase 4
  - Finalization (generate summary, update metadata, security advisory if needed)

- **State Management** (`orchestrator-state.yml` format with security context)
  ```yaml
  security_context:
    vulnerabilities_found: 5
    critical: 1
    high: 2
    medium: 2
    low: 0
    all_critical_high_fixed: false  # MUST be true before Phase 4
    compliance_required: ["GDPR", "HIPAA"]
  ```

- **Auto-Recovery Features** (per phase with max attempts)

- **Integration Points** (docs/INDEX.md, security standards, penetration testing tools)

- **Important Guidelines** (security orchestration best practices, never skip Critical/High fixes)

- **Reference Files** (list of references/ directory contents)

- **Example Workflows** (4-5 examples: SQL injection fix, dependency vuln fix, XSS fix, compliance audit)

- **Validation Checklist** (before completion, including all Critical/High fixed)

- **Success Criteria** (10 criteria including no Critical/High vulnerabilities remain)

---

### Command Files (2 files)

#### 11. `commands/security/new.md` (~450 lines)

**Purpose**: Command documentation for starting new security fix workflow

**Content**:
- Command frontmatter (YAML)
  ```yaml
  ---
  name: security:new
  description: Start a security vulnerability fixing workflow with assessment, penetration testing, and compliance verification
  category: Security Workflows
  ---
  ```

- **Command Usage**
  ```bash
  /ai-sdlc:security:new [description] [--yolo] [--from=phase] [--compliance=FRAMEWORKS]
  ```

- **Arguments and Options**
  - description: Security issue or vulnerability to fix
  - --yolo: Continuous execution
  - --from=PHASE: Start from specific phase
  - --compliance: Comma-separated frameworks (GDPR,HIPAA,SOC2)

- **Examples** (6-7 examples)
  - Example 1: SQL injection fix
  - Example 2: Dependency vulnerability fix
  - Example 3: XSS vulnerability fix
  - Example 4: Authentication vulnerability
  - Example 5: YOLO mode (fast fix)
  - Example 6: With compliance audit
  - Example 7: Resume from middle phase

- **What You Are Doing** (invoke security-orchestrator skill)

- **Workflow Phases** (brief description of each phase and outputs)

- **Execution Modes** (Interactive vs YOLO behavior)

- **Auto-Recovery Features** (per phase)

- **State Management** (orchestrator-state.yml location, security context)

- **Prerequisites**

- **When to Use This vs Individual Commands**

- **Resume After Interruption** (pointer to resume command)

- **Tips** (for different vulnerability types, compliance requirements)

- **Next Steps After Completion** (security advisory, deployment, monitoring)

- **Troubleshooting** (common issues and solutions)

- **Related Commands** (link to resume command)

- **Invoke** (call security-orchestrator skill)

---

#### 12. `commands/security/resume.md` (~500 lines)

**Purpose**: Command documentation for resuming interrupted security fix workflow

**Content**:
- Command frontmatter (YAML)

- **Command Usage**
  ```bash
  /ai-sdlc:security:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]
  ```

- **Arguments and Options**

- **Examples** (5-6 resume scenarios)
  - Simple resume (use state)
  - Resume from specific phase
  - Resume after manual fixes
  - Resume after pen test failure
  - Resume with compliance audit
  - Retry after Critical vuln detected

- **What You Are Doing** (resume workflow steps)
  - Step 1: Locate and validate task
  - Step 2: Read and validate state (including security context)
  - Step 3: Determine resume point (check Critical/High fixes before Phase 4)
  - Step 4: Validate prerequisites
  - Step 5: Apply state modifications
  - Step 6: Continue workflow

- **Use Cases** (5-6 common scenarios)
  - Computer restarted mid-fix
  - Auto-fix exhausted, manual fix applied
  - Want to re-run pen tests
  - Critical vulnerability still present (blocked Phase 4)
  - Compliance requirements changed

- **Common Scenarios** (troubleshooting)
  - Phase keeps failing
  - Want to restart a phase
  - Critical/High vulnerabilities remain (cannot proceed)
  - Compliance audit requirements unclear
  - Prerequisites missing

- **Critical Vulnerabilities Gate**
  ```
  If security_context.all_critical_high_fixed == false:
    ⚠️ Critical/High Vulnerabilities Remaining

    Cannot proceed to compliance audit until all Critical and High
    severity vulnerabilities are fixed.

    Remaining:
    - [CVE-2024-xxxx]: SQL Injection (Critical)
    - [CWE-79]: XSS in user profile (High)

    Options:
    1. Return to implementation phase to fix
    2. Review fixes and re-verify
    3. Abort workflow
  ```

- **State Reconstruction** (experimental, if state file lost)

- **Tips** (safe resume, after manual fixes, re-running phases, compliance)

- **Troubleshooting** (state file corrupted, can't determine resume point, pen tests inconsistent)

- **Related Commands** (link to new command)

- **Invoke** (call security-orchestrator skill in resume mode)

---

## CLAUDE.md Updates

### Available Skills Section

Add after `bug-fix-orchestrator` (which we'll add) and before `migration-orchestrator`:

```markdown
### security-orchestrator
Orchestrates security vulnerability fixing workflows with assessment, penetration testing, and compliance verification. Scans for OWASP Top 10 vulnerabilities, classifies by CVSS severity, plans fixes with impact analysis, conducts penetration testing, and optionally verifies compliance requirements (GDPR, HIPAA, SOC 2).

**What Makes It Different**: Severity-driven workflow (Critical/High block deployment), penetration testing validates fixes, defense-in-depth principles, optional compliance audit phase, zero tolerance for Critical/High vulnerabilities.

**Key Features**:
- **Vulnerability Scanning**: OWASP Top 10, dependency scanning, CVSS scoring
- **Severity Classification**: Critical/High/Medium/Low with exploitability assessment
- **Penetration Testing**: Automated and manual attack scenario testing
- **Compliance Verification**: GDPR, HIPAA, SOC 2, PCI-DSS (optional Phase 4)
- **Security Gates**: Cannot proceed to deployment with Critical/High vulnerabilities

**4-5 Phase Workflow**:
1. **Security Assessment & Vulnerability Analysis**: Scan, classify, score with CVSS
2. **Fix Planning & Impact Analysis**: Root cause analysis, fix strategy, impact assessment
3. **Security Fix Implementation**: Implement fixes with defense-in-depth, add security tests
4. **Security Verification & Penetration Testing**: Re-scan, pen test, verify fixes (PASS/FAIL)
5. **Compliance Audit** (Optional): Verify GDPR/HIPAA/SOC 2 compliance

**Vulnerability Types**:
- OWASP Top 10: Broken Access Control, Cryptographic Failures, Injection, Insecure Design, etc.
- Dependency vulnerabilities (npm, pip, Maven)
- XSS, CSRF, XXE, Deserialization, Path Traversal
- Authentication/Authorization flaws

**Commands**: `/ai-sdlc:security:new`, `/ai-sdlc:security:resume`

**Use Cases**:
- Security vulnerability discovered (CVE, pen test finding)
- Dependency scan shows Critical/High vulnerabilities
- Compliance audit required (GDPR, HIPAA)
- Pre-deployment security verification

**Related agents**: `security-analyzer`, `security-planner`, `security-verifier`, `compliance-auditor`

**See**: `skills/security-orchestrator/SKILL.md` for workflow phases, `references/` for OWASP Top 10, security verification, compliance requirements, CVSS scoring.
```

### Available Commands Section

Add after `/ai-sdlc:bug-fix:resume` (which we'll add):

```markdown
### /ai-sdlc:security:new
Orchestrates security vulnerability fixing workflow with assessment, penetration testing, and optional compliance verification. Scans for vulnerabilities, plans fixes, conducts pen testing, and verifies all Critical/High vulnerabilities remediated.

**Usage**: `/ai-sdlc:security:new [description] [--yolo] [--from=phase] [--compliance=FRAMEWORKS]`

**Output**: Task directory in `.ai-sdlc/tasks/security/` with assessment, fix plan, pen test results, and verification reports.

**See**: `skills/security-orchestrator/SKILL.md` for workflow phases and capabilities.

### /ai-sdlc:security:resume
Resumes interrupted security fix workflow from saved state. Validates Critical/High vulnerabilities fixed before proceeding to compliance audit. Can override resume point, reset auto-fix attempts.

**Usage**: `/ai-sdlc:security:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]`

**See**: `skills/security-orchestrator/SKILL.md` for state management and security gates.
```

### Available Subagents Section

Add after `performance-verifier`:

```markdown
### security-analyzer
Security assessment specialist that scans for vulnerabilities and classifies severity. Detects OWASP Top 10 vulnerabilities, scans dependencies for CVEs, calculates CVSS scores, identifies attack vectors. Strictly read-only.

**Workflow**: Scan dependencies → Check code patterns → Identify OWASP → Calculate CVSS → Classify types → Identify vectors → Assess exploitability → Generate report

**Tools Access**: Read, Grep, Glob, Bash (read-only), WebFetch (CVE lookups)

**Usage**: Invoked automatically by security-orchestrator during Phase 0 (Security Assessment)

**Output**: `analysis/security-assessment.md` with vulnerabilities and CVSS scores

**Philosophy**: Comprehensive assessment. Find all vulnerabilities, not just obvious ones.

### security-planner
Security fix planning specialist that analyzes root causes and creates fix plans. Plans fixes addressing root cause (not symptoms), assesses impact (breaking changes), applies defense-in-depth principles, prioritizes by severity × exploitability. Strictly read-only.

**Workflow**: Load assessment → Analyze root causes → Plan fixes → Assess impact → Evaluate defense strategies → Prioritize → Create plan

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by security-orchestrator during Phase 1 (Fix Planning)

**Output**: `implementation/security-fix-plan.md` with prioritized fixes

**Philosophy**: Fix root cause, not symptoms. Apply defense-in-depth.

### security-verifier
Security verification specialist that conducts penetration testing and verifies fixes. Re-scans for vulnerabilities, tests attack scenarios, validates security controls, generates PASS/FAIL verdict. FAIL if any Critical/High vulnerabilities remain. Strictly read-only.

**Workflow**: Re-scan → Test attacks → Validate controls → Verify fixes → Check new vulns → Pen test → Generate report

**Tools Access**: Read, Grep, Glob, Bash (read-only), WebFetch (CVE verification)

**Usage**: Invoked automatically by security-orchestrator during Phase 3 (Security Verification)

**Output**: `verification/security-verification.md` with PASS/FAIL verdict

**Philosophy**: Zero tolerance for Critical/High vulnerabilities. Verify with pen testing.

### compliance-auditor
Compliance verification specialist that validates regulatory requirements. Checks GDPR (data protection, consent), HIPAA (PHI protection, audit logs), SOC 2 (access control, monitoring), PCI-DSS (cardholder data protection). Verifies security headers, authentication, logging. Strictly read-only.

**Workflow**: Determine requirements → Check data protection → Verify auth/authz → Review logging → Check headers → Validate encryption → Generate report

**Tools Access**: Read, Grep, Glob, Bash (read-only)

**Usage**: Invoked automatically by security-orchestrator during Phase 4 (Compliance Audit, if compliance specified)

**Output**: `verification/compliance-report.md` with compliance status

**Philosophy**: Compliance is non-negotiable. Verify all requirements met.
```

---

## Implementation Order

1. **Create subagents** (4 files): security-analyzer.md → security-planner.md → security-verifier.md → compliance-auditor.md
2. **Create references** (5 files): vulnerability-types.md → security-verification.md → compliance-requirements.md → severity-classification.md → workflow-phases.md
3. **Create main skill**: SKILL.md
4. **Create commands** (2 files): new.md → resume.md
5. **Update CLAUDE.md**: Add to Available Skills, Available Commands, Available Subagents sections

---

## Key Design Decisions

**Severity-Driven Workflow**:
- Critical/High vulnerabilities block deployment
- Must fix all Critical/High before compliance audit
- Cannot skip security verification

**Defense-in-Depth**:
- Multiple layers of security controls
- Fix root cause + add additional protections
- Input validation + output encoding + CSP headers

**Penetration Testing Validates Fixes**:
- Automated pen testing after fixes
- Test attack scenarios prove vulnerability fixed
- Not just code review - actual exploitation attempts

**Compliance as Optional Phase**:
- Phase 4 only if compliance requirements specified
- Requires Phase 3 PASS (all Critical/High fixed)
- Validates specific frameworks (GDPR, HIPAA, SOC 2, PCI-DSS)

**CVSS-Based Severity**:
- Industry-standard CVSS v3.1 scoring
- Severity levels: Critical (9.0-10.0), High (7.0-8.9), Medium (4.0-6.9), Low (0.1-3.9)
- Priority = Severity × Exploitability

---

## Success Criteria

Workflow successful when:
1. ✅ All vulnerabilities identified and assessed
2. ✅ CVSS scores calculated for all vulnerabilities
3. ✅ All Critical severity vulnerabilities fixed (mandatory)
4. ✅ All High severity vulnerabilities fixed (mandatory)
5. ✅ Security fixes implemented with defense-in-depth
6. ✅ Penetration tests pass (attack scenarios fail as expected)
7. ✅ Security verification verdict = PASS
8. ✅ No new vulnerabilities introduced
9. ✅ Compliance requirements met (if Phase 4 ran)
10. ✅ Complete security documentation and advisory

Security orchestration provides complete, severity-driven, pen-test validated workflow from vulnerability discovery to production-ready secure code.
