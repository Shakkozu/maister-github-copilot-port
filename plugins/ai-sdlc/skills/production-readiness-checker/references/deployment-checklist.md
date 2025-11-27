# Production Deployment Readiness Checklist

Comprehensive checklist for verifying production deployment readiness.

---

## Configuration Management

### Environment Variables
- [ ] All required environment variables documented (README or .env.example)
- [ ] No hardcoded configuration values in source code
- [ ] Environment-specific configs separated (dev/staging/prod)
- [ ] Startup validation for required environment variables
- [ ] Sensitive values loaded from secure sources (env vars, secrets manager)

### Secrets Management
- [ ] No hardcoded secrets in code or version control
- [ ] Secrets loaded from environment variables or vault
- [ ] Database credentials externalized
- [ ] API keys externalized
- [ ] JWT/session secrets externalized and strong
- [ ] Secrets rotation capability exists

### Feature Flags
- [ ] Risky features protected by feature flags
- [ ] Ability to disable features without redeployment
- [ ] Feature flag configuration documented

---

## Monitoring & Observability

### Logging
- [ ] Structured logging library configured (not console.log)
- [ ] Appropriate log levels used (DEBUG, INFO, WARN, ERROR)
- [ ] No sensitive data logged (passwords, tokens, PII)
- [ ] Logs output to stdout/stderr for aggregation
- [ ] Request/response logging for debugging
- [ ] Error logging with stack traces and context

### Metrics & Instrumentation
- [ ] Metrics library integrated (Prometheus, StatsD, etc.)
- [ ] HTTP request metrics (rate, latency, status codes)
- [ ] Database query metrics
- [ ] External API call metrics
- [ ] Business metrics for critical operations
- [ ] Custom metrics for performance-critical code

### Error Tracking
- [ ] Error tracking service configured (Sentry, Bugsnag, etc.)
- [ ] Unhandled exception handler configured
- [ ] Unhandled promise rejection handler configured
- [ ] Error context includes relevant debugging info
- [ ] Critical errors trigger alerts

### Health Checks
- [ ] Health check endpoint exists (/health, /healthz)
- [ ] Liveness probe (is app alive?)
- [ ] Readiness probe (is app ready for traffic?)
- [ ] Database connection health check
- [ ] External dependency health checks
- [ ] Health check doesn't expose sensitive info

---

## Error Handling & Resilience

### Error Handling
- [ ] Try-catch blocks around all async operations
- [ ] Database operations have error handling
- [ ] External API calls have error handling
- [ ] Error messages are user-friendly
- [ ] Errors are logged with context
- [ ] Critical errors trigger alerts

### Retry Logic
- [ ] External API calls have retry logic
- [ ] Database connection retries on transient failures
- [ ] Exponential backoff for retries
- [ ] Maximum retry limit configured
- [ ] Idempotent operations for safe retries

### Circuit Breaker
- [ ] Circuit breaker for critical external dependencies
- [ ] Timeout thresholds configured
- [ ] Failure thresholds configured
- [ ] Circuit breaker state monitoring

### Graceful Degradation
- [ ] Non-critical features can be disabled
- [ ] Feature flags for graceful degradation
- [ ] Cache failures fallback to database
- [ ] External service failures have fallbacks

### Graceful Shutdown
- [ ] SIGTERM signal handler implemented
- [ ] SIGINT signal handler implemented
- [ ] In-flight requests allowed to complete
- [ ] Database connections closed on shutdown
- [ ] External connections closed properly
- [ ] Cleanup logic for temp files/resources

---

## Performance & Scalability

### Database
- [ ] Connection pool configured (not single connection)
- [ ] Pool size appropriate for expected load
- [ ] Connection timeout configured
- [ ] Query timeout configured
- [ ] Database indexes on foreign keys
- [ ] Database indexes on frequently queried columns
- [ ] No N+1 query problems

### Caching
- [ ] Caching layer configured (Redis, Memcached, etc.)
- [ ] Expensive operations cached
- [ ] Cache TTL configured appropriately
- [ ] Cache invalidation strategy defined
- [ ] Cache failures handled gracefully (fallback)
- [ ] Cache key naming convention documented

### Rate Limiting
- [ ] Rate limiting configured for public endpoints
- [ ] Login endpoint rate limited (prevent brute force)
- [ ] API endpoints rate limited
- [ ] Per-user rate limits configured
- [ ] Rate limit storage (Redis recommended for multi-instance)

### Resource Limits
- [ ] Request payload size limit configured
- [ ] File upload size limit configured
- [ ] Request timeout configured
- [ ] External API call timeouts configured
- [ ] Memory limits awareness (container/process)
- [ ] CPU limits awareness

### Scalability
- [ ] Application is stateless (can scale horizontally)
- [ ] Session storage externalized (Redis, database)
- [ ] File uploads go to object storage (not local disk)
- [ ] Background jobs use queue (not in-process)
- [ ] Database read replicas for heavy read workloads (if needed)

---

## Security Hardening

### Transport Security
- [ ] HTTPS enforced (redirect HTTP to HTTPS)
- [ ] TLS 1.2+ required (no TLS 1.0/1.1)
- [ ] HSTS header configured
- [ ] Valid SSL/TLS certificate
- [ ] Certificate expiration monitoring

### CORS
- [ ] CORS configured (not disabled)
- [ ] Allowed origins explicitly specified (not *)
- [ ] Credentials handling configured properly
- [ ] Preflight requests handled

### Security Headers
- [ ] Helmet or equivalent security middleware configured
- [ ] Content-Security-Policy header
- [ ] X-Frame-Options header (prevent clickjacking)
- [ ] X-Content-Type-Options header
- [ ] X-XSS-Protection header (for older browsers)
- [ ] Referrer-Policy header

