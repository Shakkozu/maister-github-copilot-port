---
name: ai-sdlc:documentation:resume
description: Resume an interrupted or failed documentation workflow from where it left off
category: Documentation Workflows
---

# Resume Documentation Creation Workflow

Resume interrupted documentation creation workflow from saved state.

## Command Usage

```bash
/ai-sdlc:documentation:resume [task-path] [--from=phase] [--reset-attempts] [--clear-failures]
```

### Arguments

- **task-path** (optional): Path to task directory
  - Example: `.ai-sdlc/tasks/documentation/2025-11-17-user-guide`
  - If omitted, you'll be prompted

### Options

- `--from=PHASE`: Override state, force start from specific phase
  - Values: `planning`, `content`, `review`, `publication`
- `--reset-attempts`: Reset auto-fix attempt counters
- `--clear-failures`: Remove failed_phases from state

## Examples

### Example 1: Simple Resume

```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide
```

Reads state, continues from next phase.

### Example 2: Resume After Review Failure

```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide --from=content
```

Review failed (readability too low), manually edited content, restart from content phase to regenerate and re-review.

### Example 3: Re-Capture Screenshots

```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide --from=content --reset-attempts
```

Application UI changed, need to re-capture screenshots. Resets attempts, restarts content creation phase.

### Example 4: Reset After Manual Fixes

```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide --reset-attempts --clear-failures
```

Fixed issues manually, clears failure history, gives fresh auto-fix attempts.

### Example 5: Force Publication After Manual Review

```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-user-guide --from=publication
```

Manually verified documentation quality, skip automated review, go straight to publication.

## What You Are Doing

**Invoke documentation-orchestrator skill in resume mode.**

Resume steps:
1. **Locate and validate task**: Check task directory exists, contains required structure
2. **Read and validate state**: Load `orchestrator-state.yml`, validate documentation context
3. **Determine resume point**: Check completed_phases to find next phase, respect review gate
4. **Validate prerequisites**: Ensure required files exist for next phase
5. **Apply state modifications**: Apply `--from`, `--reset-attempts`, `--clear-failures` if specified
6. **Continue workflow**: Resume from determined phase

## Use Cases

### Computer Restarted Mid-Documentation

**Scenario**: Computer restarted during Phase 1 (Content Creation)

**Solution**:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task
```

State preserved, workflow continues from last completed phase + 1.

### Review Failed (Readability Too Low)

**Scenario**: Phase 2 review failed, Flesch Reading Ease = 45 (target: >60)

**Options**:
1. **Auto-fix** (if attempts remain):
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task
   ```
   Workflow returns to Phase 1 to simplify language automatically.

2. **Manual fix** (if auto-fix exhausted):
   - Edit `documentation/[doc-name].md` manually (simplify language, shorter sentences)
   - Resume from content phase to re-validate:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content --reset-attempts
   ```

### Application Updated, Screenshots Outdated

**Scenario**: UI changed, screenshots no longer match current application

**Solution**:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content --reset-attempts
```

Re-runs content creation phase, re-captures all screenshots with updated UI.

### Want to Recapture Specific Screenshots

**Scenario**: Most screenshots fine, but 2-3 need updates

**Solution**:
1. Delete outdated screenshots from `documentation/screenshots/`
2. Resume from content phase:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content
   ```
   Content creation detects missing screenshots, recaptures only those.

### Phase Failed After Max Attempts

**Scenario**: Phase 1 failed 3 times (screenshot capture issues), auto-fix exhausted

**Solution**:
1. Fix underlying issue (start application, fix Playwright config)
2. Reset attempts and retry:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --reset-attempts
   ```

## Review Failure Gate (Critical)

**Phase 2 review is a quality gate. Phase 3 publication cannot proceed until review passes.**

### Review Failed Example

```yaml
documentation_context:
  review_passed: false  # BLOCKS Phase 3
```

**Review Report Shows**:
```
⚠️ Documentation Review Failed

Cannot proceed to publication until review passes.

Issues found:
- Readability: Flesch Ease = 45 (target: >60)
- Readability: Grade Level = 12 (target: <10)
- Missing sections: Troubleshooting, Next Steps
- Broken links: 2 links not found
- Technical jargon: 15 instances flagged

Recommendations:
1. Simplify language (shorter sentences, simpler words)
2. Add missing sections from outline
3. Fix broken links to [related-guide.md] and [api-docs.md]
4. Replace jargon: "instantiate" → "create", "terminate" → "stop"
```

