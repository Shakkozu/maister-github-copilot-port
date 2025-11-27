# Workflow Phases Reference

Security orchestrator 4-5 phase workflow with dependencies, state transitions, and execution patterns.

## Workflow Overview

```
Phase 0: Vulnerability Analysis & Security Baseline
    ↓
Phase 1: Security Planning & Remediation Strategy
    ↓
Phase 2: Security Implementation with Testing
    ↓
Phase 3: Security Verification
    ↓
Phase 4: Compliance Audit (Optional)
```

**Total Phases**: 4-5 (0-4, Phase 4 optional)
**Execution Modes**: Interactive (pause between phases) or YOLO (continuous)
**Auto-Recovery**: Limited (Phase 0-1: max 2 attempts, Phase 2: max 3 attempts, Phase 3-4: 0 attempts)

---

## Phase 0: Vulnerability Analysis & Security Baseline

**Agent**: `security-analyzer` (read-only subagent)

**Input**: Security issue description or codebase path

**Process**:
1. Scan dependencies for vulnerabilities (npm audit, pip-audit, etc.)
2. Analyze authentication & authorization code
3. Detect injection vulnerabilities (SQL, XSS, command injection)
4. Find sensitive data exposure (hardcoded secrets, insecure logging)
5. Check security misconfigurations
6. Identify insecure dependencies
7. Detect business logic vulnerabilities
8. Score vulnerabilities using CVSS v3.1
9. Classify by OWASP Top 10 categories
10. Generate security baseline report

**Output**: `analysis/security-baseline.md` with quantitative metrics

**Success Criteria**:
- ✅ All common vulnerability types checked
- ✅ Each vulnerability has CVSS score
- ✅ Evidence provided (file paths, code snippets)
- ✅ Vulnerabilities categorized by OWASP Top 10
- ✅ Prioritized remediation plan created

**Auto-Fix**: Max 2 attempts
- Use alternative scanner if primary unavailable
- Focus on high-risk areas for large codebases

**Failure Handling**: If scans fail after 2 attempts, HALT and ask user

---

## Phase 1: Security Planning & Remediation Strategy

**Agent**: `security-planner` (read-only subagent)

**Input**: `analysis/security-baseline.md` from Phase 0

**Process**:
1. Load vulnerability findings
2. Classify fix types (dependency, code pattern, config, cryptography, auth, input validation, secrets, logging)
3. Assess impact and effort for each fix
4. Calculate priority scores (CVSS × 10 + Impact × 2 - Effort)
5. Group fixes by type and dependency
6. Break into incremental steps (max 3 files per increment)
7. Define verification steps for each fix
8. Assess breaking change risks and mitigation
9. Create comprehensive remediation plan

**Output**: `implementation/security-remediation-plan.md`

**Success Criteria**:
- ✅ All vulnerabilities included in plan
- ✅ Each fix broken into incremental steps
- ✅ Verification steps defined
- ✅ Priorities assigned using risk formula
- ✅ Dependencies documented
- ✅ Breaking changes identified with mitigation

**Auto-Fix**: Max 2 attempts
- Research OWASP remediation if approach unclear
- Use conservative estimates if effort difficult to assess

**Failure Handling**: If strategy unclear after 2 attempts, HALT and ask user

---

## Phase 2: Security Implementation with Testing

**Agent**: Main orchestrator (delegates complex fixes to `implementation-changes-planner`)

**Input**: `implementation/security-remediation-plan.md` from Phase 1

**Process**:

**For Each Fix Group** (in priority order: P0 → P1 → P2 → P3):

1. **Read Fix Details**:
   - Load fix ID, type, location, strategy, increments

2. **Security Scan Before** (baseline for this fix):
   ```bash
   # Run relevant scanner
   npm audit --audit-level=moderate > before.txt
   grep "VULN-ID" src/file.js  # Count occurrences
   ```

3. **Implement Fix**:
   - **Simple** (1-3 file changes): Main orchestrator applies directly
   - **Complex** (4+ files): Delegate planning to `implementation-changes-planner`, orchestrator applies changes

