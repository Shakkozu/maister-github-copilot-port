# Configuration Management Guide

Guide for validating configuration management in production-ready applications.

---

## Environment Variables

### Required Environment Variables Pattern

**Detection**: Find all environment variable usage
```bash
grep -rn "process\.env\.\|os\.getenv\|ENV\[" src/
```

**What to Look For**:
- Database connection strings
- API keys for external services
- JWT secrets
- Session secrets
- Port numbers
- Environment names (dev/staging/prod)
- Feature flag configurations

### Documentation Check

**Required**: `.env.example` or `.env.template` file

**Example .env.example**:
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# External APIs
STRIPE_API_KEY=sk_test_...
SENDGRID_API_KEY=SG....

# Authentication
JWT_SECRET=your-secret-key-here-change-in-production
SESSION_SECRET=your-session-secret-here

# Application
NODE_ENV=production
PORT=3000
LOG_LEVEL=info

# Feature Flags
ENABLE_NEW_CHECKOUT=false
```

### Startup Validation

**Good Practice**: Validate on startup, fail fast if missing

**Example (Node.js)**:
```typescript
// config/env.ts
const requiredEnvVars = [
  'DATABASE_URL',
  'JWT_SECRET',
  'STRIPE_API_KEY'
];

for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    console.error(`Missing required environment variable: ${envVar}`);
    process.exit(1);
  }
}

export const config = {
  database: process.env.DATABASE_URL!,
  jwtSecret: process.env.JWT_SECRET!,
  stripeKey: process.env.STRIPE_API_KEY!,
  port: parseInt(process.env.PORT || '3000')
};
```

**Example (Python)**:
```python
import os
import sys

REQUIRED_ENV_VARS = [
    'DATABASE_URL',
    'JWT_SECRET',
    'STRIPE_API_KEY'
]

for var in REQUIRED_ENV_VARS:
    if not os.getenv(var):
        print(f"Missing required environment variable: {var}")
        sys.exit(1)

config = {
    'database_url': os.getenv('DATABASE_URL'),
    'jwt_secret': os.getenv('JWT_SECRET'),
    'stripe_key': os.getenv('STRIPE_API_KEY'),
    'port': int(os.getenv('PORT', '3000'))
}
```

---

## Secrets Management

### What Counts as a Secret?

**Always secrets**:
- Database passwords
- API keys for external services
- OAuth client secrets
- JWT signing keys
- Encryption keys
- Service account credentials
- Webhook secrets

**Not secrets (can be in code)**:
- Public API keys (if truly public)
- Application name
- Default port numbers
- Public URLs

### Detection Patterns

```bash
# Find potential hardcoded secrets
grep -rni "password\s*=\s*['\"].\+['\"]" src/ | grep -v "process.env"
grep -rni "api_key\s*=\s*['\"].\+['\"]" src/ | grep -v "process.env"
grep -rni "secret\s*=\s*['\"].\+['\"]" src/ | grep -v "process.env"

# Check for connection strings with embedded credentials
grep -rni "://.*:.*@" src/
```

### Proper Secrets Management

**Environment Variables** (minimum):
```typescript
const stripeKey = process.env.STRIPE_API_KEY;
```

**Secrets Manager** (recommended for production):
```typescript
// AWS Secrets Manager
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";

async function getSecret(secretName: string) {
  const client = new SecretsManagerClient({ region: "us-west-2" });
  const response = await client.send(
    new GetSecretValueCommand({ SecretId: secretName })
  );
  return JSON.parse(response.SecretString!);
}

const secrets = await getSecret("prod/myapp/secrets");
```

---

## Configuration Validation

### Type Validation

**Problem**: Environment variables are strings, need type conversion

**Bad**:
```typescript
const maxRetries = process.env.MAX_RETRIES; // string!
for (let i = 0; i < maxRetries; i++) { // Wrong! String comparison
  //...
}
```

**Good**:
```typescript
const maxRetries = parseInt(process.env.MAX_RETRIES || '3');
if (isNaN(maxRetries) || maxRetries < 0) {
  throw new Error('MAX_RETRIES must be a positive number');
}
```

### Schema Validation

**Use libraries for validation**:

**Example (Joi)**:
```typescript
import Joi from 'joi';

const envSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'staging', 'production').required(),
  PORT: Joi.number().port().default(3000),
  DATABASE_URL: Joi.string().uri().required(),
  JWT_SECRET: Joi.string().min(32).required(),
  LOG_LEVEL: Joi.string().valid('debug', 'info', 'warn', 'error').default('info')
});

const { error, value: config } = envSchema.validate(process.env, {
  allowUnknown: true,
  abortEarly: false
});

if (error) {
  console.error('Config validation error:', error.details);
  process.exit(1);
}

export default config;
```

---

## Environment-Specific Configuration

### Separate Configs Per Environment

**Pattern**: Use environment variable to determine which config to load

```typescript
// config/index.ts
import development from './development';
import staging from './staging';
import production from './production';

