# State Management Reference

This document provides detailed guidance on managing orchestrator state across workflow execution.

## State File Purpose

The orchestrator state file enables:
- **Resume capability**: Continue workflow after interruption
- **Progress tracking**: Know what's completed and what's pending
- **Failure recovery**: Track auto-fix attempts and errors
- **Status reporting**: Show current workflow status
- **Audit trail**: Record workflow execution history

## State File Location

```
.ai-sdlc/tasks/[type]/[dated-name]/orchestrator-state.yml
```

Example:
```
.ai-sdlc/tasks/new-features/2025-10-26-user-authentication/orchestrator-state.yml
```

## Complete State Schema

```yaml
orchestrator:
  # Execution Mode
  mode: interactive                    # or "yolo"
  started_phase: specification         # Phase where workflow began
  current_phase: implementation        # Currently executing phase

  # Phase Tracking
  completed_phases:                    # Array of completed phase names
    - specification
    - planning
  failed_phases:                       # Array of failure objects
    - phase: implementation
      attempts: 3
      error: "Step 2.3 failed: Module not found"
      timestamp: "2025-10-26T14:30:00Z"

  # Auto-Fix Tracking
  auto_fix_attempts:                   # Attempt counters per phase
    specification: 0                   # Max 2
    planning: 0                        # Max 2
    implementation: 2                  # Max 5
    verification: 0                    # Max 2
    e2e_testing: 0                     # Max 2
    user_docs: 0                       # Max 1

  # Configuration Options
  options:
    e2e_enabled: false                 # Run E2E testing?
    user_docs_enabled: false           # Generate user docs?
    skip_code_review: false            # Skip code review in verification?
    skip_production_check: true        # Skip production readiness check?

  # Timestamps
  created: "2025-10-26T12:00:00Z"
  updated: "2025-10-26T14:30:00Z"
  completed: null                      # Set when workflow finishes

  # Metadata
  task_path: ".ai-sdlc/tasks/new-features/2025-10-26-user-authentication"
  feature_description: "Add user authentication with email/password"

  # Phase Results (detailed results for resume context)
  phase_results:
    specification:
      status: success                  # success, warning, failed
      timestamp: "2025-10-26T12:15:00Z"
      duration_minutes: 15
      output_files:
        - spec.md
        - planning/requirements.md
        - verification/spec-verification.md
      key_metrics:
        requirements_count: 12
        visual_assets: 3
    planning:
      status: success
      timestamp: "2025-10-26T12:30:00Z"
      duration_minutes: 10
      output_files:
        - implementation-plan.md
      key_metrics:
        task_groups: 4
        total_steps: 18
        expected_tests: "16-34"
    implementation:
      status: in_progress
      timestamp: "2025-10-26T14:30:00Z"
      duration_minutes: 120
      output_files:
        - implementation/work-log.md
        - implementation-plan.md (updated)
      key_metrics:
        steps_completed: 12
        steps_total: 18
        tests_written: 18
        tests_passing: 16
        execution_mode: "plan-execute"
```

## Phase Names

Valid phase names for tracking:

```yaml
# Required phases (always part of workflow)
- specification
- planning
- implementation
- verification

# Optional phases (only added if enabled)
- e2e_testing
- user_documentation

# System phases
- finalization
```

## Phase Status Values

For `phase_results.[phase].status`:

```yaml
# Success states
success         # Phase completed without issues
warning         # Phase completed with minor issues

# Failure states
failed          # Phase failed, couldn't complete
in_progress     # Phase currently executing
```

## State Operations

### Initialize State (New Workflow)

When starting a new feature workflow:

```yaml
orchestrator:
  mode: interactive  # or yolo from --yolo flag
  started_phase: specification  # or from --from flag
  current_phase: specification
  completed_phases: []
  failed_phases: []
  auto_fix_attempts:
    specification: 0
    planning: 0
    implementation: 0
    verification: 0
    e2e_testing: 0
    user_docs: 0
  options:
    e2e_enabled: false  # or true from --e2e flag
    user_docs_enabled: false  # or true from --user-docs flag
    skip_code_review: false
    skip_production_check: true
  created: "2025-10-26T12:00:00Z"
  updated: "2025-10-26T12:00:00Z"
  completed: null
  task_path: ".ai-sdlc/tasks/new-features/2025-10-26-[feature-name]"
  feature_description: "[description from command]"
  phase_results: {}
```

