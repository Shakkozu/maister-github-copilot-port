# Security Vulnerability Detection Patterns

This guide provides comprehensive patterns for detecting security vulnerabilities in the code-reviewer skill.

---

## 1. Hardcoded Secrets Detection

### What to Look For

**Secrets that should NEVER be hardcoded**:
- API keys and tokens
- Database passwords
- Encryption keys
- OAuth client secrets
- Private keys (SSH, SSL/TLS)
- Service account credentials
- Session secrets
- JWT signing keys

### Detection Patterns

**Basic secret patterns**:
```bash
# Search for common secret variable names
grep -rni "password\s*=\|passwd\s*=\|pwd\s*=" src/
grep -rni "api_key\s*=\|apikey\s*=\|api-key\s*=" src/
grep -rni "secret\s*=\|secret_key\s*=\|secretkey\s*=" src/
grep -rni "token\s*=\|auth_token\s*=\|access_token\s*=" src/

# Search for Bearer tokens
grep -rni "Bearer\s" src/

# Search for Basic auth credentials
grep -rni "Basic\s" src/

# Search for connection strings with credentials
grep -rni "://.*:.*@" src/

# Search for private keys
grep -rni "BEGIN.*PRIVATE KEY" src/
```

**Language-specific patterns**:

**JavaScript/TypeScript**:
```bash
# Environment variable assignments with hardcoded values
grep -rn "process\.env\.\w*\s*=\s*['\"]" src/

# Common secret patterns in JS/TS
grep -rn "apiKey:\s*['\"].*['\"]" src/
grep -rn "secretKey:\s*['\"].*['\"]" src/
```

**Python**:
```bash
# Python credential patterns
grep -rn "PASSWORD\s*=\s*['\"]" src/
grep -rn "API_KEY\s*=\s*['\"]" src/
```

**Go**:
```bash
# Go constant secrets
grep -rn "const.*Key\s*=\s*\"" src/
grep -rn "const.*Secret\s*=\s*\"" src/
```

### False Positive Filtering

**Legitimate hardcoded values** (not secrets):
- Empty strings: `password = ""`
- Example/placeholder values: `password = "your-password-here"`
- Test fixtures: `test_password = "test123"` in test files
- Public keys (only private keys are secrets)
- Documentation examples

**Verification checklist**:
1. Is this in a test file? (May be acceptable)
2. Is this a placeholder/example value?
3. Is this actually used in production code?
4. Does the value look real (long, random-looking)?

### Examples

**Critical - Real API Key**:
```typescript
// ❌ CRITICAL: Hardcoded Stripe API key
const stripe = new Stripe('sk_live_51H4xzKLwP3...', {
  apiVersion: '2020-08-27',
});
```

**Severity**: Critical
**Risk**: API key exposed in code/git history, can be used to make unauthorized API calls
**Recommendation**: Move to environment variable
```typescript
// ✅ Correct approach
const stripe = new Stripe(process.env.STRIPE_API_KEY, {
  apiVersion: '2020-08-27',
});
```

**Critical - Database Password**:
```python
# ❌ CRITICAL: Hardcoded database credentials
db_config = {
    'host': 'prod-db.company.com',
    'user': 'admin',
    'password': 'P@ssw0rd123!',
    'database': 'production'
}
```

**Severity**: Critical
**Risk**: Database credentials exposed, full database access
**Recommendation**: Use environment variables
```python
# ✅ Correct approach
import os

db_config = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}
```

**Acceptable - Test Fixture**:
```typescript
// ✅ OK: Test fixture (if in test file)
describe('Auth', () => {
  const testUser = {
    email: 'test@example.com',
    password: 'test-password-123'
  };
});
```

**Severity**: N/A (acceptable in tests)

---

## 2. Injection Vulnerabilities

### SQL Injection

**Risk**: Attacker can execute arbitrary SQL commands

**Detection patterns**:
```bash
# String concatenation in SQL queries
grep -rn "SELECT.*+\|INSERT.*+\|UPDATE.*+\|DELETE.*+" src/
grep -rn "query.*\${}\|query.*\`\${" src/

# String interpolation in SQL
grep -rn "execute.*\${}\|db\.query.*\${}" src/

# Python string formatting in SQL
grep -rn "\.format(\|%s.*%" src/ | grep -i "select\|insert\|update\|delete"
```

**Vulnerable Examples**:

**JavaScript/TypeScript - Critical**:
```typescript
// ❌ CRITICAL: SQL Injection via string concatenation
app.get('/users/:id', async (req, res) => {
  const userId = req.params.id;
  const query = `SELECT * FROM users WHERE id = ${userId}`;
  const user = await db.query(query);
  res.json(user);
});
```

