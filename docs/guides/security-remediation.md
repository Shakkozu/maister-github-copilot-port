# Security Remediation Workflow

Guide to fixing security vulnerabilities with CVSS scoring and compliance auditing.

## Overview

Security remediation workflow identifies vulnerabilities, scores them with CVSS, prioritizes by risk, implements fixes incrementally, and optionally audits compliance (GDPR, HIPAA, SOC 2, PCI DSS).

**When to use:**
- Dependency vulnerabilities detected (npm audit, pip-audit)
- Code vulnerabilities found (SQL injection, XSS, secrets)
- Security audit required
- Need compliance assessment

## Quick Start

```bash
/ai-sdlc:security:new "Fix SQL injection vulnerabilities"
```

## Workflow Phases (4-5 Phases)

### Phase 1: Vulnerability Analysis & Security Baseline
- Scan dependencies for CVEs
- Detect code vulnerabilities (injection, XSS, secrets)
- Business logic flaws
- CVSS v3.1 scoring
- OWASP Top 10 classification

### Phase 2: Security Planning & Remediation Strategy
- Classify fix types
- Prioritize by risk: `Priority = CVSS × 10 + Impact × 2 - Effort`
- Create incremental fix plan
- Define verification steps

### Phase 3: Security Implementation
- Fix incrementally (one at a time)
- Run security scan after each fix
- Verify vulnerability eliminated

### Phase 4: Security Verification
- Re-run all scans
- Compare before/after
- Calculate risk reduction
- Generate verification report

### Phase 5 (Optional): Compliance Audit
- Audit GDPR, HIPAA, SOC 2, PCI DSS
- Identify compliance gaps
- Generate remediation roadmap

## CVSS Scoring

```
Critical (9.0-10.0): Fix immediately
High (7.0-8.9): Fix within 7 days
Medium (4.0-6.9): Fix within 30 days
Low (0.1-3.9): Fix when convenient
```

## Fix Types

- **Dependency Updates**: Upgrade packages with CVEs
- **Code Patterns**: SQL injection → parameterized queries, XSS → output escaping
- **Configuration**: Add security headers, fix CORS, disable debug
- **Cryptography**: MD5/SHA1 → bcrypt/Argon2
- **Authentication**: Add MFA, rate limiting
- **Secrets**: Hardcoded → environment variables

## Best Practices

1. **Prioritize by Risk**: Fix highest CVSS scores first
2. **Scan After Each Fix**: Verify vulnerability eliminated
3. **Don't Introduce Regressions**: Run full test suite
4. **Document Remediation**: Record what was fixed and why
5. **Consider Compliance**: Audit regulatory requirements

## Related Resources

- [Command Reference](../../commands/security/new.md)
- [Skill Documentation](../../skills/security-orchestrator/SKILL.md)
- [Security Analyzer Agent](../../agents/security-analyzer.md)

**Next Steps**: `/ai-sdlc:security:new [description]`