### Read State (Resume Workflow)

When resuming an existing workflow:

```bash
# Check if state file exists
STATE_FILE="$TASK_PATH/orchestrator-state.yml"

if [ -f "$STATE_FILE" ]; then
  echo "Found existing workflow state"
  # Read state file
  cat "$STATE_FILE"
else
  echo "No state file found - starting new workflow"
fi
```

In orchestrator logic:
1. Parse YAML
2. Extract `completed_phases` array
3. Extract `current_phase`
4. Extract `failed_phases` array
5. Determine next phase to execute

### Update State (After Phase Starts)

When a phase begins executing:

```yaml
orchestrator:
  current_phase: [phase-name]
  updated: [current-timestamp]
```

Example:
```yaml
orchestrator:
  current_phase: implementation
  updated: "2025-10-26T14:00:00Z"
```

### Update State (After Phase Succeeds)

When a phase completes successfully:

```yaml
orchestrator:
  completed_phases:
    - [previous-phases]
    - [newly-completed-phase]
  updated: [current-timestamp]
  phase_results:
    [phase-name]:
      status: success  # or warning
      timestamp: [completion-timestamp]
      duration_minutes: [calculated]
      output_files:
        - [file1]
        - [file2]
      key_metrics:
        [metric1]: [value]
        [metric2]: [value]
```

Example:
```yaml
orchestrator:
  completed_phases:
    - specification
    - planning
    - implementation
  updated: "2025-10-26T16:00:00Z"
  phase_results:
    implementation:
      status: success
      timestamp: "2025-10-26T16:00:00Z"
      duration_minutes: 120
      output_files:
        - implementation/work-log.md
        - implementation-plan.md
      key_metrics:
        steps_completed: 18
        tests_passing: 28
        execution_mode: plan-execute
```

### Update State (After Phase Fails)

When a phase fails and auto-fix is attempted:

```yaml
orchestrator:
  auto_fix_attempts:
    [phase-name]: [incremented-count]
  updated: [current-timestamp]
```

If phase fails after max attempts:

```yaml
orchestrator:
  failed_phases:
    - phase: [phase-name]
      attempts: [final-attempt-count]
      error: "[error-description]"
      timestamp: [failure-timestamp]
  updated: [current-timestamp]
```

Example:
```yaml
orchestrator:
  failed_phases:
    - phase: implementation
      attempts: 5
      error: "Step 3.4 failed: Cannot import module 'user_auth'"
      timestamp: "2025-10-26T16:45:00Z"
  auto_fix_attempts:
    implementation: 5
  updated: "2025-10-26T16:45:00Z"
```

### Update State (Workflow Completion)

When entire workflow finishes:

```yaml
orchestrator:
  current_phase: finalization
  completed_phases:
    - [all-completed-phases]
  completed: [completion-timestamp]
  updated: [completion-timestamp]
```

Example:
```yaml
orchestrator:
  current_phase: finalization
  completed_phases:
    - specification
    - planning
    - implementation
    - verification
    - e2e_testing
  completed: "2025-10-26T17:00:00Z"
  updated: "2025-10-26T17:00:00Z"
```

## State Queries

### Determine Next Phase

Given current state, determine which phase to execute next:

```python
def get_next_phase(state):
    """Determine next phase to execute"""
    workflow_phases = [
        'specification',
        'planning',
        'implementation',
        'verification',
        'e2e_testing',       # if options.e2e_enabled
        'user_documentation', # if options.user_docs_enabled
        'finalization'
    ]

    completed = state['orchestrator']['completed_phases']

    for phase in workflow_phases:
        # Skip optional phases if not enabled
        if phase == 'e2e_testing' and not state['orchestrator']['options']['e2e_enabled']:
            continue
        if phase == 'user_documentation' and not state['orchestrator']['options']['user_docs_enabled']:
            continue

        # Return first phase not in completed list
        if phase not in completed:
            return phase

    return 'finalization'  # All phases complete
```

### Check if Phase Can Be Retried

Before attempting auto-fix:

```python
def can_retry_phase(state, phase_name):
    """Check if phase has retry attempts remaining"""
    max_attempts = {
        'specification': 2,
        'planning': 2,
        'implementation': 5,
        'verification': 2,
        'e2e_testing': 2,
        'user_docs': 1
    }

    current_attempts = state['orchestrator']['auto_fix_attempts'][phase_name]
    return current_attempts < max_attempts[phase_name]
```

