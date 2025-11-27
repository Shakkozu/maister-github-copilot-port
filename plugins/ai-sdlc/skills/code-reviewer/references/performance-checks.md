# Performance Analysis Patterns

This guide provides comprehensive patterns for detecting performance issues in the code-reviewer skill.

---

## 1. N+1 Query Detection

### What is an N+1 Query Problem?

**Definition**: Making N additional queries in a loop instead of fetching all needed data upfront.

**Example Scenario**:
1. Fetch 100 orders (1 query)
2. For each order, fetch its user (100 queries)
3. Total: 101 queries instead of 2

**Performance Impact**:
- 10 items: ~10x slower
- 100 items: ~100x slower
- 1000 items: Application becomes unusable

### Detection Patterns

**Code patterns to search for**:
```bash
# Queries inside loops - JavaScript/TypeScript
grep -B3 "\.map\|\.forEach\|for.*of\|for.*in" src/ | grep "find\|findOne\|query"

# Queries inside loops - Python
grep -B3 "for.*in" src/ | grep "\.get\|\.filter\|\.query"

# Async operations in map/forEach
grep -rn "\.map.*await\|\.forEach.*await" src/
```

**ORM-specific patterns**:
```bash
# Sequelize (Node.js)
grep -rn "\.map.*findOne\|\.map.*findByPk" src/

# Prisma (Node.js)
grep -rn "\.map.*prisma\.\w*\.findUnique" src/

# Django ORM (Python)
grep -rn "for.*in.*\.all()\|for.*in.*\.filter()" src/ | grep "\.get\|\.filter"
```

### Vulnerable Examples

**JavaScript/TypeScript - Critical Performance Issue**:
```typescript
// ❌ N+1 Query: 1 + N queries
async function getOrdersWithUsers() {
  const orders = await Order.findAll(); // 1 query

  const ordersWithUsers = await Promise.all(
    orders.map(async (order) => {
      const user = await User.findByPk(order.userId); // N queries!
      return { ...order, user };
    })
  );

  return ordersWithUsers;
}
```

**Impact**: For 100 orders → 101 database queries
**Severity**: Warning (Critical if dealing with >100 records)

**Recommendation - Eager Loading**:
```typescript
// ✅ Optimized: 1-2 queries using eager loading
async function getOrdersWithUsers() {
  const orders = await Order.findAll({
    include: [User] // Sequelize eager loading
  });

  return orders;
}
```

**Recommendation - Batch Query**:
```typescript
// ✅ Optimized: 2 queries using batch fetch
async function getOrdersWithUsers() {
  const orders = await Order.findAll(); // 1 query

  const userIds = [...new Set(orders.map(o => o.userId))];
  const users = await User.findAll({
    where: { id: userIds } // 1 query fetching all users
  });

  const usersMap = new Map(users.map(u => [u.id, u]));

  return orders.map(order => ({
    ...order,
    user: usersMap.get(order.userId)
  }));
}
```

**Python/Django - Critical Performance Issue**:
```python
# ❌ N+1 Query
def get_posts_with_authors():
    posts = Post.objects.all()  # 1 query

    result = []
    for post in posts:
        author = User.objects.get(id=post.author_id)  # N queries!
        result.append({
            'post': post,
            'author': author
        })

    return result
```

**Recommendation - select_related**:
```python
# ✅ Optimized: 1 query with JOIN
def get_posts_with_authors():
    posts = Post.objects.select_related('author').all()
    return posts
```

**Python/SQLAlchemy - Critical Performance Issue**:
```python
# ❌ N+1 Query
def get_orders_with_items():
    orders = session.query(Order).all()  # 1 query

    for order in orders:
        items = order.items  # N queries (lazy loading)!
        print(f"Order {order.id} has {len(items)} items")
```

**Recommendation - joinedload**:
```python
# ✅ Optimized: Eager loading
from sqlalchemy.orm import joinedload

def get_orders_with_items():
    orders = session.query(Order).options(
        joinedload(Order.items)
    ).all()  # 1 query with JOIN

    for order in orders:
        items = order.items  # No additional query
        print(f"Order {order.id} has {len(items)} items")
```

---

### GraphQL N+1 Problems

**Detection**:
```bash
# GraphQL resolvers without dataloader
grep -rn "resolve.*{" src/ | grep -v "dataloader\|loader"
```

**Example - N+1 in GraphQL**:
```typescript
// ❌ N+1 Query in GraphQL resolver
const resolvers = {
  Query: {
    posts: () => Post.findAll()
  },
  Post: {
    author: (post) => User.findByPk(post.authorId) // N queries!
  }
};
```

