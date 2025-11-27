# Documentation Creation Workflow

Guide to creating user-facing documentation with screenshot automation using Playwright.

## Overview

Documentation creation workflow generates end-user documentation with automated screenshot capture, readability validation, and publication integration.

**When to use:**
- Documenting user-facing features
- Creating user guides and tutorials
- Building FAQ sections
- Updating documentation with screenshots

## Quick Start

```bash
/ai-sdlc:documentation:new "User guide for admin dashboard"
```

## Workflow Phases (4 Phases)

### Phase 1: Documentation Planning & Audience Analysis
- Classify documentation type (User Guide, Tutorial, Reference, FAQ, API Docs)
- Identify target audience (end-users, admins, developers)
- Determine appropriate tone (friendly, technical, formal)
- Create content outline with sections
- Identify required screenshots

### Phase 2: Content Creation with Screenshots
- Generate user-friendly content
- **Capture screenshots using Playwright** (automated)
- Write step-by-step instructions
- Include tips and troubleshooting
- Use non-technical language

### Phase 3: Review & Validation
- Check completeness (all sections present)
- Calculate readability scores:
  - **Flesch Reading Ease** (60-70 = standard, >70 = easy)
  - **Flesch-Kincaid Grade Level** (<8 = general audience)
- Validate screenshots exist and are referenced
- Check for broken links
- Flag technical jargon
- Assess clarity

### Phase 4: Publication & Integration
- Format documentation
- Generate table of contents
- Integrate with docs structure
- Publish to appropriate location

## Documentation Types

### User Guide
**Purpose**: Help users accomplish tasks
**Tone**: Friendly, step-by-step
**Example**: "How to Upload Your Avatar"

### Tutorial
**Purpose**: Teach through hands-on practice
**Tone**: Educational, detailed
**Example**: "Building Your First Dashboard"

### Reference
**Purpose**: Complete technical details
**Tone**: Technical, comprehensive
**Example**: "API Endpoint Reference"

### FAQ
**Purpose**: Answer common questions
**Tone**: Concise, direct
**Example**: "Frequently Asked Questions"

### API Docs
**Purpose**: Document endpoints and usage
**Tone**: Technical, structured
**Example**: "REST API Documentation"

## Screenshot Automation

**Uses Playwright** to capture screenshots automatically:

```
1. Navigate to feature page
2. Capture initial state
3. Interact with UI (click, fill, etc.)
4. Capture each step
5. Capture result/success state
```

**Screenshots saved to**:
```
documentation/screenshots/
├── 01-feature-overview.png
├── 02-click-button.png
└── 03-success-state.png
```

## Readability Scoring

### Flesch Reading Ease
- **90-100**: Very Easy (5th grade)
- **60-70**: Standard (8th-9th grade)
- **30-50**: Difficult (College)
- **0-30**: Very Difficult (Graduate)

**Target**: 60-70 for general users

### Flesch-Kincaid Grade Level
- **8 or below**: General audience
- **9-12**: High school
- **13+**: College+

**Target**: <8 for end-user docs

## Best Practices

1. **User-First Language**: Write for non-technical users
2. **Show, Don't Tell**: Use screenshots liberally
3. **Step-by-Step**: Number steps, one action per step
4. **Troubleshooting**: Include common issues and solutions
5. **Test Readability**: Aim for Flesch Reading Ease 60-70

## Related Resources

- [Command Reference](../../commands/documentation/new.md)
- [Skill Documentation](../../skills/documentation-orchestrator/SKILL.md)
- [User Docs Generator Agent](../../agents/user-docs-generator.md)

**Next Steps**: `/ai-sdlc:documentation:new [description]`