### Check Phase Prerequisites

Before executing a phase:

```python
def check_prerequisites(phase_name, task_path):
    """Check if prerequisites for phase exist"""
    prereqs = {
        'specification': [],  # No prerequisites
        'planning': ['spec.md'],
        'implementation': ['spec.md', 'implementation-plan.md'],
        'verification': ['spec.md', 'implementation-plan.md', 'implementation/work-log.md'],
        'e2e_testing': ['spec.md', 'implementation complete'],
        'user_documentation': ['spec.md', 'implementation complete']
    }

    required_files = prereqs[phase_name]

    for file in required_files:
        file_path = os.path.join(task_path, file)
        if not os.path.exists(file_path):
            return False, f"Missing: {file}"

    return True, "All prerequisites met"
```

### Calculate Workflow Progress

For status reporting:

```python
def calculate_progress(state):
    """Calculate workflow completion percentage"""
    required_phases = ['specification', 'planning', 'implementation', 'verification']
    optional_phases = []

    if state['orchestrator']['options']['e2e_enabled']:
        optional_phases.append('e2e_testing')
    if state['orchestrator']['options']['user_docs_enabled']:
        optional_phases.append('user_documentation')

    total_phases = len(required_phases) + len(optional_phases)
    completed_phases = len(state['orchestrator']['completed_phases'])

    percentage = (completed_phases / total_phases) * 100
    return percentage, completed_phases, total_phases
```

## State Validation

### Validate State Structure

Before using state:

```python
def validate_state(state):
    """Validate state file structure"""
    required_fields = [
        'orchestrator.mode',
        'orchestrator.current_phase',
        'orchestrator.completed_phases',
        'orchestrator.auto_fix_attempts',
        'orchestrator.created',
        'orchestrator.task_path'
    ]

    for field in required_fields:
        if not has_nested_key(state, field):
            return False, f"Missing required field: {field}"

    # Validate mode value
    if state['orchestrator']['mode'] not in ['interactive', 'yolo']:
        return False, f"Invalid mode: {state['orchestrator']['mode']}"

    # Validate phase names
    valid_phases = [
        'specification', 'planning', 'implementation',
        'verification', 'e2e_testing', 'user_documentation'
    ]

    for phase in state['orchestrator']['completed_phases']:
        if phase not in valid_phases:
            return False, f"Invalid phase name: {phase}"

    return True, "State valid"
```

### Detect State Corruption

Check for inconsistencies:

```python
def check_state_consistency(state):
    """Check for state inconsistencies"""
    issues = []

    # Check if current_phase is ahead of completed_phases
    current = state['orchestrator']['current_phase']
    completed = state['orchestrator']['completed_phases']

    phase_order = ['specification', 'planning', 'implementation', 'verification']

    try:
        current_idx = phase_order.index(current)
        for phase in completed:
            if phase_order.index(phase) >= current_idx:
                issues.append(f"Completed phase '{phase}' is >= current phase '{current}'")
    except ValueError:
        # Phase might be optional, skip this check
        pass

    # Check auto_fix_attempts don't exceed max
    max_attempts = {
        'specification': 2,
        'planning': 2,
        'implementation': 5,
        'verification': 2,
        'e2e_testing': 2,
        'user_docs': 1
    }

    for phase, count in state['orchestrator']['auto_fix_attempts'].items():
        if count > max_attempts[phase]:
            issues.append(f"auto_fix_attempts for '{phase}' exceeds max: {count} > {max_attempts[phase]}")

    return issues
```

## State Backup and Recovery

### Backup State Before Risky Operations

Before major state changes:

```bash
# Backup current state
STATE_FILE="$TASK_PATH/orchestrator-state.yml"
BACKUP_FILE="$TASK_PATH/orchestrator-state.backup.yml"

if [ -f "$STATE_FILE" ]; then
  cp "$STATE_FILE" "$BACKUP_FILE"
  echo "State backed up to: $BACKUP_FILE"
fi
```

### Restore State After Corruption

If state becomes corrupted:

```bash
# Restore from backup
BACKUP_FILE="$TASK_PATH/orchestrator-state.backup.yml"
STATE_FILE="$TASK_PATH/orchestrator-state.yml"

if [ -f "$BACKUP_FILE" ]; then
  cp "$BACKUP_FILE" "$STATE_FILE"
  echo "State restored from backup"
else
  echo "No backup found - state cannot be restored"
fi
```

