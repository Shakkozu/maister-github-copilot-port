# Implementation Plan: Add Support for Migration Tasks

## Overview
Total Steps: 31
Task Groups: 6
Expected Tests: 22-58 tests (5 implementation groups × 2-8 tests + max 10 additional)

## Implementation Steps

### Task Group 1: Migration Orchestrator Skill
**Dependencies:** None
**Estimated Steps:** 6

- [x] 1.0 Complete migration-orchestrator skill
  - [x] 1.1 Write 2-8 focused tests for orchestrator workflow
    - Limit to 2-8 highly focused tests maximum
    - Test only critical orchestrator behaviors (e.g., phase execution order, state management, migration type detection)
    - Skip exhaustive coverage of all phases and edge cases
  - [x] 1.2 Create skills/migration-orchestrator/SKILL.md
    - Follow structure from feature-orchestrator/SKILL.md
    - Sections: When to Use, Core Principles, Execution Modes, Workflow Phases (0-6)
    - Include migration type detection logic (code/data/architecture keywords)
    - Document auto-recovery strategies for each phase
    - Reuse pattern from: `skills/feature-orchestrator/SKILL.md` and `skills/enhancement-orchestrator/SKILL.md`
  - [x] 1.3 Implement orchestrator workflow execution logic
    - Initialization: Parse arguments, create state file, detect migration type
    - Phase execution loop: Execute phases 0-6 sequentially
    - State management: Track completed/failed phases, migration-specific fields
    - Auto-fix strategies: Max 2-5 attempts per phase
  - [x] 1.4 Add migration type detection
    - Code migrations: framework/library names, "upgrade", "migrate from X to Y"
    - Data migrations: database names, "schema change", "data migration"
    - Architecture migrations: pattern names (REST/GraphQL), "refactor to"
    - Store in orchestrator-state.yml: migration_type field
    - Prompt user to confirm detected type
  - [x] 1.5 Implement interactive and YOLO modes
    - Interactive: Pause after each phase, prompt for continuation
    - YOLO: Run all phases continuously without pausing
    - Mode selection from --yolo flag
  - [x] 1.6 Ensure orchestrator skill tests pass
    - Run ONLY the 2-8 tests written in 1.1
    - Verify phase execution order correct
    - Verify migration type detection works
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-8 tests written in 1.1 pass
- SKILL.md follows feature-orchestrator structure
- Migration type detection identifies code/data/architecture types
- Interactive and YOLO modes work correctly
- State file tracks migration-specific fields

### Task Group 2: Migration Reference Documentation
**Dependencies:** Task Group 1 (Orchestrator Skill)
**Estimated Steps:** 5

- [x] 2.0 Complete migration reference documentation
  - [x] 2.1 Write 2-8 focused tests for reference content validation
    - Limit to 2-8 highly focused tests maximum
    - Test only critical reference content (e.g., strategy patterns exist, migration type guides complete, auto-fix patterns documented)
    - Skip exhaustive testing of all reference scenarios
  - [x] 2.2 Create skills/migration-orchestrator/references/migration-strategies.md
    - Document incremental migration pattern (migrate piece by piece)
    - Document rollback planning pattern (undo procedures)
    - Document dual-run pattern (old + new systems parallel)
    - Include decision criteria for each strategy
    - Follow reference style from feature-orchestrator/references/
  - [x] 2.3 Create skills/migration-orchestrator/references/migration-types.md
    - Code migrations guide (framework/library changes)
    - Data migrations guide (database platform changes)
    - Architecture migrations guide (pattern refactoring)
    - Include examples for each type
  - [x] 2.4 Create skills/migration-orchestrator/references/auto-fix-strategies.md
    - Phase 0 (Analysis): Retry with expanded search (max 2 attempts)
    - Phase 1 (Target Planning): Re-prompt user (max 2 attempts)
    - Phase 2 (Specification): Regenerate spec (max 2 attempts)
    - Phase 3 (Planning): Regenerate plan (max 2 attempts)
    - Phase 4 (Execution): Fix syntax/imports/tests (max 5 retries)
    - Phase 5 (Verification): Re-run tests (max 2 attempts)
    - Phase 6 (Docs): Text-only fallback (max 1 attempt)
  - [x] 2.5 Ensure reference documentation tests pass
    - Run ONLY the 2-8 tests written in 2.1
    - Verify all reference files exist and are complete
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-8 tests written in 2.1 pass
- All three reference files created
- Migration strategies documented (incremental, rollback, dual-run)
- Migration types documented (code, data, architecture)
- Auto-fix strategies documented for all 7 phases

### Task Group 3: Slash Commands
**Dependencies:** Task Group 1 (Orchestrator Skill)
**Estimated Steps:** 5

