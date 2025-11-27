# Phase 1: Core Skills - Implementation Checklist

**Reference**: See `modular-verification-architecture.md` for complete design

---

## 1.1 code-reviewer Skill

### ✅ Completed

- [x] `skills/code-reviewer/` directory created
- [x] `skills/code-reviewer/SKILL.md` created
  - 7 phases: Initialize, Code Quality, Security, Performance, Best Practices, Generate Report, Output
  - Comprehensive analysis workflow
  - Integration points documented

### ⏳ Remaining (4 files)

#### File 1: `skills/code-reviewer/references/quality-checks.md`

**Purpose**: Detailed code quality analysis guide

**Contents to include**:
1. **Complexity Metrics**
   - Cyclomatic complexity calculation
   - Cognitive complexity patterns
   - Function length thresholds
   - Nesting depth limits

2. **Duplication Detection**
   - How to identify duplicated code
   - Acceptable duplication levels
   - When duplication is OK vs problematic

3. **Code Smell Patterns**
   - Long methods
   - Long parameter lists
   - God classes
   - Magic numbers
   - Dead code
   - TODO/FIXME handling

4. **Examples**
   - Before/after examples for each pattern
   - Project-specific considerations

**Reference**: PHASE 2 of code-reviewer SKILL.md

---

#### File 2: `skills/code-reviewer/references/security-checks.md`

**Purpose**: Security vulnerability detection patterns

**Contents to include**:
1. **Hardcoded Secrets Detection**
   - Search patterns for API keys, passwords, tokens
   - Common secret variable names
   - How to verify findings (avoid false positives)

2. **Injection Vulnerabilities**
   - SQL injection patterns (string concatenation in queries)
   - Command injection (unsafe exec/system calls)
   - XSS vulnerabilities (unescaped output)
   - Path traversal (user input in file paths)

3. **Dangerous Functions**
   - eval/exec usage
   - Unsafe deserialization
   - Weak random for security
   - Other dangerous patterns

4. **Authentication/Authorization**
   - Missing auth checks
   - Insufficient authorization
   - Session handling issues

5. **Examples**
   - Vulnerable code examples
   - Secure alternatives
   - Real-world scenarios

**Reference**: PHASE 3 of code-reviewer SKILL.md

---

#### File 3: `skills/code-reviewer/references/performance-checks.md`

**Purpose**: Performance analysis patterns

**Contents to include**:
1. **N+1 Query Detection**
   - What N+1 queries are
   - How to identify them in code
   - Patterns that indicate N+1 problems
   - Solutions (eager loading, batch queries)

2. **Missing Database Indexes**
   - How to identify unindexed queries
   - When indexes are needed
   - Composite index considerations

3. **Inefficient Operations**
   - Loading large datasets without pagination
   - Synchronous blocking operations
   - Loading entire files into memory
   - Missing streaming

4. **Caching Opportunities**
   - Repeated expensive operations
   - API calls without caching
   - Database queries that should be cached
   - When NOT to cache

5. **Examples**
   - Performance problems with metrics
   - Optimized solutions
   - Before/after comparisons

**Reference**: PHASE 4 of code-reviewer SKILL.md

---

#### File 4: `skills/code-reviewer/references/code-review-report-template.md`

**Purpose**: Standard report format with examples

**Contents to include**:
1. **Report Structure**
   - Complete template with all sections
   - Markdown formatting
   - How to categorize findings

2. **Severity Levels**
   - Critical: Definition and examples
   - Warning: Definition and examples
   - Info: Definition and examples
   - When to use each level

3. **Finding Format**
   - How to document each finding
   - Location format (file:line)
   - Description format
   - Recommendation format
   - Code example format

4. **Example Reports**
   - Example 1: Clean code (no issues)
   - Example 2: Minor issues (warnings only)
   - Example 3: Critical issues (must fix)
   - Example 4: Mixed severity issues

5. **Metrics Section**
   - What metrics to include
   - How to calculate them
   - How to present them

**Reference**: PHASE 6 of code-reviewer SKILL.md

---

## 1.2 production-readiness-checker Skill

### ⏳ All Tasks (5 files)

#### Main Skill: `skills/production-readiness-checker/SKILL.md`

**Purpose**: Main skill file for production readiness verification

**Structure** (similar to code-reviewer):
1. **Frontmatter**: name, description
2. **Phase 1**: Initialize & Validate
3. **Phase 2**: Configuration Management
4. **Phase 3**: Monitoring & Observability
5. **Phase 4**: Error Handling & Resilience
6. **Phase 5**: Performance & Scalability
7. **Phase 6**: Security Hardening
8. **Phase 7**: Deployment Considerations
9. **Phase 8**: Generate Report
10. **Phase 9**: Output Summary

**Reference**: Design doc "Skill 2: production-readiness-checker" section

