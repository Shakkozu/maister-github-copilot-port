# Screenshot Strategies Reference

Best practices for capturing, composing, organizing, and maintaining documentation screenshots.

## Purpose

Screenshots transform abstract instructions into concrete visual guides. Well-captured screenshots help users recognize UI elements, verify they're following steps correctly, and troubleshoot issues. This reference provides strategies for creating professional, maintainable documentation screenshots.

---

## What to Screenshot

### Essential Captures

**1. Initial State** (before action):
- Shows starting point for user
- Establishes context
- Helps users confirm they're in right place

**Example**: Before clicking "Create Account", show the landing page

**2. Action Being Performed** (during):
- Shows UI element to interact with
- Highlights what to click/type
- Demonstrates proper interaction

**Example**: Cursor hovering over "Create Account" button, or form with data being entered

**3. Result State** (after action):
- Shows expected outcome
- Confirms success
- Validates user followed correctly

**Example**: "Account created successfully" confirmation message

**4. Success Indicators**:
- Confirmation messages
- Status changes (e.g., "Verified" badge appears)
- UI updates (e.g., new item appears in list)

**5. Error States**:
- Validation errors (e.g., "Email required")
- Warning messages
- Failed operations

**6. Navigation Elements**:
- Menus (how to find features)
- Breadcrumbs (current location)
- Tabs/sections (where things are)

### Strategic Selection

**Capture Frequency**:
```
Simple tasks (2-3 steps):    Screenshot every step
Medium tasks (4-8 steps):    Screenshot key steps (initial, mid, final)
Complex tasks (9+ steps):    Screenshot phase transitions + critical steps
```