- [x] 3.0 Complete migration slash commands
  - [x] 3.1 Write 2-8 focused tests for command functionality
    - Limit to 2-8 highly focused tests maximum
    - Test only critical command behaviors (e.g., skill invocation, option parsing, task folder creation)
    - Skip exhaustive testing of all command options
  - [x] 3.2 Create commands/migration/new.md
    - Follow pattern from: `commands/feature/new.md`
    - Document command usage: /ai-sdlc:migration:new [description] [options]
    - Options: --yolo, --from=PHASE, --type=TYPE
    - Explain workflow phases (0-6)
    - Include examples (interactive mode, YOLO mode, resume from phase)
    - Document skill invocation: Skill tool with "ai-sdlc:migration-orchestrator"
  - [x] 3.3 Create commands/migration/resume.md
    - Follow pattern from: `commands/feature/resume.md`
    - Document command usage: /ai-sdlc:migration:resume [task-path] [options]
    - Options: --from=PHASE, --reset-attempts, --clear-failures
    - Explain state file reading and resume logic
    - Include examples (simple resume, force phase, after manual fixes)
  - [x] 3.4 Update commands directory structure
    - Create commands/migration/ directory
    - Ensure commands are discoverable by Claude Code
    - Verify command metadata (name, description, category)
  - [x] 3.5 Ensure slash command tests pass
    - Run ONLY the 2-8 tests written in 3.1
    - Verify commands invoke migration-orchestrator skill
    - Verify option parsing works correctly
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-8 tests written in 3.1 pass
- Both new.md and resume.md created
- Commands follow existing orchestrator command patterns
- Command options documented (--yolo, --from, --type, --reset-attempts, --clear-failures)
- Commands invoke migration-orchestrator skill correctly

### Task Group 4: Task Classifier Integration
**Dependencies:** Task Group 1 (Orchestrator Skill), Task Group 3 (Commands)
**Estimated Steps:** 5

- [x] 4.0 Complete task-classifier integration
  - [x] 4.1 Write 2-8 focused tests for migration classification
    - Limit to 2-8 highly focused tests maximum
    - Test only critical classification behaviors (e.g., keyword detection, migration routing, confidence scoring)
    - Skip exhaustive testing of all keyword combinations
  - [x] 4.2 Update agents/task-classifier.md or skills/task-classifier/
    - Add migration keyword detection
    - Keywords: "migrate", "migration", "move from X to Y", "upgrade to", framework names, database names
    - Confidence scoring: High (80-94%) for clear migration keywords
    - Route to migration-orchestrator when classified as migration
    - Reuse pattern from: existing classification logic
  - [x] 4.3 Update classification workflow
    - Add migration to task type enum: bug-fix | enhancement | new-feature | refactoring | performance | security | migration | documentation
    - Return task_type: migration in classification output
    - Document migration classification criteria in reference files
  - [x] 4.4 Update /work command integration
    - Modify commands/work/work.md to route migration tasks
    - When task_type == "migration", invoke migration-orchestrator skill
    - Remove placeholder "migration workflow not yet implemented" message
    - Add migration workflow description
  - [x] 4.5 Ensure task-classifier integration tests pass
    - Run ONLY the 2-8 tests written in 4.1
    - Verify migration keywords detected correctly
    - Verify routing to migration-orchestrator works
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-8 tests written in 4.1 pass
- task-classifier detects migration keywords
- Classification returns task_type: migration
- /work command routes migration tasks to migration-orchestrator
- Placeholder message removed from work.md

### Task Group 5: Documentation Updates
**Dependencies:** Task Groups 1, 3, 4 (Orchestrator, Commands, Integration)
**Estimated Steps:** 6

- [ ] 5.0 Complete CLAUDE.md documentation updates
  - [ ] 5.1 Write 2-8 focused tests for documentation completeness
    - Limit to 2-8 highly focused tests maximum
    - Test only critical documentation elements (e.g., migration section exists, commands listed, skills documented)
    - Skip exhaustive testing of all documentation content
  - [ ] 5.2 Update Task Types Supported table in CLAUDE.md
    - Confirm migration task type with 6 stages
    - Classification keywords: "migrate", "move from X to Y", "upgrade"
    - Update status from placeholder to implemented
    - Document adaptive workflow (code/data/architecture types)
  - [ ] 5.3 Add migration-orchestrator to Available Skills section
    - Description: Orchestrates complete migration workflow (6-7 phases)
    - Core capabilities: Type detection, three strategies, state management
    - When to use: Technology migrations, platform changes, architecture transitions
    - Related commands: /ai-sdlc:migration:new, /ai-sdlc:migration:resume
    - Reference patterns: feature-orchestrator, enhancement-orchestrator
  - [ ] 5.4 Add migration commands to Available Commands section
    - /ai-sdlc:migration:new: Start new migration workflow
    - /ai-sdlc:migration:resume: Resume interrupted migration
    - Document options and usage examples
    - Link to command files
  - [ ] 5.5 Update Typical Development Workflow section
    - Add migration workflow option (Option C: Migration Workflow)
    - Reference migration-orchestrator for migration tasks
    - Update workflow diagram/description if exists
  - [ ] 5.6 Ensure documentation update tests pass
    - Run ONLY the 2-8 tests written in 5.1
    - Verify all CLAUDE.md sections updated
    - Verify migration content accurate and complete
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- The 2-8 tests written in 5.1 pass
- Task Types Supported table updated with migration details
- migration-orchestrator added to Available Skills
- Migration commands added to Available Commands
- Typical Development Workflow mentions migration path
- All documentation accurate and follows existing format

