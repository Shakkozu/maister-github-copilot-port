# Gap Analysis Reference

> **Design Documentation**: This file serves as **design documentation** for developers extending or understanding the gap analysis methodology. The actual runtime analysis logic is executed by the `agents/gap-analyzer.md` subagent for path-independence when the plugin runs in user projects. This document explains the patterns and reasoning behind the subagent implementation.

**Purpose:** Pattern guide for comparing current vs desired state and assessing enhancement impact (Phase 1)

This reference provides conceptual patterns and decision frameworks for identifying gaps, classifying enhancement types, and assessing implementation impact.

---

## Table of Contents

1. [Overview](#overview)
2. [Desired Functionality Extraction](#desired-functionality-extraction)
3. [Gap Identification](#gap-identification)
4. [Enhancement Type Classification](#enhancement-type-classification)
5. [Impact Assessment](#impact-assessment)
6. [Compatibility Requirements](#compatibility-requirements)
7. [Gap Analysis Report Structure](#gap-analysis-report-structure)
8. [Failure Handling](#failure-handling)

---

## Overview

Phase 1 (Gap Analysis & Impact Assessment) bridges existing feature analysis with specification, answering:

- **What's missing?** (gaps)
- **What needs to change?** (modifications)
- **What type of enhancement is this?** (classification)
- **What's the impact?** (risk, effort, compatibility)

### Goals

- **Identify all gaps** between current and desired state
- **Classify enhancement type** (additive/modificative/refactor-based)
- **Assess risk level** (low/medium/high)
- **Estimate effort** (hours, complexity)
- **Define compatibility requirements** (strict/moderate/flexible)
- **Plan mitigation strategies** for identified risks

### Process Flow

```
Enhancement Description + Existing Analysis
              ↓
Extract Desired Functionality
              ↓
Compare Current vs Desired
              ↓
Identify Gaps (missing, incomplete, different)
              ↓
Classify Enhancement Type
              ↓
Assess Impact (files, tests, risk)
              ↓
Determine Compatibility Requirements
              ↓
Generate Gap Analysis Report
```

---

## Desired Functionality Extraction

### Purpose

Parse enhancement description to understand what capabilities are being requested.

### Algorithm Outline

**Input**: `"Add sorting to user table - allow sorting by all columns"`

**Steps**:
1. **Extract Action Verbs** → `["add", "allow"]`
2. **Identify Objects** → `["sorting", "all columns"]`
3. **Detect Scope** → `"all columns"` (comprehensive scope)
4. **Extract Constraints** → None specified
5. **Identify Priority** → Implied "must" (no conditional language)

**Output Structure**:
```
{
  new_capabilities: ["sorting functionality", "column-based sorting"],
  behavior_changes: [],
  removed_features: [],
  constraints: ["must support all columns"],
  scope_indicators: {comprehensive: true},
  priority_indicators: {must_have: true}
}
```

### Common Patterns

| Description | New Capabilities | Behavior Changes | Scope |
|------------|------------------|------------------|-------|
| "Add export to table" | ["export"] | [] | Additive only |
| "Change pagination to server-side" | [] | ["pagination"] | Modificative |
| "Refactor UserTable to use hooks" | [] | ["architecture"] | Refactor-based |
| "Improve table performance" | ["optimization"] | ["rendering"] | Enhancement |

---

## Gap Identification

### Gap Types

Compare desired functionality with existing analysis to identify gaps:

#### 1. Missing Features
**Definition**: Capabilities that don't exist at all

**Detection**:
- Desired capability NOT found in existing functionality
- No similar functionality exists
- No infrastructure to support it

**Example**:
- Current: Table displays data, handles selection
- Desired: Add sorting
- **Gap**: Sorting capability completely missing

#### 2. Incomplete Features
**Definition**: Capabilities that partially exist but need extension

**Detection**:
- Some aspect of desired functionality exists
- Missing specific cases or variations
- Limited implementation

**Example**:
- Current: Single-column sorting
- Desired: Multi-column sorting
- **Gap**: Multi-column support incomplete

#### 3. Behavior Differences
**Definition**: Existing behavior needs to change

**Detection**:
- Functionality exists but works differently
- Change in how feature operates
- Modification of existing patterns

**Example**:
- Current: Client-side pagination
- Desired: Server-side pagination
- **Gap**: Behavior needs fundamental change

#### 4. Architectural Gaps
**Definition**: Structure/design patterns need changes

**Detection**:
- Desired pattern differs from existing
- Need to refactor implementation approach
- Infrastructure changes required

**Example**:
- Current: Class components
- Desired: Functional with hooks
- **Gap**: Architectural refactoring needed

### Gap Analysis Process

**For each desired capability**:
1. Search existing analysis for similar functionality
2. Classify relationship: None/Partial/Different/Architectural
3. Document the gap with evidence
4. Assess complexity of filling gap

**Gap Complexity**:
- **Simple**: Add new prop/function (1-2 hours)
- **Moderate**: Add new module/component (2-4 hours)
- **Complex**: Change architecture/patterns (4-8 hours)

---

## Enhancement Type Classification

### Classification Decision Matrix

Use characteristics to classify enhancement type:

| Characteristic | Additive | Modificative | Refactor-Based |
|---------------|----------|--------------|----------------|
| **New Features** | ✅ Yes | Maybe | ❌ No |
| **Behavior Changes** | ❌ No | ✅ Yes | ⚠️ Preserve only |
| **API Changes** | ⚠️ Optional props | ✅ Breaking | ⚠️ Internal only |
| **Structure Changes** | ❌ No | ⚠️ Moderate | ✅ Major |
| **Risk** | Low | Medium-High | Medium-High |
| **Compatibility** | Strict | Moderate | Strict |

### Decision Flow

```
Are new features being added?
├─ Yes → Any existing behavior changing?
│         ├─ No → ADDITIVE
│         └─ Yes → MODIFICATIVE
└─ No → Is structure/architecture changing?
          ├─ Yes → REFACTOR-BASED
          └─ No → Might not be an enhancement
```

### Type Definitions

#### Additive Enhancement
**Definition**: Adding new capabilities without changing existing behavior

**Characteristics**:
- ✅ Adds new features
- ❌ No existing behavior changes
- ⚠️ Minor API changes (optional props only)
- ❌ No structure changes
- **Risk**: Low
- **Compatibility**: Strict (100% backward compatible)

**Examples**:
- "Add export button to user table"
- "Add tooltip to table headers"
- "Add loading indicator"

**Verification Requirements**:
- Default behavior test (works without new features)
- Existing tests pass without modification
- No breaking API changes

#### Modificative Enhancement
**Definition**: Changing how existing features work

**Characteristics**:
- ⚠️ May add new features
- ✅ Changes existing behavior
- ✅ API/interface changes likely
- ⚠️ Moderate structure changes
- **Risk**: Medium to High
- **Compatibility**: Moderate (managed breaking changes)

**Examples**:
- "Change pagination from client-side to server-side"
- "Replace dropdown with autocomplete"
- "Switch from REST to GraphQL"

**Verification Requirements**:
- Migration guide required
- Breaking changes documented
- Deprecation warnings for old patterns
- Compatibility layer if feasible

#### Refactor-Based Enhancement
**Definition**: Restructuring code while preserving behavior

**Characteristics**:
- ❌ No new features
- ⚠️ Behavior must be preserved
- ⚠️ Internal API changes only
- ✅ Major structure changes
- **Risk**: Medium to High
- **Compatibility**: Strict (behavior unchanged)

**Examples**:
- "Refactor UserTable to use DataTable base"
- "Convert class components to hooks"
- "Extract business logic to custom hooks"

**Verification Requirements**:
- Behavior snapshot comparison critical
- All existing tests must pass unchanged
- No functional changes allowed
- Comprehensive regression testing

### Edge Cases

**"Improve performance"**:
- If behavior unchanged → Refactor-based
- If changes user experience → Modificative

**"Add feature X and refactor Y"**:
- Multiple enhancement types → Split into separate enhancements
- Or classify as Modificative (higher risk category)

**"Fix bug and enhance"**:
- Bug fix + enhancement → Split into bug-fix + enhancement workflows
- Don't combine different task types

---

## Impact Assessment

### Assessment Dimensions

Evaluate impact across multiple dimensions:

#### 1. File Impact
**Assess**:
- How many files need changes?
- Are files core or peripheral?
- What's the change magnitude per file?

**Levels**:
- **Low**: 1-2 files, peripheral components
- **Medium**: 3-5 files, some core components
- **High**: 6+ files, multiple core components

#### 2. Test Impact
**Assess**:
- How many tests affected?
- Need new tests or modify existing?
- What's test coverage gap?

**Targeted Regression**:
- **Tier 1 (Direct)**: Tests for modified files - ALWAYS RUN
- **Tier 2 (Integration)**: Related integration tests - If scope > small
- **Tier 3 (Domain)**: All domain tests - If scope = large

**Coverage**:
- **Low**: 10-30% of test suite (additive, small)
- **Medium**: 30-70% of test suite (modificative, medium)
- **High**: 70-100% of test suite (refactor, large)

#### 3. Dependency Impact
**Assess**:
- How many files import/depend on changed files?
- Are dependencies internal or external?
- What's the ripple effect?

**Ripple Assessment**:
```
Modified File → Find all importers
                ↓
         Each importer potentially affected
                ↓
         Check if usage patterns change
                ↓
         Estimate impact per consumer
```

#### 4. API Impact
**Assess**:
- Are public APIs changing?
- Breaking or backward compatible?
- How many consumers?

**Breaking Change Indicators**:
- Required prop added
- Prop removed or renamed
- Return type changed
- Behavior changed for existing inputs

### Risk Scoring

Combine factors to calculate overall risk:

| Factor | Low (1) | Medium (2) | High (3) |
|--------|---------|------------|----------|
| Files | 1-2 | 3-5 | 6+ |
| Tests | <20 | 20-50 | 50+ |
| Dependencies | <5 | 5-15 | 15+ |
| Breaking Changes | None | Minor | Major |
| Complexity | Simple | Moderate | Complex |

**Risk Score** = Sum of factors

- **5-8**: Low Risk
- **9-11**: Medium Risk
- **12-15**: High Risk

### Effort Estimation

Consider all factors:

| Enhancement Type | Simple | Moderate | Complex |
|-----------------|--------|----------|---------|
| **Additive** | 1-2h | 2-4h | 4-6h |
| **Modificative** | 2-4h | 4-8h | 8-16h |
| **Refactor-Based** | 2-4h | 4-8h | 8-16h |

**Adjust for**:
- Test coverage gaps (+25%)
- Breaking changes (+50%)
- Low confidence in analysis (+25%)
- Legacy code (+50%)

---

## Compatibility Requirements

### Compatibility Levels

Based on enhancement type and risk, determine compatibility requirements:

#### Strict Compatibility (100% backward compatible)
**Required for**:
- Additive enhancements
- Refactor-based enhancements
- Low-risk modificative

**Criteria**:
- All existing tests pass without modification
- No breaking API changes
- Default behavior unchanged
- No new warnings or errors
- All existing usage patterns work

**Verification**:
- Default behavior test
- API compatibility test
- Existing usage patterns test
- Console warnings check
- Snapshot comparison

#### Moderate Compatibility (Managed breaking changes)
**Allowed for**:
- Modificative enhancements
- Medium to high risk changes

**Criteria**:
- Breaking changes documented with migration guide
- Deprecation warnings for old patterns
- Migration path provided and tested
- Non-breaking parts remain compatible
- Version bump required

**Verification**:
- Migration guide completeness
- Deprecation warnings present
- Migration path tested
- Breaking changes list validated

#### Flexible Compatibility (Breaking changes accepted)
**Rarely used**: Major version bumps, complete rewrites

**Criteria**:
- Major version bump
- Comprehensive migration guide
- Clear communication to users
- Compelling reason for breaking

---

## User Journey Impact Assessment

### Purpose

Evaluate how the enhancement affects existing user flows, feature discoverability, and navigation patterns. This is critical for enhancements because users already have established mental models and workflows.

### Why This Matters for Enhancements

Unlike new features, enhancements modify existing user experiences:
- **Established patterns**: Users have muscle memory for current flows
- **Change resistance**: Modifications can break familiar workflows
- **Discoverability shifts**: Changes may hide or expose features differently
- **Multi-persona impact**: Different users affected differently by same change

### Assessment Dimensions

#### 1. Feature Reachability Impact

**Analyze**: How users access the feature now vs after enhancement

**Current Access Paths**:
- Document all ways users can reach the existing feature
- Include: navigation menus, direct links, shortcuts, search results
- Map number of clicks/steps for each path

**Changed Paths**:
- Which existing paths will be modified?
- Are any paths being removed?
- Will path changes confuse existing users?

**New Access Paths**:
- What new ways to reach the feature are being added?
- Are new paths more or less discoverable?

**Dead End Analysis**:
- Are any current entry points being blocked?
- Do any flows lead to dead ends after enhancement?
- Are there orphaned UI elements?

**Discoverability Score** (Before vs After):
- **Low (1-3)**: Feature buried 3+ clicks deep, no visual indicators, easily missed
- **Medium (4-7)**: Accessible within 2 clicks, some visual cues present
- **High (8-10)**: Immediately visible, clear affordances, intuitive location

**Output**:
```markdown
### Feature Reachability
**Current Access Paths**:
1. Dashboard → Users menu → User table (2 clicks)
2. Quick search → "users" → User table (2 clicks)
3. Keyboard shortcut: Ctrl+U (0 clicks)

**Changed Paths**: None (all preserved)

**New Access Paths**:
1. Toolbar "Export" button (1 click - for new export action)

**Dead Ends**: None identified

**Discoverability Score**:
- Before: 6/10 (Medium - menu-driven, requires knowledge)
- After: 8/10 (High - visual affordance + existing paths maintained)
- Improvement: +2 points
```

#### 2. Multi-Persona Flow Analysis

**Identify Personas**: Who uses the existing feature?
- **Admin users**: Full permissions, frequent usage
- **Regular users**: Limited permissions, standard usage
- **Power users**: Expert knowledge, efficiency-focused
- **Novice users**: Learning, need guidance
- **Guest/limited users**: Restricted access
- **Mobile users**: Different interaction patterns (if applicable)

**Per-Persona Impact Assessment**:

For each persona, document:
- **Current workflow**: How they use the feature today
- **Enhanced workflow**: How they'll use it after changes
- **Impact**: Positive / Neutral / Negative / Breaking
- **Value**: High / Medium / Low / None
- **Learning curve**: None / Minimal / Moderate / Steep
- **Workarounds needed**: Any manual adjustments required

**Example Structure**:
```markdown
#### Admin User
- **Current workflow**: Dashboard → Users → Manual CSV export (5 clicks + file save)
- **Enhanced workflow**: Dashboard → Users → One-click export button
- **Impact**: ✅ POSITIVE - Saves 3-5 minutes per export
- **Value**: High (performs 10+ exports/day)
- **Learning curve**: Minimal (button is obvious)
- **Workarounds**: None needed

#### Regular User
- **Current workflow**: Dashboard → View team users (read-only)
- **Enhanced workflow**: Dashboard → View team users (export disabled/hidden)
- **Impact**: ⚪ NEUTRAL - No capability change
- **Value**: None (feature not accessible to role)
- **Learning curve**: N/A
- **Workarounds**: None needed

#### Power User
- **Current workflow**: Keyboard shortcut → Custom export script
- **Enhanced workflow**: Keyboard shortcut → Native export OR keep script
- **Impact**: ⚠️ MIXED - Native feature easier, but script more flexible
- **Value**: Medium (native covers 80% of cases)
- **Learning curve**: None (can continue using script)
- **Workarounds**: Keep script for advanced cases
```

**Persona Priority Matrix**:
```
High Impact + High Frequency → Critical to test thoroughly
High Impact + Low Frequency → Important but less urgent
Low Impact + High Frequency → Monitor for accumulation
Low Impact + Low Frequency → Accept minor issues
```

#### 3. Existing Flow Integration

**Workflow Mapping**: Document complete user workflows involving the feature

**Integration Points**: Where does enhancement fit in existing flows?

**Flow Continuity**: Does enhancement maintain logical progression?

**Downstream Effects**: What happens after users interact with enhancement?

**Example Analysis**:
```markdown
### Primary Workflow: User Management

**Current Flow**:
```
Dashboard → View Users → Select User → Edit Profile
                ↓
          [Manual operations]
```

**Enhanced Flow**:
```
Dashboard → View Users → [SORT/FILTER] → Select User → Edit Profile
                            ↑
                    New capability integrates here
                    Doesn't block downstream actions
                    Maintains flow continuity
```

**Integration Assessment**: ✅ Clean integration
- Adds capability without disrupting existing flow
- Doesn't add required steps (optional enhancement)
- Preserves all downstream actions
- No new dead ends created

**Downstream Effects**:
- Users can still edit profiles after sorting (preserved)
- Selection works same way post-sort (preserved)
- Bulk actions still available (preserved)
```

#### 4. Navigation Pattern Consistency

**App Pattern Analysis**: How does the existing feature follow app-wide navigation patterns?

**Pattern Preservation**: Does enhancement maintain consistency with app patterns?

**New Patterns**: Are we introducing new UI/navigation patterns?

**Pattern Conflicts**: Any inconsistencies with rest of application?

**Assessment Checklist**:
```markdown
### Navigation Pattern Consistency

**App-Wide Patterns**:
- ✅ Toolbar actions for data operations (Refresh, Filter, Settings)
- ✅ Right-click context menus for item actions
- ✅ Modal dialogs for forms
- ✅ Toast notifications for feedback
- ✅ Icon library: FontAwesome

**Enhancement Alignment**:
- ✅ Export button in toolbar (follows data operation pattern)
- ✅ Download icon from FontAwesome (consistent iconography)
- ✅ Click → Immediate action (matches Refresh behavior)
- ✅ Toast notification on success (standard feedback)
- ❌ Does NOT use modal (export is direct action, no modal needed)

**New Patterns Introduced**: None

**Pattern Conflicts**: None identified

**Consistency Score**: 9/10 (High - follows all major patterns)
```

**Common App Patterns to Check**:
- Action placement (toolbars vs menus vs context menus)
- Interaction models (click, hover, drag-drop)
- Feedback mechanisms (toasts, modals, inline messages)
- Icon usage and positioning
- Color coding and visual hierarchy
- Responsive behavior
- Keyboard shortcuts

#### 5. Discoverability Before/After Assessment

**Purpose**: Quantify improvement (or degradation) in feature discoverability

**Scoring Rubric**:

| Score | Level | Description |
|-------|-------|-------------|
| 1-3 | Low | Feature buried 3+ clicks deep OR no visual indicators OR requires documentation to find OR easily overlooked |
| 4-7 | Medium | Accessible within 2 clicks OR some visual cues OR somewhat intuitive OR requires minor exploration |
| 8-10 | High | Visible immediately OR clear affordances OR intuitive location OR follows obvious patterns |

**Factors to Score**:
- **Visual Prominence** (1-10): How visible is the feature?
- **Logical Location** (1-10): Is it where users would expect?
- **Affordances** (1-10): Clear cues about what it does?
- **Accessibility** (1-10): How many steps to reach it?

**Example Assessment**:
```markdown
### Discoverability Before Enhancement

**Visual Prominence**: 3/10
- Feature only accessible via menu
- No toolbar presence
- No keyboard shortcut
- No icon/visual indicator on main screen

**Logical Location**: 6/10
- Located in Users menu (somewhat expected)
- Requires knowledge of menu structure
- Not visible when viewing users

**Affordances**: 5/10
- Menu text: "Export Data" (clear purpose)
- No icon in menu
- No hint about export format

**Accessibility**: 5/10
- Requires 2 clicks (Dashboard → Users menu)
- Menu must be expanded
- Easy to miss if not looking for it

**Overall Before Score**: 4.75/10 (Medium-Low)

### Discoverability After Enhancement

**Visual Prominence**: 8/10
- Toolbar button visible on user table screen
- Download icon (universal affordance)
- Maintains menu access as backup
- Tooltip on hover: "Export user data"

**Logical Location**: 9/10
- Toolbar placement (with other data actions)
- Visible when viewing user data
- Follows app pattern for data operations

**Affordances**: 9/10
- Download icon (clear intent)
- Tooltip provides context
- Visual consistency with other actions

**Accessibility**: 9/10
- 1 click from user table view
- Immediately visible (no menu expansion)
- Also available via original menu path

**Overall After Score**: 8.75/10 (High)

**Improvement**: +4 points (Medium-Low → High)
```

### Assessment Output Format

Add this section to the Gap Analysis Report:

```markdown
## User Journey Impact Assessment

### Feature Reachability
[Document access paths, changes, new paths, dead ends, discoverability score]

### Multi-Persona Analysis
[Per-persona workflow impact assessment with value/learning curve]

### Existing Flow Integration
[Workflow diagrams, integration points, continuity check, downstream effects]

### Navigation Pattern Consistency
[App patterns, enhancement alignment, new patterns, conflicts, consistency score]

### Discoverability Assessment
[Before/after scoring with detailed rubric, improvement quantification]

### Overall User Journey Impact

**Impact Level**: Low / Medium / High
- **Low**: Minor changes, high consistency, improved discoverability
- **Medium**: Moderate changes, mostly consistent, similar discoverability
- **High**: Major changes, new patterns, or reduced discoverability

**Risk to User Experience**: Low / Medium / High
- Based on: Persona disruption + Flow breaks + Pattern conflicts + Discoverability loss

**Recommendations**:
1. [Specific action to improve user journey]
2. [Mitigation for identified risks]
3. [Enhancements to discoverability]
```

---

## Data Entity Lifecycle Analysis

## ⚠️ CRITICAL: Backend Code ≠ User Operability

**DO NOT assume API endpoints or backend code mean users can perform operations.**

**Common Mistake**:
- ✅ Found: `POST /api/allergies` endpoint
- ❌ Assumed: Users can create allergies
- ⚠️ Reality: No user-facing form exists - **users cannot actually create allergies**

**Correct Approach**:
- ✅ Found: `POST /api/allergies` endpoint (backend capability exists)
- ❓ Verify: Is there a user-facing form? → Search for AllergyInputForm.tsx
- ❓ Verify: Is form rendered in a screen? → Check if PatientRegistration.tsx imports and renders it
- ❓ Verify: Can users navigate to screen? → Check if Registration menu item exists and is accessible
- ✅ Conclusion: Users CAN create allergies (operability confirmed through all three layers)

**Three-Layer Verification Framework**:
1. **Backend Layer**: API endpoint/model method exists (technical capability exists)
2. **Component Layer**: UI form/display component exists (interface code exists)
3. **User Access Layer**: Component is actually rendered in a routed page, and users can navigate to it (USERS CAN ACTUALLY USE IT)

**ALL THREE layers required to confirm user operability. Backend code alone is insufficient.**

---

### Purpose

For enhancements involving data entities (user info, patient data, orders, etc.), ensure the complete data lifecycle is addressed. This prevents orphaned features where data can be displayed but not input, or captured but never shown.

**Critical for**: Enhancements that display, capture, or modify data entities

**Prevents**:
- **Orphaned Display**: Showing data with no way to input it (useless feature)
- **Orphaned Input**: Capturing data with nowhere to view it (user frustration)
- **Incomplete Coverage**: Data appears in only 1 place when it should appear in 5+ (poor UX)

### Why This Matters for Enhancements

Unlike new features, enhancements often touch existing data entities that have established lifecycle expectations:
- **Users expect completeness**: If data can be viewed, it should be editable
- **Data has multiple contexts**: Patient allergies appear in appointments, prescriptions, emergencies, etc.
- **Partial implementations break workflows**: Display without input = feature can't be used
- **Safety-critical in some domains**: Healthcare, finance require complete data access

### Entity Extraction

**Goal**: Identify data entities involved in the enhancement

**Algorithm Outline**:

**Input**: `"Display allergy information on patient summary screen"`

**Steps**:
1. **Extract Nouns** → `["allergy", "information", "patient", "summary", "screen"]`
2. **Identify Data Entities** → `["allergy information", "patient"]`
   - Data entities: Nouns that represent stored/persisted data
   - Not entities: UI elements (screen, button), actions (display, show)
3. **Classify Entity Type**:
   - **User/Customer Data**: Patient info, user profile, customer records
   - **Transaction Data**: Orders, appointments, prescriptions, payments
   - **System Data**: Settings, configurations, logs
   - **Reference Data**: Categories, types, statuses (usually read-only)
4. **Determine Entity Criticality**:
   - **Critical**: Safety, legal, financial (allergies, prescriptions, payments)
   - **Important**: Core functionality (user profile, orders)
   - **Standard**: Nice-to-have (preferences, favorites)

**Output Structure**:
```
{
  entities: [
    {
      name: "allergy information",
      type: "User/Customer Data",
      criticality: "Critical",
      domain: "patient health"
    }
  ]
}
```

**Common Entity Indicators**:
- Healthcare: patient, allergy, prescription, diagnosis, lab result, vital signs
- E-commerce: order, product, cart, payment, shipping, inventory
- Finance: transaction, account, balance, invoice, payment
- SaaS: user, organization, subscription, usage, billing

### CRUD Lifecycle Mapping

## ⚠️ CRITICAL INSTRUCTION: EXECUTE VERIFICATION NOW

**For each data entity operation (CREATE/READ/UPDATE/DELETE):**

1. **DO NOT write "Needs verification"**
2. **ACTIVELY SEARCH the codebase NOW** using the Detection Patterns below
3. **USE Grep, Glob, and Read tools** to search for evidence
4. **DOCUMENT SEARCH RESULTS** with evidence (file paths, line numbers)
5. **CONCLUDE with layer status**: ✅ Found / ❌ Not Found / ⚠️ Partial

**DO NOT defer verification. Search and document findings immediately.**

---

For each data entity, map the complete Create-Read-Update-Delete lifecycle:

#### CREATE (Input/Capture)

**Questions to Ask**:
- How is this data initially captured?
- Where in the user journey does creation happen?
- Who can create this data?
- What forms/interfaces exist for input?
- Are there API endpoints for creation?
- Can data be imported/bulk created?

**Evidence to Search For** (Three-Layer Verification):

**Layer 1 - Backend Capability**:
- API POST/CREATE endpoints
- Model create methods
- Database schemas

**Layer 2 - UI Component Existence**:
- Form components with entity input fields
- Import/upload interfaces
- Inline creation UI

**Layer 3 - User Accessibility** (CRITICAL):
- Where form is rendered (page/screen components)
- Routes that display the form
- Navigation paths (menu items, buttons, links)
- Permission/role requirements

**Detection Pattern** (Three-Layer Search):

**⚠️ EXECUTE THIS SEARCH NOW using Grep/Glob/Read tools. DO NOT write "Needs verification".**

```bash
# Layer 1: Backend Capability
grep -r "POST /api/allergies" --include="*.ts" --include="*.js"
grep -r "Allergy.create\|createAllergy" --include="*.ts" --include="*.js"
# Result: Backend CAN store data

# Layer 2: UI Component Exists
find . -name "*AllergyForm*" -o -name "*AddAllergy*" -o -name "*CreateAllergy*"
grep -r "allergyInput\|allergy.*input" --include="*.tsx" --include="*.jsx"
# Result: Form component exists

# Layer 3: User Can Access (MOST IMPORTANT)
# Step 3a: Find where form is rendered
grep -r "import.*AllergyForm\|<AllergyForm" --include="*.tsx" --include="*.jsx"
# Expected: PatientRegistration.tsx, AppointmentIntake.tsx

# Step 3b: Verify pages are routed
grep -r "PatientRegistration\|AppointmentIntake" router* routes* --include="*.ts" --include="*.tsx"
# Expected: /registration, /appointments/new

# Step 3c: Verify navigation access
grep -r "/registration\|/appointments/new" navigation* menu* sidebar* header* --include="*.tsx"
# Expected: "Register Patient" menu item, "New Appointment" button

# Step 3d: Check permission requirements
grep -r "requiresRole\|requiresPermission" PatientRegistration* AppointmentIntake*
# Expected: Role requirements if any
```

**Gap Indicators**:
- ❌ **Critical**: No backend API endpoint (Layer 1 missing)
- ❌ **Critical**: No form component (Layer 2 missing)
- ⚠️ **Critical**: Form exists but NOT imported/rendered anywhere (Layer 3 missing - **unused code**)
- ⚠️ **Critical**: Form rendered but page has no route (Layer 3 missing - **unreachable**)
- ⚠️ **Critical**: Route exists but no navigation to it (Layer 3 missing - **hidden from users**)
- ⚠️ **Important**: Navigation behind inaccessible permissions (Layer 3 restricted - **users can't access**)

**⚠️ Backend API + Component File ≠ User Operability. Must verify Layer 3 (User Access).**

#### READ (Display/Output)

**Questions to Ask**:
- Where is this data currently displayed?
- Where SHOULD this data be displayed?
- Which user personas need to see it?
- In which contexts is it relevant?
- Are there different views for different personas?

**Multi-Context Discovery**:
1. **Identify entity domain** (e.g., "patient health")
2. **Find all screens in domain**:
   - Patient summary
   - Appointment view
   - Medical history
   - Prescription workflow
   - Emergency contact
   - Lab orders
3. **For each screen, assess relevance**:
   - Is this entity critical here? (allergies critical in prescription)
   - Is this entity helpful here? (allergies helpful in appointment)
   - Is this entity optional here? (allergies optional in billing)
4. **Categorize by priority**:
   - **Must-have**: Safety-critical, workflow-blocking
   - **Should-have**: High-value, user expects it
   - **Nice-to-have**: Convenience, edge cases

**Evidence to Search For** (Three-Layer Verification):

**Layer 1 - Backend Capability**:
- API GET endpoints
- Data fetching methods
- Database queries

**Layer 2 - UI Component Existence**:
- Display components (tables, cards, lists, badges)
- Data visualization components
- Read-only views

**Layer 3 - User Accessibility** (CRITICAL):
- Where display component is rendered (page/screen components)
- Routes that show the data
- Navigation paths to reach the display
- Permission/role requirements to view

**Detection Pattern** (Three-Layer Search):

**⚠️ EXECUTE THIS SEARCH NOW using Grep/Glob/Read tools. DO NOT write "Needs verification".**

```bash
# Layer 1: Backend Capability
grep -r "GET /api/allergies\|/patients/:id/allergies" --include="*.ts" --include="*.js"
# Result: Backend CAN retrieve data

# Layer 2: UI Component Exists
find . -name "*AllergyDisplay*" -o -name "*AllergyList*" -o -name "*AllergyTag*"
grep -r "allergies.*map\|allergy.*display" --include="*.tsx" --include="*.jsx"
# Result: Display component exists

# Layer 3: User Can Access (MOST IMPORTANT)
# Step 3a: Find where display is rendered
grep -r "import.*AllergyDisplay\|<AllergyDisplay\|<AllergyList" --include="*.tsx" --include="*.jsx"
# Expected: PatientSummary.tsx, AppointmentView.tsx, PrescriptionWorkflow.tsx

# Step 3b: Verify pages are routed and accessible
grep -r "PatientSummary\|AppointmentView\|PrescriptionWorkflow" router* routes*
# Expected: /patients/:id, /appointments/:id, /prescriptions/new

# Step 3c: Verify navigation access to these pages
grep -r "/patients\|/appointments\|/prescriptions" navigation* menu* sidebar*
# Expected: Menu items, links, buttons that users can click

# Step 3d: Check if data is actually rendered (not just component imported)
grep -r "allergies=" PatientSummary* AppointmentView* PrescriptionWorkflow* --include="*.tsx"
# Expected: Props being passed with actual data
```

**Gap Indicators**:
- ❌ **Critical**: No backend GET endpoint (Layer 1 missing)
- ❌ **Critical**: No display component (Layer 2 missing)
- ⚠️ **Critical**: Component exists but NOT imported/rendered (Layer 3 missing - **unused code**)
- ⚠️ **Critical**: Component rendered but page unreachable (Layer 3 missing - **no route**)
- ⚠️ **Critical**: Page exists but users can't navigate to it (Layer 3 missing - **hidden**)
- ⚠️ **Important**: Display behind inaccessible permissions (Layer 3 restricted)
- ⚠️ **Incomplete Coverage**: Entity displayed in only 1 screen but relevant in 5+ critical contexts (partial Layer 3)
- ❌ **User mentions 1 location** but analysis finds 5+ other safety-critical touchpoints (incomplete scope)

**⚠️ Backend API + Display Component ≠ User Can View. Must verify Layer 3 (User Access) for ALL relevant touchpoints.**

#### UPDATE (Edit/Modify)

**Questions to Ask**:
- Can users edit this data after creation?
- Who has permission to update?
- Where are edit forms/interfaces?
- Are there API endpoints for updates?
- Is there version history/audit trail?
- Can data be bulk updated?

**Evidence to Search For** (Three-Layer Verification):

**Layer 1 - Backend Capability**:
- API PUT/PATCH endpoints
- Update methods in models
- Version history/audit trails

**Layer 2 - UI Component Existence**:
- Edit forms or inline edit components
- Edit buttons, pencil icons
- Modal dialogs for editing

**Layer 3 - User Accessibility** (CRITICAL):
- Where edit UI is rendered (which pages show edit buttons)
- How users trigger edit (button clicks, context menus, inline)
- Navigation to edit forms
- Permission/role requirements

**Detection Pattern** (Three-Layer Search):

**⚠️ EXECUTE THIS SEARCH NOW using Grep/Glob/Read tools. DO NOT write "Needs verification".**

```bash
# Layer 1: Backend Capability
grep -r "PUT /api/allergies\|PATCH /api/allergies" --include="*.ts" --include="*.js"
grep -r "updateAllergy\|Allergy.update" --include="*.ts" --include="*.js"
# Result: Backend CAN update data

# Layer 2: UI Component Exists
find . -name "*EditAllergy*" -o -name "*UpdateAllergy*" -o -name "*AllergyEdit*"
grep -r "edit.*button\|pencil.*icon.*allergy" --include="*.tsx" --include="*.jsx"
# Result: Edit UI component exists

# Layer 3: User Can Access (MOST IMPORTANT)
# Step 3a: Find where edit UI is rendered
grep -r "import.*EditAllergy\|<EditAllergy\|editAllergy" --include="*.tsx" --include="*.jsx"
# Expected: PatientProfile.tsx, AppointmentView.tsx

# Step 3b: Verify pages with edit UI are routable
grep -r "PatientProfile\|AppointmentView" router* routes*
# Expected: /patients/:id/profile, /appointments/:id

# Step 3c: Check if edit action is actually wired up
grep -r "onClick.*edit\|onEdit\|handleEdit" PatientProfile* AppointmentView* --include="*.tsx"
# Expected: Event handlers that trigger edit

# Step 3d: Verify permissions don't block edit
grep -r "canEdit\|requiresPermission.*edit\|requiresRole.*edit" --include="*.tsx"
# Expected: Permission checks if any
```

**Gap Indicators**:
- ❌ **Critical**: No backend UPDATE endpoint (Layer 1 missing)
- ❌ **Critical**: No edit UI component (Layer 2 missing)
- ⚠️ **Critical**: Edit UI exists but NOT rendered anywhere (Layer 3 missing - **unused code**)
- ⚠️ **Critical**: Edit button exists but no onClick handler (Layer 3 missing - **non-functional**)
- ⚠️ **Critical**: Edit form unreachable (Layer 3 missing - **no navigation path**)
- ⚠️ **Important**: Edit behind restrictive permissions that block target users (Layer 3 restricted)
- ❌ Display exists but users cannot edit (frustrating if data incorrect)
- ❌ Create exists but users cannot update (can't fix mistakes)

**⚠️ Backend API + Edit Component ≠ User Can Edit. Must verify Layer 3 (User Access and actual functionality).**

#### DELETE (Remove/Archive)

**Questions to Ask**:
- Can this data be deleted?
- Is it soft delete (archive) or hard delete?
- Who can delete?
- Are there cascade effects?
- Is there undo/restore capability?
- Should data be archived instead of deleted?

**Evidence to Search For** (Three-Layer Verification):

**Layer 1 - Backend Capability**:
- API DELETE endpoints
- Delete/archive methods in models
- Soft delete timestamps (deletedAt, archivedAt)
- Cascade delete logic

**Layer 2 - UI Component Existence**:
- Delete buttons, trash icons
- Confirmation dialogs
- Archive/restore UI

**Layer 3 - User Accessibility** (CRITICAL):
- Where delete UI is rendered (which pages show delete buttons)
- How users trigger delete (button clicks, context menus, swipe actions)
- Confirmation flows before deletion
- Permission/role requirements

**Detection Pattern** (Three-Layer Search):

**⚠️ EXECUTE THIS SEARCH NOW using Grep/Glob/Read tools. DO NOT write "Needs verification".**

```bash
# Layer 1: Backend Capability
grep -r "DELETE /api/allergies" --include="*.ts" --include="*.js"
grep -r "deleteAllergy\|removeAllergy\|Allergy.delete" --include="*.ts" --include="*.js"
grep -r "deletedAt\|archivedAt\|isArchived" --include="*.ts" --include="*.js"
# Result: Backend CAN delete/archive data

# Layer 2: UI Component Exists
grep -r "delete.*button\|trash.*icon\|remove.*button" --include="*.tsx" --include="*.jsx"
grep -r "ConfirmDelete\|DeleteConfirmation" --include="*.tsx" --include="*.jsx"
# Result: Delete UI component exists

# Layer 3: User Can Access (MOST IMPORTANT)
# Step 3a: Find where delete UI is rendered
grep -r "delete.*onClick\|onDelete\|handleDelete" --include="*.tsx" --include="*.jsx"
# Expected: PatientProfile.tsx, AppointmentView.tsx, AllergyList.tsx

# Step 3b: Verify delete action is wired up
grep -r "deleteAllergy\|removeAllergy" --include="*.tsx" --include="*.jsx"
# Expected: Component actually calls delete function

# Step 3c: Check for confirmation dialogs
grep -r "confirm.*delete\|are you sure.*delete" --include="*.tsx" --include="*.jsx"
# Expected: Safety confirmation before delete

# Step 3d: Verify permissions protect delete
grep -r "canDelete\|requiresPermission.*delete\|requiresRole.*delete" --include="*.tsx"
# Expected: Permission checks to prevent unauthorized deletion
```

**Gap Indicators**:
- ❌ **Critical**: No backend DELETE endpoint (Layer 1 missing)
- ❌ **Critical**: No delete UI component (Layer 2 missing)
- ⚠️ **Critical**: Delete button exists but NOT rendered (Layer 3 missing - **unused code**)
- ⚠️ **Critical**: Delete button exists but no onClick handler (Layer 3 missing - **non-functional**)
- ⚠️ **Critical**: Delete action with no confirmation dialog (Layer 3 unsafe - **accidental deletion risk**)
- ⚠️ **Important**: Delete not protected by permissions (Layer 3 unsafe - **anyone can delete**)
- ❌ Create/Update exist but users cannot delete (can't remove incorrect data)
- ⚠️ Hard delete for data that should be archived (audit trail lost, compliance risk)

**⚠️ Backend API + Delete Button ≠ User Can Safely Delete. Must verify Layer 3 (User Access, confirmation flows, and permissions).**

### Orphaned Operation Detection

**Pattern 1: Orphaned Display**

**Definition**: Enhancement adds data display but no input mechanism exists

**Example**:
- Enhancement: "Display allergy information on patient summary"
- Analysis finds: ✅ Display component exists or will be added
- Analysis finds: ❌ No allergy input forms, no API creation endpoints
- **Result**: Feature is useless - data will always be empty

**Enhanced Detection** (Three-Layer Verification):

**⚠️ EXECUTE these checks NOW using Grep/Glob tools. DO NOT write "Needs verification".**

```
IF enhancement involves READ operation
THEN:
  1. Search for CREATE backend using Grep:
     grep -r "POST /api/[entity]" --include="*.ts" --include="*.js"

  2. Search for CREATE UI component using Glob/Grep:
     find . -name "*[Entity]Form*" -o -name "*Add[Entity]*"

  3. Search for component usage using Grep:
     grep -r "import.*[Entity]Form\|<[Entity]Form" --include="*.tsx" --include="*.jsx"

  4. IF ANY layer missing → flag as "Orphaned Display - Critical Gap"
```

**Verification Steps TO EXECUTE NOW**:
1. ✅ **Layer 1 - Backend**: Search for CREATE API (POST endpoint, model method)
2. ✅ **Layer 2 - UI Component**: Search for CREATE form component (input form file)
3. ✅ **Layer 3 - User Access**: Search if form is rendered in pages (grep for imports/rendering)
4. ⚠️ **If ANY layer missing** → Document as Orphaned Display with search evidence

**Example with Backend but No UI**:
```markdown
Enhancement: "Display allergy information on patient summary"

Layer 1 - Backend: ✅ POST /api/allergies exists
Layer 2 - UI Component: ❌ No AllergyForm component found
Layer 3 - User Access: ❌ Not applicable (no component to access)

Result: ORPHANED DISPLAY - Backend CAN store data, but users have NO INTERFACE to input it
```

**Recommendation**:
```
Expand scope to include:
1. Allergy input form (registration)
2. Allergy input during appointment intake
3. Patient profile self-service edit

OR split into 2 enhancements:
1. Input mechanism (prerequisite)
2. Display enhancement (this one)
```

**Pattern 2: Orphaned Input**

**Definition**: Enhancement adds data capture but no display/usage

**Example**:
- Enhancement: "Add allergy field to patient registration form"
- Analysis finds: ✅ Input form exists or will be added
- Analysis finds: ❌ No screens display allergies, no usage in workflows
- **Result**: Data captured but never seen or used (user frustration)

**Enhanced Detection** (Three-Layer Verification):

**⚠️ EXECUTE these checks NOW using Grep/Glob tools. DO NOT write "Needs verification".**

```
IF enhancement involves CREATE operation
THEN:
  1. Search for READ backend using Grep:
     grep -r "GET /api/[entity]" --include="*.ts" --include="*.js"

  2. Search for READ UI component using Glob/Grep:
     find . -name "*[Entity]Display*" -o -name "*[Entity]List*"

  3. Search for component usage using Grep:
     grep -r "import.*[Entity]Display\|<[Entity]Display" --include="*.tsx" --include="*.jsx"

  4. IF ANY layer missing → flag as "Orphaned Input - Critical Gap"
```

**Verification Steps TO EXECUTE NOW**:
1. ✅ **Layer 1 - Backend**: Search for READ API (GET endpoint, fetch method)
2. ✅ **Layer 2 - UI Component**: Search for READ display component (display component file)
3. ✅ **Layer 3 - User Access**: Search if display is rendered in pages (grep for imports/rendering)
4. ⚠️ **If ANY layer missing** → Document as Orphaned Input with search evidence

**Example with Backend but No UI**:
```markdown
Enhancement: "Add allergy field to patient registration form"

Layer 1 - Backend: ✅ GET /api/allergies exists
Layer 2 - UI Component: ❌ No AllergyDisplay component found
Layer 3 - User Access: ❌ Not applicable (no component to access)

Result: ORPHANED INPUT - Backend CAN retrieve data, but users have NO INTERFACE to view it
```

**Recommendation**:
```
Expand scope to include:
1. Display in patient summary
2. Display in appointment view
3. Display in prescription workflow (drug interactions)

OR ensure this is Phase 1 of multi-phase plan
```

**Pattern 3: Incomplete Touchpoint Coverage**

**Definition**: Data displayed in some contexts but missing from other relevant ones

**Example**:
- Enhancement: "Display allergies on patient summary"
- Analysis finds: ✅ Patient summary will show allergies
- Analysis finds: ⚠️ Allergies also relevant in:
  - Appointment view (doctor needs before treatment)
  - Prescription workflow (drug interaction warnings)
  - Emergency contact screen (critical in emergencies)
  - Lab orders (avoid contraindicated tests)
  - Medical history (comprehensive record)
- **Result**: Incomplete UX - data accessible but not where users expect it

**Detection**:
```
IF enhancement involves READ for entity
THEN:
  1. Discover all screens in entity domain
  2. Assess relevance for each screen
  3. Compare user-mentioned locations vs all relevant locations
  4. Flag missing must-have and should-have touchpoints
```

**Recommendation**:
```
Expand scope to include all critical touchpoints:

Must-have (safety-critical):
- Prescription workflow (drug interactions)
- Emergency contact screen
- Appointment view

Should-have (high-value):
- Medical history
- Lab orders

Nice-to-have (convenience):
- Patient profile page
```

### Multi-Context Discovery Algorithm

**Goal**: Find ALL places where a data entity should appear, not just user-mentioned locations

**Algorithm**:

**Step 1: Identify Entity Domain**
```
Entity: "allergy information"
→ Domain: "patient health data"
→ Related domains: "appointments", "prescriptions", "medical history"
```

**Step 2: Discover Domain Screens**

Search codebase for screens in domain:
```bash
# Find patient-related pages/views
find . -name "*Patient*" -o -name "*patient*" | grep -i "page\|view\|screen\|component"

# Find appointment-related screens
find . -name "*Appointment*" -o -name "*appointment*" | grep -i "page\|view\|screen"

# Find prescription-related screens
find . -name "*Prescription*" -o -name "*prescription*" | grep -i "page\|view\|screen"

# Search for medical/health-related screens
grep -r "medical\|health\|clinical" --include="*.tsx" --include="*.jsx" | grep "page\|view\|screen"
```

**Step 3: Assess Relevance Per Screen**

For each discovered screen:
```
Screen: AppointmentView.tsx

Questions:
1. Would this entity be useful here?
   → YES - doctor needs to know allergies before treatment

2. How critical is it?
   → CRITICAL - patient safety (drug allergies)

3. Who uses this screen?
   → Doctors, nurses (high-frequency users)

4. What workflows involve this screen?
   → Appointment preparation, treatment planning

5. Is entity currently displayed here?
   → Search code: grep -r "allergy\|Allergy" AppointmentView.tsx
   → NO - not currently shown

Assessment: Must-have touchpoint (critical + high-frequency + safety)
```

**Step 4: Categorize Touchpoints**

```
Must-have (Critical + High-Frequency OR Safety-Critical):
- Prescription workflow (drug interaction warnings) ⚠️ SAFETY
- Appointment view (treatment planning) ⚠️ SAFETY
- Emergency contact screen (emergency response) ⚠️ SAFETY

Should-have (High-Value + Medium-Frequency):
- Medical history (comprehensive record)
- Lab orders screen (avoid contraindicated tests)
- Patient profile (self-service view/edit)

Nice-to-have (Convenience + Low-Frequency):
- Billing screen (potential insurance relevance)
- Patient dashboard (overview widget)
```

**Step 5: Compare with User Request**

```
User mentioned: "Patient summary screen"

Found in codebase: 6 additional relevant screens

Gap: 3 must-have + 3 should-have + 2 nice-to-have screens missing

Recommendation: Expand scope to include must-have touchpoints
```

**Output**: Complete touchpoint map with priorities

---

### UI Accessibility Verification Patterns

**Purpose**: Systematically verify that users can actually perform CRUD operations through the UI, not just that backend code exists.

## ⚠️ EXECUTE VERIFICATION NOW - DO NOT WRITE "Needs verification"

**Use Grep, Glob, and Read tools to search the codebase immediately. Document findings with file paths and evidence.**

---

**For each CRUD operation, verify all three layers:**

#### Layer 1: Backend Capability

**What to verify**: Technical capability exists in backend code

**Search for**:
- API endpoints (REST routes, GraphQL resolvers)
- Model methods (create, find, update, delete)
- Database operations (queries, migrations)
- Business logic functions

**Tools**: grep for routes/endpoints/methods, check API documentation

**Example**:
```bash
# Search for allergy API endpoints
grep -r "POST /api/allergies\|GET /api/allergies\|PUT /api/allergies\|DELETE /api/allergies" --include="*.ts" --include="*.js"

# Search for model methods
grep -r "Allergy.create\|Allergy.find\|Allergy.update\|Allergy.delete" --include="*.ts" --include="*.js"
```

**Result**: ✅ Backend CAN store/retrieve/modify data OR ❌ Backend capability missing

---

#### Layer 2: UI Component Existence

**What to verify**: UI components exist as code files

**Search for**:
- Form components (input, edit forms)
- Display components (lists, cards, tables, detail views)
- Action components (buttons, icons, menu items)
- Modal/dialog components

**Tools**: glob/find for component files, grep for component usage

**Example**:
```bash
# Search for allergy UI components
find . -name "*AllergyForm*" -o -name "*AllergyDisplay*" -o -name "*AllergyList*"

# Search for allergy-related UI code
grep -r "allergy.*input\|allergy.*form\|allergy.*display" --include="*.tsx" --include="*.jsx"
```

**Result**: ✅ UI component code exists OR ❌ UI component file missing

---

#### Layer 3: User Accessibility (CRITICAL)

**What to verify**: Users can actually access and use the UI components

**Four sub-checks required**:

**3a. Component Rendering**: Is component imported and rendered?
```bash
# Find where AllergyForm is imported/used
grep -r "import.*AllergyForm\|<AllergyForm" --include="*.tsx" --include="*.jsx"
# Expected: PatientRegistration.tsx imports and renders <AllergyForm>
```

**3b. Page Routing**: Is the page routable/accessible?
```bash
# Check if PatientRegistration is routed
grep -r "PatientRegistration\|/registration\|/patient/register" router* routes* App.tsx --include="*.ts" --include="*.tsx"
# Expected: Route like /registration or /patient/register exists
```

**3c. Navigation Access**: Can users navigate to the page?
```bash
# Check for navigation/menu items
grep -r "registration\|register.*patient" navigation* menu* sidebar* header* toolbar* --include="*.tsx" --include="*.jsx"
# Expected: Menu item, button, or link users can click
```

**3d. Permission/Role Check**: Are users authorized?
```bash
# Check for permission requirements
grep -r "requiresRole\|requiresPermission\|canAccess\|isAuthorized" PatientRegistration* --include="*.tsx" --include="*.ts"
# Expected: No overly restrictive permissions, or target users have required permissions
```

**Result**: ✅ Users CAN access and use OR ❌ Access blocked/missing

---

#### Common Layer 3 Failures (Critical to Detect)

**Failure Type 1: Component Not Rendered**
- Component file exists (Layer 2 ✅)
- But NOT imported or rendered anywhere (Layer 3 ❌)
- **Result**: Unused/dead code - users cannot access

**Failure Type 2: Page Not Routed**
- Component rendered in page (Layer 3a ✅)
- But page has no route definition (Layer 3b ❌)
- **Result**: Unreachable page - users cannot navigate to it

**Failure Type 3: No Navigation Path**
- Page is routed (Layer 3b ✅)
- But no menu/button/link to access it (Layer 3c ❌)
- **Result**: Hidden page - requires typing URL directly

**Failure Type 4: Blocked by Permissions**
- Navigation exists (Layer 3c ✅)
- But behind overly restrictive permissions (Layer 3d ❌)
- **Result**: Target users cannot access

---

#### Complete Verification Example

**Enhancement**: "Display allergy information on patient summary"

**CREATE Operation Verification**:

**Layer 1 - Backend Capability**:
```bash
grep -r "POST /api/allergies" --include="*.ts"
# Result: ✅ Found src/api/allergies.ts:42 - POST /api/patients/:id/allergies
```

**Layer 2 - UI Component Existence**:
```bash
find . -name "*AllergyForm*" -o -name "*AddAllergy*"
# Result: ❌ NOT FOUND - No allergy input form component exists
```

**Layer 3 - User Accessibility**:
```
N/A - Cannot verify accessibility when component doesn't exist
```

**Conclusion**: ❌ **ORPHANED DISPLAY - Critical Gap**
- Backend CAN store allergies
- But NO user-facing interface to input them
- Feature will be useless (allergies always empty)

---

### Scope Expansion Decision Framework

**When to Expand Enhancement Scope**:

#### Scenario 1: Missing Critical Lifecycle Stage

**Condition**: Enhancement touches entity but missing CREATE or primary READ
```
IF (enhancement adds READ AND no CREATE exists)
OR (enhancement adds CREATE AND no READ exists)
THEN expand scope = REQUIRED
```

**Rationale**: Feature is fundamentally broken without both input and output

**Action**: Expand scope to include missing lifecycle stage

#### Scenario 2: Safety-Critical Incomplete Coverage

**Condition**: Entity is critical and missing from safety-critical contexts
```
IF entity.criticality = "Critical"
AND enhancement adds READ in 1 location
AND missing touchpoints include safety-critical screens
THEN expand scope = STRONGLY RECOMMENDED
```

**Rationale**: Patient safety, legal compliance, financial accuracy require complete coverage

**Action**: Expand scope to include all must-have touchpoints

**Example**: Allergies must appear in prescription workflow (drug interactions)

#### Scenario 3: Poor UX from Incomplete Coverage

**Condition**: Entity relevant in 5+ places but enhancement only covers 1-2
```
IF total_relevant_touchpoints >= 5
AND user_mentioned_touchpoints <= 2
AND missing must-have touchpoints >= 2
THEN expand scope = RECOMMENDED
```

**Rationale**: Incomplete coverage creates frustrating, inconsistent UX

**Action**: Present options:
1. Expand scope to all must-have touchpoints
2. Split into multiple phased enhancements
3. Deliver minimal scope with follow-up plan

#### Scenario 4: Acceptable Limited Scope

**Condition**: Enhancement is genuinely incremental addition
```
IF entity already has complete CRUD lifecycle
AND enhancement adds 1 new touchpoint
AND no safety-critical gaps
AND user explicitly wants limited scope
THEN expand scope = NOT REQUIRED
```

**Rationale**: Incremental improvements are valid when foundation exists

**Action**: Document as Phase N of larger feature set, proceed with limited scope

### Integration with Gap Analysis

**Updated Gap Identification Process**:

**For each desired capability**:
1. ~~Search existing analysis for similar functionality~~ (existing)
2. ~~Classify relationship: None/Partial/Different/Architectural~~ (existing)
3. **NEW: If capability involves data entity:**
   - Extract entity name and type
   - Map CRUD lifecycle (current state)
   - Identify orphaned operations
   - Discover all relevant touchpoints
   - Assess scope completeness
4. ~~Document the gap with evidence~~ (existing)
5. **NEW: Recommend scope expansion if critical gaps found**

**Gap Complexity** (updated):
- ~~Simple: Add new prop/function (1-2 hours)~~ (existing)
- ~~Moderate: Add new module/component (2-4 hours)~~ (existing)
- ~~Complex: Change architecture/patterns (4-8 hours)~~ (existing)
- **Data Lifecycle Gap: Add missing CREATE/READ/UPDATE/DELETE (2-6 hours per stage)**
- **Multi-Touchpoint Gap: Add N missing display contexts (1-2 hours per touchpoint)**

### Data Flow Analysis Report Section

**Template to add to Gap Analysis Report**:

```markdown
## Data Entity Lifecycle Analysis

*[Include this section when enhancement involves data entities]*

### Entities Identified

**Primary Entity**: Allergy Information
- **Type**: User/Customer Data (Patient Health)
- **Criticality**: Critical (safety-related)
- **Domain**: Patient health data

### CRUD Lifecycle Assessment

#### CREATE (Input/Capture)

**Current State**: ❌ NO USER-FACING INPUT MECHANISM EXISTS

**Three-Layer Verification**:

**Layer 1 - Backend Capability**: ⚠️ PARTIAL
- ✅ Found: POST /api/patients/:id/allergies endpoint (src/api/patients/allergies.ts:42)
- ✅ Found: Allergy.create() model method (src/models/Allergy.ts:15)
- **Conclusion**: Backend CAN store allergies

**Layer 2 - UI Component**: ❌ MISSING
- Searched for: AllergyForm, AddAllergyForm, CreateAllergyForm components
- Searched for: Allergy input fields in forms
- **Result**: No allergy input form component found
- **Conclusion**: No UI form exists for user input

**Layer 3 - User Accessibility**: ❌ NOT ACCESSIBLE
- No form component exists, so no user access possible
- **Conclusion**: Users CANNOT create allergies through UI

**Gap Identified**: ❌ **CRITICAL - Orphaned Display**
- Backend API exists but no user-facing interface
- Users have no way to input allergy data
- Feature will be useless (allergies always empty)

**Evidence Details**:
```
Backend: src/api/patients/allergies.ts:42 - POST /api/patients/:id/allergies
Backend: src/models/Allergy.ts:15 - Allergy.create(data)
UI Component: NOT FOUND
UI Usage: NOT APPLICABLE (no component)
Navigation: NOT APPLICABLE (no form to navigate to)
```

**Required Actions**:
- ✅ MUST ADD: AllergyForm component with input fields
- ✅ MUST ADD: Render form in PatientRegistration screen
- ✅ MUST ADD: Render form in AppointmentIntake screen
- ✅ MUST ADD: Navigation/menu access to registration
- ✅ MUST VERIFY: User permissions allow form access

**Estimated Effort**: +6-8 hours (form component + integration + testing)

---

#### READ (Display/Output)

**Current State**: ⚠️ INCOMPLETE COVERAGE

**User Mentioned**:
- ✅ Patient summary screen (this enhancement)

**Multi-Touchpoint Discovery**:

Searched codebase for patient health screens:
- AppointmentView.tsx - appointment management
- PrescriptionWorkflow.tsx - prescription orders
- MedicalHistory.tsx - patient medical records
- EmergencyContact.tsx - emergency information
- LabOrders.tsx - laboratory test orders
- PatientProfile.tsx - patient information

**Relevance Assessment**:

**Must-have Touchpoints** (Safety-Critical):
1. ❌ PrescriptionWorkflow.tsx
   - **Why critical**: Drug interaction warnings (patient safety)
   - **Current state**: No allergy display found
   - **Priority**: CRITICAL - prescribing without allergy info is dangerous

2. ❌ AppointmentView.tsx
   - **Why critical**: Doctor needs before treatment
   - **Current state**: No allergy display found
   - **Priority**: CRITICAL - treatment planning requires allergy knowledge

3. ❌ EmergencyContact.tsx
   - **Why critical**: Emergency response needs immediate access
   - **Current state**: No allergy display found
   - **Priority**: CRITICAL - life-threatening situations

**Should-have Touchpoints** (High-Value):
4. ❌ MedicalHistory.tsx
   - **Why important**: Comprehensive patient record
   - **Current state**: No allergy display found
   - **Priority**: HIGH - expected in medical history

5. ❌ LabOrders.tsx
   - **Why important**: Avoid contraindicated tests
   - **Current state**: No allergy display found
   - **Priority**: MEDIUM - useful but not always critical

**Nice-to-have Touchpoints**:
6. ❌ PatientProfile.tsx
   - **Why helpful**: Patient self-service view
   - **Current state**: No allergy display found
   - **Priority**: LOW - convenience feature

**Gap Identified**: Critical - Incomplete Touchpoint Coverage
- Enhancement covers 1 of 6 relevant screens
- Missing 3 safety-critical touchpoints
- Missing 2 high-value touchpoints

**Required Actions**:
- ✅ MUST ADD: Display in PrescriptionWorkflow (drug interactions)
- ✅ MUST ADD: Display in AppointmentView (treatment planning)
- ✅ MUST ADD: Display in EmergencyContact (emergency response)
- ✅ SHOULD ADD: Display in MedicalHistory (complete record)
- ✅ SHOULD ADD: Display in LabOrders (test safety)

**Estimated Effort**: +6-10 hours (1-2 hours per screen)

---

#### UPDATE (Edit/Modify)

**Current State**: ❌ NO UPDATE MECHANISM EXISTS

**Evidence**:
- Searched for: EditAllergy, UpdateAllergy components
- Searched for: PUT/PATCH /api/allergies endpoints
- Searched for: Edit buttons, inline editing
- **Result**: No evidence of allergy update capability found

**Gap Identified**: Important - Cannot Correct Errors
- If allergy data is incorrect, no way to fix it
- Users expect ability to update health information
- Doctors may need to correct/clarify allergies

**Required Actions**:
- ✅ SHOULD ADD: Allergy edit in patient profile (self-service)
- ✅ SHOULD ADD: Allergy edit in appointment (doctor corrections)
- ✅ SHOULD ADD: API endpoint PUT /api/allergies/:id

**Estimated Effort**: +3-4 hours

---

#### DELETE (Remove/Archive)

**Current State**: ❌ NO DELETE MECHANISM EXISTS

**Evidence**:
- Searched for: deleteAllergy, removeAllergy functions
- Searched for: DELETE /api/allergies endpoints
- Searched for: Delete/remove UI elements
- **Result**: No evidence of allergy deletion capability found

**Gap Identified**: Important - Cannot Remove Incorrect Data
- If allergy recorded in error, no way to remove
- Should use soft delete (archive) to maintain history
- May have legal/audit trail requirements

**Recommended Actions**:
- ✅ SHOULD ADD: Soft delete capability (archive, not hard delete)
- ✅ SHOULD ADD: Allergy history/audit trail
- ✅ SHOULD ADD: API endpoint DELETE /api/allergies/:id (soft delete)

**Estimated Effort**: +2-3 hours

---

### Overall Data Lifecycle Completeness

**Completeness Score**: 10% (Only 1 of 10 required operations)

| Operation | Status | Priority | Effort |
|-----------|--------|----------|--------|
| CREATE - Registration form | ❌ Missing | Must-have | 2h |
| CREATE - Appointment intake | ❌ Missing | Must-have | 2h |
| CREATE - API endpoint | ❌ Missing | Must-have | 1h |
| READ - Patient summary | ✅ This enhancement | Must-have | - |
| READ - Prescription workflow | ❌ Missing | Must-have | 2h |
| READ - Appointment view | ❌ Missing | Must-have | 1h |
| READ - Emergency contact | ❌ Missing | Must-have | 1h |
| READ - Medical history | ❌ Missing | Should-have | 1h |
| READ - Lab orders | ❌ Missing | Should-have | 1h |
| UPDATE - Edit capability | ❌ Missing | Should-have | 3h |
| DELETE - Archive capability | ❌ Missing | Should-have | 2h |

**Total Identified Gaps**: 10 operations missing

**Total Additional Effort**: 16-19 hours (vs original estimate of 2-3 hours)

---

### Scope Expansion Recommendations

**Option 1: Expand Current Enhancement (Comprehensive)**

**Scope**: Complete allergy lifecycle in one enhancement

**Includes**:
- ✅ All CREATE operations (input forms + API)
- ✅ All must-have READ touchpoints (6 screens)
- ✅ UPDATE capability
- ✅ DELETE capability (soft delete)

**Estimated Total Effort**: 18-22 hours

**Pros**:
- Complete, usable feature
- All workflows covered
- No orphaned operations
- Safety-critical gaps addressed

**Cons**:
- Large scope (10x original estimate)
- Long development time
- Higher risk

---

**Option 2: Split into Phased Enhancements (Recommended)**

**Phase 1: Input & Critical Display** (6-8 hours)
- CREATE: Allergy input forms (registration + appointment)
- CREATE: API endpoints
- READ: Patient summary (original request)
- READ: Prescription workflow (safety-critical)
- READ: Appointment view (safety-critical)

**Phase 2: Extended Display** (3-4 hours)
- READ: Emergency contact (safety-critical)
- READ: Medical history
- READ: Lab orders

**Phase 3: Edit & Archive** (5-6 hours)
- UPDATE: Edit capability
- DELETE: Soft delete/archive
- Audit trail

**Pros**:
- Manageable scope per phase
- Delivers value incrementally
- Phase 1 addresses critical safety gaps
- Flexibility to prioritize

**Cons**:
- Multiple enhancements to track
- Some inconsistency between phases
- Requires coordination

---

**Option 3: Minimal Viable Scope** (Not Recommended)

**Scope**: Original request only (patient summary display)

**Effort**: 2-3 hours

**Critical Issues**:
- ❌ Orphaned display (no input mechanism)
- ❌ Safety gaps (missing from prescription workflow)
- ❌ Feature is essentially useless

**Only acceptable if**:
- This is explicitly a UI mockup/prototype
- Input mechanism exists elsewhere and we're unaware
- This is demo/proof-of-concept only

---

### Recommended Action

**✅ Recommend: Option 2 (Phased Approach)**

**Rationale**:
1. **Safety-critical domain**: Healthcare requires completeness
2. **Orphaned display**: Must include input mechanism
3. **Manageable phases**: 6-8 hour phases are reasonable
4. **Incremental value**: Phase 1 delivers usable feature

**Next Steps**:
1. Confirm phased approach with user
2. Create separate enhancement for Phase 1
3. Update spec to include:
   - Allergy input (registration + appointment)
   - Display in patient summary
   - Display in prescription workflow
   - Display in appointment view
4. Plan Phase 2 & 3 for roadmap

**Updated Effort Estimate**: 6-8 hours (Phase 1 only)

---

*End of Data Entity Lifecycle Analysis*
```

### Best Practices

**Do's**:

✅ **Always check for data entities** - If enhancement mentions displaying/capturing data, run lifecycle analysis

✅ **Search codebase thoroughly** - Don't assume - find actual evidence of CREATE/READ/UPDATE/DELETE

✅ **Consider safety criticality** - Healthcare, finance, legal domains require complete coverage

✅ **Discover ALL relevant touchpoints** - Don't trust user-mentioned locations only

✅ **Recommend scope expansion** - When critical gaps found, present options clearly

✅ **Provide effort estimates** - Help user make informed decisions about scope

**Don'ts**:

❌ **Don't skip lifecycle analysis** - Orphaned operations are common, catch them early

❌ **Don't assume single-context display** - Data entities usually appear in multiple places

❌ **Don't accept orphaned features** - Always flag missing input or missing output

❌ **Don't hide scope impact** - Be transparent about additional effort required

❌ **Don't force large scope** - Offer phased approach as alternative

---

## Gap Analysis Report Structure

### Report Template

```markdown
# Gap Analysis: [Enhancement Name]

**Date**: [timestamp]
**Enhancement Type**: [Additive/Modificative/Refactor-Based]
**Risk Level**: [Low/Medium/High]

## Executive Summary

[2-3 sentences summarizing gaps, type, and impact]

## Current vs Desired State

### Current State
- Feature displays users in table
- Supports selection
- Fixed column order
- No sorting capability

### Desired State
- Add sorting functionality
- Sort by any column
- Multi-column sort support
- Preserve existing features

## Identified Gaps

### 1. Missing: Sorting Functionality
**Type**: Missing Feature
**Complexity**: Moderate
**Files Affected**: UserTable.tsx, useUserData.ts
**Estimated Effort**: 3-4 hours

**Details**:
- No sorting state management
- No column header interactions
- No sort algorithm implementation
- Need to integrate with data fetching

### 2. Missing: Sort UI Indicators
**Type**: Missing Feature
**Complexity**: Simple
**Files Affected**: TableHeader.tsx
**Estimated Effort**: 1 hour

**Details**:
- No sort direction indicators (arrows)
- No active column highlighting
- No multi-sort visual feedback

## Enhancement Classification

**Type**: Additive

**Justification**:
- ✅ Adds new feature (sorting)
- ❌ No existing behavior changes (table still displays, selection works)
- ⚠️ Minor API changes (optional `onSort` prop)
- ❌ No structure changes
- **Risk**: Low
- **Compatibility**: Strict (100% backward compatible)

## Impact Assessment

### File Impact
**Level**: Medium (3 files)
- UserTable.tsx (primary, 200 lines modified)
- useUserData.ts (data hook, 50 lines modified)
- TableHeader.tsx (UI, 30 lines modified)

### Test Impact
**Targeted Regression**: 30% of test suite
- **Tier 1 (Direct)**: 8 tests (UserTable, useUserData, TableHeader)
- **Tier 2 (Integration)**: 12 tests (user management flows)
- **Tier 3 (Domain)**: Not needed (small scope)
- **New Tests**: 6 tests for sorting

### Dependency Impact
**Consumers**: 5 components use UserTable
- Impact: Low (optional feature, backward compatible)
- No changes needed in consumers
- Opt-in via props

### Risk Factors
- **Files**: 3 (medium)
- **Tests**: 26 (medium)
- **Dependencies**: 5 (low)
- **Breaking**: None (low)
- **Complexity**: Moderate (medium)
- **Risk Score**: 8/15 (Low Risk)

## User Journey Impact Assessment

### Feature Reachability
**Current Access Paths**:
1. Dashboard → Users → User table component (direct render)

**Changed Paths**: None (internal component enhancement)

**New Access Paths**: None (enhancement is internal to existing component)

**Dead Ends**: None identified

**Discoverability Score**:
- Before: 7/10 (Medium-High - table visible but no sort affordance)
- After: 9/10 (High - column headers show sort affordance on hover)
- Improvement: +2 points

### Multi-Persona Analysis

#### Admin User
- **Current workflow**: View users, manually track sort needs, re-filter often
- **Enhanced workflow**: View users, click column header to sort
- **Impact**: ✅ POSITIVE - Saves time, easier data analysis
- **Value**: High (frequent table usage, needs data analysis)
- **Learning curve**: Minimal (hover shows sort arrows)
- **Workarounds**: None needed

#### Regular User
- **Current workflow**: View team users only (read-only access)
- **Enhanced workflow**: View team users with sorting capability
- **Impact**: ✅ POSITIVE - Easier to find team members
- **Value**: Medium (occasional usage, helpful but not critical)
- **Learning curve**: Minimal (intuitive column header interaction)
- **Workarounds**: None needed

### Existing Flow Integration

**Primary Workflow**: User Management
```
Current: View Users → Select User → Edit
Enhanced: View Users → [Optional: Sort] → Select User → Edit
                          ↑
                  Enhances but doesn't disrupt
```

**Integration Assessment**: ✅ Clean integration
- Sorting is optional, doesn't block existing workflows
- All downstream actions preserved
- No new required steps

### Navigation Pattern Consistency

**App-Wide Patterns**:
- ✅ Column header interactions for table features
- ✅ Visual affordances on hover (arrows for sortability)
- ✅ Click-to-action pattern for data operations

**Enhancement Alignment**:
- ✅ Column headers show sort arrows (follows table interaction pattern)
- ✅ Click header to sort (common pattern)
- ✅ Visual feedback on hover (consistent with app)

**Consistency Score**: 10/10 (Perfect alignment with existing table patterns)

### Discoverability Assessment

**Before**: 7/10 (Medium-High)
- Table visible but no sort capability

**After**: 9/10 (High)
- Hover reveals sort arrows
- Clear affordance
- Intuitive interaction

**Improvement**: +2 points

### Overall User Journey Impact

**Impact Level**: Low (Minor enhancement, high consistency)

**Risk to User Experience**: Low
- No workflow disruption
- Preserves all existing patterns
- Adds intuitive capability

**Recommendations**:
1. Add tooltip on first hover: "Click to sort"
2. Maintain column header visual consistency
3. Ensure sort state is visible (arrow direction)

## Compatibility Requirements

**Level**: Strict (100% backward compatible)

**Requirements**:
- Default behavior unchanged (no sorting if not configured)
- All existing tests pass without modification
- Optional `onSort` and `sortable` props
- No breaking API changes
- Existing usage patterns work unchanged

**Verification Plan**:
- Default behavior test (table works without sort props)
- API compatibility test (existing props still work)
- Usage patterns test (all 5 consumers work unchanged)
- No console warnings

## Estimated Effort

**Total**: 4-5 hours

**Breakdown**:
- Phase 2 (Spec): 30 min
- Phase 3 (Plan): 30 min
- Phase 4 (Implementation): 3-4 hours
- Phase 5 (Verification): 45 min

## Recommendations

1. **Use optional props** - Don't force sorting on all tables
2. **Test with real data** - Ensure performance with large datasets
3. **Preserve existing tests** - All should pass without changes
4. **Add targeted tests** - 6 new tests for sorting scenarios
5. **Document in README** - Add usage examples

## Next Steps

1. ✅ Gap analysis complete
2. → Proceed to Phase 2: Create enhanced specification
3. → Phase 3: Create implementation plan with targeted testing
4. → Phase 4: Implement with backward compatibility
5. → Phase 5: Verify compatibility + run targeted regression

---

**Gap analysis complete. Ready for specification creation.**
```

---

## Failure Handling

### Scenario 1: Cannot Classify Enhancement Type

**Causes**:
- Description ambiguous
- Mixed characteristics
- Unclear scope

**Recovery**:
1. Use AskUserQuestion to ask clarifying questions:
   - "Are you adding new features or changing existing ones?"
   - "Will existing behavior change?"
   - "Is this a structural refactoring?"
2. Present characteristics for user to confirm
3. Default to Modificative (safer, higher rigor)

### Scenario 2: Risk Assessment Unclear

**Causes**:
- Limited existing analysis
- Uncertain dependency map
- Unknown test coverage

**Recovery**:
1. Default to conservative estimates (higher risk)
2. Flag uncertainties explicitly
3. Recommend discovery phase
4. Plan for iterative refinement

### Scenario 3: Compatibility Requirements Conflict

**Causes**:
- User expects backward compatibility but changes are breaking
- Classification suggests strict but modifications are extensive

**Recovery**:
1. Explain conflict clearly
2. Present options:
   - Split into multiple enhancements
   - Accept breaking changes with migration
   - Redesign to preserve compatibility
3. Get user decision
4. Update classification/requirements accordingly

### Scenario 4: Scope Creep Detected

**Causes**:
- Description mentions multiple unrelated features
- "And also..." patterns

**Recovery**:
1. Identify distinct enhancements
2. Suggest splitting into separate tasks
3. If user insists on combined: Classify as Modificative (higher risk)
4. Warn about increased complexity

---

## Best Practices

### Do's

✅ **Compare systematically** - Check each desired capability against existing
✅ **Classify conservatively** - When unsure, choose higher risk category
✅ **Document gaps explicitly** - Provide evidence and reasoning
✅ **Assess impact thoroughly** - Consider files, tests, dependencies, API
✅ **Set compatibility early** - Don't discover breaking changes late

### Don'ts

❌ **Don't assume additive** - Most enhancements have some modifications
❌ **Don't underestimate impact** - Ripple effects are common
❌ **Don't ignore tests** - Test changes often indicate risk
❌ **Don't skip classification** - It drives verification approach
❌ **Don't hide breaking changes** - Better to know early

---

## Quick Reference

### Enhancement Type Decision Tree

```
New features added?
├─ Yes → Existing behavior changes?
│         ├─ No → ADDITIVE (Low risk, Strict compat)
│         └─ Yes → MODIFICATIVE (Medium risk, Moderate compat)
└─ No → Structure changes?
          ├─ Yes → REFACTOR-BASED (Medium risk, Strict compat)
          └─ No → Re-evaluate if enhancement needed
```

### Risk Scoring Quick Reference

| Risk Score | Level | Action |
|------------|-------|--------|
| 5-8 | Low | Standard workflow |
| 9-11 | Medium | Extra verification, more tests |
| 12-15 | High | Extensive testing, phased rollout |

### Compatibility Quick Reference

| Type | Compatibility | Breaking Allowed? |
|------|---------------|-------------------|
| Additive | Strict | ❌ No |
| Modificative | Moderate | ✅ With migration |
| Refactor-Based | Strict | ❌ No |

---

**End of gap-analysis.md reference**
