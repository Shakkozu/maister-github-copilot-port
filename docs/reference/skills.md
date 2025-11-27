# Skills Reference

Complete reference of all skills (workflows and utilities) in the AI SDLC plugin.

## Overview

Skills are autonomous workflows that orchestrate complex tasks. There are two types:
- **Orchestrator Skills**: Multi-phase workflows for complete task execution
- **Utility Skills**: Specialized capabilities invoked by orchestrators

## Orchestrator Skills (10)

### feature-orchestrator
**Purpose**: Complete new feature development workflow

**Phases**: 7 (Spec → Plan → Implement → Verify → E2E → User Docs → Finalize)

**Key Features**:
- Dual execution modes (Interactive/YOLO)
- Auto-recovery from failures
- Optional E2E testing and user documentation
- State management for pause/resume

**Use When**: Building completely new capabilities

**Command**: `/ai-sdlc:feature:new`

[Detailed Guide](../guides/feature-development.md) | [Skill Documentation](../../skills/feature-orchestrator/SKILL.md)

---

### bug-fix-orchestrator
**Purpose**: Systematic bug fixing with TDD Red→Green discipline

**Phases**: 4 (Bug Analysis → Fix Implementation → Testing → Documentation)

**Key Features**:
- Mandatory TDD Red→Green gates (test fails before fix, passes after)
- Exact reproduction data capture
- Root cause analysis
- Regression prevention

**Use When**: Fixing bugs, errors, crashes

**Command**: `/ai-sdlc:bug-fix:new`

[Detailed Guide](../guides/bug-fixing.md) | [Skill Documentation](../../skills/bug-fix-orchestrator/SKILL.md)

---

### enhancement-orchestrator
**Purpose**: Improve existing features with backward compatibility

**Phases**: 6 (Existing Analysis → Gap Analysis → Spec → Plan → Implement → Compatibility Verification)

**Key Features**:
- Analyzes existing feature first
- Gap detection with user journey impact
- Data lifecycle completeness checks
- Targeted regression testing (30-70% of suite)
- Backward compatibility verification

**Use When**: Improving or extending existing features

**Command**: `/ai-sdlc:enhancement:new`

[Detailed Guide](../guides/enhancement-workflow.md) | [Skill Documentation](../../skills/enhancement-orchestrator/SKILL.md)

---

### initiative-orchestrator
**Purpose**: Coordinate multiple related tasks with dependencies

**Phases**: 6 (Planning → Task Creation → Dependency Resolution → Execution → Verification → Finalization)

**Key Features**:
- Manages 3-15 related tasks
- Dependency management with validation
- Mixed parallel/sequential execution
- File-based state coordination
- Progress tracking

**Use When**: Multi-task projects with dependencies

**Commands**: `/ai-sdlc:initiative:new`, `/ai-sdlc:initiative:status`, `/ai-sdlc:initiative:resume`

[Detailed Guide](../guides/initiatives.md) | [Skill Documentation](../../skills/initiative-orchestrator/skill.md)

---

### performance-orchestrator
**Purpose**: Performance optimization with benchmarking

**Phases**: 5 (Baseline & Profiling → Bottleneck Analysis → Implementation → Verification → Load Testing)

**Key Features**:
- Benchmark-driven optimization
- Bottleneck detection (N+1 queries, missing indexes)
- Prove every improvement with metrics
- Load testing for production readiness

**Use When**: Application slow, high resource usage

**Command**: `/ai-sdlc:performance:new`

[Detailed Guide](../guides/performance-optimization.md) | [Skill Documentation](../../skills/performance-orchestrator/SKILL.md)

---

### security-orchestrator
**Purpose**: Security remediation with CVSS scoring

**Phases**: 4-5 (Vulnerability Analysis → Remediation Planning → Implementation → Verification → Compliance Audit)

**Key Features**:
- CVSS v3.1 scoring
- OWASP Top 10 classification
- Risk-based prioritization
- Compliance auditing (GDPR, HIPAA, SOC 2, PCI DSS)

**Use When**: Security vulnerabilities, compliance requirements

**Command**: `/ai-sdlc:security:new`

[Detailed Guide](../guides/security-remediation.md) | [Skill Documentation](../../skills/security-orchestrator/SKILL.md)

---

### refactoring-orchestrator
**Purpose**: Safe refactoring with automatic rollback

**Phases**: 6 (Quality Baseline → Planning → Behavioral Snapshot → Execution → Behavior Verification → Quality Verification)

**Key Features**:
- Git checkpoints before each increment
- Automatic rollback on ANY test failure
- Zero tolerance for behavior changes
- Behavior preservation verification

**Use When**: Improving code structure while preserving behavior

**Command**: `/ai-sdlc:refactoring:new`

[Detailed Guide](../guides/refactoring.md) | [Skill Documentation](../../skills/refactoring-orchestrator/SKILL.md)

---

### migration-orchestrator
**Purpose**: Technology and pattern migrations

**Phases**: 6 (Current State → Target State → Strategy → Rollback Planning → Implementation → Cutover Verification)

**Key Features**:
- Auto-classifies migration type (code/data/architecture)
- Recommends strategy (incremental/big-bang/dual-run/phased)
- Rollback procedures for every phase
- Dual-run support for data migrations