### Task Group 6: Test Review & Gap Analysis
**Dependencies:** Task Groups 1-5
**Estimated Steps:** 4

- [ ] 6.0 Review existing tests and fill critical gaps only
  - [ ] 6.1 Review tests from previous task groups
    - Review the 2-8 tests from each implementation group (Groups 1-5)
    - Total existing tests: approximately 10-40 tests
    - Document what's covered:
      - Orchestrator workflow execution
      - Migration type detection
      - Reference documentation completeness
      - Command invocation
      - Task-classifier routing
  - [ ] 6.2 Analyze test coverage gaps for migration support only
    - Identify critical workflows that lack test coverage
    - Focus ONLY on gaps related to migration orchestrator feature
    - Do NOT assess entire plugin test coverage
    - Prioritize end-to-end migration workflows over unit test gaps
    - Example gaps to check:
      - Full migration workflow (new → analyze → plan → execute → verify)
      - State management across phase boundaries
      - Auto-recovery from failures
      - Resume from interrupted state
  - [ ] 6.3 Write up to 10 additional strategic tests maximum
    - Add maximum of 10 new tests to fill identified critical gaps
    - Focus on integration points and end-to-end workflows:
      - Test: Complete migration workflow (all phases)
      - Test: Resume from interrupted phase
      - Test: Migration type detection accuracy
      - Test: State persistence across phases
      - Test: Auto-recovery from common failures
    - Do NOT write comprehensive coverage for all scenarios
    - Skip edge cases unless business-critical
  - [ ] 6.4 Run migration feature-specific tests only
    - Run ONLY tests related to migration orchestrator feature
    - Expected total: approximately 20-50 tests maximum
    - Do NOT run the entire plugin test suite
    - Verify critical migration workflows pass:
      - Orchestrator phases execute in order
      - Migration type detection works
      - Commands invoke orchestrator correctly
      - task-classifier routes to migration-orchestrator
      - State management persists across phases

**Acceptance Criteria:**
- All migration feature-specific tests pass (approximately 20-50 tests total)
- Critical migration workflows covered (new workflow, resume, type detection, state management)
- No more than 10 additional tests added
- Testing focused exclusively on migration orchestrator feature

## Execution Order

Recommended implementation sequence:
1. Migration Orchestrator Skill (6 steps) - Core workflow logic
2. Migration Reference Documentation (5 steps, depends on 1) - Supporting guidance
3. Slash Commands (5 steps, depends on 1) - User interface
4. Task Classifier Integration (5 steps, depends on 1, 3) - Routing and discovery
5. Documentation Updates (6 steps, depends on 1, 3, 4) - Complete documentation
6. Test Review & Gap Analysis (4 steps, depends on 1-5) - Comprehensive testing

## Standards Compliance

During implementation, follow standards from:
- `.ai-sdlc/docs/standards/global/` - Language-agnostic standards (if exists)
- Existing orchestrator patterns:
  - `skills/feature-orchestrator/SKILL.md` - Overall structure, state management, auto-recovery
  - `skills/enhancement-orchestrator/SKILL.md` - Phase 0 and 1 patterns, gap analysis
  - `skills/bug-fix-orchestrator/SKILL.md` - Simpler workflow patterns
- Command patterns:
  - `commands/feature/new.md` - Command structure and documentation
  - `commands/feature/resume.md` - Resume functionality
- Reference documentation style:
  - `skills/feature-orchestrator/references/` - Reference file structure and content style

## Notes

- **Test-Driven Approach**: Each task group begins with writing 2-8 focused tests
- **Run Tests Incrementally**: Run only newly written tests after each group, not entire suite
- **Mark Progress**: Check off steps as completed in this file
- **Reuse First**: Prioritize reusing existing orchestrator patterns (feature-orchestrator, enhancement-orchestrator)
- **Migration-Specific**: Focus on migration workflow differences (6-7 phases, type detection, strategies)
- **State Management**: Extend orchestrator-state.yml with migration-specific fields (migration_type, current_system, target_system, migration_strategy)
- **Integration**: Ensure task-classifier routes migration tasks correctly
- **Documentation**: Update CLAUDE.md to reflect migration support across all relevant sections