4. **Security Scan After**:
   ```bash
   # Re-run scanner
   npm audit --audit-level=moderate > after.txt
   grep "VULN-ID" src/file.js  # Verify fixed
   ```

5. **Verify Fix**:
   - Compare before/after scan results
   - Verify vulnerability eliminated
   - Document actual result

6. **Run Tests**:
   ```bash
   npm test  # or appropriate test command

   If tests fail:
     - Rollback fix using git
     - Mark as failed in plan
     - Continue to next fix
   ```

7. **Update Plan**:
   - Mark fix complete
   - Document improvement
   - Note issues encountered

**Output**:
- Fixed code files
- `implementation/security-scans/*.txt` - Before/after scan results
- `implementation/security-remediation-plan.md` - Updated with results

**Success Criteria (Per Fix)**:
- ✅ Code changes applied
- ✅ Security scan shows improvement
- ✅ Tests pass
- ✅ Results documented

**Auto-Fix**: Max 3 attempts
- Fix syntax errors, missing imports
- Retry failed scans
- Adjust fix if target not met

**Failure Handling**:
- If fix breaks tests: Rollback, mark failed, continue
- If scan shows no improvement: Document, continue
- If max attempts exceeded: HALT, user investigates

---

## Phase 3: Security Verification

**Agent**: `security-verifier` (read-only subagent)

**Input**:
- `analysis/security-baseline.md` from Phase 0
- `implementation/security-remediation-plan.md` from Phase 2

**Process**:
1. Load baseline security metrics
2. Re-run all dependency vulnerability scans
3. Re-scan code for vulnerability patterns
4. Verify each fix individually (check code, run tests)
5. Check for new vulnerabilities introduced
6. Calculate security improvement metrics:
   - Vulnerability count reduction
   - Severity-weighted risk score reduction
   - CVSS score improvement
   - Category coverage improvement
7. Generate verification report with PASS/FAIL verdict

**Output**: `verification/security-verification-report.md` with verdict

**Success Criteria**:
- ✅ All security scans re-run
- ✅ Each fix verified with evidence
- ✅ New vulnerabilities identified
- ✅ Improvement metrics calculated
- ✅ Verdict determined

**Auto-Fix**: Max 0 attempts (read-only, reports only)

**Failure Handling**: Document all findings, don't modify code

**Verdict Criteria**:
- ✅ **PASS**: All P0 (Critical/High CVSS >7.0) fixed, no critical new vulnerabilities, risk reduction >70%
- ⚠️ **PASS with Issues**: Most P0 fixed (>80%), no critical new vulnerabilities, risk reduction >50%
- ❌ **FAIL**: Critical vulnerabilities remain or critical new vulnerabilities introduced

**Cannot Proceed to Phase 4 if**: Verdict = FAIL

---

## Phase 4: Compliance Audit (Optional)

**Agent**: `compliance-auditor` (read-only subagent)

**Input**: Fixed codebase (post-Phase 3 PASS)

**Prerequisites**: Phase 3 verdict = PASS or PASS with Issues

**Process**:
1. Determine applicable compliance frameworks (GDPR, HIPAA, SOC 2, PCI DSS)
2. Audit GDPR compliance (if applicable):
   - Data privacy & consent
   - Right to access and erasure
   - Data minimization
   - Breach notification
3. Audit HIPAA compliance (if applicable):
   - Access controls
   - Audit logging
   - Transmission & encryption security
4. Audit SOC 2 compliance (if applicable):
   - Security (access, monitoring, change management)
   - Availability (backups, uptime)
   - Confidentiality, Processing Integrity, Privacy
5. Audit PCI DSS compliance (if applicable):
   - Cardholder data protection
   - Encryption requirements
   - Access logging
6. Generate compliance assessment report

**Output**: `verification/compliance-assessment-report.md`

