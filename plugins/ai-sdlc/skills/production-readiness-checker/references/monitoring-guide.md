# Monitoring & Observability Guide

Guide for verifying monitoring and observability setup for production deployments.

---

## The Three Pillars of Observability

1. **Logging**: Detailed event records (what happened?)
2. **Metrics**: Numerical measurements over time (how is it performing?)
3. **Tracing**: Request flow through distributed systems (where is the bottleneck?)

All three are essential for production systems.

---

## Logging

### Structured Logging

**Bad** (unstructured):
```typescript
console.log('User logged in: ' + userId);
console.log('Failed to process payment for order ' + orderId + ' error: ' + error);
```

**Good** (structured JSON):
```typescript
logger.info('User logged in', { userId, timestamp: new Date() });
logger.error('Payment processing failed', {
  orderId,
  error: error.message,
  stack: error.stack,
  userId
});
```

**Why**: Structured logs are easy to parse, search, and analyze.

### Logging Libraries

**Node.js**:
- Winston (popular, feature-rich)
- Pino (fast, minimal)
- Bunyan (structured by default)

**Python**:
- structlog (structured logging)
- python-json-logger

**Go**:
- zap (high performance)
- logrus (structured)

### Log Levels

Use appropriately:

- **DEBUG**: Detailed diagnostic info (development only)
- **INFO**: General informational messages
- **WARN**: Warning messages, potential issues
- **ERROR**: Error messages, failures
- **FATAL**: Critical errors, app cannot continue

**Example**:
```typescript
logger.debug('Cache miss', { key });
logger.info('User created', { userId });
logger.warn('Rate limit approaching', { userId, current: 95, limit: 100 });
logger.error('Database connection failed', { error, retries: 3 });
logger.fatal('Cannot connect to database', { error });
```

### What NOT to Log

**Never log**:
- Passwords (plain or hashed)
- API keys, tokens, secrets
- Credit card numbers
- Social Security Numbers
- Other PII (unless necessary and anonymized)

**Detection**:
```bash
grep -rni "log.*password\|log.*token\|log.*secret\|log.*creditCard" src/
```

### Log Aggregation

**Production requirement**: Logs must go to centralized system

**Output to stdout/stderr**:
```typescript
// Good - logs go to stdout
logger.info('Message');

// Bad - logs to file (hard to aggregate in containers)
logger.add(new transports.File({ filename: 'app.log' }));
```

**Aggregation systems**:
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Splunk
- Datadog
- CloudWatch Logs (AWS)
- Google Cloud Logging

---

## Metrics & Instrumentation

### What to Measure

**System Metrics** (automatic via agent):
- CPU usage
- Memory usage
- Disk I/O
- Network I/O

**Application Metrics** (manual instrumentation):
- Request rate (requests/second)
- Request latency (p50, p95, p99)
- Error rate (errors/total requests)
- Active connections
- Database query time
- External API call time
- Queue depth
- Cache hit/miss rate

**Business Metrics**:
- User signups
- Orders placed
- Payments processed
- Feature usage

### Metrics Libraries

**Node.js**:
```typescript
import promClient from 'prom-client';

// Counter - incrementing value
const requestCounter = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status']
});

// Histogram - distribution
const requestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Request duration in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.1, 0.5, 1, 2, 5]
});

// Usage in middleware
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    requestCounter.inc({ method: req.method, route: req.route?.path, status: res.statusCode });
    requestDuration.observe({ method: req.method, route: req.route?.path }, duration);
  });

  next();
});
```

**Python**:
```python
from prometheus_client import Counter, Histogram

request_counter = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

request_duration = Histogram(
    'http_request_duration_seconds',
    'Request duration in seconds',
    ['method', 'endpoint']
)

@app.before_request
def before_request():
    g.start_time = time.time()

@app.after_request
def after_request(response):
    if hasattr(g, 'start_time'):
        duration = time.time() - g.start_time
        request_duration.labels(
            method=request.method,
            endpoint=request.endpoint
        ).observe(duration)
        request_counter.labels(
            method=request.method,
            endpoint=request.endpoint,
            status=response.status_code
        ).inc()
    return response
```

### Custom Metrics

**Example - Track business events**:
```typescript
const userSignups = new promClient.Counter({
  name: 'user_signups_total',
  help: 'Total user signups'
});

const paymentAmount = new promClient.Histogram({
  name: 'payment_amount_dollars',
  help: 'Payment amount in dollars',
  buckets: [10, 50, 100, 500, 1000, 5000]
});

// In application code
async function createUser(data) {
  const user = await User.create(data);
  userSignups.inc();
  return user;
}

async function processPayment(amount) {
  // ...process payment...
  paymentAmount.observe(amount);
}
```

### Detection

```bash
# Check for metrics library
grep -r "prometheus\|prom-client\|statsd\|datadog" package.json

# Check for metrics instrumentation
grep -rn "Counter\|Gauge\|Histogram\|Summary" src/

# Check for metrics endpoint
grep -rn "\/metrics" src/
```

---

## Error Tracking

### Error Tracking Services

**Popular services**:
- Sentry (most popular)
- Bugsnag
- Rollbar
- Raygun
- Airbrake

### Basic Setup (Sentry)