**Attack**: `/users/1 OR 1=1` returns all users
**Severity**: Critical
**Recommendation**: Use parameterized queries
```typescript
// ✅ Safe: Parameterized query
app.get('/users/:id', async (req, res) => {
  const userId = req.params.id;
  const user = await db.query(
    'SELECT * FROM users WHERE id = ?',
    [userId]
  );
  res.json(user);
});
```

**Python - Critical**:
```python
# ❌ CRITICAL: SQL Injection via string formatting
def get_user(user_id):
    query = f"SELECT * FROM users WHERE id = {user_id}"
    return db.execute(query)
```

**Recommendation**:
```python
# ✅ Safe: Parameterized query
def get_user(user_id):
    query = "SELECT * FROM users WHERE id = ?"
    return db.execute(query, (user_id,))
```

**ORM Usage** (Generally Safe):
```typescript
// ✅ Safe: ORM with parameterization
const user = await User.findOne({ where: { id: userId } });
```

---

### Command Injection

**Risk**: Attacker can execute arbitrary system commands

**Detection patterns**:
```bash
# Dangerous command execution functions
grep -rn "\bexec\b\|\bsystem\b\|shell_exec\|child_process" src/
grep -rn "spawn\|execSync\|execFile" src/

# User input in commands
grep -rn "exec.*req\.\|spawn.*req\.\|system.*input" src/
```

**Vulnerable Examples**:

**Node.js - Critical**:
```typescript
// ❌ CRITICAL: Command injection
app.post('/convert', (req, res) => {
  const filename = req.body.filename;
  exec(`convert ${filename} output.pdf`, (error, stdout) => {
    res.send('Converted');
  });
});
```

**Attack**: `filename = "file.jpg; rm -rf /"`
**Severity**: Critical
**Recommendation**: Validate input and use safe alternatives
```typescript
// ✅ Safe: Input validation + safe execution
const path = require('path');
const { execFile } = require('child_process');

app.post('/convert', (req, res) => {
  const filename = path.basename(req.body.filename); // Remove path traversal

  // Whitelist validation
  if (!/^[\w\-]+\.(jpg|png)$/.test(filename)) {
    return res.status(400).send('Invalid filename');
  }

  // Use execFile with array args (no shell injection)
  execFile('convert', [filename, 'output.pdf'], (error, stdout) => {
    res.send('Converted');
  });
});
```

**Python - Critical**:
```python
# ❌ CRITICAL: Command injection
import os

def backup_file(filename):
    os.system(f"cp {filename} /backup/")
```

**Recommendation**:
```python
# ✅ Safe: Use subprocess with list args
import subprocess
import shutil

def backup_file(filename):
    # Better: Use shutil for file operations
    shutil.copy(filename, '/backup/')

    # Or subprocess with list (no shell)
    subprocess.run(['cp', filename, '/backup/'], check=True)
```

---

### Cross-Site Scripting (XSS)

**Risk**: Attacker can inject malicious scripts into web pages

**Detection patterns**:
```bash
# Dangerous innerHTML usage
grep -rn "innerHTML\s*=" src/

# React dangerous props
grep -rn "dangerouslySetInnerHTML" src/

# Unescaped template output
grep -rn "<%=\|{{{\|{!!.*!!}" src/

# document.write
grep -rn "document\.write" src/
```

**Vulnerable Examples**:

**React - Warning**:
```typescript
// ⚠️ WARNING: Potential XSS via dangerouslySetInnerHTML
function MessageComponent({ message }) {
  return (
    <div dangerouslySetInnerHTML={{ __html: message.content }} />
  );
}
```

**Attack**: `message.content = "<img src=x onerror='alert(document.cookie)'>")`
**Severity**: Warning (could be Critical if user-generated content)
**Recommendation**: Sanitize HTML or use safe rendering
```typescript
// ✅ Safe: Use text rendering (React auto-escapes)
function MessageComponent({ message }) {
  return <div>{message.content}</div>;
}

// ✅ Safe: Sanitize if HTML is required
import DOMPurify from 'dompurify';

function MessageComponent({ message }) {
  const sanitized = DOMPurify.sanitize(message.content);
  return <div dangerouslySetInnerHTML={{ __html: sanitized }} />;
}
```

**Vanilla JavaScript - Critical**:
```javascript
// ❌ CRITICAL: XSS via innerHTML
function displayUsername(username) {
  document.getElementById('user').innerHTML = `Welcome ${username}!`;
}
```

**Attack**: `username = "<script>steal_cookies()</script>"`
**Recommendation**:
```javascript
// ✅ Safe: Use textContent
function displayUsername(username) {
  document.getElementById('user').textContent = `Welcome ${username}!`;
}
```

