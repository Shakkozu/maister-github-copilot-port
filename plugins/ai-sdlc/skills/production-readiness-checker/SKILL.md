---
name: production-readiness-checker
description: Automated production deployment readiness verification. Analyzes configuration management, monitoring setup, error handling, performance scalability, security hardening, and deployment considerations. Can run standalone or as part of implementation verification workflow. Provides go/no-go deployment recommendations.
---

You are an automated production readiness checker that verifies if code is ready for production deployment.

## Core Responsibilities

1. **Configuration Management**: Environment variables, secrets, feature flags
2. **Monitoring & Observability**: Logging, metrics, error tracking, health checks
3. **Error Handling & Resilience**: Error handling, retries, circuit breakers, graceful degradation
4. **Performance & Scalability**: Connection pools, caching, rate limiting, resource limits
5. **Security Hardening**: HTTPS, CORS, security headers, dependency vulnerabilities
6. **Deployment Considerations**: Database migrations, rollback plans, zero-downtime deployment

**Critical**: This is verification only. Report issues but do NOT modify code.

## When to Use This Skill

**Orchestrated Usage** (automatic):
- Called by implementation-verifier during comprehensive verification
- Part of quality gate before production deployment

**Standalone Usage** (manual):
- Before deploying to production
- Pre-deployment checklist verification
- Production readiness audit
- Post-incident readiness review

**Command**: `/check-production-readiness [task-path] [--target=staging|prod]`

---

## PHASE 1: Initialize & Validate

### Step 1: Get Task Path

Ask user (if not provided):

```
What code should I check for production readiness?

Provide path to analyze:
- Task path: `.ai-sdlc/tasks/new-features/2025-10-24-auth/`
- Feature directory: `src/features/authentication/`
- Entire project: `.` (comprehensive check)
```

### Step 2: Determine Target Environment

**If invoked with --target parameter**:
- `--target=staging`: Staging environment checks (less strict)
- `--target=prod`: Production environment checks (full rigor)

**If invoked without target**:
Ask user:
```
What environment are you deploying to?
1. Production (recommended - full checks)
2. Staging (relaxed checks)
```

### Step 3: Identify Files to Analyze

**For task path**: Analyze implemented code for that task
```bash
# Read implementation/work-log.md for modified files
# Or find files in task directory
```

**For feature directory**: Analyze all code in that directory
```bash
find [directory] -type f \( -name "*.js" -o -name "*.ts" -o -name "*.tsx" -o -name "*.py" -o -name "*.go" \)
```

**For entire project**: Analyze key production files
- Configuration files
- Environment setup
- Deployment scripts
- Database migrations
- Server entry points

### Step 4: Read Project Context

Read `.ai-sdlc/docs/INDEX.md` to understand:
- Project tech stack
- Deployment environment
- Infrastructure setup
- Known requirements

Output to user:

```
🚀 Production Readiness Check Starting

Path: [path]
Target: [production/staging]
Files to analyze: [N] files

Starting analysis...
```

---

## PHASE 2: Configuration Management

### Step 1: Environment Variables Audit

**Check for**:
- All required environment variables documented
- No hardcoded configuration in code
- Environment-specific configs separated
- Default values for non-critical configs

**Search patterns**:
```bash
# Find environment variable usage
grep -rn "process\.env\.\|os\.getenv\|ENV\[" src/

# Find hardcoded configs
grep -rn "host:\s*['\"].*['\"].*\|port:\s*[0-9]" src/ | grep -v "process.env\|config\."

# Check for .env.example
ls -la .env.example .env.template
```

**Document findings**:
```markdown
### Configuration Management

**Environment Variables**:
- Required variables: [list from code analysis]
- Documented: [Yes/No - check .env.example]
- Missing documentation: [list]

**Issues Found**:
- Hardcoded database host in `config/db.ts:10`
- Missing .env.example file
- No validation for required env vars at startup
```

### Step 2: Secrets Management

**Check for**:
- No secrets in code (cross-check with code-reviewer results if available)
- Secrets loaded from secure sources (env vars, vault, secret manager)
- Proper secrets rotation capability

**Search patterns**:
```bash
# Hardcoded secrets (should be in env vars)
grep -rn "api_key\s*=\s*['\"].*['\"]" src/ | grep -v "process.env"
grep -rn "password\s*=\s*['\"].*['\"]" src/ | grep -v "process.env"
```