**Use When**: Technology upgrades, platform changes

**Command**: `/ai-sdlc:migration:new`

[Detailed Guide](../guides/migrations.md) | [Skill Documentation](../../skills/migration-orchestrator/SKILL.md)

---

### documentation-orchestrator
**Purpose**: User documentation with screenshots

**Phases**: 4 (Planning → Content Creation → Review & Validation → Publication)

**Key Features**:
- Screenshot automation with Playwright
- Readability scoring (Flesch metrics)
- Multiple doc types (guide/tutorial/reference/FAQ/API)
- User-first language

**Use When**: Creating user-facing documentation

**Command**: `/ai-sdlc:documentation:new`

[Detailed Guide](../guides/documentation-creation.md) | [Skill Documentation](../../skills/documentation-orchestrator/SKILL.md)

---

### research-orchestrator
**Purpose**: Systematic research workflows

**Phases**: 5 (Planning → Information Gathering → Analysis & Synthesis → Documentation → Verification)

**Key Features**:
- Multi-source data collection (codebase, docs, web)
- Evidence-based findings with citations
- Adapts methodology by research type
- Reusable research artifacts

**Use When**: Understanding codebase, exploring best practices

**Command**: `/ai-sdlc:research:new`

[Detailed Guide](../guides/research.md) | [Skill Documentation](../../skills/research-orchestrator/SKILL.md)

---

## Utility Skills (8)

### specification-creator
**Purpose**: Create comprehensive specifications

**Process**: Initialize → Research → Write → Verify

**Invoked By**: All orchestrators during specification phase

**Output**: `spec.md`, `requirements.md`

[Skill Documentation](../../skills/specification-creator/SKILL.md)

---

### implementation-planner
**Purpose**: Break work into implementation steps

**Process**: Analyze spec → Determine task groups → Create steps → Set dependencies → Define acceptance criteria

**Invoked By**: All orchestrators during planning phase

**Output**: `implementation-plan.md`

[Skill Documentation](../../skills/implementation-planner/SKILL.md)

---

### implementer
**Purpose**: Execute implementation plans with standards discovery

**Execution Modes**:
- Direct (1-3 steps)
- Plan-Execute (4-8 steps)
- Orchestrated (9+ steps)

**Key Feature**: Continuous standards discovery from INDEX.md

**Invoked By**: All orchestrators during implementation phase

**Output**: Code changes, `work-log.md`

[Skill Documentation](../../skills/implementer/SKILL.md)

---

### implementation-verifier
**Purpose**: Verify implementation complete and production-ready

**Verification Aspects**:
- Implementation completeness
- Full test suite execution
- Standards compliance
- Documentation completeness
- Optional code review
- Optional production readiness check

**Invoked By**: All orchestrators during verification phase

**Output**: `implementation-verification.md` with PASS/FAIL verdict

[Skill Documentation](../../skills/implementation-verifier/SKILL.md)

---

### code-reviewer
**Purpose**: Automated code quality, security, and performance analysis

**Analysis Scope**:
- Code quality (complexity, duplication, smells)
- Security (vulnerabilities, secrets, injection)
- Performance (N+1 queries, inefficiency)
- Best practices

**Invoked By**: implementation-verifier (optional), standalone command

**Output**: `code-review-report.md`

**Command**: `/ai-sdlc:code-review:review`

[Skill Documentation](../../skills/code-reviewer/SKILL.md)

---

### production-readiness-checker
**Purpose**: Deployment readiness verification

**Verification Categories**:
- Configuration management
- Monitoring & observability
- Error handling & resilience
- Performance & scalability
- Security hardening
- Deployment considerations

**Invoked By**: implementation-verifier (optional), standalone command

**Output**: `production-readiness-report.md` with GO/NO-GO decision

**Command**: `/ai-sdlc:deployment:check-readiness`

[Skill Documentation](../../skills/production-readiness-checker/SKILL.md)

---

### docs-manager
**Purpose**: Manage `.ai-sdlc/docs/` structure and standards

**Capabilities**:
- Initialize documentation structure
- Maintain INDEX.md
- Manage project documentation
- Manage technical standards
- Discover standards from codebase

**Commands**: `/init-sdlc`, `/ai-sdlc:standards:discover`, `/ai-sdlc:standards:update`

[Skill Documentation](../../skills/docs-manager/SKILL.md)

---

### task-classifier
**Purpose**: Auto-classify task descriptions

**Classification Types**: 9 types (initiative, new-feature, bug-fix, enhancement, refactoring, performance, security, migration, documentation)

**Invoked By**: `/work` command

**Output**: Classification with confidence score

[Skill Documentation](../../skills/task-classifier/SKILL.md)

---

## Skill Invocation

Skills are invoked automatically by:
1. **Commands** - Slash commands invoke orchestrator skills
2. **Orchestrators** - Orchestrator skills invoke utility skills
3. **Agents** - Some skills delegate to specialized agents

Users typically interact with orchestrator skills via commands, not directly.

---

## Related Resources

- [Commands Reference](commands.md) - All available commands
- [Agents Reference](agents.md) - Specialized agents
- [Architecture](../Architecture.md) - How skills work internally

---

**Complete reference for all AI SDLC plugin skills**
