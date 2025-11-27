# Agents Reference

Complete reference of all specialized agents (subagents) in the AI SDLC plugin.

## Overview

Agents are specialized subagents that perform focused tasks like analysis, planning, or verification. They are invoked by skills and return structured results.

**Total Agents**: 28

## Agent Categories

### Analysis Agents (7)

**Purpose**: Pre-phase analysis to establish baselines

| Agent | Purpose | Invoked By | Output |
|-------|---------|------------|--------|
| **project-analyzer** | Deep codebase analysis for documentation generation | docs-manager (init-sdlc) | Project analysis report |
| **refactoring-analyzer** | Code quality baseline (complexity, duplication, smells) | refactoring-orchestrator | code-quality-baseline.md |
| **performance-profiler** | Performance metrics baseline (response time, throughput, CPU, memory) | performance-orchestrator | performance-baseline.md |
| **bottleneck-analyzer** | Identify performance bottlenecks (N+1 queries, missing indexes) | performance-orchestrator | optimization-plan.md |
| **security-analyzer** | Vulnerability analysis with CVSS scoring | security-orchestrator | security-baseline.md |
| **existing-feature-analyzer** | Analyze existing feature before enhancement | enhancement-orchestrator | existing-feature-analysis.md |
| **gap-analyzer** | Gap detection and user journey impact analysis | enhancement-orchestrator | gap-analysis.md |

### Planning Agents (5)

**Purpose**: Create detailed plans for execution

| Agent | Purpose | Invoked By | Output |
|-------|---------|------------|--------|
| **refactoring-planner** | Incremental refactoring plan with git checkpoints | refactoring-orchestrator | refactoring-plan.md |
| **security-planner** | Security remediation plan with risk prioritization | security-orchestrator | security-remediation-plan.md |
| **research-planner** | Research methodology and data sources | research-orchestrator | research-plan.md |
| **documentation-planner** | Documentation structure and outline | documentation-orchestrator | documentation-outline.md |
| **initiative-planner** | Multi-task breakdown with dependency graph | initiative-orchestrator | task-plan.md |
| **implementation-changes-planner** | Detailed change plans without modifying files | implementer | change-plan.md |

### Verification Agents (7)

**Purpose**: Post-implementation verification (read-only)

| Agent | Purpose | Invoked By | Output |
|-------|---------|------------|--------|
| **behavioral-snapshot-capturer** | Capture behavior baseline before refactoring | refactoring-orchestrator | behavioral-snapshot.md |
| **behavioral-verifier** | Verify behavior preserved exactly after refactoring | refactoring-orchestrator | behavior-verification-report.md |
| **performance-verifier** | Verify performance targets met | performance-orchestrator | performance-verification.md |
| **security-verifier** | Verify vulnerabilities fixed | security-orchestrator | security-verification-report.md |
| **documentation-reviewer** | Validate documentation quality and readability | documentation-orchestrator | documentation-review.md |
| **e2e-test-verifier** | Browser-based E2E testing with Playwright | feature/enhancement-orchestrator | e2e-verification-report.md |
| **spec-auditor** | Independent specification audit | Standalone or orchestrators | spec-audit-report.md |

### Utility Agents (9)

**Purpose**: Helper agents for specialized tasks