### Manual State Recovery

If both state and backup are lost, reconstruct from artifacts:

```python
def reconstruct_state(task_path):
    """Reconstruct state from existing artifacts"""
    state = {
        'orchestrator': {
            'mode': 'interactive',  # Default to interactive
            'current_phase': None,
            'completed_phases': [],
            'failed_phases': [],
            'auto_fix_attempts': {
                'specification': 0,
                'planning': 0,
                'implementation': 0,
                'verification': 0,
                'e2e_testing': 0,
                'user_docs': 0
            },
            'options': {
                'e2e_enabled': False,
                'user_docs_enabled': False
            },
            'created': datetime.now().isoformat(),
            'updated': datetime.now().isoformat(),
            'completed': None,
            'task_path': task_path,
            'phase_results': {}
        }
    }

    # Check which phases have completed based on artifacts
    if os.path.exists(os.path.join(task_path, 'spec.md')):
        state['orchestrator']['completed_phases'].append('specification')

    if os.path.exists(os.path.join(task_path, 'implementation-plan.md')):
        state['orchestrator']['completed_phases'].append('planning')

    if os.path.exists(os.path.join(task_path, 'implementation', 'work-log.md')):
        # Check if implementation is complete
        plan_path = os.path.join(task_path, 'implementation-plan.md')
        with open(plan_path) as f:
            content = f.read()
            total_checks = content.count('- [ ]')
            if total_checks == 0:  # All marked complete
                state['orchestrator']['completed_phases'].append('implementation')

    if os.path.exists(os.path.join(task_path, 'implementation', 'implementation-verification.md')):
        state['orchestrator']['completed_phases'].append('verification')

    # Determine current phase (next incomplete phase)
    state['orchestrator']['current_phase'] = get_next_phase(state)

    return state
```

## State File Examples

### Example 1: New Workflow (Just Started)

```yaml
orchestrator:
  mode: interactive
  started_phase: specification
  current_phase: specification
  completed_phases: []
  failed_phases: []
  auto_fix_attempts:
    specification: 0
    planning: 0
    implementation: 0
    verification: 0
    e2e_testing: 0
    user_docs: 0
  options:
    e2e_enabled: false
    user_docs_enabled: false
    skip_code_review: false
    skip_production_check: true
  created: "2025-10-26T12:00:00Z"
  updated: "2025-10-26T12:00:00Z"
  completed: null
  task_path: ".ai-sdlc/tasks/new-features/2025-10-26-user-profile"
  feature_description: "Add user profile editing"
  phase_results: {}
```

### Example 2: Mid-Workflow (Implementation in Progress)

```yaml
orchestrator:
  mode: interactive
  started_phase: specification
  current_phase: implementation
  completed_phases:
    - specification
    - planning
  failed_phases: []
  auto_fix_attempts:
    specification: 0
    planning: 0
    implementation: 1
    verification: 0
    e2e_testing: 0
    user_docs: 0
  options:
    e2e_enabled: true
    user_docs_enabled: false
    skip_code_review: false
    skip_production_check: true
  created: "2025-10-26T12:00:00Z"
  updated: "2025-10-26T14:30:00Z"
  completed: null
  task_path: ".ai-sdlc/tasks/new-features/2025-10-26-user-profile"
  feature_description: "Add user profile editing"
  phase_results:
    specification:
      status: success
      timestamp: "2025-10-26T12:20:00Z"
      duration_minutes: 20
      output_files:
        - spec.md
        - planning/requirements.md
      key_metrics:
        requirements_count: 15
    planning:
      status: success
      timestamp: "2025-10-26T12:35:00Z"
      duration_minutes: 15
      output_files:
        - implementation-plan.md
      key_metrics:
        task_groups: 4
        total_steps: 16
```

### Example 3: Workflow with Failures