**Recommendation - DataLoader**:
```typescript
// ✅ Optimized: Using DataLoader
const DataLoader = require('dataloader');

const userLoader = new DataLoader(async (userIds) => {
  const users = await User.findAll({
    where: { id: userIds }
  });
  return userIds.map(id => users.find(u => u.id === id));
});

const resolvers = {
  Query: {
    posts: () => Post.findAll()
  },
  Post: {
    author: (post) => userLoader.load(post.authorId) // Batched!
  }
};
```

---

## 2. Missing Database Indexes

### What are Database Indexes?

**Purpose**: Speed up data retrieval by creating efficient lookup structures
**Impact**: Unindexed queries can be 10x-1000x slower on large tables

### When Indexes are Critical

**Always index**:
- Primary keys (usually automatic)
- Foreign keys
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY
- Columns in GROUP BY

**Consider indexing**:
- Frequently searched columns
- Columns in LIKE patterns (if prefix match)
- Composite indexes for multi-column queries

### Detection Strategies

**Code Analysis**:
```bash
# Find WHERE clauses
grep -rn "WHERE\|where:" src/

# Find JOIN conditions
grep -rn "JOIN.*ON\|join.*on" src/

# Find ORDER BY
grep -rn "ORDER BY\|orderBy" src/
```

**Check Migration Files**:
```bash
# Look for missing index definitions
grep -L "createIndex\|add_index\|CREATE INDEX" migrations/
```

**ORM Query Analysis**:
```bash
# Sequelize queries without indexes
grep -rn "where:.*{" src/

# Prisma queries
grep -rn "where:.*{" src/
```

### Examples

**Missing Index - Warning**:
```typescript
// ⚠️ Query on unindexed column
async function findUserByEmail(email: string) {
  return await User.findOne({
    where: { email } // Is 'email' indexed?
  });
}
```

**Check Migration**:
```typescript
// ❌ Missing index in migration
await queryInterface.createTable('users', {
  id: { type: DataTypes.INTEGER, primaryKey: true },
  email: { type: DataTypes.STRING }, // No index!
  name: { type: DataTypes.STRING }
});
```

**Recommendation**:
```typescript
// ✅ Add index
await queryInterface.createTable('users', {
  id: { type: DataTypes.INTEGER, primaryKey: true },
  email: {
    type: DataTypes.STRING,
    unique: true // Creates unique index
  },
  name: { type: DataTypes.STRING }
});

// Or add separately
await queryInterface.addIndex('users', ['email'], {
  unique: true,
  name: 'users_email_unique'
});
```

**Complex Query - Missing Composite Index**:
```sql
-- ❌ Query using multiple columns
SELECT * FROM orders
WHERE user_id = 123
  AND status = 'pending'
ORDER BY created_at DESC;
```

**Recommendation**:
```sql
-- ✅ Add composite index
CREATE INDEX idx_orders_user_status_created
ON orders (user_id, status, created_at DESC);
```

**Rule of Thumb**: Index order matters - put most selective column first, or follow query WHERE/ORDER BY order.

---

### Foreign Key Indexes

**Critical**: Always index foreign keys

**Detection**:
```bash
# Find foreign key columns
grep -rn "References\|references\|foreignKey" migrations/
```

**Example**:
```typescript
// ⚠️ Foreign key without index
await queryInterface.createTable('posts', {
  id: { type: DataTypes.INTEGER, primaryKey: true },
  author_id: {
    type: DataTypes.INTEGER,
    references: { model: 'users', key: 'id' }
    // Missing index!
  }
});
```

**Recommendation**:
```typescript
// ✅ Add index on foreign key
await queryInterface.createTable('posts', {
  id: { type: DataTypes.INTEGER, primaryKey: true },
  author_id: {
    type: DataTypes.INTEGER,
    references: { model: 'users', key: 'id' }
  }
});

await queryInterface.addIndex('posts', ['author_id']);
```

---

## 3. Inefficient Operations

### Loading Large Datasets Without Pagination

**Risk**: Memory exhaustion, slow response times

**Detection**:
```bash
# Find queries without limits
grep -rn "findAll()\|\.all()\|SELECT \*" src/ | grep -v "limit\|LIMIT"

# Find array operations on large datasets
grep -rn "\.findAll()\|\.all()" src/
```

**Examples**:

**Critical - Loading All Records**:
```typescript
// ❌ Loading potentially millions of records
app.get('/api/users', async (req, res) => {
  const users = await User.findAll(); // All users!
  res.json(users);
});
```

**Impact**:
- 10K users: ~2MB, slow response
- 100K users: ~20MB, very slow
- 1M users: ~200MB, server crash

**Severity**: Critical