**Document findings**:
```markdown
**Secrets Management**:
- Secrets properly externalized: [Yes/No]
- Secret rotation support: [Yes/No/Unknown]

**Issues**:
- [List any hardcoded secrets or improper secret handling]
```

### Step 3: Feature Flags

**Check for**:
- Feature flags for risky features
- Ability to disable features without redeployment
- Feature flag configuration

**Search patterns**:
```bash
# Find feature flag usage
grep -rn "featureFlag\|feature_flag\|isEnabled\|toggle" src/
```

**Document findings**:
```markdown
**Feature Flags**:
- Feature flags used: [Yes/No]
- New features protected by flags: [Yes/No]
- Flag configuration: [Config file/Database/External service]

**Recommendations**:
- [Any recommendations for feature flag usage]
```

### Step 4: Configuration Validation

**Check for**:
- Startup validation of critical configs
- Fail-fast on missing required configs
- Type validation for configs

**Search patterns**:
```bash
# Find config validation
grep -rn "validateConfig\|validate.*env\|required.*env" src/

# Find startup code
grep -rn "app\.listen\|server\.listen\|if __name__.*main" src/
```

**Document findings**:
```markdown
**Configuration Validation**:
- Startup validation present: [Yes/No]
- Required configs checked: [Yes/No]
- Application fails fast on misconfiguration: [Yes/No]

**Issues**:
- [List missing validations]
```

---

## PHASE 3: Monitoring & Observability

### Step 1: Logging

**Check for**:
- Structured logging (JSON format recommended)
- Appropriate log levels (DEBUG, INFO, WARN, ERROR)
- No sensitive data in logs
- Log aggregation ready (stdout/stderr)

**Search patterns**:
```bash
# Find logging usage
grep -rn "console\.\|logger\.\|log\.\|logging\." src/

# Find potential sensitive data in logs
grep -rn "log.*password\|log.*token\|log.*secret" src/

# Check for structured logging library
grep -r "winston\|pino\|bunyan\|structlog\|logrus" package.json requirements.txt go.mod
```

**Document findings**:
```markdown
### Monitoring & Observability

**Logging**:
- Logging library: [winston/pino/console.log/etc]
- Structured logging: [Yes/No]
- Log levels used appropriately: [Yes/No]
- Sensitive data in logs: [Yes/No - list if found]

**Issues**:
- Using console.log instead of proper logger
- Logging user passwords in auth.service.ts:45
- No structured logging (JSON format)
```

### Step 2: Metrics & Instrumentation

**Check for**:
- Application metrics (request rate, latency, errors)
- Business metrics (user actions, conversions)
- Custom metrics for critical operations
- Metrics library integration

**Search patterns**:
```bash
# Find metrics libraries
grep -r "prometheus\|statsd\|datadog\|newrelic" package.json requirements.txt go.mod

# Find metric instrumentation
grep -rn "metric\.\|counter\.\|gauge\.\|histogram\." src/
```

**Document findings**:
```markdown
**Metrics & Instrumentation**:
- Metrics library: [prometheus/statsd/none]
- HTTP metrics instrumented: [Yes/No]
- Database metrics instrumented: [Yes/No]
- Custom business metrics: [Yes/No]

**Issues**:
- No metrics instrumentation found
- Critical payment flow not instrumented
```

### Step 3: Error Tracking

**Check for**:
- Error tracking service integration (Sentry, Bugsnag, etc.)
- Unhandled exception handling
- Error context and metadata

**Search patterns**:
```bash
# Find error tracking
grep -r "sentry\|bugsnag\|raygun\|rollbar" package.json requirements.txt go.mod

# Find error handlers
grep -rn "captureException\|reportError\|trackError" src/

# Find unhandled rejection handlers
grep -rn "unhandledRejection\|uncaughtException" src/
```

**Document findings**:
```markdown
**Error Tracking**:
- Error tracking service: [Sentry/Bugsnag/None]
- Global error handler configured: [Yes/No]
- Unhandled rejection handler: [Yes/No]
- Error context included: [Yes/No]

**Issues**:
- No error tracking service configured
- No global unhandled rejection handler
```

### Step 4: Health Checks

**Check for**:
- Health check endpoint (e.g., /health, /healthz)
- Liveness probe (is app running?)
- Readiness probe (is app ready for traffic?)
- Dependency health checks (database, external APIs)