---

#### File 1: `skills/production-readiness-checker/references/deployment-checklist.md`

**Purpose**: Comprehensive production readiness checklist

**Contents**:
- Configuration management checklist
- Monitoring requirements
- Error handling requirements
- Performance requirements
- Security requirements
- Deployment requirements
- Go/no-go criteria

---

#### File 2: `skills/production-readiness-checker/references/configuration-guide.md`

**Purpose**: Configuration validation guide

**Contents**:
- Environment variable patterns
- Secrets management best practices
- Configuration validation
- Feature flag usage
- Environment-specific config

---

#### File 3: `skills/production-readiness-checker/references/monitoring-guide.md`

**Purpose**: Observability requirements guide

**Contents**:
- Logging requirements
- Metrics instrumentation
- Error tracking setup
- Health check patterns
- Alerting considerations

---

#### File 4: `skills/production-readiness-checker/references/production-readiness-report-template.md`

**Purpose**: Standard production readiness report format

**Contents**:
- Report structure
- Status indicators (Ready/Concerns/Not Ready)
- Deployment risk categorization
- Go/no-go recommendation format
- Example reports

---

## 1.3 Commands

### ⏳ All Tasks (2 files)

#### Command 1: `commands/code-review/review.md`

**Purpose**: `/code-review` slash command

**Contents**:
```markdown
---
description: Run automated code quality, security, and performance analysis
---

[Command documentation that invokes code-reviewer skill]

## Usage
- /code-review [path]
- /code-review [path] --scope=quality
- /code-review [path] --scope=security
- /code-review [path] --scope=performance

## What This Does
[Invokes code-reviewer skill with provided path and scope]

## Examples
[Usage examples]
```

**Reference**: Design doc commands section, existing `/implement` command for format

---

#### Command 2: `commands/deployment/check-readiness.md`

**Purpose**: `/check-production-readiness` slash command

**Contents**:
```markdown
---
description: Verify production deployment readiness
---

[Command documentation that invokes production-readiness-checker skill]

## Usage
- /check-production-readiness [task-path]
- /check-production-readiness [task-path] --target=prod

## What This Does
[Invokes production-readiness-checker skill]

## Examples
[Usage examples]
```

**Reference**: Design doc commands section, existing commands for format

---

## Quick Start for New Session

1. **Read these files first**:
   - `modular-verification-architecture.md` (design)
   - `IMPLEMENTATION-STATUS.md` (progress)
   - `PHASE-1-CHECKLIST.md` (this file)

2. **Start with Phase 1.1 remaining files**:
   - Create 4 reference files for code-reviewer (listed above)
   - Use code-reviewer SKILL.md as reference for content
   - Keep files concise but comprehensive

3. **Then proceed to Phase 1.2**:
   - Create production-readiness-checker skill (5 files)
   - Similar structure to code-reviewer
   - Use design doc for specifications

4. **Finally Phase 1.3**:
   - Create 2 commands
   - Use existing command files as templates

5. **Update IMPLEMENTATION-STATUS.md** as you complete each file

---

## File Creation Order (Recommended)

**Phase 1.1 (Finish code-reviewer)**:
1. `skills/code-reviewer/references/quality-checks.md`
2. `skills/code-reviewer/references/security-checks.md`
3. `skills/code-reviewer/references/performance-checks.md`
4. `skills/code-reviewer/references/code-review-report-template.md`

**Phase 1.2 (production-readiness-checker)**:
1. `skills/production-readiness-checker/` directory
2. `skills/production-readiness-checker/SKILL.md`
3. `skills/production-readiness-checker/references/deployment-checklist.md`
4. `skills/production-readiness-checker/references/configuration-guide.md`
5. `skills/production-readiness-checker/references/monitoring-guide.md`
6. `skills/production-readiness-checker/references/production-readiness-report-template.md`

**Phase 1.3 (Commands)**:
1. `commands/code-review/` directory
2. `commands/code-review/review.md`
3. `commands/deployment/` directory
4. `commands/deployment/check-readiness.md`

**Total**: 14 files remaining in Phase 1

---

## Testing After Phase 1

After all Phase 1 files are created:

1. **Verify file structure**:
```bash
ls -la skills/code-reviewer/
ls -la skills/production-readiness-checker/
ls -la commands/code-review/
ls -la commands/deployment/
```

2. **Check all files are present**:
- 1 code-reviewer SKILL.md ✅
- 4 code-reviewer references
- 1 production-readiness-checker SKILL.md
- 4 production-readiness-checker references
- 2 commands

3. **Move to Phase 2**:
- See IMPLEMENTATION-STATUS.md for Phase 2 tasks
- Phase 2: Update implementation-verifier for orchestration

---

*This checklist ensures all Phase 1 work can be completed in any session with full context*