**Options**:

**Option 1: Return to Phase 1 (Auto-Fix)**
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task
```
Workflow returns to content creation, attempts automatic fixes.

**Option 2: Manual Edit + Re-Review**
1. Edit `documentation/[doc-name].md` manually
2. Simplify language, add missing sections, fix links
3. Resume from review phase:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=review --reset-attempts
```

**Option 3: Override Review (Not Recommended)**
1. Manually set `review_passed: true` in `orchestrator-state.yml`
2. Force publication:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=publication
```
**Warning**: Bypasses quality validation, may publish unclear documentation.

## State Reconstruction (Experimental)

If `orchestrator-state.yml` missing but artifacts exist, workflow attempts reconstruction:

**Phase Completion Detection**:
1. Check `planning/documentation-outline.md` → Phase 0 complete
2. Check `documentation/[doc-name].md` exists → Phase 1 complete
3. Check `verification/documentation-review.md` exists → Phase 2 complete
4. Check published documentation in target location → Phase 3 complete

**Documentation Context Reconstruction**:
- Read doc type from outline or content metadata
- Detect target audience from tone and language used
- Extract readability metrics from review report (if exists)

**Limitation**: Reconstructed state may be incomplete. Best practice: Don't delete state file.

Resume from most recent complete phase + 1.

## Prerequisites Validation

**Phase 1 (Content Creation)** requires:
- `planning/documentation-outline.md` (from Phase 0)
- Application running (if capturing screenshots)
- Playwright configured (playwright-mcp server)

**Phase 2 (Review)** requires:
- `documentation/[doc-name].md` (from Phase 1)
- `planning/documentation-outline.md` (to check completeness)

**Phase 3 (Publication)** requires:
- `documentation/[doc-name].md` (from Phase 1)
- `verification/documentation-review.md` (from Phase 2)
- `documentation_context.review_passed: true` (Phase 2 must PASS)

**Missing Prerequisites**: Workflow prompts to start from earlier phase.

## Common Scenarios

### Scenario: Planning Phase Unclear About Doc Type

**Problem**: Planning agent couldn't determine if user guide or tutorial

**Solution**:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=planning
```

Orchestrator prompts: "Is this a user guide (task-focused) or tutorial (learning-focused)?"

### Scenario: Screenshot Capture Failing

**Problem**: Phase 1 failing, screenshots not capturing

**Root Causes**:
- Application not running
- Playwright not configured
- Browser automation blocked
- URL not accessible

**Solution**:
1. Fix root cause (start app, configure playwright-mcp)
2. Resume with reset:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content --reset-attempts
   ```

### Scenario: Phase Keeps Failing

**Problem**: Phase fails, auto-fix exhausted, keeps failing even after reset

**Solution**:
1. Read phase output carefully (check logs in `implementation/work-log.md`)
2. Identify root cause
3. Fix manually (edit files, fix configuration)
4. Skip problematic phase:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=next-phase
   ```

### Scenario: Want to Restart a Phase

**Problem**: Phase completed but want to redo it (e.g., regenerate content with different approach)

**Solution**:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=phase-name --reset-attempts --clear-failures
```

Restarts phase with fresh state.

### Scenario: Application Updated Mid-Documentation

**Problem**: Started documenting v1.0, app updated to v1.1 with UI changes

**Solution**:
1. Review changes in `documentation/[doc-name].md`, keep text that's still accurate
2. Delete outdated screenshots
3. Re-run content creation:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content --reset-attempts
   ```
   Regenerates content, re-captures screenshots with v1.1 UI.

## Tips for Safe Resume

**Always Review State Before Resume**:
```bash
cat .ai-sdlc/tasks/documentation/2025-11-17-task/orchestrator-state.yml
```

Check:
- `current_phase`: Where did it stop?
- `completed_phases`: What's done?
- `documentation_context.review_passed`: Did review pass?
- `failed_phases`: What failed previously?