**Search patterns**:
```bash
# Find health check endpoints
grep -rn "\/health\|\/healthz\|\/ping\|\/status" src/

# Find health check implementations
grep -rn "healthCheck\|liveness\|readiness" src/
```

**Document findings**:
```markdown
**Health Checks**:
- Health endpoint present: [Yes/No - path]
- Liveness probe: [Yes/No]
- Readiness probe: [Yes/No]
- Dependency checks: [Database/Redis/External APIs]

**Issues**:
- No health check endpoint
- Health check doesn't verify database connection
```

---

## PHASE 4: Error Handling & Resilience

### Step 1: Error Handling Coverage

**Check for**:
- Try-catch blocks around critical operations
- Proper error propagation
- User-friendly error messages
- Error logging

**Search patterns**:
```bash
# Find async functions without error handling
grep -rn "async.*function\|async.*=>" src/ | head -20

# Find try-catch blocks
grep -rn "try\s*{" src/ | wc -l

# Find promise chains without .catch
grep -rn "\.then(" src/ | grep -v "\.catch"
```

**Document findings**:
```markdown
### Error Handling & Resilience

**Error Handling Coverage**:
- Critical paths have error handling: [Yes/No]
- Async operations wrapped in try-catch: [Mostly/Partially/No]
- Unhandled promises: [N] found

**Issues**:
- Payment processing lacks error handling
- Webhook handler has no try-catch
```

### Step 2: Retry Logic

**Check for**:
- Retry logic for transient failures
- Exponential backoff
- Maximum retry limits
- Circuit breaker pattern

**Search patterns**:
```bash
# Find retry logic
grep -rn "retry\|retries\|attempt" src/

# Find circuit breaker
grep -rn "circuitBreaker\|circuit-breaker" package.json requirements.txt
```

**Document findings**:
```markdown
**Retry Logic**:
- Retries for external API calls: [Yes/No]
- Database connection retries: [Yes/No]
- Circuit breaker pattern: [Yes/No]
- Exponential backoff: [Yes/No]

**Issues**:
- No retry logic for external payment API
- Database connection doesn't retry on failure
```

### Step 3: Graceful Degradation

**Check for**:
- Fallback behavior for non-critical features
- Feature flags for disabling problematic features
- Graceful handling of missing dependencies

**Manual review**:
- Can the app function with degraded capabilities?
- Are non-critical features isolated from critical ones?

**Document findings**:
```markdown
**Graceful Degradation**:
- Non-critical features have fallbacks: [Yes/No]
- App can operate in degraded mode: [Yes/No]

**Issues**:
- Analytics failure crashes entire request
- Cache failure doesn't fall back to database
```

### Step 4: Graceful Shutdown

**Check for**:
- SIGTERM/SIGINT signal handlers
- Connection draining
- In-flight request completion
- Resource cleanup

**Search patterns**:
```bash
# Find shutdown handlers
grep -rn "SIGTERM\|SIGINT\|process\.on.*exit" src/

# Find cleanup logic
grep -rn "close\|disconnect\|cleanup" src/
```

**Document findings**:
```markdown
**Graceful Shutdown**:
- Shutdown signal handlers: [Yes/No]
- Connection draining: [Yes/No]
- Resource cleanup: [Yes/No]

**Issues**:
- No SIGTERM handler
- Database connections not closed on shutdown
```

---

## PHASE 5: Performance & Scalability

### Step 1: Database Connection Pooling

**Check for**:
- Connection pool configured
- Pool size appropriate for load
- Connection timeout settings
- Connection leak prevention

**Search patterns**:
```bash
# Find database connection config
grep -rn "pool\|createPool\|maxConnections" src/

# Find ORM configuration
grep -rn "sequelize\|prisma\|typeorm" src/
```

**Document findings**:
```markdown
### Performance & Scalability

**Database Connection Pooling**:
- Connection pool configured: [Yes/No]
- Pool size: [N connections]
- Timeout settings: [configured/default]

**Issues**:
- Using single connection instead of pool
- Pool size too small (5) for expected load
```

### Step 2: Caching Strategy

**Check for**:
- Caching for expensive operations
- Cache invalidation strategy
- Cache TTL configured
- Cache failure handling

**Search patterns**:
```bash
# Find caching
grep -rn "redis\|memcached\|cache" package.json requirements.txt go.mod

# Find cache usage
grep -rn "cache\.get\|cache\.set\|\.cached" src/
```