---

### Path Traversal

**Risk**: Attacker can access files outside intended directory

**Detection patterns**:
```bash
# User input in file paths
grep -rn "readFile.*req\|writeFile.*req" src/
grep -rn "path\.join.*req\.\|path\.resolve.*req\." src/
grep -rn "open.*input\|fopen.*input" src/
```

**Vulnerable Examples**:

**Node.js - Critical**:
```typescript
// ❌ CRITICAL: Path traversal vulnerability
app.get('/download/:filename', (req, res) => {
  const filename = req.params.filename;
  res.sendFile(`./uploads/${filename}`);
});
```

**Attack**: `/download/../../etc/passwd`
**Severity**: Critical
**Recommendation**: Validate and sanitize file paths
```typescript
// ✅ Safe: Validate path
const path = require('path');

app.get('/download/:filename', (req, res) => {
  const filename = path.basename(req.params.filename); // Remove directory
  const filepath = path.join('./uploads', filename);

  // Verify resolved path is within uploads directory
  const uploadsDir = path.resolve('./uploads');
  const requestedPath = path.resolve(filepath);

  if (!requestedPath.startsWith(uploadsDir)) {
    return res.status(400).send('Invalid file path');
  }

  res.sendFile(requestedPath);
});
```

**Python - Critical**:
```python
# ❌ CRITICAL: Path traversal
def read_user_file(filename):
    with open(f"./files/{filename}", 'r') as f:
        return f.read()
```

**Recommendation**:
```python
# ✅ Safe: Path validation
import os

def read_user_file(filename):
    # Use basename to prevent directory traversal
    safe_filename = os.path.basename(filename)

    # Construct and validate path
    base_dir = os.path.abspath('./files')
    file_path = os.path.abspath(os.path.join(base_dir, safe_filename))

    # Ensure file is within base directory
    if not file_path.startswith(base_dir):
        raise ValueError("Invalid file path")

    with open(file_path, 'r') as f:
        return f.read()
```

---

## 3. Dangerous Functions

### eval() and exec()

**Risk**: Arbitrary code execution

**Detection**:
```bash
grep -rn "\beval\s*(\|Function\s*(" src/
grep -rn "\bexec\s*(\|compile\s*(" src/
```

**Examples**:

**JavaScript - Critical**:
```javascript
// ❌ CRITICAL: eval() with user input
app.post('/calculate', (req, res) => {
  const expression = req.body.expression;
  const result = eval(expression);
  res.json({ result });
});
```

**Attack**: `expression = "process.exit()"`
**Severity**: Critical
**Recommendation**: Use safe alternatives
```javascript
// ✅ Safe: Use math parser library
const math = require('mathjs');

app.post('/calculate', (req, res) => {
  const expression = req.body.expression;
  try {
    const result = math.evaluate(expression);
    res.json({ result });
  } catch (error) {
    res.status(400).json({ error: 'Invalid expression' });
  }
});
```

---

### Unsafe Deserialization

**Risk**: Object injection, remote code execution

**Detection**:
```bash
# JavaScript/Node.js
grep -rn "JSON\.parse.*req\." src/

# Python
grep -rn "pickle\.loads\|yaml\.load[^_]" src/

# Ruby
grep -rn "Marshal\.load" src/
```

**Examples**:

**Node.js - Warning**:
```typescript
// ⚠️ WARNING: Deserializing untrusted data
app.post('/restore', (req, res) => {
  const data = JSON.parse(req.body.data);
  Object.assign(config, data); // Potential prototype pollution
});
```

**Severity**: Warning
**Recommendation**: Validate structure
```typescript
// ✅ Safe: Validate before merging
const Joi = require('joi');

const schema = Joi.object({
  theme: Joi.string().valid('light', 'dark'),
  language: Joi.string().valid('en', 'es', 'fr')
});

app.post('/restore', (req, res) => {
  const { error, value } = schema.validate(JSON.parse(req.body.data));
  if (error) {
    return res.status(400).json({ error: error.details });
  }
  Object.assign(config, value);
});
```

**Python - Critical**:
```python
# ❌ CRITICAL: Unsafe pickle deserialization
import pickle

def load_user_data(data):
    return pickle.loads(data)  # Can execute arbitrary code
```

**Severity**: Critical
**Recommendation**: Use safe serialization
```python
# ✅ Safe: Use JSON for untrusted data
import json

def load_user_data(data):
    return json.loads(data)  # Safe, no code execution
```

---

### Weak Random for Security

**Risk**: Predictable values in security contexts

**Detection**:
```bash
# JavaScript
grep -rn "Math\.random()" src/ | grep -i "token\|password\|key\|session"

# Python
grep -rn "random\." src/ | grep -i "token\|password\|key\|secret"
```

