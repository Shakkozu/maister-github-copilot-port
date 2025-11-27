---
name: plugin-skill-creator
description: Creates and manages skills for the ai-sdlc plugin. Use this when adding new skills to the plugin's skills/ directory.
allowed-tools: Read, Write, Edit, Glob, Bash
---

# Plugin Skill Creator

This skill helps you create new skills for the ai-sdlc Claude Code plugin.

## When to Use This Skill

Use this skill when you need to:
- Create a new skill for the ai-sdlc plugin
- Add functionality that should be bundled with the plugin
- Structure a skill with proper frontmatter and documentation

## Skill Creation Workflow

### 1. Understand the Purpose

Before creating a skill, clarify:
- What specific capability does this skill provide?
- When should it be invoked automatically?
- What tools does it need access to?
- Should it include reference documentation or templates?

### 2. Plan the Structure

Skills follow this structure:
```
skills/skill-name/
├── SKILL.md          (Required: frontmatter + instructions)
├── references/       (Optional: detailed docs, schemas, APIs)
├── scripts/          (Optional: executable helpers)
└── assets/           (Optional: templates, boilerplate)
```

### 3. Create the Skill Directory

Create the skill directory under the plugin's `skills/` folder:
```bash
mkdir -p skills/skill-name/references
```

### 4. Write SKILL.md

The SKILL.md file must include:

**Required YAML Frontmatter:**
```yaml
---
name: skill-name
description: Brief description (max 1024 chars) stating what the skill does and when to use it
---
```

**Optional Frontmatter Fields:**
```yaml
allowed-tools: Read, Write, Edit, Glob, Bash  # Restrict tool access
```

**Naming Rules:**
- Use lowercase letters, numbers, and hyphens only
- Maximum 64 characters
- Must be unique within the plugin

**Description Best Practices:**
- Clearly state what the skill does
- Include when it should be invoked
- Use keywords that trigger appropriate activation
- Keep it concise but specific

**Instruction Body:**
- Use imperative language (commands, not suggestions)
- Keep core instructions concise
- Reference detailed documentation in `references/` folder
- Use progressive disclosure: metadata → SKILL.md → bundled resources

### 5. Add Supporting Resources

**references/** - Detailed documentation that doesn't need to be loaded upfront:
- API schemas
- Detailed specifications
- Examples and templates
- Reference guides

**scripts/** - Executable code for deterministic tasks:
- Validation scripts
- Code generators
- File manipulators

**assets/** - Output templates and boilerplate:
- File templates
- Configuration examples
- Starter code

### 6. Test the Skill

After creating:
1. Test that the skill activates appropriately
2. Verify tool restrictions work as expected
3. Ensure instructions are clear and actionable
4. Check that reference files are properly linked

## Plugin Context

This skill creates skills specifically for the ai-sdlc plugin, which provides:
- Workflow commands for SDLC tasks
- Specialized agents for development workflows
- Coding standards management
- Verification and quality assurance capabilities

Skills should align with these SDLC-focused capabilities.

## Reference Documentation

See `references/plugin-structure.md` for detailed information about:
- Complete plugin directory structure
- Plugin manifest configuration
- Component integration patterns
- Best practices for plugin development