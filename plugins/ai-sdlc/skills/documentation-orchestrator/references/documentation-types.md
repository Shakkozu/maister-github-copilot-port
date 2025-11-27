# Documentation Types Reference

This reference describes the 5 core documentation types supported by the documentation-orchestrator, their characteristics, when to use them, and structural patterns.

---

## Overview

**5 Documentation Types**:
1. **User Guide** - Task-oriented (help users accomplish goals)
2. **Tutorial** - Learning-oriented (teach through practice)
3. **Reference** - Information-oriented (comprehensive details)
4. **FAQ** - Problem-oriented (quick answers)
5. **API Documentation** - Integration-oriented (developer endpoints)

**Selection Criteria**: Based on primary purpose and target audience

---

## 1. User Guide

### Purpose

Help users accomplish specific tasks with the application.

### When to Use

- Documenting how to use a feature
- Task-oriented content ("How do I...?")
- User-facing features with UI
- Step-by-step instructions needed

### Target Audience

- **Primary**: End users (non-technical)
- **Secondary**: New users, occasional users
- **Technical Level**: Beginner to intermediate
- **Prior Knowledge**: Basic computer skills

### Characteristics

**Content Focus**:
- Task completion (not feature explanation)
- Step-by-step procedures
- Visual guidance (many screenshots)
- Practical examples with real data

**Tone and Style**:
- Friendly and encouraging
- Second person ("you")
- Simple, everyday language
- Short sentences (15-20 words)
- Active voice

**Structure**:
- Task-based organization
- Linear progression (basics → advanced)
- Clear success indicators
- Troubleshooting section

**Readability Targets**:
- Flesch Reading Ease: 60-80 (Standard to Easy)
- Grade Level: 6-8 (Middle school)

### Standard Structure

```markdown
# [Feature]: User Guide

## 1. Overview
- What is [feature]?
- Who should use this?
- Key benefits

## 2. Getting Started
- Prerequisites
- Initial setup (if needed)
- First steps

## 3. Basic Tasks
### 3.1 [Most Common Task]
- When to use
- Step-by-step instructions
- Expected result

### 3.2 [Second Task]
[Same pattern]

## 4. Advanced Features (Optional)
### 4.1 [Advanced Feature]
- Use case
- Instructions

## 5. Tips and Best Practices
- Helpful tips
- Best practices
- Shortcuts

## 6. Troubleshooting
### Issue 1
- Problem description
- Solution

## 7. Related Features
- Links to related docs

## 8. Getting Help
- Support contacts
```

### Example Titles

- "How to Create a Task"
- "Managing Your Profile"
- "Getting Started with Task Management"
- "Using the Dashboard"
- "Collaborating with Teams"

### Key Success Factors

- ✅ Every section answers "How do I...?"
- ✅ Screenshots for every significant step
- ✅ Real examples (not "foo", "test", "example")
- ✅ Clear success indicators ("What you should see")
- ✅ Troubleshooting for common issues

---

## 2. Tutorial

### Purpose

Teach concepts and skills through hands-on practice and progressive learning.

### When to Use

- Teaching new skills or concepts
- Progressive learning path needed
- Building something from start to finish
- Educational content with practice

### Target Audience

- **Primary**: Users wanting to learn
- **Secondary**: New users, students
- **Technical Level**: Beginner to intermediate
- **Prior Knowledge**: Minimal (stated in prerequisites)

### Characteristics

**Content Focus**:
- Concept explanation (why, not just how)
- Progressive steps (each builds on previous)
- Hands-on exercises
- Learning reinforcement

**Tone and Style**:
- Educational and patient
- Encouraging tone
- Detailed explanations
- Teaching mindset

**Structure**:
- Learning objectives upfront
- Prerequisites clearly stated
- Progressive difficulty
- Practice exercises
- Summary of what was learned

**Readability Targets**:
- Flesch Reading Ease: 60-70 (Standard)
- Grade Level: 8-10 (High school)

### Standard Structure

```markdown
# [Topic]: Tutorial

## 1. Learning Objectives
- What you'll learn
- What you'll be able to do after
- Time to complete
- Prerequisites

## 2. Introduction
- Why this matters
- What you'll build
- Technologies/concepts used

## 3. Setup
- Environment setup
- Required tools
- Starting code/data

## 4. Lesson Steps
### Step 1: [First Concept]
- Concept explanation
- Hands-on exercise
- What you learned

### Step 2: [Second Concept]
- Build on Step 1
- Hands-on exercise
- What you learned

[5-10 progressive steps]

## 5. Practice Exercises
- Exercise 1: Reinforce concepts
- Exercise 2: Apply learning
- Bonus challenges

## 6. Summary
- Key takeaways
- What you've accomplished
- Skills acquired

## 7. Next Steps
- Advanced topics to explore
- Related tutorials
- Further reading
```

### Example Titles