**Examples**:

**JavaScript - Critical**:
```typescript
// ❌ CRITICAL: Weak random for security token
function generateSessionToken() {
  return Math.random().toString(36).substring(7);
}
```

**Severity**: Critical
**Recommendation**: Use crypto random
```typescript
// ✅ Safe: Cryptographically secure random
const crypto = require('crypto');

function generateSessionToken() {
  return crypto.randomBytes(32).toString('hex');
}
```

**Python - Critical**:
```python
# ❌ CRITICAL: Weak random for password reset token
import random
import string

def generate_reset_token():
    return ''.join(random.choices(string.ascii_letters, k=32))
```

**Recommendation**:
```python
# ✅ Safe: Cryptographically secure random
import secrets

def generate_reset_token():
    return secrets.token_urlsafe(32)
```

---

## 4. Authentication & Authorization

### Missing Authentication

**Detection**:
```bash
# Find API routes without auth middleware
grep -rn "app\.\(get\|post\|put\|delete\)" src/ | grep -v "auth\|isAuthenticated"

# Find handlers without auth checks
grep -rn "async.*handler\|function.*handler" src/
```

**Examples**:

**Express - Critical**:
```typescript
// ❌ CRITICAL: Sensitive endpoint without auth
app.delete('/api/users/:id', async (req, res) => {
  await User.delete(req.params.id);
  res.json({ success: true });
});
```

**Severity**: Critical
**Recommendation**: Add authentication middleware
```typescript
// ✅ Safe: Auth required
const { requireAuth, requireAdmin } = require('./middleware/auth');

app.delete('/api/users/:id',
  requireAuth,
  requireAdmin,
  async (req, res) => {
    await User.delete(req.params.id);
    res.json({ success: true });
  }
);
```

---

### Missing Authorization

**Risk**: Users can access resources they shouldn't

**Detection**:
```bash
# Find operations without permission checks
grep -rn "delete\|update\|modify" src/ | grep -v "can\|authorize\|permission"
```

**Examples**:

**Critical - No Ownership Check**:
```typescript
// ❌ CRITICAL: Users can delete any post
app.delete('/api/posts/:id', requireAuth, async (req, res) => {
  await Post.delete(req.params.id); // No check if user owns this post
  res.json({ success: true });
});
```

**Severity**: Critical
**Recommendation**: Verify ownership
```typescript
// ✅ Safe: Check ownership
app.delete('/api/posts/:id', requireAuth, async (req, res) => {
  const post = await Post.findById(req.params.id);

  if (!post) {
    return res.status(404).json({ error: 'Post not found' });
  }

  if (post.authorId !== req.user.id && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Not authorized' });
  }

  await post.delete();
  res.json({ success: true });
});
```

---

### Insecure Session Management

**Detection**:
```bash
# Find session configuration
grep -rn "session\|cookie" src/ | grep -i "secure\|httponly\|samesite"
```

**Examples**:

**Warning - Insecure Cookies**:
```typescript
// ⚠️ WARNING: Insecure session configuration
app.use(session({
  secret: 'my-secret',
  cookie: {
    secure: false,      // Should be true in production
    httpOnly: false,    // Should be true
    sameSite: 'none'    // Should be 'strict' or 'lax'
  }
}));
```

**Severity**: Warning
**Recommendation**: Secure cookie settings
```typescript
// ✅ Safe: Secure session configuration
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    secure: true,        // HTTPS only
    httpOnly: true,      // Prevents XSS from stealing cookies
    sameSite: 'strict',  // CSRF protection
    maxAge: 3600000      // 1 hour expiration
  },
  resave: false,
  saveUninitialized: false
}));
```

---

## 5. Reporting Format

### Security Finding Template

```markdown
### [SECURITY] [Category] - [Brief Description]

**Location**: `file.ts:123`
**Severity**: Critical | Warning | Info
**CWE**: [CWE-XX] (if applicable)

**Vulnerability**:
[Clear description of the security issue]

**Vulnerable Code**:
```[language]
[Code showing the vulnerability]
```

**Attack Scenario**:
[Concrete example of how this could be exploited]

**Impact**:
- [What attacker can achieve]
- [Data at risk]
- [System impact]

**Recommendation**:
[Specific fix instructions]

**Secure Implementation**:
```[language]
[Code showing the fix]
```

**Priority**: [Immediate/High/Medium] - [Why]
```

---

## Summary

This guide provides comprehensive patterns for detecting security vulnerabilities. Always verify findings to reduce false positives, and provide clear remediation guidance. Security issues should be prioritized by severity and fixed before production deployment.