| Agent | Purpose | Invoked By | Output |
|-------|---------|------------|--------|
| **task-classifier** | Auto-classify task descriptions into task types | /work command | Classification with confidence |
| **ui-mockup-generator** | ASCII mockups showing UI integration | enhancement/feature-orchestrator | ui-mockups.md |
| **user-docs-generator** | User documentation with screenshots | feature/enhancement/documentation-orchestrator | user-guide.md |
| **information-gatherer** | Multi-source data collection with citations | research-orchestrator | findings/*.md |
| **research-synthesizer** | Research findings synthesis | research-orchestrator | synthesis.md, research-report.md |
| **code-quality-pragmatist** | Over-engineering and complexity detection | implementation-verifier | pragmatic-review-report.md |
| **compliance-auditor** | Regulatory compliance verification (GDPR, HIPAA, SOC 2, PCI DSS) | security-orchestrator | compliance-assessment-report.md |
| **reality-assessor** | Multi-agent validation orchestrator | implementation-verifier | reality-assessment-report.md |

---

## Analysis Agents Details

### project-analyzer
**Deep codebase analysis for documentation generation**

**Capabilities**:
- Project type classification (new/existing/legacy)
- Tech stack detection (languages, frameworks, databases, tools)
- Architecture discovery (MVC, layered, microservices)
- Conventions analysis (naming, code organization, style)
- Current state assessment (strengths, weaknesses, technical debt)

**Tools**: Read, Glob, Grep, Bash (read-only), WebFetch

**Philosophy**: Evidence-based analysis. Every finding references actual code.

[Agent Documentation](../../agents/project-analyzer.md)

---

### refactoring-analyzer
**Establishes code quality baseline before refactoring**

**Metrics**:
- Cyclomatic complexity (average, max per function)
- Code duplication percentage
- Code smells (long methods, god classes, deep nesting)
- Test coverage

**Tools**: Read, Grep, Glob, Bash (read-only)

[Agent Documentation](../../agents/refactoring-analyzer.md)

---

### performance-profiler
**Measures performance metrics baseline**

**Metrics**:
- Response time (p50/p95/p99)
- Throughput (requests per second)
- CPU usage
- Memory usage
- Database query count

**Tools**: Read, Grep, Glob, Bash (read-only)

[Agent Documentation](../../agents/performance-profiler.md)

---

### bottleneck-analyzer
**Identifies performance bottlenecks**

**Detects**:
- N+1 query patterns
- Missing database indexes
- Inefficient algorithms
- Memory leaks
- Blocking I/O

**Prioritization**: Impact vs Effort matrix

**Tools**: Read, Grep, Glob, Bash (read-only)

[Agent Documentation](../../agents/bottleneck-analyzer.md)

---

### security-analyzer
**Analyzes security vulnerabilities with CVSS scoring**

**Detects**:
- Dependency CVEs
- Code vulnerabilities (SQL injection, XSS, hardcoded secrets)
- Authentication/authorization flaws
- Business logic flaws

**Scoring**: CVSS v3.1
**Classification**: OWASP Top 10 2021

**Tools**: Read, Grep, Glob, Bash (read-only)

[Agent Documentation](../../agents/security-analyzer.md)

---

### existing-feature-analyzer
**Analyzes existing feature before enhancement**

**Analyzes**:
- Current functionality
- Dependencies and integrations
- Test coverage
- Code complexity
- Multi-strategy search with confidence scoring

**Tools**: Read, Glob, Grep, Bash, AskUserQuestion

[Agent Documentation](../../agents/existing-feature-analyzer.md)

---

### gap-analyzer
**Compares current vs desired state**

**Analyzes**:
- Enhancement type classification (additive/modificative/refactor-based)
- User journey impact assessment
- Data entity lifecycle analysis (3-layer verification)
- Orphaned feature detection
- Discoverability scoring

**Critical Feature**: Detects incomplete features (e.g., display without input mechanism)

**Tools**: Read, Glob, Grep, Bash, AskUserQuestion

[Agent Documentation](../../agents/gap-analyzer.md)

---

## Verification Agents Details

All verification agents are **strictly read-only** - they report issues but never fix them.

### behavioral-verifier
**Verifies refactored code preserves behavior exactly**

**Verifies**:
- Function signatures match exactly
- Test results match exactly
- Side effects preserved
- Behavioral fingerprint match

**Verdict**: PASS/FAIL (any change = FAIL)

**Tools**: Read, Grep, Glob, Bash (read-only)

[Agent Documentation](../../agents/behavioral-verifier.md)

---

### e2e-test-verifier
**Browser-based E2E testing with Playwright**

**Tests**:
- User stories from spec
- Acceptance criteria
- UI behavior
- JavaScript errors

**Evidence**: Screenshots of each step

**Tools**: Read, Write, Bash, Playwright MCP tools

[Agent Documentation](../../agents/e2e-test-verifier.md)

---

### spec-auditor
**Independent specification audit with senior auditor perspective**

**Verifies**:
- Completeness
- Ambiguity detection
- Implementability
- External verification (Azure/GitHub CLI)

**Philosophy**: Never trusts claims - examines codebase for evidence

**Tools**: Read, Grep, Glob, Bash, Azure CLI, GitHub CLI

[Agent Documentation](../../agents/spec-auditor.md)

---

## Related Resources

- [Commands Reference](commands.md) - Commands that invoke agents
- [Skills Reference](skills.md) - Skills that delegate to agents
- [Architecture](../Architecture.md) - Agent execution model

---

**Complete reference for all AI SDLC plugin agents**