const env = process.env.NODE_ENV || 'development';

const configs = {
  development,
  staging,
  production
};

export default configs[env];
```

### Environment Detection

**Explicit is better than implicit**:

**Good**:
```typescript
const isProduction = process.env.NODE_ENV === 'production';
```

**Bad**:
```typescript
const isProduction = !process.env.NODE_ENV; // Ambiguous
```

---

## Feature Flags

### Purpose
- Enable/disable features without code deployment
- Gradual rollout of new features
- Quick rollback of problematic features
- A/B testing

### Simple Feature Flags

**Environment Variable Based**:
```typescript
// config/features.ts
export const features = {
  newCheckout: process.env.ENABLE_NEW_CHECKOUT === 'true',
  betaFeatures: process.env.ENABLE_BETA === 'true',
  maintenanceMode: process.env.MAINTENANCE_MODE === 'true'
};

// Usage
if (features.newCheckout) {
  return renderNewCheckout();
} else {
  return renderOldCheckout();
}
```

### Advanced Feature Flags

**Database or Service Based**:
```typescript
// services/featureFlags.ts
import { db } from './database';

export async function isFeatureEnabled(featureName: string): Promise<boolean> {
  const feature = await db.featureFlags.findOne({ name: featureName });
  return feature?.enabled || false;
}

// With user-specific targeting
export async function isFeatureEnabledForUser(
  featureName: string,
  userId: string
): Promise<boolean> {
  const feature = await db.featureFlags.findOne({ name: featureName });

  if (!feature?.enabled) return false;

  // Gradual rollout - 10% of users
  if (feature.rolloutPercentage) {
    const hash = hashString(userId);
    return (hash % 100) < feature.rolloutPercentage;
  }

  return true;
}
```

**External Service (LaunchDarkly, Split.io)**:
```typescript
import LaunchDarkly from 'launchdarkly-node-server-sdk';

const ldClient = LaunchDarkly.init(process.env.LAUNCHDARKLY_SDK_KEY!);

export async function isFeatureEnabled(
  featureName: string,
  user: { key: string; email?: string }
): Promise<boolean> {
  await ldClient.waitForInitialization();
  return await ldClient.variation(featureName, user, false);
}
```

---

## Configuration Best Practices

### 1. Twelve-Factor App Principles

**Store config in environment**:
- ✅ Environment variables
- ❌ Config files in version control (except templates)
- ❌ Hardcoded values

**Strict separation**:
- ✅ Separate config per environment
- ✅ No if/else based on environment in code
- ✅ Config injection

### 2. Security

**Secrets**:
- Never commit secrets to version control
- Use `.env.example` with dummy values
- Add `.env` to `.gitignore`
- Rotate secrets regularly
- Use secrets manager in production

**Access control**:
- Limit who can access production secrets
- Audit secret access
- Use different secrets per environment

### 3. Documentation

**Document all configuration**:
- What each variable does
- Required vs optional
- Default values
- Valid values/format
- Example values

### 4. Validation

**Validate early**:
- Validate on app startup
- Fail fast if invalid
- Provide clear error messages
- Type checking

---

## Detection Checklist

Use this checklist when analyzing configuration:

### Environment Variables
- [ ] All env vars documented in .env.example
- [ ] Required env vars validated at startup
- [ ] No hardcoded values in code
- [ ] Type conversion for numeric/boolean vars
- [ ] Default values for optional configs

### Secrets
- [ ] No hardcoded secrets in code
- [ ] Secrets loaded from environment/vault
- [ ] Different secrets per environment
- [ ] No secrets in version control
- [ ] No secrets in logs

### Feature Flags
- [ ] New/risky features behind flags
- [ ] Flags documented
- [ ] Ability to toggle without deployment

### Validation
- [ ] Config schema defined
- [ ] Validation on startup
- [ ] Clear error messages
- [ ] Type checking

---

## Common Issues

### Issue: Hardcoded Configuration

**Problem**:
```typescript
const dbConfig = {
  host: 'prod-db.company.com', // Hardcoded!
  port: 5432,
  database: 'production'
};
```

**Solution**:
```typescript
const dbConfig = {
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME
};
```

### Issue: Missing Validation

**Problem**: App starts with invalid config, fails later

**Solution**: Validate on startup
```typescript
if (!process.env.DATABASE_URL) {
  throw new Error('DATABASE_URL is required');
}
```

### Issue: Secrets in Code

**Problem**: API keys committed to git

**Solution**:
1. Remove from code
2. Add to .env
3. Use environment variable
4. Rotate the exposed secret

---

## Summary

Good configuration management:
- Externalizes all environment-specific values
- Validates configuration on startup
- Keeps secrets out of code and version control
- Documents all configuration variables
- Uses feature flags for risky changes

This enables safe, flexible deployments across environments.