- "Your First API Integration"
- "Building a Dashboard from Scratch"
- "Introduction to Task Automation"
- "Creating Your First Workflow"
- "Mastering Advanced Filters"

### Key Success Factors

- ✅ Learning objectives clear upfront
- ✅ Each step explains "why" not just "how"
- ✅ Progressive difficulty (simple → complex)
- ✅ Practice exercises to reinforce learning
- ✅ Summary shows what was accomplished

---

## 3. Reference Documentation

### Purpose

Provide complete, comprehensive technical details for all features, options, or APIs.

### When to Use

- Documenting all options/features exhaustively
- Technical specifications needed
- Complete API/function reference
- Lookup/search-oriented content

### Target Audience

- **Primary**: Developers, power users
- **Secondary**: Advanced users, integrators
- **Technical Level**: Intermediate to advanced
- **Prior Knowledge**: Technical concepts, terminology

### Characteristics

**Content Focus**:
- Completeness (every option documented)
- Accuracy and precision
- Technical details (parameters, types, values)
- Organized for lookup/search

**Tone and Style**:
- Technical and precise
- Concise but complete
- Formal tone
- Technical terminology appropriate

**Structure**:
- Organized by feature/function
- Alphabetical or logical grouping
- Consistent format for each item
- Quick reference tables

**Readability Targets**:
- Flesch Reading Ease: 50-60 (Fairly Difficult)
- Grade Level: 10-12 (High school to college)

### Standard Structure

```markdown
# [Feature/API]: Reference

## 1. Overview
- Purpose
- Quick reference table
- Version information

## 2. [Category 1]
### 2.1 [Item 1]
**Description**: What it does

**Parameters/Properties**:
| Name | Type | Required | Description |
|------|------|----------|-------------|
| param1 | string | Yes | ... |

**Return Value**: Type and description

**Example**:
```code
example usage
```

**Notes**: Edge cases, limitations

[Repeat for all items]

## 3. Examples
- Common use cases
- Code snippets
- Integration patterns

## 4. Error Reference
- Error codes
- Error messages
- Solutions

## 5. Changelog
- Version history
- Breaking changes
```

### Example Titles

- "API Reference"
- "Configuration Options"
- "Complete Function Reference"
- "Command-Line Arguments"
- "Database Schema Reference"

### Key Success Factors

- ✅ Every option/parameter documented
- ✅ Consistent format for all items
- ✅ Technical accuracy (correct types, values)
- ✅ Code examples that work
- ✅ Easy to search/scan

---

## 4. FAQ (Frequently Asked Questions)

### Purpose

Answer common questions quickly and concisely.

### When to Use

- Addressing frequently asked questions
- Troubleshooting common issues
- Quick reference needed
- Repetitive support questions

### Target Audience

- **Primary**: All users (universal)
- **Secondary**: Support teams, new users
- **Technical Level**: Varies by question
- **Prior Knowledge**: Minimal

### Characteristics

**Content Focus**:
- Quick answers (not long explanations)
- Common questions and issues
- Problem-solution format
- Links to detailed guides

**Tone and Style**:
- Concise and direct
- Helpful and supportive
- Varied (matches question complexity)
- Short answers (2-5 sentences)

**Structure**:
- Question-answer format
- Organized by category
- Searchable/scannable
- Links to detailed docs

**Readability Targets**:
- Flesch Reading Ease: 60-70 (Standard)
- Grade Level: 8-10 (General public)

### Standard Structure

```markdown
# [Feature]: FAQ

## General Questions

### Q: [Question 1]
**A:** Short answer (2-5 sentences)

[Link to detailed guide if needed]

### Q: [Question 2]
**A:** Short answer

[5-10 general questions]

## [Category 2] Questions

### Q: [Question about Category 2]
**A:** Answer

[Continue by category]

## Troubleshooting

### Q: Why isn't [X] working?
**A:** Common causes and quick fixes

### Q: I'm getting [error], what do I do?
**A:** Solution steps

## Advanced Questions

[Questions for power users]
```

### Example Titles

- "Frequently Asked Questions"
- "Common Issues and Solutions"
- "Task Management FAQ"
- "Troubleshooting Guide"
- "Quick Answers"

### Key Success Factors

- ✅ Addresses actual common questions (not hypothetical)
- ✅ Answers are concise (not essays)
- ✅ Links to detailed guides for complex topics
- ✅ Organized by category for easy browsing
- ✅ Searchable (good keywords in questions)

---

## 5. API Documentation

### Purpose

Document API endpoints and usage for developer integration.

### When to Use

- Documenting REST APIs
- Developer integration guides
- SDK/library documentation
- Programmatic access to features

### Target Audience

- **Primary**: Developers
- **Secondary**: Technical integrators, partners
- **Technical Level**: Advanced
- **Prior Knowledge**: HTTP, REST, JSON, programming

### Characteristics