**Recommendation - Pagination**:
```typescript
// ✅ Paginated query
app.get('/api/users', async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = 50;
  const offset = (page - 1) * limit;

  const { rows: users, count } = await User.findAndCountAll({
    limit,
    offset
  });

  res.json({
    users,
    pagination: {
      page,
      limit,
      total: count,
      totalPages: Math.ceil(count / limit)
    }
  });
});
```

**Recommendation - Cursor-Based Pagination** (better for large datasets):
```typescript
// ✅ Cursor-based pagination (more scalable)
app.get('/api/users', async (req, res) => {
  const cursor = req.query.cursor;
  const limit = 50;

  const users = await User.findAll({
    where: cursor ? { id: { [Op.gt]: cursor } } : {},
    limit,
    order: [['id', 'ASC']]
  });

  res.json({
    users,
    nextCursor: users.length === limit ? users[users.length - 1].id : null
  });
});
```

---

### Synchronous Blocking Operations

**Risk**: Blocks event loop, makes entire app unresponsive

**Detection**:
```bash
# Find synchronous file operations
grep -rn "Sync(" src/ | grep -v "test\|spec"

# Common blocking operations
grep -rn "readFileSync\|writeFileSync\|execSync" src/
```

**Examples**:

**Critical - Blocking File Read**:
```typescript
// ❌ Blocks event loop
const fs = require('fs');

app.get('/config', (req, res) => {
  const config = fs.readFileSync('./config.json', 'utf8'); // Blocks!
  res.json(JSON.parse(config));
});
```

**Severity**: Warning (Critical if in hot path)

**Recommendation**:
```typescript
// ✅ Non-blocking async
const fs = require('fs').promises;

app.get('/config', async (req, res) => {
  const config = await fs.readFile('./config.json', 'utf8');
  res.json(JSON.parse(config));
});
```

**Acceptable Usage**:
```typescript
// ✅ OK: One-time startup config loading
const config = fs.readFileSync('./config.json', 'utf8'); // Before server starts
app.listen(3000);
```

---

### Loading Entire Files Into Memory

**Risk**: Memory exhaustion for large files

**Detection**:
```bash
# Find file reads without streaming
grep -rn "readFile\|read_file" src/ | grep -v "stream\|Stream"
```

**Examples**:

**Warning - Loading Large File**:
```typescript
// ⚠️ Loads entire file into memory
app.get('/download/:id', async (req, res) => {
  const file = await storage.getFile(req.params.id);
  const content = await file.download(); // Could be GB!
  res.send(content);
});
```

**Impact**: 100MB file → 100MB memory per request

**Recommendation - Streaming**:
```typescript
// ✅ Stream file
app.get('/download/:id', async (req, res) => {
  const file = await storage.getFile(req.params.id);
  const stream = file.createReadStream();

  res.setHeader('Content-Type', file.contentType);
  stream.pipe(res);
});
```

**Python Example**:
```python
# ❌ Loading entire file
def process_large_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()  # All in memory
        return process(content)

# ✅ Line-by-line processing
def process_large_file(filepath):
    with open(filepath, 'r') as f:
        for line in f:  # Stream line by line
            process(line)
```

---

### Missing Streaming for Large Responses

**Detection**:
```bash
# Find array operations that could benefit from streaming
grep -rn "\.map(\|\.filter(" src/ | grep -i "data\|rows\|results"
```

**Example**:
```typescript
// ⚠️ Loads all data before sending
app.get('/export/users', async (req, res) => {
  const users = await User.findAll(); // All users in memory
  const csv = users.map(u => `${u.id},${u.name},${u.email}`).join('\n');
  res.send(csv);
});
```

**Recommendation**:
```typescript
// ✅ Stream results
const { Readable } = require('stream');

app.get('/export/users', async (req, res) => {
  res.setHeader('Content-Type', 'text/csv');

  const stream = new Readable({
    async read() {
      // Fetch in batches
      const users = await User.findAll({ limit: 1000, offset: this.offset || 0 });
      this.offset = (this.offset || 0) + 1000;

      for (const user of users) {
        this.push(`${user.id},${user.name},${user.email}\n`);
      }

      if (users.length < 1000) {
        this.push(null); // End stream
      }
    }
  });

  stream.pipe(res);
});
```

---

## 4. Missing Caching

### When to Cache

**Always consider caching**:
- Expensive computations
- External API calls
- Database queries for static/slow-changing data
- Frequently accessed data

**Don't cache**:
- User-specific data (unless keyed properly)
- Rapidly changing data
- Data requiring real-time accuracy

### Detection Strategies

**Find repeated expensive operations**:
```bash
# Find API calls without caching
grep -rn "fetch(\|axios\|http\.get" src/ | grep -v "cache"

# Find expensive queries
grep -rn "join.*join\|JOIN.*JOIN" src/
```

### Examples