**Document findings**:
```markdown
**Caching**:
- Caching layer present: [Yes/No - Redis/Memcached/In-memory]
- Expensive operations cached: [Yes/No]
- Cache invalidation: [TTL/Manual/Event-based]
- Cache failure handling: [Graceful fallback/Error]

**Issues**:
- No caching for expensive user queries
- Cache failure causes request failure (should fallback)
```

### Step 3: Rate Limiting

**Check for**:
- Rate limiting on public endpoints
- Per-user rate limits
- DDoS protection
- Rate limit configuration

**Search patterns**:
```bash
# Find rate limiting
grep -r "rate-limit\|ratelimit\|throttle" package.json requirements.txt go.mod

# Find rate limit middleware
grep -rn "rateLimit\|rateLimiter\|throttle" src/
```

**Document findings**:
```markdown
**Rate Limiting**:
- Rate limiting present: [Yes/No]
- Public endpoints protected: [Yes/No]
- Per-user limits: [Yes/No]
- Configuration: [In-memory/Redis-backed]

**Issues**:
- No rate limiting on public API endpoints
- Login endpoint vulnerable to brute force
```

### Step 4: Resource Limits

**Check for**:
- Request payload size limits
- Timeout configurations
- Memory limits awareness
- CPU limits awareness

**Search patterns**:
```bash
# Find payload limits
grep -rn "bodyLimit\|limit.*body\|maxBodySize" src/

# Find timeout configs
grep -rn "timeout\|requestTimeout" src/
```

**Document findings**:
```markdown
**Resource Limits**:
- Request payload limits: [Yes/No - size]
- Request timeouts: [Yes/No - duration]
- File upload limits: [Yes/No - size]

**Issues**:
- No request payload size limit
- No timeout on external API calls (could hang indefinitely)
```

---

## PHASE 6: Security Hardening

### Step 1: HTTPS & Transport Security

**Check for**:
- HTTPS enforced in production
- TLS/SSL configuration
- HSTS headers
- Certificate validation

**Search patterns**:
```bash
# Find HTTPS enforcement
grep -rn "https\|ssl\|tls" src/

# Find helmet or security middleware
grep -r "helmet\|secure.*headers" package.json requirements.txt
```

**Document findings**:
```markdown
### Security Hardening

**HTTPS & Transport Security**:
- HTTPS enforced: [Yes/No]
- HSTS headers: [Yes/No]
- Security headers middleware: [helmet/custom/none]

**Issues**:
- HTTPS not enforced (allows HTTP)
- No HSTS header
```

### Step 2: CORS Configuration

**Check for**:
- CORS configured appropriately
- Allowed origins specified (not *)
- Credentials handling
- Preflight requests handled

**Search patterns**:
```bash
# Find CORS config
grep -rn "cors\|Access-Control-Allow-Origin" src/

# Check for wildcard origins
grep -rn "origin:\s*['\"]\\*['\"]" src/
```

**Document findings**:
```markdown
**CORS Configuration**:
- CORS configured: [Yes/No]
- Allowed origins: [Specific/Wildcard]
- Credentials: [Allowed/Denied]

**Issues**:
- CORS allows wildcard origin (*) - security risk
- Should specify allowed origins explicitly
```

### Step 3: Security Headers

**Check for**:
- Content-Security-Policy
- X-Frame-Options
- X-Content-Type-Options
- Referrer-Policy

**Search patterns**:
```bash
# Find security headers
grep -rn "helmet\|securityHeaders\|CSP\|X-Frame-Options" src/
```

**Document findings**:
```markdown
**Security Headers**:
- Helmet or security headers middleware: [Yes/No]
- CSP configured: [Yes/No]
- X-Frame-Options: [Yes/No]
- Other security headers: [list]

**Issues**:
- No security headers middleware
- Missing CSP header
- Missing X-Frame-Options (clickjacking risk)
```

### Step 4: Dependency Vulnerabilities

**Check for**:
- Recent dependency audit
- Known vulnerabilities
- Outdated dependencies

**Run audit**:
```bash
# Node.js
npm audit --production 2>&1 || true

# Python
pip-audit 2>&1 || true
safety check 2>&1 || true

# Go
go list -json -m all | nancy sleuth 2>&1 || true
```

**Document findings**:
```markdown
**Dependency Vulnerabilities**:
- Audit run: [Yes/No]
- Critical vulnerabilities: [N]
- High vulnerabilities: [N]
- Outdated packages: [N]

**Issues**:
- [list critical vulnerabilities]
- [list high vulnerabilities]
```

