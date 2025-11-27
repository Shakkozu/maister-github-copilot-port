# Troubleshooting Guide

This guide helps you diagnose and resolve common issues when using the AI SDLC plugin.

## Table of Contents

- [Common Errors](#common-errors)
- [Recovery Procedures](#recovery-procedures)
- [Frequently Asked Questions (FAQ)](#frequently-asked-questions-faq)
- [Debugging Tips](#debugging-tips)
- [Getting Help](#getting-help)

---

## Common Errors

### Error: "Task directory not found"

**Symptoms:**
```
Error: Task directory not found: .ai-sdlc/tasks/new-features/2025-11-17-user-profile
```

**Causes:**
- Incorrect path provided to resume command
- Task directory was moved or deleted
- Working directory is not project root

**Solutions:**

1. **Verify the path** - List all task directories:
   ```bash
   ls -la .ai-sdlc/tasks/new-features/
   ```

2. **Use absolute path** - If working from subdirectory, use full path:
   ```bash
   /ai-sdlc:feature:resume /full/path/to/.ai-sdlc/tasks/new-features/2025-11-17-user-profile
   ```

3. **Check working directory** - Ensure you're in project root:
   ```bash
   pwd
   # Should show your project root directory
   ```

---

### Error: "Invalid workflow state"

**Symptoms:**
```
Error: Invalid workflow state - orchestrator-state.yml is corrupted or missing
```

**Causes:**
- State file was manually edited and became invalid
- State file was deleted
- Workflow interrupted during state write

**Solutions:**

1. **Attempt state reconstruction** - Use `--reconstruct` flag:
   ```bash
   /ai-sdlc:feature:resume [task-path] --reconstruct
   ```
   This reads artifacts (spec.md, implementation-plan.md) to rebuild state.

2. **Check state file validity** - Inspect the YAML file:
   ```bash
   cat .ai-sdlc/tasks/new-features/2025-11-17-user-profile/orchestrator-state.yml
   ```
   Ensure valid YAML syntax.

3. **Restart from specific phase** - Override resume point:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=implementation
   ```

4. **Start fresh** - If reconstruction fails, start a new task and copy relevant artifacts.

---

### Error: "Test suite failed"

**Symptoms:**
```
✗ Test suite failed: 245/250 tests passing (98%)
```

**Context:**
- Implementation phase completed but some tests are failing
- Verification phase detected test failures

**Solutions:**

1. **Review verification report** - Check which tests failed:
   ```bash
   cat .ai-sdlc/tasks/[type]/[task-name]/verification/implementation-verification.md
   ```

2. **Fix failing tests manually** - Address the specific test failures, then re-run:
   ```bash
   npm test  # or your test command
   ```

3. **Resume implementation** - If tests indicate incomplete work:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=implementation
   ```

4. **Reset auto-fix attempts** - If auto-recovery exhausted:
   ```bash
   /ai-sdlc:feature:resume [task-path] --reset-attempts
   ```

---

### Error: "Standards compliance check failed"

**Symptoms:**
```
⚠️ Standards compliance: 3/5 standards applied
Missing: Error handling patterns, Logging conventions
```

**Causes:**
- Implementation didn't follow all project standards
- Standards were added to INDEX.md after implementation started

**Solutions:**

1. **Review missing standards** - Check which standards weren't applied:
   ```bash
   cat .ai-sdlc/tasks/[type]/[task-name]/verification/implementation-verification.md
   ```

2. **Review INDEX.md** - Understand the missing standards:
   ```bash
   cat .ai-sdlc/docs/INDEX.md
   ```

3. **Apply standards manually** - Update code to follow missing standards, then:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=verification
   ```

4. **Update work-log.md** - Document which standards you applied:
   ```bash
   # In implementation/work-log.md
   ## Manual Standards Application
   - Applied error handling patterns from standards/backend/error-handling.md
   - Added logging using conventions from standards/global/logging.md
   ```

---

### Error: "Dependency resolution failed" (Initiatives)

**Symptoms:**
```
Error: Circular dependency detected: task-A → task-B → task-C → task-A
```

**Causes:**
- Tasks have circular dependencies
- Dependency graph is invalid

**Solutions:**

1. **Review initiative plan** - Check dependency graph:
   ```bash
   cat .ai-sdlc/docs/project/initiatives/[initiative-name]/task-plan.md
   ```

2. **Use status command** - Visualize dependencies:
   ```bash
   /ai-sdlc:initiative:status [initiative-path] --graph
   ```

3. **Fix metadata.yml** - Edit task dependencies in each task's `metadata.yml`:
   ```yaml
   dependencies:
     - task-id-1
     - task-id-2
   blocks: []
   ```

4. **Resume initiative** - After fixing dependencies:
   ```bash
   /ai-sdlc:initiative:resume [initiative-path]
   ```

---

### Error: "Auto-recovery attempts exhausted"

**Symptoms:**
```
❌ Auto-recovery exhausted: implementation phase failed after 3 attempts
```

**Causes:**
- Persistent error that auto-fix can't resolve
- Logic error requiring manual intervention

**Solutions:**

1. **Review failure details** - Check state file:
   ```bash
   cat .ai-sdlc/tasks/[type]/[task-name]/orchestrator-state.yml
   # Look at failures: []
   ```

2. **Fix the underlying issue manually** - Address the root cause

3. **Reset attempts and resume** - After manual fix:
   ```bash
   /ai-sdlc:feature:resume [task-path] --reset-attempts
   ```

4. **Clear failures and continue** - If issue is resolved:
   ```bash
   /ai-sdlc:feature:resume [task-path] --clear-failures
   ```

---

### Error: "Behavior verification failed" (Refactoring)

**Symptoms:**
```
❌ Behavior Verification: FAILED
Detected behavior changes:
- Function signature changed: getUserProfile(id) → getUserProfile(id, options)
- Test results differ: 5 tests now failing
```

**Causes:**
- Refactoring inadvertently changed behavior
- Tests are now failing that previously passed

**Solutions:**

1. **Review behavior report** - Understand what changed:
   ```bash
   cat .ai-sdlc/tasks/refactoring/[task-name]/verification/behavior-verification-report.md
   ```

2. **Automatic rollback** - Refactoring workflows auto-rollback on behavior change:
   ```
   Git checkpoint branch: refactor-[task-name]-checkpoint-1
   Rollback: git checkout refactor-[task-name]-checkpoint-1
   ```

3. **Manual rollback** - If you need to rollback:
   ```bash
   git checkout refactor-[task-name]-checkpoint-N
   ```

4. **Fix and retry** - Correct the refactoring to preserve behavior:
   ```bash
   /ai-sdlc:refactoring:resume [task-path] --from=execution
   ```

**Important**: Refactoring must preserve behavior exactly. Any change = failed refactoring.

---

### Error: "E2E tests failed"

**Symptoms:**
```
❌ E2E Test Verification: 3 critical issues found
- User profile page not accessible
- Avatar upload button not found
```

**Causes:**
- Implementation doesn't match specification
- UI elements missing or incorrectly placed
- JavaScript errors in browser

**Solutions:**

1. **Review E2E report** - Check screenshots and errors:
   ```bash
   cat .ai-sdlc/tasks/[type]/[task-name]/verification/e2e-verification-report.md
   ```

2. **Check browser console errors** - Look for JavaScript errors in report

3. **Fix UI issues** - Update implementation to match spec

4. **Re-run E2E tests** - After fixes:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=e2e-testing
   ```

---

## Recovery Procedures

### Recovering from Failed Workflow

1. **Identify the failure point** - Check orchestrator-state.yml:
   ```bash
   cat [task-path]/orchestrator-state.yml
   ```

2. **Review error details** - Check verification reports or work-log.md

3. **Fix the issue manually** - Address the root cause

4. **Resume from appropriate phase**:
   ```bash
   /ai-sdlc:[workflow]:resume [task-path] --from=[phase]
   ```

**Available phases**:
- `specification` - Restart requirements gathering
- `planning` - Recreate implementation plan
- `implementation` - Re-execute implementation
- `verification` - Re-run verification
- `e2e-testing` - Re-run E2E tests (if applicable)
- `user-documentation` - Regenerate user docs (if applicable)

### Recovering from Lost State File

If `orchestrator-state.yml` is deleted or corrupted:

1. **Attempt reconstruction**:
   ```bash
   /ai-sdlc:feature:resume [task-path] --reconstruct
   ```

2. **Manual reconstruction** - Create minimal state file:
   ```yaml
   workflow: feature
   current_phase: implementation
   phase_history:
     - specification: completed
     - planning: completed
   execution_mode: interactive
   options: {}
   auto_fix_attempts: {}
   failures: []
   created_at: 2025-11-17T10:00:00Z
   updated_at: 2025-11-17T11:00:00Z
   ```

3. **Resume with override**:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=verification
   ```

### Recovering from Git Conflicts

If you have uncommitted changes and workflow creates conflicts:

1. **Stash current changes**:
   ```bash
   git stash
   ```

2. **Resume workflow**:
   ```bash
   /ai-sdlc:feature:resume [task-path]
   ```

3. **After completion, apply stash**:
   ```bash
   git stash pop
   # Resolve conflicts manually
   ```

---

## Frequently Asked Questions (FAQ)

### General Questions

**Q: How do I know which workflow to use?**

A: Use `/work [description]` and let the plugin auto-classify. It analyzes your description and codebase context to recommend the best workflow.

**Q: Can I skip phases in a workflow?**

A: Not recommended. Workflows are designed as complete end-to-end processes. However, you can resume from a specific phase using `--from=[phase]`.

**Q: What's the difference between YOLO mode and interactive mode?**

A:
- **Interactive** (default): Pauses between phases for your review
- **YOLO** (`--yolo` flag): Runs all phases continuously without pausing

**Q: Can I run multiple workflows in parallel?**

A: Yes, each task is independent. You can have multiple tasks in progress simultaneously in different directories.

**Q: How do I customize the workflows?**

A:
1. Modify standards in `.ai-sdlc/docs/standards/` - workflows will discover and apply them
2. Create custom skills/agents (see [Contributing.md](Contributing.md))
3. Extend existing workflows by forking skills

---

### Task Management Questions

**Q: Where are my tasks stored?**

A: All tasks are in `.ai-sdlc/tasks/[type]/YYYY-MM-DD-task-name/`

**Q: How do I see all my tasks?**

A:
```bash
ls -la .ai-sdlc/tasks/*/
```

Or list by type:
```bash
ls -la .ai-sdlc/tasks/new-features/
ls -la .ai-sdlc/tasks/bug-fixes/
```

**Q: Can I rename a task directory?**

A: Yes, but you'll need to update references in:
- Initiative metadata (if task is part of initiative)
- Resume commands (use new path)

**Q: How do I delete a task?**

A: Simply remove the directory:
```bash
rm -rf .ai-sdlc/tasks/new-features/2025-11-17-unwanted-task
```

---

### Standards Questions

**Q: How do I add a new coding standard?**

A:
1. Create file in `.ai-sdlc/docs/standards/[category]/my-standard.md`
2. Update `.ai-sdlc/docs/INDEX.md` to reference it
3. Workflows will automatically discover and apply it

**Q: What if my project already has coding standards?**

A: Use `/ai-sdlc:standards:discover` to auto-discover from:
- Configuration files (eslint, prettier, etc.)
- Existing code patterns
- Documentation
- Pull request patterns
- CI/CD configs

**Q: How do I know which standards are being applied?**

A: Check the work-log.md file in your task:
```bash
cat .ai-sdlc/tasks/[type]/[task-name]/implementation/work-log.md
# Look for "Standards Applied" sections
```

---

### Verification Questions

**Q: What does "Passed with Issues" mean?**

A: Implementation is 90-99% complete with 90-94% tests passing. Minor issues exist but nothing critical. Review verification report for details.

**Q: When should I run code review?**

A: Code review is optional but recommended for:
- Production deployments
- Security-sensitive features
- Performance-critical code
- Large refactorings

**Q: What's the difference between implementation verification and reality check?**

A:
- **Implementation Verification**: Technical correctness (tests pass, standards applied, docs complete)
- **Reality Check**: Functional reality (actually solves the problem, usable by real users)

---

### Initiative Questions

**Q: When should I use an initiative instead of individual tasks?**

A: Use initiatives when:
- You have 3-15 related tasks
- Tasks have dependencies (task B needs task A done first)
- You want coordinated progress tracking
- Multi-week project with multiple phases

**Q: How do I track initiative progress?**

A:
```bash
/ai-sdlc:initiative:status [initiative-path]
```

Shows:
- Progress percentage
- Task states (pending/in-progress/completed/failed)
- Dependency graph
- Blocked tasks
- Next steps

**Q: Can I add tasks to an initiative after it starts?**

A: Yes, but you'll need to:
1. Update `initiative.yml` with new task
2. Create task directory with `initiative_id` in metadata
3. Update dependencies if needed
4. Resume initiative

---

## Debugging Tips

### Enable Verbose Logging

Check work-log.md for detailed execution logs:

```bash
tail -f .ai-sdlc/tasks/[type]/[task-name]/implementation/work-log.md
```

### Inspect State Files

State files reveal current workflow status:

```bash
cat [task-path]/orchestrator-state.yml
cat [task-path]/metadata.yml
```

### Check Test Output

Review test results in verification reports:

```bash
cat [task-path]/verification/implementation-verification.md
```

### Verify Standards Discovery

Check if INDEX.md is being read:

```bash
cat .ai-sdlc/docs/INDEX.md
# Ensure standards are listed
```

### Check File Permissions

Ensure plugin can write to task directories:

```bash
ls -la .ai-sdlc/tasks/
```

All directories should be writable.

### Validate YAML Syntax

If state files are corrupted, validate YAML:

```bash
# Using Python
python -c "import yaml; yaml.safe_load(open('[file].yml'))"

# Using Node.js
node -e "console.log(require('js-yaml').load(require('fs').readFileSync('[file].yml')))"
```

### Check Git Status

Ensure no conflicting changes:

```bash
git status
git diff
```

### Review Plugin Metadata

Verify plugin is correctly installed:

```bash
cat .claude-plugin/plugin.json
```

---

## Getting Help

### 1. Check Documentation

- [Quick Start](Quick-Start.md) - Hands-on tutorial
- [Architecture](Architecture.md) - Understanding components
- [Workflow Guides](../README.md#core-workflows) - Detailed workflow documentation

### 2. Search Existing Issues

Check if your issue has been reported:
- Plugin repository issues
- Community discussions

### 3. Review Verification Reports

Most issues are documented in verification reports:

```bash
cat .ai-sdlc/tasks/[type]/[task-name]/verification/*.md
```

### 4. Ask for Help

When asking for help, provide:
- **Workflow type** - Feature, bug fix, enhancement, etc.
- **Current phase** - Where did it fail?
- **Error message** - Exact error text
- **State file** - Contents of orchestrator-state.yml
- **Verification report** - If available
- **Steps to reproduce** - What you were doing when error occurred

### 5. Report Bugs

If you found a bug, report with:
- Clear description of expected vs actual behavior
- Minimal reproduction steps
- Environment details (OS, Claude Code version)
- Relevant log files
- Task directory structure (if applicable)

---

## Common Scenarios & Solutions

### Scenario: "I want to cancel a workflow"

**Solution**: Workflows support pause/resume. Simply stop responding:
1. Close Claude Code or interrupt the workflow
2. Later, resume with:
   ```bash
   /ai-sdlc:[workflow]:resume [task-path]
   ```

Or start fresh:
```bash
rm -rf .ai-sdlc/tasks/[type]/[task-name]
```

---

### Scenario: "Tests are failing but I think they're wrong"

**Solution**:
1. Review the tests in your test suite
2. If tests are incorrect, fix them manually
3. Re-run verification:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=verification
   ```

---

### Scenario: "Workflow created files I don't want"

**Solution**:
1. Review work-log.md to see what was created
2. Delete unwanted files manually
3. Update implementation-plan.md to mark affected steps as incomplete
4. Resume implementation:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=implementation
   ```

---

### Scenario: "I want to change the specification mid-workflow"

**Solution**:
1. Edit `implementation/spec.md` manually
2. Resume from planning to regenerate implementation plan:
   ```bash
   /ai-sdlc:feature:resume [task-path] --from=planning
   ```

---

### Scenario: "Initiative task failed - how do I recover?"

**Solution**:
1. Check which task failed:
   ```bash
   /ai-sdlc:initiative:status [initiative-path]
   ```
2. Fix the failed task:
   ```bash
   /ai-sdlc:[workflow]:resume [failed-task-path]
   ```
3. Resume initiative:
   ```bash
   /ai-sdlc:initiative:resume [initiative-path]
   ```

Initiative will continue from where it left off.

---

**Still stuck?** Check the [Architecture](Architecture.md) to understand how components work together, or consult workflow-specific guides in [docs/guides/](guides/).