**When NOT to Screenshot**:
- Repetitive actions (screenshot once, describe repetition in text)
- Obvious next steps (e.g., clicking "Next" button multiple times)
- Sensitive data entry (describe in text, don't show actual credentials)

---

## Screenshot Composition

### Framing and Focus

**Viewport Screenshots** (default choice):
- Captures visible browser area
- Includes navigation/context
- Most common for UI documentation

**When to use**:
```javascript
// Playwright example
await page.screenshot({
  path: 'screenshots/dashboard-overview.png'
});
```

**Element Screenshots** (focused captures):
- Captures specific component
- Removes distractions
- Highlights particular UI element

**When to use**:
```javascript
// Playwright example - capture specific element
const element = await page.locator('[data-testid="user-profile"]');
await element.screenshot({
  path: 'screenshots/user-profile-card.png'
});
```

**Full Page Screenshots** (comprehensive view):
- Captures entire scrollable page
- Shows complete layout
- Useful for overviews

**When to use**:
```javascript
// Playwright example
await page.screenshot({
  path: 'screenshots/full-settings-page.png',
  fullPage: true
});
```

### Context and Clarity

**Include Enough Context**:
- Show navigation (where user is)
- Include headings (what page/section)
- Capture breadcrumbs if available

❌ **Bad** (no context):
```
[Screenshot showing only a button with no surrounding UI]
```

✅ **Good** (includes context):
```
[Screenshot showing page header, navigation, and the button with surrounding UI elements]
```

**Highlight Important Elements**:

**Annotation Strategies** (post-processing):
- Red box/circle: Primary action element
- Arrow: Direction or sequence
- Number badges: Step sequence
- Highlighting: Important text/fields

**Note**: Annotations done post-capture, not during Playwright screenshot

**Clean Visual Appearance**:
- Use consistent browser window size
- Same theme/appearance throughout
- Clean up test data/debug elements
- Remove distracting browser extensions

---

## Naming Conventions

### Descriptive Naming

**Format Pattern**:
```
[sequence]-[action-or-feature]-[state].png

Examples:
01-login-page.png
02-enter-credentials.png
03-dashboard-success.png
04-settings-navigation.png
05-profile-edit-form.png
06-profile-save-confirmation.png
```

**Components**:
- **Sequence**: `01`, `02`, `03` (for step-by-step guides)
- **Action/Feature**: `login`, `create-account`, `edit-profile`
- **State**: `initial`, `filled`, `success`, `error`, `loading`

### Naming Strategies

**Sequential Numbering** (for procedures):
```
01-initial-state.png
02-click-button.png
03-fill-form.png
04-success-message.png
```

**Benefits**: Clear order, easy to follow

**Feature Prefixing** (for related screenshots):
```
profile-overview.png
profile-edit-form.png
profile-photo-upload.png
profile-success.png
```

**Benefits**: Groups related images, easier to maintain

**State Suffixing** (for variations):
```
login-form-empty.png
login-form-filled.png
login-form-error.png
login-form-success.png
```

**Benefits**: Shows different states of same UI

### File Naming Best Practices

**Use Lowercase**: `login-page.png` not `Login-Page.png`

**Use Hyphens**: `create-account.png` not `create_account.png` or `createAccount.png`

**Be Descriptive**: `settings-security-tab.png` not `img3.png`

**Avoid Special Characters**: No spaces, punctuation (except hyphens)

**Version Control** (if needed):
```
dashboard-v1.png
dashboard-v2.png
dashboard-2024-11-17.png
```

---

## Playwright Screenshot Strategies

### Basic Screenshot Capture

**Full Browser Viewport**:
```javascript
// Captures visible browser area
await page.screenshot({
  path: 'screenshots/page-view.png'
});
```

**Full Scrollable Page**:
```javascript
// Captures entire page including scrolled content
await page.screenshot({
  path: 'screenshots/full-page.png',
  fullPage: true
});
```

**Specific Element**:
```javascript
// Captures only the element
const element = await page.locator('.user-card');
await element.screenshot({
  path: 'screenshots/user-card.png'
});
```

### Timing and Stability

**Wait for Network Idle** (page fully loaded):
```javascript
await page.goto('https://example.com/dashboard');
await page.waitForLoadState('networkidle');
await page.screenshot({ path: 'screenshots/dashboard.png' });
```

**Wait for Animations to Complete**:
```javascript
// Wait for element to be visible and stable
await page.locator('.modal').waitFor({ state: 'visible' });
await page.waitForTimeout(500); // Let animations finish
await page.screenshot({ path: 'screenshots/modal.png' });
```

**Wait for Specific Element**:
```javascript
// Wait for success message before screenshot
await page.locator('.success-message').waitFor({ state: 'visible' });
await page.screenshot({ path: 'screenshots/success.png' });
```

### Quality and Format

**Image Format**:
```javascript
// PNG (default, best for UI screenshots)
await page.screenshot({
  path: 'screenshots/page.png',
  type: 'png'
});

// JPEG (smaller file size, acceptable for photos)
await page.screenshot({
  path: 'screenshots/page.jpg',
  type: 'jpeg',
  quality: 90
});
```

**Recommendation**: Use PNG for UI screenshots (sharp text, no compression artifacts)

**Browser Window Size** (consistent sizing):
```javascript
// Set viewport before screenshots
await page.setViewportSize({ width: 1280, height: 720 });
await page.screenshot({ path: 'screenshots/page.png' });
```

**Recommended sizes**:
- Desktop docs: 1280×720 or 1440×900
- Mobile docs: 375×667 (iPhone) or 412×915 (Android)

---

## Screenshot Organization

### Directory Structure

**Simple Documentation** (single guide):
```
documentation/
├── user-guide.md
└── screenshots/
    ├── 01-login-page.png
    ├── 02-dashboard.png
    └── 03-settings.png
```

**Multiple Guides** (organized by feature):
```
documentation/
├── getting-started.md
├── user-management.md
├── settings-guide.md
└── screenshots/
    ├── getting-started/
    │   ├── 01-signup.png
    │   └── 02-first-login.png
    ├── user-management/
    │   ├── 01-user-list.png
    │   └── 02-add-user.png
    └── settings/
        ├── 01-settings-menu.png
        └── 02-security-tab.png
```

**Benefits**: Clear organization, easy to find images, maintainable

### Referencing in Markdown

**Relative Path** (standard approach):
```markdown
![Login page](screenshots/01-login-page.png)
```

**With Subdirectories**:
```markdown
![User list](screenshots/user-management/01-user-list.png)
```

**With Alt Text** (for accessibility):
```markdown
![Screenshot showing the login page with email and password fields](screenshots/01-login-page.png)
```

---

## Accessibility Considerations

### Alt Text

**Purpose**: Describes screenshot for screen readers and when images fail to load

**Writing Good Alt Text**:

❌ **Bad** (generic, not descriptive):
```markdown
![Screenshot](screenshots/page.png)
![Image](screenshots/form.png)
```

✅ **Good** (descriptive, specific):
```markdown
![Login page with email and password input fields and a blue Sign In button](screenshots/login.png)

![Settings page showing Security tab with Two-Factor Authentication toggle enabled](screenshots/security-settings.png)
```

**Alt Text Guidelines**:
- Describe what's visible and relevant
- Include UI element names ("Sign In button")
- Mention state if important ("toggle enabled")
- Keep under 125 characters (screen reader limit)
- Don't start with "Image of" or "Screenshot of" (redundant)

### Text Descriptions

**Don't Rely Solely on Screenshots**:
- Always describe actions in text
- Screenshots supplement, don't replace instructions
- Users with visual impairments need text descriptions
- Screenshots may not load on slow connections

❌ **Bad** (relies only on image):
```markdown
See the image below:
![Login page](screenshots/login.png)
```

✅ **Good** (text + image):
```markdown
Enter your email address and password, then click the blue **Sign In** button at the bottom of the form.

![Login page with email and password fields and Sign In button](screenshots/login.png)
```

### Visual Clarity

**High Contrast**: Ensure text readable, elements distinguishable

**Sufficient Size**: Large enough to see details (minimum 800px width for desktop UI)

**Color Independence**: Don't rely solely on color (e.g., "click the red button" → "click the red Delete button at the bottom right")

---

## Screenshot Maintenance

### Update Strategy

**When to Update**:
- UI redesign or visual changes
- Feature modifications
- Brand/color scheme updates
- Layout restructuring

**Track Screenshot Age**:
```markdown
<!-- In documentation metadata -->
screenshots_captured: 2024-11-17
app_version: 2.5.0
```

**Version Screenshots** (if supporting multiple versions):
```
screenshots/
├── v2.4/
│   └── login-old.png
└── v2.5/
    └── login-new.png
```

### Automated Screenshot Updates

**Strategy**: Re-run Playwright tests to regenerate all screenshots

**Benefits**:
- Consistency (same browser, size, state)
- Fast updates (automated capture)
- Reproducibility (same script = same screenshots)

**Implementation Pattern**:
```javascript
// screenshot-generator.js
const screenshots = [
  { url: '/login', filename: '01-login-page.png' },
  { url: '/dashboard', filename: '02-dashboard.png' },
  { url: '/settings', filename: '03-settings.png' }
];

for (const shot of screenshots) {
  await page.goto(shot.url);
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: `screenshots/${shot.filename}` });
}
```

### Documentation in Screenshots

**Screenshot Metadata File** (optional):
```yaml
# screenshots/metadata.yml
screenshots:
  - filename: 01-login-page.png
    captured: 2024-11-17
    page: /login
    description: Login page with email and password fields
    app_version: 2.5.0
  - filename: 02-dashboard.png
    captured: 2024-11-17
    page: /dashboard
    description: Main dashboard after successful login
    app_version: 2.5.0
```

**Benefits**: Track when to update, what each screenshot shows

---

## Best Practices Summary

### Capture Checklist

**Before Capturing**:
- [ ] Set consistent browser window size (e.g., 1280×720)
- [ ] Clean up test data (use realistic examples)
- [ ] Remove debug elements/extensions
- [ ] Ensure page fully loaded (networkidle)
- [ ] Wait for animations to complete

**During Capture**:
- [ ] Include sufficient context (navigation, headings)
- [ ] Frame important elements clearly
- [ ] Capture at right moment (action/result visible)
- [ ] Use appropriate screenshot type (viewport/element/full-page)

**After Capture**:
- [ ] Name descriptively (sequence-action-state.png)
- [ ] Store in organized directory
- [ ] Add descriptive alt text
- [ ] Reference in documentation with text description
- [ ] Verify image quality and clarity

### Quality Standards

**Image Quality**:
- Format: PNG (for UI screenshots)
- Size: 800-1440px width
- Clarity: Sharp text, no blur
- Loading: Optimize file size (<500KB per screenshot)

**Consistency**:
- Same browser window size throughout
- Same theme/appearance
- Same naming convention
- Same directory structure

**Accessibility**:
- Descriptive alt text (under 125 characters)
- Text description in documentation
- High contrast and readability
- Color-independent instructions

### Common Pitfalls to Avoid

❌ **Don't**:
- Capture with debug panels/extensions visible
- Use placeholder data (foo@bar.com)
- Screenshot without context (cropped too tight)
- Rely only on screenshots (no text description)
- Mix window sizes (inconsistent appearance)
- Use vague names (img1.png, screenshot.png)
- Capture mid-animation or while loading

✅ **Do**:
- Clean UI before capturing
- Use realistic professional data
- Include navigation and context
- Supplement with text descriptions
- Use consistent window size
- Use descriptive naming
- Wait for stability before capture

---

## Playwright Screenshot Patterns

### Pattern 1: Sequential Step Capture

```javascript
// Capture each step of a workflow
async function captureUserRegistrationSteps(page) {
  // Step 1: Initial page
  await page.goto('/register');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: 'screenshots/01-register-initial.png' });

  // Step 2: Form filled
  await page.fill('[name="email"]', 'sarah.johnson@company.com');
  await page.fill('[name="password"]', 'SecureP@ss123');
  await page.screenshot({ path: 'screenshots/02-register-filled.png' });

  // Step 3: Success state
  await page.click('button[type="submit"]');
  await page.waitForSelector('.success-message');
  await page.screenshot({ path: 'screenshots/03-register-success.png' });
}
```

### Pattern 2: Error State Capture

```javascript
// Capture error states for troubleshooting docs
async function captureErrorStates(page) {
  await page.goto('/login');

  // Empty form submission (validation error)
  await page.click('button[type="submit"]');
  await page.waitForSelector('.error-message');
  await page.screenshot({ path: 'screenshots/login-error-empty.png' });

  // Invalid credentials error
  await page.fill('[name="email"]', 'invalid@example.com');
  await page.fill('[name="password"]', 'wrong');
  await page.click('button[type="submit"]');
  await page.waitForSelector('.auth-error');
  await page.screenshot({ path: 'screenshots/login-error-invalid.png' });
}
```

### Pattern 3: Feature Comparison

```javascript
// Capture before/after states
async function captureFeatureStates(page) {
  // Before enabling feature
  await page.goto('/settings/security');
  await page.screenshot({ path: 'screenshots/2fa-disabled.png' });

  // After enabling feature
  await page.click('[data-testid="enable-2fa"]');
  await page.waitForSelector('.2fa-enabled');
  await page.screenshot({ path: 'screenshots/2fa-enabled.png' });
}
```

---

These screenshot strategies ensure documentation visuals are professional, consistent, accessible, and maintainable. Combine with writing guidelines for complete, user-focused documentation.
