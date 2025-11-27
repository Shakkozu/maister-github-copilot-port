# Continuous Standards Discovery Guide

This guide explains how to continuously discover and apply standards throughout implementation.

## Core Principle

**Not all standards are obvious at the beginning of implementation.**

As you progress through implementation, different standards become relevant at different times. Continuous discovery ensures you don't miss applicable standards.

## When to Check docs/INDEX.md

### 1. Initial Check (Phase 1)
**Purpose**: Understand what's available

```bash
cat .ai-sdlc/docs/INDEX.md
```

**What to identify**:
- Available standards directories (global/, frontend/, backend/, testing/)
- Project documentation (vision, roadmap, tech-stack, architecture)
- Any project-specific guidelines

**Output**: Mental map of available resources

### 2. Before Each Task Group (Phase 2)
**Purpose**: Identify standards for specialty area

**Example - Database Task Group**:
```bash
# Check INDEX.md for database-related standards
cat .ai-sdlc/docs/INDEX.md | grep -i database

# Read relevant standards
cat .ai-sdlc/docs/standards/backend/database.md
cat .ai-sdlc/docs/standards/global/naming-conventions.md
```

**Example - Frontend Task Group**:
```bash
# Check INDEX.md for frontend standards
cat .ai-sdlc/docs/INDEX.md | grep -i frontend

# Read relevant standards
cat .ai-sdlc/docs/standards/frontend/components.md
cat .ai-sdlc/docs/standards/frontend/styling.md
cat .ai-sdlc/docs/standards/global/naming-conventions.md
```

### 3. During Step Analysis (Phase 2)
**Purpose**: Check if specific step triggers new standards

**Triggers for additional standards checks**:

| Step Content | Check These Standards |
|--------------|----------------------|
| "upload", "download", "file" | global/file-handling.md, backend/storage.md |
| "auth", "login", "permission" | global/security.md, backend/authentication.md |
| "email", "notification" | backend/email.md, global/external-services.md |
| "payment", "billing" | global/security.md, global/secrets.md, backend/payment.md |
| "form", "input" | frontend/forms.md, frontend/validation.md, global/accessibility.md |
| "API", "endpoint" | backend/api.md, global/error-handling.md |
| "test", "spec" | testing/unit-tests.md, testing/integration-tests.md |
| "migration", "schema" | backend/database.md, backend/migrations.md |

**Process**:
1. Read step description
2. Identify keywords
3. Check INDEX.md for related standards
4. Read newly discovered standards
5. Incorporate into planning/implementation

### 4. Before Applying Changes (Phase 2)
**Purpose**: Verify compliance before modifying files

**Checklist**:
```markdown
Before making changes to [file]:
- [ ] Re-read relevant standards for this file type
- [ ] Check if file follows existing project patterns
- [ ] Verify change aligns with discovered standards
- [ ] Confirm no new standards apply to this change
```

**Example**:
```bash
# Before modifying UserProfileForm.tsx
cat .ai-sdlc/docs/standards/frontend/components.md
cat .ai-sdlc/docs/standards/frontend/forms.md
cat .ai-sdlc/docs/standards/global/accessibility.md

# Look for form-related standards we might have missed
cat .ai-sdlc/docs/INDEX.md | grep -i "form\|input\|validation"
```

### 5. Final Check (Phase 3)
**Purpose**: Ensure nothing was missed

**Process**:
1. List all files modified
2. For each file, verify applicable standards
3. Check INDEX.md one more time for any missed standards
4. Review work-log.md for standards applied

**Final verification questions**:
- Did we apply all global/ standards?
- Did we apply all area-specific standards (frontend/backend/testing)?
- Did we discover standards late that we need to apply retroactively?
- Are there any patterns in modified files suggesting standards we missed?

## Discovery Patterns

### Pattern 1: Technology-Specific Standards

**When Working With**: Database models
**Check**: backend/database.md, backend/migrations.md, global/naming-conventions.md

**When Working With**: React components
**Check**: frontend/components.md, frontend/styling.md, frontend/state-management.md

**When Working With**: API endpoints
**Check**: backend/api.md, global/error-handling.md, global/security.md

### Pattern 2: Feature-Specific Standards

**When Implementing**: File uploads
**Check**: global/file-handling.md, global/security.md, backend/storage.md

**When Implementing**: Authentication
**Check**: global/security.md, global/secrets.md, backend/authentication.md, backend/sessions.md

**When Implementing**: Forms
**Check**: frontend/forms.md, frontend/validation.md, global/accessibility.md

**When Implementing**: External API integration
**Check**: global/external-services.md, global/secrets.md, backend/api-clients.md

### Pattern 3: Cross-Cutting Standards

**Always Applicable**:
- global/naming-conventions.md
- global/code-organization.md
- global/comments-documentation.md

**Often Applicable**:
- global/error-handling.md (when handling errors)
- global/security.md (when handling user data)
- global/performance.md (when building user-facing features)
- global/accessibility.md (when building UI)

## Real-World Discovery Examples

### Example 1: Discovering Accessibility Standards Late

**Scenario**: Implementing user profile editing form

