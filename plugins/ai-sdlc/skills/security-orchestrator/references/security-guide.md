# Security Guide

Comprehensive reference covering security scanning tools, fix patterns, verification methods, and compliance frameworks.

## Table of Contents

1. [Security Scanning Tools](#security-scanning-tools)
2. [Common Fix Patterns](#common-fix-patterns)
3. [Verification Methods](#verification-methods)
4. [Compliance Frameworks](#compliance-frameworks)

---

# Security Scanning Tools

## Dependency Vulnerability Scanners

### Node.js / npm

**npm audit** (Built-in):
```bash
# Run audit
npm audit

# JSON output
npm audit --json

# Fix vulnerabilities automatically
npm audit fix

# Force fix (may introduce breaking changes)
npm audit fix --force

# Audit specific severity
npm audit --audit-level=moderate
```

**Snyk**:
```bash
# Install
npm install -g snyk

# Authenticate
snyk auth

# Test for vulnerabilities
snyk test

# Fix vulnerabilities
snyk fix

# Monitor project
snyk monitor
```

### Python

**pip-audit**:
```bash
# Install
pip install pip-audit

# Scan
pip-audit

# JSON output
pip-audit --format json

# Scan requirements.txt
pip-audit -r requirements.txt
```

**safety**:
```bash
# Install
pip install safety

# Check installed packages
safety check

# JSON output
safety check --json

# Check requirements file
safety check -r requirements.txt
```

### Java / Maven

**OWASP Dependency-Check**:
```bash
# Download from https://owasp.org/www-project-dependency-check/

# Run scan
dependency-check --project "MyProject" --scan . --format JSON

# With suppression file
dependency-check --project "MyProject" --scan . \
  --suppression suppression.xml
```

**Snyk for Java**:
```bash
snyk test --file=pom.xml
```

### Ruby

**bundle audit**:
```bash
# Install
gem install bundler-audit

# Update vulnerability database
bundle audit update

# Check for vulnerabilities
bundle audit check

# JSON output
bundle audit check --format json
```

## Static Code Analysis Tools

### JavaScript / TypeScript

**ESLint with security plugins**:
```bash
# Install
npm install eslint eslint-plugin-security --save-dev

# Configure (.eslintrc.json)
{
  "plugins": ["security"],
  "extends": ["plugin:security/recommended"]
}

# Run
npx eslint .
```

**SonarQube**:
```bash
# Run sonar-scanner
sonar-scanner \
  -Dsonar.projectKey=myproject \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000
```

### Python

**Bandit**:
```bash
# Install
pip install bandit

# Scan
bandit -r src/

# JSON output
bandit -r src/ -f json -o bandit-report.json
```

**Semgrep**:
```bash
# Install
pip install semgrep

# Scan with security rules
semgrep --config=auto src/
```

### Multi-Language

**CodeQL**:
```bash
# Initialize database
codeql database create mydb --language=javascript

# Run queries
codeql database analyze mydb \
  --format=sarif-latest \
  --output=results.sarif
```

---

# Common Fix Patterns

## SQL Injection Fixes

### JavaScript/Node.js

**Bad** (String concatenation):
```javascript
const userId = req.query.id;
const query = `SELECT * FROM users WHERE id = ${userId}`;
db.execute(query);
```

**Good** (Parameterized query):
```javascript
const userId = req.query.id;
const query = 'SELECT * FROM users WHERE id = ?';
db.execute(query, [userId]);
```

**Good** (ORM - Sequelize):
```javascript
const userId = req.query.id;
const user = await User.findByPk(userId);
```

### Python

**Bad** (String formatting):
```python
user_id = request.args.get('id')
query = f"SELECT * FROM users WHERE id = {user_id}"
cursor.execute(query)
```

**Good** (Parameterized):
```python
user_id = request.args.get('id')
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))
```

**Good** (ORM - SQLAlchemy):
```python
user_id = request.args.get('id')
user = User.query.get(user_id)
```

## XSS Fixes

### React

**Bad** (dangerouslySetInnerHTML):
```javascript
function Comment({ text }) {
  return <div dangerouslySetInnerHTML={{ __html: text }} />;
}
```

**Good** (Auto-escaped):
```javascript
function Comment({ text }) {
  return <div>{text}</div>;
}
```

**Good** (Sanitized HTML):
```javascript
import DOMPurify from 'dompurify';

function Comment({ html }) {
  const clean = DOMPurify.sanitize(html);
  return <div dangerouslySetInnerHTML={{ __html: clean }} />;
}
```

### Plain JavaScript

**Bad** (innerHTML):
```javascript
element.innerHTML = userInput;
```

**Good** (textContent):
```javascript
element.textContent = userInput;
```

**Good** (Create text node):
```javascript
const textNode = document.createTextNode(userInput);
element.appendChild(textNode);
```

## Command Injection Fixes

### Node.js

**Bad** (String concatenation with exec):
```javascript
const filename = req.query.file;
exec(`cat ${filename}`, (error, stdout) => {
  res.send(stdout);
});
```

**Good** (Avoid shell, use array):
```javascript
const filename = req.query.file;
// Validate filename first
if (!/^[a-zA-Z0-9._-]+$/.test(filename)) {
  return res.status(400).send('Invalid filename');
}

execFile('cat', [filename], (error, stdout) => {
  res.send(stdout);
});
```

**Best** (Don't execute commands from user input):
```javascript
const filename = req.query.file;
fs.readFile(path.join('/safe/path', filename), 'utf8', (err, data) => {
  res.send(data);
});
```

## Weak Hashing Fixes

### JavaScript/Node.js

**Bad** (MD5):
```javascript
const crypto = require('crypto');
const hash = crypto.createHash('md5').update(password).digest('hex');
```

**Good** (bcrypt):
```javascript
const bcrypt = require('bcrypt');
const saltRounds = 12;
const hash = await bcrypt.hash(password, saltRounds);

// Verify
const match = await bcrypt.compare(password, hash);
```

### Python

**Bad** (MD5):
```python
import hashlib
hash = hashlib.md5(password.encode()).hexdigest()
```

**Good** (bcrypt):
```python
import bcrypt

# Hash
salt = bcrypt.gensalt(rounds=12)
hash = bcrypt.hashpw(password.encode(), salt)

# Verify
match = bcrypt.checkpw(password.encode(), hash)
```

## Hardcoded Secrets Fixes

**Bad** (Hardcoded):
```javascript
const API_KEY = 'sk_live_abc123xyz789';
const dbPassword = 'MyPassword123!';
```

**Good** (Environment variables):
```javascript
require('dotenv').config();
const API_KEY = process.env.STRIPE_API_KEY;
const dbPassword = process.env.DB_PASSWORD;
```

**.env file** (NOT committed to git):
```bash
STRIPE_API_KEY=sk_live_abc123xyz789
DB_PASSWORD=MyPassword123!
```

**.gitignore**:
```
.env
.env.local
*.key
*.pem
```

## Missing Security Headers Fixes

### Express.js

**Without helmet**:
```javascript
const express = require('express');
const app = express();
// No security headers
```

**With helmet**:
```javascript
const express = require('express');
const helmet = require('helmet');
const app = express();

app.use(helmet());

// Custom CSP
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    scriptSrc: ["'self'"],
    imgSrc: ["'self'", "data:", "https:"],
  }
}));
```

### Django

**settings.py**:
```python
# Security middleware
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    # ...other middleware
]

# Security headers
SECURE_BROWSER_XSS_FILTER = True
X_FRAME_OPTIONS = 'DENY'
SECURE_CONTENT_TYPE_NOSNIFF = True

# HTTPS
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# HSTS
SECURE_HSTS_SECONDS = 31536000  # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
```

## CORS Misconfiguration Fixes

**Bad** (Allow all origins):
```javascript
app.use(cors({
  origin: '*'
}));
```

**Good** (Whitelist specific origins):
```javascript
const allowedOrigins = [
  'https://myapp.com',
  'https://www.myapp.com'
];

app.use(cors({
  origin: function(origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));
```

## Authentication Fixes

### Missing Rate Limiting

**Bad** (No rate limiting):
```javascript
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  // Vulnerable to brute force
  const user = await authenticate(username, password);
  res.json({ token: user.token });
});
```

**Good** (With rate limiting):
```javascript
const rateLimit = require('express-rate-limit');

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts, please try again later'
});

app.post('/login', loginLimiter, async (req, res) => {
  const { username, password } = req.body;
  const user = await authenticate(username, password);
  res.json({ token: user.token });
});
```

### Weak Password Policy

**Bad** (No validation):
```javascript
function validatePassword(password) {
  return password.length > 0;
}
```

**Good** (Strong validation):
```javascript
function validatePassword(password) {
  // Minimum 12 characters
  if (password.length < 12) return false;

  // Require uppercase
  if (!/[A-Z]/.test(password)) return false;

  // Require lowercase
  if (!/[a-z]/.test(password)) return false;

  // Require number
  if (!/[0-9]/.test(password)) return false;

  // Require special character
  if (!/[!@#$%^&*]/.test(password)) return false;

  return true;
}
```

---

# Verification Methods

## Manual Code Review

**SQL Injection Verification**:
```bash
# Search for parameterized queries
grep -r "execute\|query" src/ | grep "?"

# Search for string concatenation (bad)
grep -r "query.*+\|SELECT.*\${" src/
```

**XSS Verification**:
```bash
# Check for safe rendering
grep -r "textContent\|createTextNode" src/

# Check for dangerous rendering (should be 0)
grep -r "innerHTML\|dangerouslySetInnerHTML" src/
```

## Automated Security Scanning

**Re-run Dependency Scanners**:
```bash
# npm
npm audit --audit-level=moderate

# Python
pip-audit

# Expected: 0 vulnerabilities
```

**Re-run Static Analysis**:
```bash
# ESLint
npx eslint . --ext .js,.jsx,.ts,.tsx

# Bandit (Python)
bandit -r src/

# Expected: No security issues
```

## Penetration Testing

### SQL Injection Test

```bash
# Test with malicious input
curl "http://localhost:3000/users?id=' OR '1'='1"

# Expected: 400 Bad Request or empty result, NOT all users
```

### XSS Test

```bash
# Test script injection in comments
curl -X POST http://localhost:3000/comments \
  -H "Content-Type: application/json" \
  -d '{"text":"<script>alert(1)</script>"}'

# View comment
curl http://localhost:3000/comments/123

# Expected: Escaped HTML (&lt;script&gt;), NOT executable script
```

### Authentication Test

```bash
# Test brute force protection
for i in {1..10}; do
  curl -X POST http://localhost:3000/login \
    -d "username=admin&password=wrong"
done

# Expected: After 5 attempts, rate limit error (429)
```

## Integration Testing

**Test Security Headers**:
```javascript
const request = require('supertest');
const app = require('./app');

test('should return security headers', async () => {
  const response = await request(app).get('/');

  expect(response.headers['x-frame-options']).toBe('DENY');
  expect(response.headers['x-content-type-options']).toBe('nosniff');
  expect(response.headers['strict-transport-security']).toBeDefined();
});
```

**Test CSRF Protection**:
```javascript
test('should reject POST without CSRF token', async () => {
  const response = await request(app)
    .post('/api/data')
    .send({ data: 'test' });

  expect(response.status).toBe(403);
});
```

---

# Compliance Frameworks

## GDPR (EU)

**Key Requirements**:
1. **Lawful Basis** (Article 6): Consent, contract, legal obligation, vital interests, public task, legitimate interests
2. **Consent** (Article 7): Freely given, specific, informed, unambiguous
3. **Right to Access** (Article 15): Provide copy of personal data
4. **Right to Rectification** (Article 16): Correct inaccurate data
5. **Right to Erasure** (Article 17): Delete personal data ("right to be forgotten")
6. **Data Portability** (Article 20): Provide data in machine-readable format
7. **Breach Notification** (Article 33): Notify within 72 hours

**Implementation Checklist**:
- [ ] Privacy policy accessible and clear
- [ ] Consent mechanism (opt-in, not opt-out)
- [ ] Data export API (JSON/CSV format)
- [ ] Account deletion with cascading data removal
- [ ] Incident response plan documented
- [ ] Data retention policies defined
- [ ] Data minimization (collect only necessary data)

## HIPAA (US Healthcare)

**Key Requirements**:

**Administrative Safeguards**:
- Security management process
- Assigned security responsibility
- Workforce security and training
- Information access management
- Security awareness training

**Physical Safeguards**:
- Facility access controls
- Workstation and device security

**Technical Safeguards** (§164.312):
1. **Access Control**: Unique user identification, automatic logoff
2. **Audit Controls**: Hardware, software, procedural mechanisms to record and examine activity
3. **Integrity**: Protect PHI from unauthorized alteration or destruction
4. **Transmission Security**: Protect PHI transmitted over electronic networks

**Implementation Checklist**:
- [ ] Unique user IDs required
- [ ] Role-based access control
- [ ] Automatic session timeout (15 minutes)
- [ ] All PHI access logged (who, what, when)
- [ ] Audit logs immutable and retained 6 years
- [ ] PHI encrypted in transit (TLS 1.2+)
- [ ] PHI encrypted at rest (AES-256)
- [ ] Emergency access procedures documented

## SOC 2 (Trust Services Criteria)

**Five Trust Service Criteria**:

**1. Security** (Common Criteria - Required):
- Access controls (authentication, authorization)
- Logical and physical access
- System operations (monitoring, change management)
- Change management
- Risk mitigation

**2. Availability**:
- System performance monitoring
- Incident handling
- Backup and recovery

**3. Processing Integrity**:
- Quality assurance
- Input completeness and accuracy

**4. Confidentiality**:
- Data classification
- Encryption
- Disposal

**5. Privacy**:
- Notice and communication
- Choice and consent
- Collection and retention
- Use and disclosure

**Implementation Checklist**:
- [ ] MFA for admin accounts
- [ ] Strong password policy (12+ chars, complexity)
- [ ] Role-based access control
- [ ] Version control (git)
- [ ] Code review process
- [ ] CI/CD with automated testing
- [ ] Application monitoring (uptime, errors)
- [ ] Automated backups
- [ ] Incident response plan
- [ ] Security awareness training

## PCI DSS (Payment Card Data)

**12 Requirements**:

1. **Firewall**: Install and maintain firewall configuration
2. **Passwords**: Don't use vendor-supplied defaults
3. **Cardholder Data**: Protect stored cardholder data
4. **Encryption**: Encrypt transmission of cardholder data
5. **Anti-Virus**: Use and update anti-virus software
6. **Systems**: Develop and maintain secure systems
7. **Access**: Restrict access to cardholder data by business need-to-know
8. **Unique IDs**: Assign unique ID to each person with computer access
9. **Physical Access**: Restrict physical access to cardholder data
10. **Monitoring**: Track and monitor access to network and cardholder data
11. **Testing**: Regularly test security systems and processes
12. **Policy**: Maintain information security policy

**Implementation Checklist** (for developers):
- [ ] Never store full PAN (use tokenization)
- [ ] Never store CVV/CVC
- [ ] Mask PAN when displayed (show only last 4 digits)
- [ ] Encrypt PAN if must be stored (AES-256)
- [ ] Transmit card data only over TLS 1.2+
- [ ] Log all payment transactions
- [ ] Implement strong access controls
- [ ] Use payment gateway (Stripe, Square) - avoid handling raw card data

**Note**: Full PCI DSS compliance requires infrastructure, not just code.

---

## Quick Reference: Compliance by Industry

| Industry | Applicable Frameworks |
|----------|----------------------|
| Healthcare | HIPAA, GDPR (if EU patients), HITECH |
| Finance | PCI DSS (if payments), SOX, GDPR, GLBA |
| SaaS | SOC 2, GDPR, CCPA |
| E-commerce | PCI DSS, GDPR, CCPA |
| Government | FedRAMP, FISMA, NIST |
| Education | FERPA, GDPR |

---

This guide provides practical patterns and verification methods for systematic security remediation and compliance.
