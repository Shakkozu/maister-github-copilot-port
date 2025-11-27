# User-Centric Development

How the plugin ensures features are discoverable, accessible, and complete from a user perspective.

## Overview

User-centric development means prioritizing usability and user experience throughout the development process. The plugin ensures features aren't just technically implemented, but actually usable by real users.

**Key Principle**: A feature isn't complete until users can discover, access, and use it.

## Core Components

### 1. User Journey Analysis

**Purpose**: Understand how users will interact with features

**Analyzed By**: Gap analyzer, UI mockup generator

**Questions Answered**:
- How do users currently access related features?
- How will users discover this new feature?
- What's the user flow from entry point to completion?
- Does this fit naturally into existing workflows?

**Example**:
```markdown
## User Journey: Add Sort to User Table

### Current Journey
User → Dashboard → Users List → View 50 users

### New Journey
User → Dashboard → Users List → Click Sort Dropdown → Select Name/Email/Date → Sorted View

### Discoverability: 9/10
- Sort dropdown next to existing table
- Visible without scrolling
- Follows common UI patterns
- No training needed
```

---

### 2. Multi-Persona Analysis

**Purpose**: Understand impact across different user types

**Personas**:
- End users (regular application users)
- Admins (administrative users)
- Power users (advanced features)
- Developers (API consumers)
- Support staff (helping end users)

**Analysis**:
```markdown
## Persona Impact: Add Export to CSV

### End Users
**Value**: 8/10 - Need to export data for reports
**Learning Curve**: 2/10 - Simple button click
**Workflow Impact**: Minimal - Adds capability, doesn't change existing

### Admins
**Value**: 10/10 - Export all users for audits
**Learning Curve**: 1/10 - Same as end users
**Workflow Impact**: High - New audit capability

### Power Users
**Value**: 7/10 - Prefer API access
**Learning Curve**: 1/10 - Obvious UI
**Workflow Impact**: Minimal - Won't use often
```

---

### 3. Discoverability Scoring (1-10)

**Purpose**: Quantify how easily users will find the feature

**Scoring Criteria**:

| Score | Meaning | Characteristics |
|-------|---------|----------------|
| 1-3 | **Hidden** | Buried in menus, requires documentation |
| 4-6 | **Findable** | Visible with some exploration |
| 7-8 | **Obvious** | Clear, follows patterns |
| 9-10 | **Impossible to Miss** | Prominent, intuitive placement |

**Factors**:
- Visual prominence
- Follows UI patterns
- Contextual placement
- No training needed

**Example**:
```markdown
## Discoverability Analysis

Feature: Export to CSV

**Placement**: Button next to table header
**Visibility**: Always visible (no scrolling)
**Pattern**: Standard export icon (universally recognized)
**Context**: Exactly where users would look for export

**Score**: 9/10 (Obvious, follows patterns)
```

---

### 4. Data Entity Lifecycle Analysis

**Purpose**: Ensure complete CRUD (Create, Read, Update, Delete) lifecycle

**Three-Layer Verification**:

#### Layer 1: Backend Capability
**Question**: Does the API/backend support the operation?

**Check**:
- API endpoint exists
- Database schema supports it
- Business logic implemented

#### Layer 2: UI Component
**Question**: Does a UI component exist for this operation?

**Check**:
- Component renders data
- Component has input controls
- Component handles interactions

#### Layer 3: User Accessibility
**Question**: Can users actually access and use it?

**Check**:
- Component rendered on accessible page
- Page reachable from navigation
- Appropriate permissions
- Discoverable (users can find it)

---

### 5. Orphaned Feature Detection

**Purpose**: Find features that look complete but are unusable

#### Orphaned Display (Display Without Input)

**Problem**: Users can see data but have no way to create/edit it

**Example**:
```markdown
❌ Orphaned Display Detected

User Story: "Display allergy information on patient summary"

Backend:
✓ GET /api/patients/{id}/allergies exists
✓ Database: patients_allergies table exists

Frontend:
✓ AllergyDisplay component exists
✓ Component renders on PatientSummary page

BUT:
❌ No way to INPUT allergies
❌ No "Add Allergy" button
❌ No allergy input form

Result: Feature unusable (users can't create allergies to display)

Recommendation:
Phase 1: Add allergy input mechanism
Phase 2: Display allergies (as originally requested)
```

#### Orphaned Input (Input Without Display)

**Problem**: Users can input data but never see it used

**Example**:
```markdown
❌ Orphaned Input Detected

Feature: "Add allergy input form"

Backend:
✓ POST /api/patients/{id}/allergies exists

Frontend:
✓ AllergyInputForm component exists
✓ Form accessible from patient profile

BUT:
❌ Allergies not displayed anywhere
❌ No confirmation after save
❌ User has no idea if it worked

Result: Feature frustrating (data goes into black hole)

Recommendation:
Add allergy display to patient summary after save
```