**Node.js**:
```typescript
import * as Sentry from "@sentry/node";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 0.1, // 10% of transactions
});

// Express error handler
app.use(Sentry.Handlers.errorHandler());

// Manual error capture
try {
  await riskyOperation();
} catch (error) {
  Sentry.captureException(error, {
    tags: { operation: 'payment' },
    user: { id: userId },
    extra: { orderId }
  });
  throw error;
}
```

**Python**:
```python
import sentry_sdk

sentry_sdk.init(
    dsn=os.getenv('SENTRY_DSN'),
    environment=os.getenv('ENVIRONMENT'),
    traces_sample_rate=0.1
)

# Automatic error capture
try:
    risky_operation()
except Exception as e:
    sentry_sdk.capture_exception(e)
    raise
```

### Global Error Handlers

**Node.js - Required**:
```typescript
// Unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  logger.error('Unhandled Promise Rejection', { reason, promise });
  Sentry.captureException(reason);
});

// Uncaught exceptions
process.on('uncaughtException', (error) => {
  logger.error('Uncaught Exception', { error });
  Sentry.captureException(error);
  // Give time to send error, then exit
  setTimeout(() => process.exit(1), 1000);
});
```

### Error Context

**Good error tracking includes context**:
```typescript
Sentry.captureException(error, {
  tags: {
    operation: 'payment_processing',
    payment_method: 'credit_card'
  },
  user: {
    id: userId,
    email: userEmail
  },
  extra: {
    orderId,
    amount,
    currency,
    attemptNumber: 3
  }
});
```

### Detection

```bash
# Check for error tracking service
grep -r "sentry\|bugsnag\|rollbar" package.json

# Check for error handlers
grep -rn "captureException\|reportError" src/

# Check for global handlers
grep -rn "unhandledRejection\|uncaughtException" src/
```

---

## Health Checks

### Health Check Endpoint

**Purpose**: Allow load balancers and orchestrators to determine if instance is healthy

**Basic Health Check**:
```typescript
// /health or /healthz
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});
```

### Liveness vs Readiness

**Liveness** (is app alive?):
- Basic check - can the app respond?
- If fails: restart the container/process

**Readiness** (is app ready for traffic?):
- Comprehensive check - are all dependencies ready?
- If fails: remove from load balancer, but don't restart

**Example**:
```typescript
// Liveness - simple
app.get('/health/live', (req, res) => {
  res.status(200).json({ status: 'alive' });
});

// Readiness - comprehensive
app.get('/health/ready', async (req, res) => {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    externalApi: await checkExternalAPI()
  };

  const allHealthy = Object.values(checks).every(check => check.healthy);

  res.status(allHealthy ? 200 : 503).json({
    status: allHealthy ? 'ready' : 'not ready',
    checks
  });
});

async function checkDatabase() {
  try {
    await db.raw('SELECT 1');
    return { healthy: true };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}
```

### Kubernetes Health Checks

```yaml
livenessProbe:
  httpGet:
    path: /health/live
    port: 3000
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /health/ready
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 5
```

### Detection

```bash
# Find health check endpoints
grep -rn "\/health\|\/healthz\|\/ping" src/

# Find health check implementations
grep -rn "checkDatabase\|checkRedis" src/
```

---

## Alerting

### What to Alert On

**Critical** (page on-call immediately):
- Error rate > 5%
- All instances unhealthy
- Database connection failures
- Payment processing failures
- Authentication service down

**Warning** (notify team, not urgent):
- Error rate > 1%
- High response times (p99 > 3s)
- High memory usage (> 80%)
- Disk space low
- Rate limit approaching

**Info** (nice to know):
- Deployments
- Configuration changes
- Scaling events

### Alert Fatigue

**Avoid**:
- Too many alerts
- Alerts for non-actionable issues
- Duplicate alerts
- Flapping alerts (on/off repeatedly)

**Best practices**:
- Alert on symptoms, not causes
- Alert on user impact
- Use escalation (warn before critical)
- Tune thresholds based on historical data

---

## Monitoring Dashboard

### Key Metrics to Display

**RED Method** (Requests, Errors, Duration):
- Request rate (requests/sec)
- Error rate (%)
- Duration (p50, p95, p99)

**USE Method** (Utilization, Saturation, Errors):
- CPU utilization (%)
- Memory utilization (%)
- Disk I/O saturation
- Network saturation

**Custom Metrics**:
- Business KPIs
- Feature usage
- Conversion rates

---

## Detection Checklist

Use this when analyzing monitoring setup:

### Logging
- [ ] Structured logging library (not console.log)
- [ ] Appropriate log levels used
- [ ] No sensitive data in logs
- [ ] Logs to stdout/stderr
- [ ] Error logging with context

### Metrics
- [ ] Metrics library configured
- [ ] HTTP request metrics (rate, latency, errors)
- [ ] Database metrics
- [ ] Custom business metrics
- [ ] Metrics endpoint exposed (/metrics)

### Error Tracking
- [ ] Error tracking service configured
- [ ] Global error handlers
- [ ] Error context included
- [ ] Unhandled rejection handler

### Health Checks
- [ ] Health endpoint exists
- [ ] Liveness check
- [ ] Readiness check with dependencies
- [ ] No sensitive info in health response

---

## Summary

Production-ready monitoring includes:
- **Structured logging** for debugging
- **Metrics instrumentation** for performance
- **Error tracking** for bug detection
- **Health checks** for orchestration
- **Alerting** for proactive response

Without comprehensive observability, you're flying blind in production.