**After Manual Edits**:
- Resume from phase after edited content (e.g., edited content → resume from review)
- Use `--reset-attempts` to give fresh auto-fix attempts

**Before Re-Running Phase**:
- Use `--clear-failures` to remove failure history
- Use `--reset-attempts` to reset attempt counters

**When Uncertain**:
- Start from earlier phase (safer than skipping)
- Use `--from=planning` to restart entire workflow if state unclear

## Troubleshooting

### State File Corrupted

**Symptoms**: YAML parse errors, missing required fields

**Solution**:
1. Backup corrupted file: `cp orchestrator-state.yml orchestrator-state.yml.bak`
2. Delete corrupted file: `rm orchestrator-state.yml`
3. Resume (triggers reconstruction):
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task
   ```

### Can't Determine Resume Point

**Symptoms**: State file missing, unclear which phase completed

**Solution**: Use `--from=phase` to specify explicitly:
```bash
/ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content
```

### Playwright Issues

**Symptoms**: "playwright-mcp server not found", "browser not installed"

**Solution**:
1. Install Playwright: `npx playwright install`
2. Configure playwright-mcp server in Claude Code settings
3. Verify server running: Check MCP server status
4. Resume after fixing:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --reset-attempts
   ```

### Application Not Running

**Symptoms**: Screenshots failing, "connection refused", "cannot navigate to URL"

**Solution**:
1. Start application (e.g., `npm start`, `./run.sh`)
2. Verify accessible in browser
3. Resume:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=content --reset-attempts
   ```

### Review Keeps Failing (Readability)

**Symptoms**: Flesch scores consistently below target despite auto-fix attempts

**Solution**: Manual intervention required
1. Read review report: `verification/documentation-review.md`
2. Identify specific issues (long sentences, jargon, complex words)
3. Edit `documentation/[doc-name].md`:
   - Shorten sentences (15-20 words max)
   - Replace jargon with simple words
   - Break long paragraphs
   - Add examples and analogies
4. Resume from review:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=review --reset-attempts
   ```

### Publication Fails (Integration)

**Symptoms**: "target directory not found", "permission denied", "file format incompatible"

**Solution**:
1. Check target documentation directory exists
2. Verify write permissions
3. Review publication logs in `implementation/work-log.md`
4. Fix directory/permissions issues
5. Resume:
   ```bash
   /ai-sdlc:documentation:resume .ai-sdlc/tasks/documentation/2025-11-17-task --from=publication --reset-attempts
   ```

## Related Commands

- `/ai-sdlc:documentation:new` - Start new documentation workflow
- `/init-sdlc` - Initialize documentation structure

## State File Format

Example `orchestrator-state.yml`:

```yaml
workflow_type: documentation
current_phase: review
completed_phases:
  - planning
  - content
failed_phases: []
phase_attempts:
  planning: 1
  content: 2
  review: 0
  publication: 0
execution_mode: interactive  # or yolo
documentation_context:
  doc_type: user-guide  # user-guide, tutorial, reference, faq, api-docs
  target_audience: end-users  # end-users, developers, admins, power-users
  tone: friendly  # friendly, technical, formal
  readability_target:
    ease: 60  # Flesch Reading Ease target
    grade: 8  # Grade level target
  screenshot_count: 15
  review_passed: false  # MUST be true before Phase 3
  doc_filename: user-guide.md
created_at: "2025-11-17T10:00:00Z"
updated_at: "2025-11-17T12:30:00Z"
```

## Important Notes

**Review Gate**: Phase 3 (Publication) CANNOT proceed until `documentation_context.review_passed: true`. This ensures quality documentation is published.

**Screenshot Recapture**: Deleting screenshots from `documentation/screenshots/` and resuming from content phase will re-capture only missing screenshots.

**Manual Edits**: After editing documentation manually, always resume from review phase to re-validate quality.

**State Preservation**: Always keep `orchestrator-state.yml`. If lost, reconstruction is possible but may be incomplete.

**Auto-Fix Attempts**: Phase-specific limits prevent infinite retry loops. Use `--reset-attempts` after fixing root cause.

## Invoke

Invoke the **documentation-orchestrator** skill in resume mode to continue documentation creation from saved state with quality validation and publication.