---

## Real-World Example

### Scenario: Healthcare Application

**User Request**: "Display patient allergy information on the summary page"

#### Without User-Centric Analysis

**What gets implemented**:
```
✓ Backend: GET /api/patients/{id}/allergies
✓ Frontend: AllergyDisplay component
✓ UI: Component renders on summary page
```

**Result**: Feature looks complete technically

**Problem**: 
- ❌ No way for users to INPUT allergies
- ❌ Feature is 100% useless (no data to display)

---

#### With User-Centric Analysis (Data Lifecycle)

**Layer 1: Backend Capability**
- ✅ GET /api/patients/{id}/allergies (read)
- ❌ POST /api/patients/{id}/allergies (create) - MISSING
- ❌ PUT /api/patients/{id}/allergies/{id} (update) - MISSING
- ❌ DELETE /api/patients/{id}/allergies/{id} (delete) - MISSING

**Layer 2: UI Component**
- ✅ AllergyDisplay (read)
- ❌ AllergyInputForm (create) - MISSING
- ❌ AllergyEditForm (update) - MISSING
- ❌ Delete button (delete) - MISSING

**Layer 3: User Accessibility**
- ❌ Orphaned display detected
- ❌ No input mechanism
- ❌ Incomplete lifecycle

**Gap Analysis Output**:
```markdown
⚠️ INCOMPLETE FEATURE DETECTED

Current Scope: Display allergies (read-only)

Missing Critical Functionality:
1. Input mechanism (how do allergies get created?)
2. Edit capability (how to fix mistakes?)
3. Delete capability (how to remove invalid entries?)

Additional Touchpoints Needed:
1. Prescription workflow (check allergies before prescribing)
2. Medication administration (verify no allergic reactions)
3. Emergency summary (quick allergy overview)
4. Appointment scheduling (pre-appointment allergy review)
5. Discharge summary (allergy documentation)

Recommended Phased Approach:
Phase 1 (Critical): 
  - Add allergy input form
  - Display in 3 critical touchpoints (prescription, emergency, summary)
  
Phase 2 (Important):
  - Add edit capability
  - Add to appointment and discharge workflows
  
Phase 3 (Nice-to-have):
  - Delete capability
  - Allergy history tracking
  - Allergy reaction severity
```

**Result**: Complete, safe, usable feature

---

## Benefits

### 1. Prevents Unusable Features

**Without analysis**:
- Technically complete ≠ Usable
- Users frustrated
- Wasted development effort

**With analysis**:
- Features truly complete
- Users productive
- Development effort well-spent

---

### 2. Ensures Safety (Healthcare/Finance)

**Safety-Critical Domains**: Healthcare, finance, legal

**Risk**: Incomplete features can cause harm

**Example**:
```
Missing allergy input → Can't warn about allergies
→ Wrong medication prescribed
→ Patient harm
```

**Protection**: Data lifecycle analysis catches missing critical touchpoints

---

### 3. Improves User Experience

**Without analysis**:
- Features hidden
- Confusing workflows
- Poor discoverability

**With analysis**:
- Features discoverable (8-10/10)
- Natural workflows
- Intuitive UI

---

### 4. Reduces Rework

**Without analysis**:
- Build feature
- Users can't find it
- Rebuild with better UX

**With analysis**:
- Build once correctly
- Users find and use immediately
- No rework needed

---

## Implementation in Workflows

### Enhancement Workflow

**Phase 1: Gap Analysis**

Invokes gap-analyzer agent:
1. User journey impact assessment
2. Multi-persona analysis
3. Data lifecycle completeness
4. Orphaned feature detection
5. Discoverability scoring

**Output**: `analysis/gap-analysis.md`, `analysis/user-journey-impact.md`

---

### Feature Workflow (Optional)

**Phase 1.5: UI Mockup Generation**

For UI-heavy features, invokes ui-mockup-generator:
1. Analyzes existing UI patterns
2. Creates ASCII mockups showing integration
3. Identifies reusable components
4. Ensures navigation consistency

**Output**: `analysis/ui-mockups.md`

---

## Best Practices

### 1. Think Like a User

Don't think: "Does the API exist?"
Think: "Can users actually do this?"

### 2. Verify All Three Layers

Backend + UI + Accessibility = Complete

### 3. Consider All Personas

Feature might be great for admins but confusing for end users

### 4. Check Multiple Touchpoints

Data often needs to appear in multiple places (not just one)

### 5. Score Discoverability

Aim for 8-10/10 (obvious, follows patterns)

---

## Related Resources

- [Enhancement Workflow](../guides/enhancement-workflow.md) - Gap analysis in practice
- [Gap Analyzer Agent](../../agents/gap-analyzer.md) - Technical implementation
- [UI Mockup Generator](../../agents/ui-mockup-generator.md) - Visual integration planning

---

**User-centric development ensures features are truly complete and usable**
