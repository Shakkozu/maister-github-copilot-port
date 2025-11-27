# Performance Optimization Guide

Comprehensive reference covering performance metrics, profiling strategies, optimization patterns, and benchmarking approaches.

## Table of Contents

1. [Performance Metrics](#performance-metrics)
2. [Profiling Strategies](#profiling-strategies)
3. [Optimization Patterns](#optimization-patterns)
4. [Benchmarking Approaches](#benchmarking-approaches)

---

# Performance Metrics

## Response Time Metrics

**p50 (Median)**: 50% of requests faster than this value
**p95**: 95% of requests faster (typical SLA target)
**p99**: 99% of requests faster (worst-case for most users)
**Max**: Slowest request (often outlier, less important)

**Interpretation Thresholds**:
- p95 < 100ms: Excellent
- p95 100-500ms: Good
- p95 500-1000ms: Acceptable
- p95 > 1000ms: Slow (optimization needed)

## Throughput Metrics

**Requests/sec**: Total requests handled per second
**Transactions/sec**: Completed transactions per second
**Saturation Point**: Concurrency level where throughput plateaus

**Targets by Application Type**:
- Simple API: 1000+ req/s
- Complex API: 100-500 req/s
- Database-heavy: 50-200 req/s

## CPU Metrics

**Usage %**: Overall CPU utilization
**Hot Functions**: Top functions by CPU time
**Complexity**: O(n), O(n log n), O(n²), etc.

**Thresholds**:
- < 70%: Good headroom
- 70-90%: Acceptable
- > 90%: Saturated

## Memory Metrics

**Heap Size**: Current memory usage
**Heap Growth**: Memory increase over time (leak indicator)
**GC Frequency**: Garbage collection frequency

**Leak Detection**: Heap grows continuously without plateau

## Database Metrics

**Queries/Request**: Total database queries per request
**Query Time**: Time spent in database
**N+1 Pattern**: 1 query + N related queries in loop
**Missing Indexes**: Full table scans

**Targets**:
- Queries/request: < 10
- Query time: < 50ms avg
- Slow queries (>100ms): 0

---

# Profiling Strategies

## JavaScript/Node.js

### CPU Profiling

```bash
# Built-in profiler
node --prof app.js
node --prof-process isolate-*.log > cpu-profile.txt

# clinic.js (better visualization)
clinic doctor -- node app.js

# Chrome DevTools
node --inspect app.js
# Open chrome://inspect
```

### Memory Profiling

```bash
# Heap snapshot
node --expose-gc --inspect app.js
# Take snapshot in Chrome DevTools

# clinic.js
clinic bubbleprof -- node app.js

# Track GC
node --trace-gc app.js
```

## Python

### CPU Profiling

```bash
# cProfile (built-in)
python -m cProfile -o profile.stats app.py
python -m pstats profile.stats
# Use 'sort cumulative' and 'stats 20'

# py-spy (sampling, low overhead)
py-spy record -o profile.svg -- python app.py
```

### Memory Profiling

```bash
# memory_profiler
pip install memory_profiler
python -m memory_profiler script.py

# objgraph (find leaks)
import objgraph
objgraph.show_most_common_types()
objgraph.show_growth()
```

## Database Profiling

### PostgreSQL

```sql
-- Enable slow query log
ALTER SYSTEM SET log_min_duration_statement = 100; -- >100ms
SELECT pg_reload_conf();

-- View slow queries
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC LIMIT 20;

-- Check missing indexes
EXPLAIN ANALYZE SELECT ...;
-- Look for "Seq Scan" (missing index)
```

### MySQL

```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 0.1;

-- View slow queries
SELECT * FROM mysql.slow_log
ORDER BY query_time DESC LIMIT 20;
```

---

# Optimization Patterns

## Database Optimizations

### Fix N+1 Queries

**Problem**: 1 query to fetch list + N queries for related data

**Bad** (N+1 pattern):
```javascript
const users = await User.findAll();  // 1 query
for (let user of users) {
  user.profile = await Profile.findByPk(user.id);  // N queries
}
```

**Good** (eager loading):
```javascript
const users = await User.findAll({
  include: [{ model: Profile }]  // Single JOIN query
});
```

### Add Missing Indexes

**Detection**: EXPLAIN shows "Seq Scan" or high cost

```sql
-- Before (slow)
SELECT * FROM orders WHERE user_id = 123;
-- Seq Scan on orders (cost=0.00..2500.00)

-- Add index
CREATE INDEX CONCURRENTLY idx_orders_user_id ON orders(user_id);

-- After (fast)
-- Index Scan using idx_orders_user_id (cost=0.00..8.00)
```

### Connection Pooling

```javascript
// Bad: New connection per query
const connection = await mysql.createConnection(config);

// Good: Connection pool
const pool = mysql.createPool({
  connectionLimit: 10,
  ...config
});
```

## Algorithm Optimizations

### Replace O(n²) with O(n)

**Bad** (nested loops):
```javascript
// O(n²)
for (let user of users) {
  for (let order of orders) {
    if (order.userId === user.id) {
      user.orders.push(order);
    }
  }
}
```

**Good** (hash map):
```javascript
// O(n)
const ordersByUser = {};
for (let order of orders) {
  if (!ordersByUser[order.userId]) ordersByUser[order.userId] = [];
  ordersByUser[order.userId].push(order);
}
for (let user of users) {
  user.orders = ordersByUser[user.id] || [];
}
```

### Memoization

**Bad** (repeated calculations):
```javascript
function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);  // Exponential time
}
```

**Good** (memoized):
```javascript
const memo = {};
function fibonacci(n) {
  if (n <= 1) return n;
  if (memo[n]) return memo[n];
  memo[n] = fibonacci(n - 1) + fibonacci(n - 2);
  return memo[n];
}
```

## Caching Strategies

### Cache Expensive Operations

```javascript
// Bad: Calculate every time
app.get('/stats', async (req, res) => {
  const stats = await calculateExpensiveStats();  // 5 seconds
  res.json(stats);
});

// Good: Cache results
const cache = new Map();
app.get('/stats', async (req, res) => {
  let stats = cache.get('stats');
  if (!stats) {
    stats = await calculateExpensiveStats();
    cache.set('stats', stats);
    setTimeout(() => cache.delete('stats'), 60000);  // TTL: 1 min
  }
  res.json(stats);
});
```

### Redis Caching

```javascript
const redis = require('redis');
const client = redis.createClient();

// Cache expensive query
async function getUser(id) {
  const cached = await client.get(`user:${id}`);
  if (cached) return JSON.parse(cached);

  const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);
  await client.setex(`user:${id}`, 3600, JSON.stringify(user));  // TTL: 1 hour
  return user;
}
```

## I/O Optimizations

### Async vs Sync

**Bad** (blocking):
```javascript
const data = fs.readFileSync('large-file.json');  // Blocks event loop
```

**Good** (non-blocking):
```javascript
const data = await fs.promises.readFile('large-file.json');  // Async
```

### Parallel API Calls

**Bad** (sequential):
```javascript
const user = await fetchUser(id);       // 200ms
const orders = await fetchOrders(id);   // 200ms
const profile = await fetchProfile(id); // 200ms
// Total: 600ms
```

**Good** (parallel):
```javascript
const [user, orders, profile] = await Promise.all([
  fetchUser(id),
  fetchOrders(id),
  fetchProfile(id)
]);
// Total: 200ms (fastest of the three)
```

## Memory Optimizations

### Streaming Large Data

**Bad** (load all):
```javascript
const data = await fs.promises.readFile('large-file.csv');  // 1GB in memory
processCSV(data);
```

**Good** (stream):
```javascript
const stream = fs.createReadStream('large-file.csv');
stream.pipe(csvParser()).on('data', processRow);  // Constant memory
```

### Object Pooling

```javascript
// Bad: Create new objects constantly
for (let i = 0; i < 1000000; i++) {
  const obj = { x: i, y: i * 2 };  // 1M allocations
  process(obj);
}

// Good: Reuse objects
const pool = { x: 0, y: 0 };
for (let i = 0; i < 1000000; i++) {
  pool.x = i;
  pool.y = i * 2;  // 1 allocation, reused
  process(pool);
}
```

---

# Benchmarking Approaches

## Load Testing Tools

### ApacheBench (Simple)

```bash
# 1000 requests, 10 concurrent
ab -n 1000 -c 10 http://localhost:3000/api/users

# With POST data
ab -n 1000 -c 10 -p data.json -T application/json http://localhost:3000/api/users
```

### wrk (Advanced)

```bash
# 4 threads, 100 connections, 30 seconds
wrk -t4 -c100 -d30s http://localhost:3000/api/users

# With custom script
wrk -t4 -c100 -d30s -s script.lua http://localhost:3000/api/users
```

### k6 (Most Flexible)

```javascript
// load-test.js
import http from 'k6/http';
import { check } from 'k6';

export let options = {
  vus: 100,  // Virtual users
  duration: '30s',
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests < 500ms
  },
};

export default function() {
  let res = http.get('http://localhost:3000/api/users');
  check(res, { 'status is 200': (r) => r.status === 200 });
}
```

```bash
k6 run load-test.js
```

## Benchmarking Methodology

### Warm-Up

Always warm up before profiling:
```bash
# Run for 30s to warm up JIT, caches
wrk -t4 -c10 -d30s http://localhost:3000/api/users

# Then profile
wrk -t4 -c100 -d60s http://localhost:3000/api/users
```

### Multiple Runs

Run 3-5 times, use median:
```bash
for i in {1..5}; do
  wrk -t4 -c100 -d30s http://localhost:3000/api/users
done
# Use median p95, not average
```

### Realistic Workloads

Use production-like data:
- Same data volume (not test database with 10 rows)
- Same query patterns (not just GET /health)
- Same traffic mix (read/write ratio)

## Load Testing Patterns

### Ramp-Up Testing

Gradually increase load:
```javascript
export let options = {
  stages: [
    { duration: '2m', target: 100 },  // Ramp up to 100 users over 2 min
    { duration: '5m', target: 100 },  // Stay at 100 for 5 min
    { duration: '2m', target: 200 },  // Ramp up to 200
    { duration: '5m', target: 200 },
    { duration: '2m', target: 0 },    // Ramp down
  ],
};
```

### Sustained Load

Constant load over time:
```javascript
export let options = {
  vus: 500,
  duration: '30m',  // 500 concurrent users for 30 minutes
};
```

### Spike Testing

Sudden traffic increase:
```javascript
export let options = {
  stages: [
    { duration: '10s', target: 100 },   // Normal load
    { duration: '10s', target: 1000 },  // Spike (10x)
    { duration: '3m', target: 1000 },   // Sustain spike
    { duration: '10s', target: 100 },   // Back to normal
  ],
};
```

### Stress Testing

Find breaking point:
```javascript
export let options = {
  stages: [
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 200 },
    { duration: '5m', target: 200 },
    { duration: '2m', target: 300 },
    { duration: '5m', target: 300 },
    { duration: '2m', target: 400 },
    { duration: '5m', target: 400 },
    // Continue until errors spike
  ],
};
```

## Interpreting Results

### Latency Percentiles

Focus on p95, p99 (not average):
```
p50: 45ms   (Median, typical user)
p95: 180ms  (95% of users, SLA target)
p99: 280ms  (Worst 1% of users)
max: 800ms  (Outlier, ignore)
```

### Throughput Analysis

```
Requests/sec by concurrency:
10 concurrent:  200 req/s
50 concurrent:  450 req/s
100 concurrent: 580 req/s  ← Peak
200 concurrent: 580 req/s  ← Saturated (no improvement)
500 concurrent: 550 req/s  ← Degraded (errors increasing)
```

Saturation point: 100 concurrent users (580 req/s)

### Error Rate

```
Load Level    | Success Rate | Error Rate
10 concurrent | 100%         | 0%
100 concurrent| 99.5%        | 0.5%   ← Acceptable
500 concurrent| 92%          | 8%     ← Too high
```

Target: < 1% error rate under normal load

---

This guide provides practical patterns and tools for systematic performance optimization.