**Success Criteria**:
- ✅ Applicable frameworks identified
- ✅ Framework controls checked
- ✅ Evidence collected
- ✅ Gaps documented with severity
- ✅ Remediation guidance provided

**Auto-Fix**: Max 0 attempts (read-only audit)

**Failure Handling**: Document gaps, provide remediation roadmap

**Compliance Status**:
- ✅ **Compliant**: 90-100% controls met
- ⚠️ **Partially Compliant**: 70-89% controls met
- ❌ **Non-Compliant**: <70% controls met

---

## Phase Dependencies

**Prerequisite Requirements**:

**Phase 1** requires:
- Phase 0 complete
- `analysis/security-baseline.md` exists

**Phase 2** requires:
- Phase 1 complete
- `implementation/security-remediation-plan.md` exists

**Phase 3** requires:
- Phase 2 complete
- At least 1 fix implemented

**Phase 4** requires:
- Phase 3 complete
- Verification verdict = PASS or PASS with Issues
- Cannot proceed if verdict = FAIL

---

## State Transitions

**Valid Transitions**:
```
-1 (Start) → 0 → 1 → 2 → 3 → 4 (Complete, if compliance audit)
                        ↓
                     HALT (if verification FAIL)
```

**Invalid Transitions**:
- ❌ Cannot skip phases (e.g., 0 → 2)
- ❌ Cannot proceed to Phase 4 if Phase 3 verdict = FAIL
- ❌ Cannot proceed if prerequisite outputs missing

---

## Execution Modes

### Interactive Mode (Default)

**Behavior**: Pause after each phase, prompt user to continue

**User Prompts**:
- After Phase 0: "Security baseline complete (X vulnerabilities found). Continue to planning?"
- After Phase 1: "Remediation plan created (X fixes). Review plan before implementing?"
- After Phase 2: "Fixes implemented. Run verification?"
- After Phase 3: "Verification complete (PASS). Run compliance audit?"

**User Actions**: Approve to continue, or stop to review

### YOLO Mode

**Behavior**: Continuous execution, no pauses

**Command**: `/ai-sdlc:security:new [description] --yolo`

**Stops Only If**:
- Phase fails after auto-fix attempts exhausted
- Phase 3 verification verdict = FAIL
- Critical error in Phase 4

---

## Error Recovery

### Phase 0-1: Limited Auto-Fix

**Max Attempts**: 2 per phase

**Strategy**:
- Try alternative scanners if primary fails
- Focus on high-risk areas for large codebases
- Prompt user if unresolved

**If Unresolved**: HALT, ask user for input

### Phase 2: Moderate Auto-Fix

**Max Attempts**: 3 per fix

**Strategy**:
- Fix syntax errors automatically
- Retry failed scans
- Rollback and try alternative approach

**If Unresolved**: Mark fix as failed, continue to next fix

### Phase 3-4: Report Only

**Max Attempts**: 0

**Strategy**:
- Report issues with evidence
- Don't modify code
- Provide recommendations

**User Action**: Review findings, decide whether to retry Phase 2

---

## Workflow Completion

### Success Path

```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ✅ (PASS) → Phase 4 ✅

Final State:
- workflow_status: completed
- overall_status: Success
- All critical vulnerabilities fixed
- Compliance gaps identified (if Phase 4 run)
- Ready for deployment
```

### Failure Paths

**Failure in Phase 3** (Verification FAIL):
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ❌ (FAIL verdict)
                                          ↓
                                    HALT (cannot proceed)

Final State:
- workflow_status: failed
- failed_phase: phase-3-verification
- Critical vulnerabilities remain or regressions
- Require additional remediation work
```

**Compliance Gaps in Phase 4**:
```
Phase 0 ✅ → Phase 1 ✅ → Phase 2 ✅ → Phase 3 ✅ → Phase 4 ⚠️ (Partial)

Final State:
- workflow_status: completed_with_gaps
- Security improved but compliance gaps exist
- Remediation roadmap provided
```

---

This workflow ensures systematic, measurable security remediation with clear quality gates and compliance assessment.