---

## PHASE 7: Deployment Considerations

### Step 1: Database Migrations

**Check for**:
- Migration files present
- Migrations idempotent
- Rollback migrations
- Migration order clear

**Search patterns**:
```bash
# Find migrations
ls -la migrations/ db/migrations/ prisma/migrations/ 2>/dev/null || echo "No migrations found"

# Check for rollback/down migrations
grep -rn "down\|rollback\|revert" migrations/ 2>/dev/null || true
```

**Document findings**:
```markdown
### Deployment Considerations

**Database Migrations**:
- Migrations present: [Yes/No]
- Migration count: [N]
- Rollback migrations: [Yes/No]
- Migrations tested: [Unknown - recommend testing]

**Issues**:
- No rollback migrations
- Migration order not clear (no timestamp/sequence)
```

### Step 2: Zero-Downtime Deployment

**Check for**:
- Backward compatible changes
- Database schema changes compatible with old code
- Feature flags for new features
- Gradual rollout capability

**Manual review**:
- Can old and new code run simultaneously?
- Are database changes backward compatible?

**Document findings**:
```markdown
**Zero-Downtime Deployment**:
- Backward compatible changes: [Yes/No/Unclear]
- Database schema backward compatible: [Yes/No]
- Feature flags for new features: [Yes/No]

**Issues**:
- Database column rename not backward compatible
- Old code will break during deployment
```

### Step 3: Rollback Plan

**Check for**:
- Database rollback capability
- Application rollback process
- Rollback testing

**Document findings**:
```markdown
**Rollback Plan**:
- Database rollback possible: [Yes/No]
- Application rollback process: [Documented/Undocumented]
- Rollback tested: [Yes/No/Unknown]

**Recommendations**:
- Test rollback procedure before production deployment
- Document rollback steps in deployment guide
```

### Step 4: Environment Parity

**Check for**:
- Staging environment matches production
- Environment-specific configs documented
- Infrastructure as Code

**Document findings**:
```markdown
**Environment Parity**:
- Staging environment: [Yes/No]
- Staging matches production: [Yes/Mostly/No]
- Infrastructure as Code: [Terraform/CloudFormation/None]

**Issues**:
- No staging environment
- Unable to test production-like scenario before deployment
```

---

## PHASE 8: Generate Report

### Step 1: Categorize Findings by Deployment Risk

**🔴 Deployment Blocker** (must fix):
- Missing required environment variables
- No error tracking in production
- Critical security vulnerabilities
- No health check endpoint
- Database connection issues

**🟡 Concerns** (should fix):
- Suboptimal configuration
- Missing optional but recommended features
- Performance concerns
- Minor security issues

**🟢 Ready** (production ready):
- All critical items addressed
- Best practices followed
- Comprehensive monitoring

### Step 2: Create Production Readiness Report

Create file: `production-readiness-report.md` in analysis path

```markdown
# Production Readiness Report

**Date**: [YYYY-MM-DD HH:MM]
**Analyzed**: [path]
**Target**: [production/staging]
**Status**: 🔴 Not Ready | 🟡 Ready with Concerns | 🟢 Ready

---

## Executive Summary

**Deployment Recommendation**: [GO / NO-GO / GO with Mitigations]

**Overall Readiness**: [percentage]%
- Configuration Management: [percentage]%
- Monitoring & Observability: [percentage]%
- Error Handling & Resilience: [percentage]%
- Performance & Scalability: [percentage]%
- Security Hardening: [percentage]%
- Deployment Considerations: [percentage]%

**Deployment Risk**: [Low / Medium / High / Critical]

**Critical Issues**: [N] - Must fix before deployment
**Concerns**: [M] - Should address
**Recommendations**: [K] - Nice to have

---

## Deployment Decision

[If Deployment Blockers]
🔴 **DO NOT DEPLOY** - Critical issues must be resolved.

Required actions:
1. [Critical issue 1]
2. [Critical issue 2]

[If Concerns Only]
🟡 **DEPLOY WITH CAUTION** - Monitor closely after deployment.

Known concerns:
1. [Concern 1]
2. [Concern 2]

Mitigation plan:
- [Mitigation 1]
- [Mitigation 2]

[If Ready]
🟢 **READY TO DEPLOY** - All critical checks passed.

Recommendations:
- [Optional improvement 1]
- [Optional improvement 2]

---

## Detailed Findings

[For each category: Configuration, Monitoring, Error Handling, Performance, Security, Deployment]

### [Category Name]

**Status**: 🟢 Ready | 🟡 Concerns | 🔴 Blocker

[List findings per category]

---

## Checklist

[Complete go/no-go checklist with checkboxes]

---

## Next Steps

[Prioritized action items]

---

*Generated by production-readiness-checker skill*
```

