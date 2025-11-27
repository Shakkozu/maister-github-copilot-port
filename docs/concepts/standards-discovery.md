# Standards Discovery

How continuous standards checking works throughout implementation.

## Overview

Standards discovery is the process of continuously checking `.ai-sdlc/docs/INDEX.md` for project standards throughout workflow execution, not just at the start.

**Key Principle**: Standards become relevant as implementation progresses. Not all standards are obvious at the beginning.

## Why Continuous Discovery?

### Problem with One-Time Check

**Traditional approach** (check once at start):
```
Phase 1: Check INDEX.md for all standards
Phase 2: Apply standards from memory
Phase 3: Hope nothing was missed
```

**Issues**:
- ❌ Can't know all relevant standards upfront
- ❌ Standards forgotten by time they're needed
- ❌ Specialty-specific standards missed

### Solution: Continuous Discovery

**AI SDLC approach** (check throughout):
```
Phase 1: Check INDEX.md → Initial understanding
Phase 2: Check INDEX.md → Before each task group
Phase 3: Check INDEX.md → Before each step
Phase 4: Check INDEX.md → Before applying changes
Phase 5: Check INDEX.md → Final verification
```

**Benefits**:
- ✅ Standards discovered when relevant
- ✅ Fresh context at each check
- ✅ Specialty-specific standards found
- ✅ Nothing missed

## How It Works

### 1. Initial Check (Phase Start)

**When**: Beginning of implementation phase

**Purpose**: Understand available standards

**Reads**: Entire INDEX.md file

**Example**:
```markdown
# .ai-sdlc/docs/INDEX.md

## Global Standards
- Naming conventions
- Error handling
- Documentation

## Frontend Standards
- Component patterns
- State management
- Styling

## Backend Standards
- API design
- Database conventions
- Security practices
```

**Action**: Note categories available for later reference

---

### 2. Task Group Check (Before Each Group)

**When**: Before starting each task group (Database, API, Frontend, etc.)

**Purpose**: Find specialty-specific standards

**Example** - Before Frontend task group:
```
Task Group: Frontend Components

Checking INDEX.md for frontend standards...
Found:
- Component patterns (standards/frontend/component-patterns.md)
- State management (standards/frontend/state-management.md)
- Styling (standards/frontend/styling.md)

Loading these standards for context...
```

**Action**: Load relevant standards for this specialty

---

### 3. Step Check (Before Each Step)

**When**: Before executing each implementation step

**Purpose**: Check if new standards apply to this specific action

**Example** - Before implementing error handling:
```
Step 2.3: Implement file upload validation

Checking INDEX.md for error handling standards...
Found:
- Error handling (standards/global/error-handling.md)

This is relevant → Load standard
```

**Action**: Load newly relevant standards

---

### 4. Pre-Change Check (Before Applying Changes)

**When**: Before writing/editing code files

**Purpose**: Final compliance verification

**Example**:
```
About to modify: src/components/AvatarUpload.tsx

Checking INDEX.md for applicable standards...
- Component patterns: ✓ Loaded
- Naming conventions: ✓ Loaded
- Error handling: ✓ Loaded

All relevant standards applied → Proceed
```

**Action**: Verify all standards followed

---

### 5. Final Check (Phase End)

**When**: End of implementation phase

**Purpose**: Ensure nothing missed

**Example**:
```
Implementation complete. Final standards check...

Applied:
✓ Component patterns (5 components)
✓ API design (3 endpoints)
✓ Error handling (all functions)
✓ Naming conventions (consistent)

Not applied:
- Performance optimization (not relevant for this task)
- Accessibility (no UI changes)

Result: 4/4 relevant standards applied
```

**Action**: Document standards compliance in work-log.md

## Standards Organization

### INDEX.md Structure

```markdown
# Documentation Index

## Project Documentation
- [Vision](project/vision.md)
- [Roadmap](project/roadmap.md)
- [Tech Stack](project/tech-stack.md)

## Global Standards
- [Naming Conventions](standards/global/naming-conventions.md)
- [Error Handling](standards/global/error-handling.md)
- [Documentation](standards/global/documentation.md)

## Frontend Standards
- [Component Patterns](standards/frontend/component-patterns.md)
- [State Management](standards/frontend/state-management.md)

## Backend Standards
- [API Design](standards/backend/api-design.md)
- [Database Conventions](standards/backend/database-conventions.md)

## Testing Standards
- [Unit Testing](standards/testing/unit-testing.md)
- [Integration Testing](standards/testing/integration-testing.md)
```