### Input Validation
- [ ] All user input validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (escaped output)
- [ ] Path traversal prevention
- [ ] File upload validation (type, size)

### Authentication & Authorization
- [ ] Authentication required on protected endpoints
- [ ] Authorization checks before sensitive operations
- [ ] Password hashing (bcrypt, argon2)
- [ ] Session security (httpOnly, secure, sameSite)
- [ ] JWT tokens signed and validated
- [ ] Rate limiting on auth endpoints

### Dependency Security
- [ ] npm audit / pip-audit / go audit run
- [ ] No critical vulnerabilities
- [ ] High vulnerabilities reviewed and mitigated
- [ ] Dependencies reasonably up-to-date
- [ ] Automated dependency scanning in CI/CD

---

## Deployment Considerations

### Database Migrations
- [ ] Database migrations exist for schema changes
- [ ] Migrations are idempotent (can run multiple times)
- [ ] Rollback/down migrations exist
- [ ] Migrations tested in staging
- [ ] Migration order clear (timestamp/sequence)
- [ ] Data migrations separate from schema migrations

### Zero-Downtime Deployment
- [ ] Code changes backward compatible with old version
- [ ] Database schema changes backward compatible
- [ ] Feature flags protect breaking changes
- [ ] Gradual rollout capability (canary/blue-green)
- [ ] Old and new versions can coexist briefly

### Rollback Plan
- [ ] Application rollback process documented
- [ ] Database rollback procedure documented
- [ ] Rollback tested in staging
- [ ] Data loss prevention during rollback
- [ ] Rollback decision criteria defined

### Environment Parity
- [ ] Staging environment exists
- [ ] Staging mirrors production closely
- [ ] Changes tested in staging before production
- [ ] Infrastructure as Code (Terraform, CloudFormation)
- [ ] Environment-specific differences documented

### Deployment Process
- [ ] Deployment runbook/process documented
- [ ] Automated deployment pipeline
- [ ] Deployment verification steps defined
- [ ] Smoke tests run post-deployment
- [ ] Deployment notifications configured (Slack, email)

### Backup & Recovery
- [ ] Database backups configured
- [ ] Backup retention policy defined
- [ ] Backup restoration tested
- [ ] Point-in-time recovery possible
- [ ] Disaster recovery plan documented

---

## Go/No-Go Criteria

### Required (Deployment Blockers)

Must have all of these to deploy:

- [ ] **Health check endpoint** - Required for load balancer/orchestrator
- [ ] **Error tracking** - Required to detect production issues
- [ ] **Structured logging** - Required for debugging
- [ ] **Environment variables externalized** - Required for configuration management
- [ ] **No hardcoded secrets** - Critical security issue
- [ ] **Database connection pooling** - Required for scalability
- [ ] **Graceful shutdown** - Required for zero-downtime deployments
- [ ] **HTTPS enforced** - Required for security
- [ ] **No critical security vulnerabilities** - Blockers per npm audit / pip-audit

### Strongly Recommended (Concerns if Missing)

Should have these, but can deploy with mitigation plan:

- [ ] **Metrics instrumentation** - Hard to diagnose production issues without
- [ ] **Rate limiting** - Vulnerable to abuse/DDoS
- [ ] **Retry logic for external APIs** - Transient failures cause user-facing errors
- [ ] **Circuit breaker for critical dependencies** - Failures cascade
- [ ] **Security headers** - Missing security hardening
- [ ] **Request timeouts** - Hanging requests can exhaust resources
- [ ] **Staging environment testing** - Increased deployment risk

### Nice to Have (Recommendations)

Improve these over time:

- [ ] **Caching for expensive operations** - Performance optimization
- [ ] **Automated dependency scanning** - Proactive security
- [ ] **Business metrics** - Product insights
- [ ] **Canary/blue-green deployment** - Safer rollouts
- [ ] **Disaster recovery plan** - Business continuity

---

## Deployment Risk Assessment

Use this rubric to assess deployment risk:

### 🟢 Low Risk (Ready to Deploy)
- All required criteria met
- All strongly recommended criteria met
- Comprehensive monitoring and observability
- Well-tested in staging
- Rollback plan ready

### 🟡 Medium Risk (Deploy with Caution)
- All required criteria met
- Some strongly recommended criteria missing
- Mitigation plan for missing items
- Tested in staging
- Manual monitoring plan for missing observability

### 🔴 High Risk (Do Not Deploy)
- Any required criteria missing
- Multiple strongly recommended criteria missing
- No staging testing
- No rollback plan
- Critical security vulnerabilities

---

## Post-Deployment Verification

After deploying, verify:

- [ ] Health check endpoint returns 200 OK
- [ ] Application logs flowing to log aggregation
- [ ] Metrics appearing in monitoring dashboard
- [ ] Error tracking receiving events (test with intentional error)
- [ ] Database connections healthy
- [ ] External API integrations working
- [ ] Critical user flows tested (smoke tests)
- [ ] No error spikes in monitoring
- [ ] Response times within acceptable range

---

## Rollback Triggers

Roll back immediately if:

- Health check failures
- Error rate > 5% of requests
- Response time > 3x baseline
- Database connection failures
- Critical feature completely broken
- Security vulnerability actively exploited

---

## Summary

This checklist ensures production deployments are safe, observable, and maintainable. Focus on the **Required** section first - those are deployment blockers. Address **Strongly Recommended** items before deploying or have a clear mitigation plan. **Nice to Have** items can be addressed post-deployment.

**Remember**: It's better to delay deployment and fix critical issues than to deploy and cause production incidents.