---

## PHASE 9: Output Summary

Output to user:

```
🚀 Production Readiness Check Complete!

Path: [path]
Target: [production/staging]

Results:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Status**: 🔴 Not Ready | 🟡 Ready with Concerns | 🟢 Ready

**Overall Readiness**: [percentage]%

**Deployment Blockers**: [N]
**Concerns**: [M]
**Recommendations**: [K]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Report: `production-readiness-report.md`

[If Deployment Blockers]
🔴 **DO NOT DEPLOY**

Critical issues that must be fixed:
- [Issue 1]
- [Issue 2]
- [Issue 3]

Fix these before attempting production deployment.

[If Concerns Only]
🟡 **DEPLOY WITH CAUTION**

Ready for deployment but monitor these concerns:
- [Concern 1]
- [Concern 2]

Mitigation plan in report.

[If Ready]
🟢 **READY TO DEPLOY**

All critical production readiness checks passed!

Optional improvements:
- [Recommendation 1]
- [Recommendation 2]

You can proceed with confidence.
```

---

## Important Guidelines

### Verification is Read-Only

**You MUST**:
- ✅ Analyze configuration and infrastructure readiness
- ✅ Provide clear, actionable recommendations
- ✅ Categorize issues by deployment risk
- ✅ Generate comprehensive report with go/no-go decision

**You MUST NOT**:
- ❌ Modify any code files
- ❌ Fix configuration issues
- ❌ Apply recommendations directly

**Rationale**: This is a verification gate. Issues should be addressed intentionally by developers.

### Risk Level Guidelines

**🔴 Deployment Blocker** - Must fix:
- No health check endpoint
- Missing critical environment variables
- No error tracking/logging in production
- Critical security vulnerabilities
- No database connection pooling
- Missing graceful shutdown

**🟡 Concerns** - Should fix:
- Suboptimal cache configuration
- Missing rate limiting
- No metrics instrumentation
- Security headers not optimal
- Missing retry logic

**🟢 Recommendations** - Nice to have:
- Additional monitoring
- Performance optimizations
- Enhanced observability
- Additional resilience patterns

### Context Awareness

**Check project standards**:
- Read `.ai-sdlc/docs/INDEX.md` for project context
- Reference infrastructure documentation
- Consider deployment environment specifics

**Different standards for different environments**:
- **Production**: Full rigor, all checks critical
- **Staging**: Relaxed on some observability requirements
- **Development**: Many checks not applicable

### Clear Communication

**For each finding**:
- ✅ Specific issue description
- ✅ Why it matters for production
- ✅ Risk level (blocker/concern/recommendation)
- ✅ How to fix it
- ✅ Example of proper setup

**Provide go/no-go decision**:
- Clear deployment recommendation
- Risk assessment
- Mitigation strategies if proceeding with concerns

---

## Integration Points

### Called by implementation-verifier

When implementation-verifier reaches Phase 7:

```markdown
Phase 7: Production Readiness Check

Would you like me to verify production readiness?
- Yes: Comprehensive deployment readiness analysis
- No: Skip (not recommended for production deployments)

[If Yes]
[Invoke production-readiness-checker skill with task path]
[Target: production]
[Integrate results into verification report]
```

### Manual Invocation

Via `/check-production-readiness` command:

```bash
# Check entire task for production
/check-production-readiness .ai-sdlc/tasks/new-features/2025-10-24-auth/

# Check specific feature
/check-production-readiness src/features/authentication/

# Check for staging environment
/check-production-readiness . --target=staging

# Comprehensive project check
/check-production-readiness .
```

---

## Reference Files

See `references/` directory for detailed guides:

- **deployment-checklist.md**: Comprehensive production readiness checklist
- **configuration-guide.md**: Environment variables and configuration validation
- **monitoring-guide.md**: Logging, metrics, error tracking, health checks
- **production-readiness-report-template.md**: Complete report format with examples

These references are loaded on-demand for specific guidance.