### Standards Files

Each standard file documents specific conventions:

**Example**: `standards/frontend/component-patterns.md`
```markdown
# Component Patterns

## File Structure
- One component per file
- File name matches component name
- Use .tsx extension for TypeScript

## Component Structure
```tsx
// Props interface
interface Props {
  // ...
}

// Component
export const ComponentName: React.FC<Props> = ({ ...props }) => {
  // Hooks at top
  // Event handlers
  // Render
}
```

## Naming
- PascalCase for components
- camelCase for props
- Descriptive names (UserProfile not UP)
```

## Discovery Patterns

### Pattern 1: Specialty-Based Discovery

```
Task Group: Database Schema
↓
Check INDEX.md for "Backend Standards"
↓
Find: Database Conventions
↓
Load and apply
```

### Pattern 2: Keyword-Based Discovery

```
Step: "Implement error handling"
↓
Check INDEX.md for "error handling"
↓
Find: Error Handling standard
↓
Load and apply
```

### Pattern 3: File-Type-Based Discovery

```
About to modify: *.tsx file
↓
Check INDEX.md for "Frontend Standards"
↓
Find: Component Patterns
↓
Load and apply
```

## Benefits

### For Implementer Skill

**Without continuous discovery**:
- Loads all standards at start (memory overload)
- Forgets standards by time they're needed
- Can't adapt to changing context

**With continuous discovery**:
- Fresh context at each check
- Standards loaded when relevant
- Adapts to implementation flow

### For Code Quality

**Without continuous discovery**:
- Inconsistent application of standards
- Standards missed for specialty areas
- Manual compliance checking needed

**With continuous discovery**:
- Consistent standards application
- Specialty standards discovered automatically
- Built-in compliance checking

### For Developer Experience

**Without continuous discovery**:
- Must remember all standards
- Consult documentation frequently
- Prone to missing standards

**With continuous discovery**:
- Standards applied automatically
- No manual lookup needed
- Nothing missed

## Work Log Documentation

Standards discovery is documented in `work-log.md`:

```markdown
## Task Group 1: Database Schema

**Standards Checked**: 
- Database naming conventions (standards/backend/database-conventions.md)
- Migration patterns (standards/backend/migrations.md)

**Standards Applied**:
✓ Table names: plural, snake_case
✓ Column names: descriptive, no abbreviations
✓ Migration: reversible, timestamped

---

## Task Group 2: API Endpoints

**Standards Checked**:
- API design (standards/backend/api-design.md)
- Error handling (standards/global/error-handling.md)

**Standards Applied**:
✓ Endpoint naming: plural resources, kebab-case
✓ Error responses: consistent format
✓ Status codes: appropriate (200, 201, 400, 404, 500)
```

## Best Practices

### 1. Keep INDEX.md Updated

Add new standards as project evolves:
```bash
/ai-sdlc:standards:update [standard-path]
```

### 2. Organize by Category

Group standards logically:
- Global (apply everywhere)
- Frontend (UI-specific)
- Backend (API/DB-specific)
- Testing (test-specific)

### 3. Link from INDEX.md

Always reference standards in INDEX.md:
```markdown
## Backend Standards
- [API Design](standards/backend/api-design.md) ← Link to actual file
```

### 4. Write Clear Standards

Each standard should be:
- Specific and actionable
- Include examples
- Explain WHY (not just HOW)

### 5. Review Compliance

Check work-log.md to verify standards applied:
```bash
cat .ai-sdlc/tasks/[type]/[task]/implementation/work-log.md
```

## Related Resources

- [Implementer Skill](../../skills/implementer/SKILL.md) - How implementation executes with standards discovery
- [State Management](state-management.md) - How standards context is maintained
- [Docs Manager Skill](../../skills/docs-manager/SKILL.md) - Managing standards files

---

**Continuous standards discovery ensures quality without manual checking**