```yaml
orchestrator:
  mode: yolo
  started_phase: specification
  current_phase: verification
  completed_phases:
    - specification
    - planning
  failed_phases:
    - phase: implementation
      attempts: 5
      error: "Step 3.4: Cannot import 'user_service'"
      timestamp: "2025-10-26T15:30:00Z"
  auto_fix_attempts:
    specification: 0
    planning: 0
    implementation: 5
    verification: 0
    e2e_testing: 0
    user_docs: 0
  options:
    e2e_enabled: false
    user_docs_enabled: false
    skip_code_review: true
    skip_production_check: true
  created: "2025-10-26T12:00:00Z"
  updated: "2025-10-26T15:30:00Z"
  completed: null
  task_path: ".ai-sdlc/tasks/new-features/2025-10-26-payment-integration"
  feature_description: "Integrate payment gateway"
  phase_results:
    specification:
      status: success
      timestamp: "2025-10-26T12:15:00Z"
      duration_minutes: 15
      output_files:
        - spec.md
      key_metrics:
        requirements_count: 20
    planning:
      status: success
      timestamp: "2025-10-26T12:30:00Z"
      duration_minutes: 15
      output_files:
        - implementation-plan.md
      key_metrics:
        task_groups: 6
        total_steps: 24
    implementation:
      status: failed
      timestamp: "2025-10-26T15:30:00Z"
      duration_minutes: 180
      output_files:
        - implementation/work-log.md (partial)
      key_metrics:
        steps_completed: 18
        steps_total: 24
```

### Example 4: Completed Workflow

```yaml
orchestrator:
  mode: interactive
  started_phase: specification
  current_phase: finalization
  completed_phases:
    - specification
    - planning
    - implementation
    - verification
    - e2e_testing
    - user_documentation
  failed_phases: []
  auto_fix_attempts:
    specification: 0
    planning: 0
    implementation: 2
    verification: 1
    e2e_testing: 0
    user_docs: 0
  options:
    e2e_enabled: true
    user_docs_enabled: true
    skip_code_review: false
    skip_production_check: false
  created: "2025-10-26T09:00:00Z"
  updated: "2025-10-26T17:00:00Z"
  completed: "2025-10-26T17:00:00Z"
  task_path: ".ai-sdlc/tasks/new-features/2025-10-26-shopping-cart"
  feature_description: "Implement shopping cart functionality"
  phase_results:
    specification:
      status: success
      timestamp: "2025-10-26T09:30:00Z"
      duration_minutes: 30
    planning:
      status: success
      timestamp: "2025-10-26T09:50:00Z"
      duration_minutes: 20
    implementation:
      status: success
      timestamp: "2025-10-26T14:00:00Z"
      duration_minutes: 250
    verification:
      status: warning
      timestamp: "2025-10-26T15:30:00Z"
      duration_minutes: 90
    e2e_testing:
      status: success
      timestamp: "2025-10-26T16:15:00Z"
      duration_minutes: 45
    user_documentation:
      status: success
      timestamp: "2025-10-26T17:00:00Z"
      duration_minutes: 45
```

---

## Best Practices

### State File Management

1. **Always update state after phase changes**
   - After phase starts: Update current_phase
   - After phase completes: Add to completed_phases
   - After auto-fix: Increment attempt counter
   - After failure: Add to failed_phases

2. **Use atomic writes**
   - Write to temporary file first
   - Rename to actual state file (atomic operation)
   - Prevents partial writes and corruption

3. **Validate before reading**
   - Check file exists
   - Validate YAML syntax
   - Validate required fields present
   - Check for inconsistencies

4. **Include timestamps**
   - Track created, updated, completed
   - Include timestamps in phase_results
   - Useful for debugging and reporting

5. **Store rich phase_results**
   - Capture key metrics for each phase
   - Store output file paths
   - Record duration for performance analysis
   - Include status and any warnings

### Resume Safety

1. **Validate prerequisites before resuming**
   - Check required files exist
   - Verify file contents not corrupted
   - Ensure application state matches workflow state

2. **Allow phase restart**
   - User should be able to restart failed phase
   - Reset auto_fix_attempts when restarting
   - Clear from failed_phases

3. **Handle mid-phase resumes**
   - If phase was interrupted (not failed)
   - Check what was completed
   - Resume from appropriate point

### Error Recovery

1. **Backup before risky operations**
   - Before attempting auto-fix
   - Before major state changes
   - Keep last-known-good state

2. **Detect and recover from corruption**
   - Validate state structure
   - Check for inconsistencies
   - Reconstruct from artifacts if needed

3. **Provide manual override**
   - Allow user to manually edit state
   - Document state schema clearly
   - Provide tools for state inspection

---

This reference provides comprehensive guidance for managing orchestrator state throughout the feature development workflow.