**Content Focus**:
- Endpoint details (path, method, params)
- Request/response examples
- Authentication methods
- Error codes and handling

**Tone and Style**:
- Technical and precise
- Structured and consistent
- Code-heavy
- Language-neutral (or multi-language examples)

**Structure**:
- Organized by resource/endpoint
- Consistent format for each endpoint
- Authentication section
- Code examples in multiple languages

**Readability Targets**:
- Flesch Reading Ease: 50-60 (Fairly Difficult)
- Grade Level: 10-12 (Technical audience)

### Standard Structure

```markdown
# [Service] API Documentation

## 1. API Overview
- Base URL
- Versioning
- Authentication
- Rate limits
- Response format

## 2. Authentication
- Authentication methods
- Token management
- Example requests

## 3. Endpoints

### 3.1 [Resource Name]

#### GET /api/resource
**Description**: What this endpoint does

**Parameters**:
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | integer | Yes | Resource ID |

**Request Example**:
```http
GET /api/resource/123
Authorization: Bearer {token}
```

**Response Example** (200 OK):
```json
{
  "id": 123,
  "name": "Example"
}
```

**Error Responses**:
- 400 Bad Request: Invalid parameters
- 401 Unauthorized: Missing/invalid token
- 404 Not Found: Resource not found

[Repeat for all endpoints]

## 4. Code Examples
- [Language 1] examples
- [Language 2] examples

## 5. Error Handling
- Error response format
- Common error codes
- Best practices

## 6. Changelog
- Version history
- Breaking changes
```

### Example Titles

- "API Reference"
- "Developer Documentation"
- "REST API Guide"
- "[Service] Integration Guide"
- "SDK Documentation"

### Key Success Factors

- ✅ Every endpoint fully documented
- ✅ Request/response examples that work
- ✅ Authentication clearly explained
- ✅ Error codes and handling documented
- ✅ Code examples in multiple languages

---

## Type Selection Guide

### Decision Matrix

**Question 1: Who is the primary audience?**
- End users (non-technical) → User Guide or Tutorial
- Developers → Reference or API Docs
- All users → FAQ

**Question 2: What's the primary goal?**
- Help users accomplish a task → User Guide
- Teach concepts/skills → Tutorial
- Provide comprehensive details → Reference
- Answer common questions → FAQ
- Enable integration → API Docs

**Question 3: What's the content structure?**
- Task-based procedures → User Guide
- Progressive learning steps → Tutorial
- Exhaustive option listing → Reference
- Question-answer format → FAQ
- Endpoint documentation → API Docs

### Keywords by Type

**User Guide Keywords**:
- "how to", "guide", "use", "do", "accomplish", "task"

**Tutorial Keywords**:
- "learn", "teach", "tutorial", "lesson", "practice", "build"

**Reference Keywords**:
- "API", "reference", "all options", "complete", "specification"

**FAQ Keywords**:
- "FAQ", "questions", "common", "frequently", "troubleshooting"

**API Docs Keywords**:
- "API", "endpoint", "integration", "developers", "SDK"

### Type Confusion Resolution

**User Guide vs Tutorial**:
- User Guide: "Here's how to do X" (task completion)
- Tutorial: "Here's how to learn X" (skill building)

**Reference vs API Docs**:
- Reference: General technical documentation
- API Docs: Specifically HTTP endpoints for developers

**FAQ vs User Guide**:
- FAQ: Quick answers (2-5 sentences)
- User Guide: Detailed procedures (step-by-step)

---

## Hybrid Documentation

### When to Combine Types

Sometimes documentation needs elements from multiple types:

**User Guide + FAQ**:
- User guide for main content
- FAQ section at end for quick answers

**Tutorial + Reference**:
- Tutorial for learning
- Reference section for complete details

**API Docs + Tutorial**:
- API reference for endpoints
- Getting Started tutorial for integration

### Structure for Hybrid Docs

```markdown
# [Feature] Documentation

## Part 1: Getting Started (Tutorial)
[Tutorial-style introduction]

## Part 2: User Guide
[Task-based procedures]

## Part 3: Reference
[Complete option/parameter listing]

## Part 4: FAQ
[Common questions]
```

**Guideline**: Primary type determines overall structure, secondary types are sections within.

---

## Summary

**5 Documentation Types**:
1. **User Guide**: Task-oriented, help users accomplish goals
2. **Tutorial**: Learning-oriented, teach through practice
3. **Reference**: Information-oriented, comprehensive details
4. **FAQ**: Problem-oriented, quick answers
5. **API Documentation**: Integration-oriented, developer endpoints

**Selection Criteria**:
- Audience (end users vs developers)
- Purpose (do task vs learn vs lookup vs integrate)
- Structure (procedures vs progressive vs exhaustive vs Q&A)

**Key Principle**: Choose type based on primary purpose and target audience. Use hybrid structures when multiple goals exist.