**Warning - Repeated External API Call**:
```typescript
// ⚠️ Calls external API on every request
app.get('/exchange-rate/:currency', async (req, res) => {
  const rate = await fetch(`https://api.exchangerate.com/${req.params.currency}`);
  res.json(await rate.json());
});
```

**Impact**: Slow response, API rate limits, costs

**Recommendation - Simple Caching**:
```typescript
// ✅ Cache with TTL
const cache = new Map();
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

app.get('/exchange-rate/:currency', async (req, res) => {
  const currency = req.params.currency;
  const cached = cache.get(currency);

  if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
    return res.json(cached.data);
  }

  const rate = await fetch(`https://api.exchangerate.com/${currency}`);
  const data = await rate.json();

  cache.set(currency, { data, timestamp: Date.now() });
  res.json(data);
});
```

**Recommendation - Redis Caching**:
```typescript
// ✅ Production-ready with Redis
const redis = require('redis').createClient();

app.get('/exchange-rate/:currency', async (req, res) => {
  const currency = req.params.currency;
  const cacheKey = `exchange-rate:${currency}`;

  // Try cache first
  const cached = await redis.get(cacheKey);
  if (cached) {
    return res.json(JSON.parse(cached));
  }

  // Fetch and cache
  const rate = await fetch(`https://api.exchangerate.com/${currency}`);
  const data = await rate.json();

  await redis.setEx(cacheKey, 300, JSON.stringify(data)); // 5 min TTL
  res.json(data);
});
```

---

**Warning - Repeated Database Query**:
```typescript
// ⚠️ Fetches settings on every request
app.use(async (req, res, next) => {
  req.settings = await Settings.findOne(); // Every request!
  next();
});
```

**Recommendation**:
```typescript
// ✅ Cache application settings
let settingsCache = null;
let lastFetch = 0;
const CACHE_TTL = 60 * 1000; // 1 minute

app.use(async (req, res, next) => {
  if (!settingsCache || Date.now() - lastFetch > CACHE_TTL) {
    settingsCache = await Settings.findOne();
    lastFetch = Date.now();
  }

  req.settings = settingsCache;
  next();
});
```

---

### Memoization for Expensive Functions

**Example - Expensive Calculation**:
```typescript
// ⚠️ Recalculates every time
function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2); // Exponential time!
}
```

**Recommendation**:
```typescript
// ✅ Memoized
const memo = new Map();

function fibonacci(n) {
  if (n <= 1) return n;

  if (memo.has(n)) {
    return memo.get(n);
  }

  const result = fibonacci(n - 1) + fibonacci(n - 2);
  memo.set(n, result);
  return result;
}
```

---

### HTTP Caching Headers

**Missing Cache Headers**:
```typescript
// ⚠️ No cache headers for static content
app.get('/images/:id', async (req, res) => {
  const image = await getImage(req.params.id);
  res.send(image);
});
```

**Recommendation**:
```typescript
// ✅ Add cache headers
app.get('/images/:id', async (req, res) => {
  const image = await getImage(req.params.id);

  res.setHeader('Cache-Control', 'public, max-age=31536000'); // 1 year
  res.setHeader('ETag', image.hash);
  res.send(image);
});
```

---

## 5. Database Connection Issues

### Connection Pool Configuration

**Detection**:
```bash
grep -rn "pool:\|createPool\|connection.*config" src/
```

**Example - Poor Configuration**:
```typescript
// ⚠️ Single connection for entire app
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password'
});
```

**Recommendation**:
```typescript
// ✅ Connection pool
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'password',
  connectionLimit: 10,      // Max connections
  queueLimit: 0,            // Unlimited queue
  waitForConnections: true
});
```

---

## 6. Reporting Format

### Performance Finding Template

```markdown
### [PERFORMANCE] [Category] - [Brief Description]

**Location**: `file.ts:123`
**Severity**: Critical | Warning | Info
**Type**: [N+1 Query | Missing Index | Inefficient Operation | Missing Cache]

**Issue**:
[Clear description of performance problem]

**Current Implementation**:
```[language]
[Code showing the issue]
```

**Performance Impact**:
- [Specific metrics: queries, memory, time]
- [Scale impact: "10x slower with 100 records"]
- [User experience impact]

**Recommendation**:
[Specific optimization approach]

**Optimized Implementation**:
```[language]
[Code showing the fix]
```

**Expected Improvement**:
[Specific metrics: "100 queries → 2 queries"]

**Effort**: [Low/Medium/High]
```

---

## Summary

Performance issues compound at scale. An N+1 query with 10 records might be acceptable, but with 1000 records it becomes critical. Always consider the scale when assessing severity. Provide concrete metrics (query count, memory usage) and specific optimization strategies.