**Initial standards identified**:
- frontend/components.md
- frontend/forms.md
- backend/api.md

**Implementation progress**:
1. Built database layer (applied backend/database.md)
2. Built API layer (applied backend/api.md)
3. Started frontend layer (applied frontend/components.md, frontend/forms.md)
4. **During form implementation**: Noticed accessibility concerns
5. **Checked INDEX.md again**: Found global/accessibility.md
6. **Applied retroactively**: Updated form with ARIA labels, keyboard navigation

**Lesson**: Accessibility standard wasn't obvious until building the form. Continuous checking revealed it at the right time.

### Example 2: Discovering External Services Standards

**Scenario**: Implementing email notifications

**Initial standards identified**:
- backend/email.md

**Implementation progress**:
1. Built email template system (applied backend/email.md)
2. **During API integration**: Needed to store API keys
3. **Checked INDEX.md again**: Found global/secrets.md, global/external-services.md
4. **Applied immediately**: Used environment variables, added error handling for external service

**Lesson**: External service standards became relevant when integrating with email provider. Initial planning didn't reveal these standards.

### Example 3: Discovering Security Standards During Payment Implementation

**Scenario**: Implementing payment processing

**Initial standards identified**:
- backend/api.md
- backend/database.md

**Implementation progress**:
1. Built payment model (applied backend/database.md)
2. **During payment form implementation**: Handling sensitive card data
3. **Checked INDEX.md again**: Found global/security.md, frontend/secure-forms.md, global/secrets.md
4. **Applied immediately**: Used secure form handling, encrypted data, environment variables for API keys
5. **During webhook implementation**: Needed signature verification
6. **Checked INDEX.md again**: Found backend/webhooks.md
7. **Applied immediately**: Added signature verification, replay protection

**Lesson**: Multiple standards discovered throughout implementation. Security standards revealed themselves at each step dealing with sensitive data.

## Discovery Checklist

Use this checklist throughout implementation:

### Initial Discovery (Phase 1)
- [ ] Read docs/INDEX.md completely
- [ ] List all available standards directories
- [ ] Note project documentation available
- [ ] Create mental map of resources

### Task Group Discovery (Phase 2 - Before Each Group)
- [ ] Re-read docs/INDEX.md
- [ ] Identify standards for this specialty (database/API/frontend/testing)
- [ ] Read all identified standards fully
- [ ] Note patterns to follow

### Step Discovery (Phase 2 - Before Each Step)
- [ ] Read step description and identify keywords
- [ ] Check INDEX.md for keyword-related standards
- [ ] Read any newly discovered standards
- [ ] Update implementation approach with new standards

### Pre-Change Discovery (Phase 2 - Before Each File Edit)
- [ ] List applicable standards for this file type
- [ ] Re-read relevant standards
- [ ] Check for any missed standards via INDEX.md search
- [ ] Verify change aligns with all standards

### Final Discovery (Phase 3)
- [ ] Review all modified files
- [ ] For each file, verify all applicable standards were applied
- [ ] Check INDEX.md one final time
- [ ] Document all standards applied in work-log.md

## Tools for Discovery

### Bash Commands

**List all standards**:
```bash
find .ai-sdlc/docs/standards -name "*.md" -type f | sort
```

**Search for keyword**:
```bash
grep -r "upload\|file\|attachment" .ai-sdlc/docs/standards/
```

**Check specific standard**:
```bash
cat .ai-sdlc/docs/standards/[area]/[standard].md
```

**Search INDEX.md**:
```bash
cat .ai-sdlc/docs/INDEX.md | grep -i [keyword]
```

### Read Tool

**Read INDEX.md**:
Use Read tool with path `.ai-sdlc/docs/INDEX.md`

**Read specific standard**:
Use Read tool with path `.ai-sdlc/docs/standards/[area]/[standard].md`

### Grep Tool

**Find standards mentioning keyword**:
Use Grep tool with pattern `[keyword]` and path `.ai-sdlc/docs/standards/`

## Integration with Work Log

Document standards discovery in `implementation/work-log.md`:

```markdown
## [YYYY-MM-DD HH:MM] - Standards Discovery

**Phase**: [Task Group 3 - Frontend Layer]
**Trigger**: [Implementing payment form]

**Newly Discovered Standards**:
- global/security.md (discovered when handling card data)
- frontend/secure-forms.md (discovered from INDEX.md search for "payment")

**Applied**:
- Used secure input fields for card data
- Implemented client-side validation without exposing card numbers
- Added HTTPS-only form submission

**Action**: Updated PaymentForm component with security standards
```

This creates an audit trail of continuous discovery and shows why certain standards were applied at specific times.

## Summary

**Key Takeaways**:

1. **Standards discovery is continuous** - Not a one-time activity
2. **Check docs/INDEX.md frequently** - At multiple phases
3. **Keywords trigger discovery** - Watch for patterns suggesting standards
4. **Apply immediately** - When discovered, apply before proceeding
5. **Document discovery** - Log what was found and when
6. **Verify at the end** - Final check ensures nothing missed

**Remember**: The goal is not to find all standards at the beginning (impossible), but to discover and apply them at the right time as implementation progresses.
