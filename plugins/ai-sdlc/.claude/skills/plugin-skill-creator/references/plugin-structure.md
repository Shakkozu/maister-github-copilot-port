# Plugin Structure Reference

## Complete Directory Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json           # Required manifest
├── commands/                  # Slash commands (optional)
│   └── command-name/
│       └── command-name.md
├── agents/                    # Specialized agents (optional)
│   └── agent-name.md
├── skills/                    # Agent Skills (optional)
│   └── skill-name/
│       ├── SKILL.md          # Required
│       ├── references/       # Optional
│       ├── scripts/          # Optional
│       └── assets/           # Optional
├── hooks/                     # Event handlers (optional)
│   └── hooks.json
├── .mcp.json                 # MCP servers (optional)
└── CLAUDE.md                 # Plugin documentation (recommended)
```

## Plugin Manifest (plugin.json)

### Required Fields
```json
{
  "name": "plugin-name"
}
```

### Complete Example
```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief description of plugin functionality",
  "author": {
    "name": "Author Name",
    "email": "email@example.com"
  },
  "homepage": "https://example.com",
  "repository": "https://github.com/org/repo",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": "${CLAUDE_PLUGIN_ROOT}/commands",
  "agents": "${CLAUDE_PLUGIN_ROOT}/agents",
  "hooks": "${CLAUDE_PLUGIN_ROOT}/hooks/hooks.json",
  "mcpServers": "${CLAUDE_PLUGIN_ROOT}/.mcp.json"
}
```

**Important:** Always use `${CLAUDE_PLUGIN_ROOT}` for paths to ensure correct resolution across installations.

## Component Types

### 1. Commands (Slash Commands)

**Location:** `commands/command-name/command-name.md`

**Purpose:** User-invoked commands that extend functionality

**Format:** Markdown files with optional YAML frontmatter

**Example:**
```markdown
---
description: Short description of what the command does
---

# Command Instructions

Detailed instructions for Claude on what to do when this command is invoked.
```

### 2. Agents

**Location:** `agents/agent-name.md`

**Purpose:** Specialized subagents for specific tasks

**Format:** Markdown files with frontmatter describing capabilities

**Example:**
```markdown
---
name: agent-name
description: What this agent specializes in
---

# Agent Instructions

Detailed instructions for the agent's behavior and capabilities.
```

### 3. Skills

**Location:** `skills/skill-name/SKILL.md`

**Purpose:** Model-invoked capabilities that Claude uses autonomously

**Required Frontmatter:**
```yaml
---
name: skill-name
description: What the skill does and when to use it (max 1024 chars)
---
```

**Optional Frontmatter:**
```yaml
---
name: skill-name
description: Skill description
allowed-tools: Read, Write, Edit, Glob, Bash
---
```

**Naming Rules:**
- Lowercase letters, numbers, hyphens only
- Maximum 64 characters
- Must be unique

**Supporting Files:**
- `references/` - Detailed documentation loaded as needed
- `scripts/` - Executable helpers
- `assets/` - Templates and boilerplate

### 4. Hooks

**Location:** `hooks/hooks.json`

**Purpose:** Event handlers for workflow automation

**Available Events:**
- `PreToolUse` - Before any tool execution
- `PostToolUse` - After tool execution
- `UserPromptSubmit` - When user submits input
- `Notification` - System notifications
- `Stop` - When execution stops
- `SessionStart` - Session initialization
- `SessionEnd` - Session cleanup
- `PreCompact` - Before context compaction

**Example:**
```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "command": "bash -c 'echo \"About to use tool\"'"
    }
  ]
}
```

### 5. MCP Servers

**Location:** `.mcp.json`

**Purpose:** External tool integration via Model Context Protocol

**Example:**
```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["path/to/server.js"]
    }
  }
}
```

## Best Practices

### For Skills
1. **Keep SKILL.md concise** - Use progressive disclosure
2. **Store details in references/** - API docs, schemas, examples
3. **Use specific descriptions** - Include triggering keywords
4. **Restrict tools when possible** - Use `allowed-tools` for security
5. **One capability per skill** - Keep skills focused

### For Plugins
1. **Use `${CLAUDE_PLUGIN_ROOT}`** - Always for path references
2. **Include CLAUDE.md** - Document plugin purpose and usage
3. **Version your plugin** - Use semantic versioning
4. **Test all components** - Verify commands, skills, agents work
5. **Keep metadata current** - Update description and keywords

### For the ai-sdlc Plugin Specifically
- Focus on SDLC workflow capabilities
- Align with feature development, bug fixes, code reviews
- Support standards management and verification
- Integrate with existing agents and commands
- Maintain consistency with plugin's SDLC focus

## Distribution

Plugins are installed from marketplaces - curated catalogs of available plugins. Users install via:
```
/plugin install plugin-name@org
```

Plugin skills are automatically available when the plugin is installed.