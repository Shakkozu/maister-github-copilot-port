# Writing Guidelines Reference

Writing style, tone, and clarity guidelines for creating user-focused documentation.

## Purpose

Effective documentation bridges the gap between technical implementation and user understanding. These guidelines ensure documentation is accessible, clear, and helpful for target audiences ranging from non-technical end users to technical developers.

---

## Core Writing Principles

### 1. Know Your Audience

**Audience Types**:
- **End Users**: Non-technical, need task-focused help
- **Administrators**: Semi-technical, need configuration guidance
- **Developers**: Technical, need API details and integration guides
- **Power Users**: Advanced users, need optimization tips

**Adjust Complexity**:
```
End Users:        Simple language, step-by-step, screenshots
Administrators:   Moderate technical terms, configuration focus
Developers:       Technical precision, code examples, API details
Power Users:      Advanced features, shortcuts, best practices
```

### 2. User-First Perspective

**Use Second Person** ("you" not "the user"):
- ✅ Good: "Click the Save button to store your changes"
- ❌ Bad: "The user should click the Save button to store their changes"

**Focus on User Goals** (not system features):
- ✅ Good: "Create an account to save your preferences"
- ❌ Bad: "The system provides account creation functionality"

**Explain Why** (not just how):
- ✅ Good: "Enable two-factor authentication to protect your account from unauthorized access"
- ❌ Bad: "Enable two-factor authentication in Settings"

---

## Writing Style

### Tone Guidelines

**Friendly and Encouraging**:
- Be welcoming and supportive
- Use encouraging language ("Great!", "You're all set!")
- Avoid condescending tone ("simply", "just", "obviously")

**Examples**:
- ✅ Good: "Let's get your account set up. Follow these steps:"
- ❌ Bad: "The account setup procedure requires the following actions:"

**Clear and Confident**:
- Be direct and assertive
- Avoid hedging ("might", "perhaps", "possibly")
- Use definite language

**Examples**:
- ✅ Good: "This will delete your account permanently"
- ❌ Bad: "This might possibly delete your account"

**Helpful and Patient**:
- Anticipate user questions
- Provide context and explanations
- Include troubleshooting tips

**Examples**:
- ✅ Good: "If you don't see the button, scroll down to the bottom of the page"
- ❌ Bad: "Click the button"

### Voice Guidelines

**Active Voice** (subject performs action):
- ✅ Active: "Click the button to save"
- ❌ Passive: "The button should be clicked to save"
- ❌ Passive: "Changes are saved by clicking the button"

**Present Tense** (describe current actions):
- ✅ Present: "The system validates your input"
- ❌ Past: "The system validated your input"
- ❌ Future: "The system will validate your input"

**Imperative Mood** (give direct instructions):
- ✅ Imperative: "Enter your email address"
- ❌ Declarative: "You should enter your email address"
- ❌ Interrogative: "Would you like to enter your email address?"

---

## Language and Clarity

### Simplicity

**Use Simple Words**:
```
Instead of:        Use:
utilize            use
commence           start
terminate          end
facilitate         help
endeavor           try
subsequently       then
```

**Avoid Jargon** (or explain when necessary):
- ✅ Good: "Two-factor authentication (2FA) adds an extra security step by requiring a code from your phone"
- ❌ Bad: "Enable 2FA for enhanced auth security via TOTP"

**Short Sentences** (15-20 words maximum):
- ✅ Good: "Click Save to store your changes. You can edit them later."
- ❌ Bad: "By clicking the Save button, you will store your changes to the database, and you can edit them at a later time by navigating back to this page."

### Precision

**Be Specific**:
- ✅ Good: "Enter a password with at least 8 characters, including one number and one symbol"
- ❌ Bad: "Enter a strong password"

**Use Concrete Examples**:
- ✅ Good: "For example, 'MyP@ssw0rd' meets the requirements"
- ❌ Bad: "Use a password that meets the requirements"

**Avoid Ambiguity**:
- ✅ Good: "Click the blue Save button at the bottom right"
- ❌ Bad: "Click the button" (Which button? Where?)

### Consistency

**Consistent Terminology**:
- Don't mix: "delete" / "remove" / "erase"
- Pick one term and use throughout

**Consistent Formatting**:
- UI elements: **Bold** (e.g., "Click **Save**")
- Code/commands: `Monospace` (e.g., "Run `npm install`")
- Keyboard keys: <kbd>Ctrl</kbd>+<kbd>C</kbd>
- File paths: `code/style` (e.g., "`/home/user/documents`")

---

## Structure Guidelines

### Document Organization

**Logical Flow**:
1. Overview (what is this?)
2. Prerequisites (what do I need?)
3. Steps (how do I do it?)
4. Verification (how do I know it worked?)
5. Next steps (what's next?)
6. Troubleshooting (what if it fails?)

**Progressive Disclosure**:
- Start with basics
- Add advanced details later
- Use expandable sections for optional info

### Headings

**Descriptive Headings** (clear, specific):
- ✅ Good: "How to Reset Your Password"
- ❌ Bad: "Password"

**Hierarchy**:
```markdown
# Main Title (H1) - One per document
## Major Section (H2) - Main topics
### Subsection (H3) - Subtopics
#### Detail (H4) - Fine details (use sparingly)
```

**Parallel Structure**:
- ✅ Consistent: "Creating an Account", "Managing Your Profile", "Updating Settings"
- ❌ Inconsistent: "How to Create an Account", "Profile Management", "Update Your Settings"

### Lists

**Numbered Lists** (for sequential steps):
```markdown
1. Open the Settings page
2. Click **Account**
3. Enter your new password
4. Click **Save**
```

**Bullet Lists** (for non-sequential items):
```markdown
- Email address (required)
- Phone number (optional)
- Profile picture (optional)
```

**Avoid Long Lists** (>7 items = hard to scan):
- Break into multiple lists with subheadings
- Group related items

### Paragraphs

**Short Paragraphs** (3-4 sentences maximum):
- One idea per paragraph
- Use whitespace for readability

**Lead with Key Point**:
- First sentence = main idea
- Following sentences = supporting details

**Examples**:
```markdown
✅ Good (scannable):
Passwords must be at least 8 characters long. Include at least one number and one symbol. Avoid using common words or personal information.

❌ Bad (wall of text):
When creating a password, you should make sure it is at least 8 characters long, and you should also include at least one number and at least one symbol in your password, and you should avoid using common words like "password" or personal information like your birthday because these are easy for hackers to guess.
```

---

## Readability Metrics

### Flesch Reading Ease

**Formula**:
```
Reading Ease = 206.835 - (1.015 × ASL) - (84.6 × ASW)

Where:
ASL = Average Sentence Length (words per sentence)
ASW = Average Syllables per Word
```

**Score Interpretation**:
```
90-100: Very Easy (5th grade, accessible to all)
80-90:  Easy (6th grade, conversational)
70-80:  Fairly Easy (7th grade, clear and direct)
60-70:  Standard (8th-9th grade, plain English)
50-60:  Fairly Difficult (10th-12th grade, technical)
30-50:  Difficult (college level, complex)
0-30:   Very Difficult (graduate level, academic)
```

**Target by Audience**:
- End Users: 70-80 (Fairly Easy)
- Administrators: 60-70 (Standard)
- Developers: 50-60 (Fairly Difficult, acceptable for technical docs)

**Improvement Strategies**:
- Reduce sentence length (aim for 15-20 words)
- Use simpler words (1-2 syllables)
- Break long sentences into shorter ones

### Flesch-Kincaid Grade Level

**Formula**:
```
Grade Level = (0.39 × ASL) + (11.8 × ASW) - 15.59
```

**Target by Audience**:
- End Users: Grade 6-8 (general public)
- Administrators: Grade 8-10 (high school)
- Developers: Grade 10-12 (technical content acceptable)

**Example**:
```
Grade 6 (target for end users):
"Click the Save button. Your changes are saved immediately. You can edit them later if needed."

Grade 12 (acceptable for developers):
"The API endpoint accepts POST requests with JSON payloads. Authentication is required via Bearer token in the Authorization header."
```

---

## Clarity Techniques

### Use Analogies

**Connect to Familiar Concepts**:
- "Think of folders like drawers in a filing cabinet"
- "A password is like a key to your house"
- "Caching is like keeping frequently used items on your desk instead of in storage"

### Provide Examples

**Realistic, Professional Examples**:
- ✅ Good: "For example: john.doe@company.com"
- ❌ Bad: "For example: foo@bar.com"

**Show Expected Results**:
```markdown
Enter your email address in the format: name@domain.com

Example: sarah.johnson@acme.com
```

### Visual Indicators

**Use Symbols for Emphasis**:
- ✅ Success/correct: "✅ Password saved successfully"
- ⚠️ Warning/caution: "⚠️ This action cannot be undone"
- ❌ Error/incorrect: "❌ Invalid email format"
- 💡 Tip/insight: "💡 Tip: Use a password manager for better security"
- 📝 Note/information: "📝 Note: Changes take effect immediately"

**Color-Coded Callouts**:
```markdown
> ✅ **Success**: Your account has been created

> ⚠️ **Warning**: Deleting your account is permanent

> ❌ **Error**: Email address is required

> 💡 **Tip**: Use keyboard shortcuts to work faster
```

### Show What Users Should See

**Success Indicators**:
```markdown
4. Click **Save**

**What you should see**: A green message appears at the top: "Settings saved successfully"
```

**Visual Confirmation**:
```markdown
If successful, you'll see:
- A checkmark icon next to your profile name
- The status changes to "Verified"
- An email confirmation is sent to your inbox
```

---

## Common Mistakes to Avoid

### 1. Assuming Prior Knowledge

**Problem**: Users may not have background knowledge

❌ Bad:
```markdown
Configure your DNS settings to point to the server
```

✅ Good:
```markdown
Configure your DNS settings:

DNS (Domain Name System) translates your domain name (like example.com) into an IP address that computers can understand.

1. Log into your domain registrar (where you purchased your domain)
2. Find the DNS settings page
3. Add a new A record pointing to: 123.45.67.89
```

### 2. Using Technical Jargon Without Explanation

**Problem**: Terminology barriers prevent understanding

❌ Bad:
```markdown
Enable TOTP-based MFA for enhanced auth security
```

✅ Good:
```markdown
Enable two-factor authentication (2FA) for extra security:

Two-factor authentication requires both your password and a code from your phone to log in. This protects your account even if someone steals your password.
```

### 3. Passive Voice

**Problem**: Unclear who does what

❌ Bad:
```markdown
The form should be filled out and submitted
```

✅ Good:
```markdown
Fill out the form and click Submit
```

### 4. Ambiguous Pronouns

**Problem**: "It", "this", "that" without clear antecedent

❌ Bad:
```markdown
Enter your password. This will be validated. It must be correct.
```

✅ Good:
```markdown
Enter your password. The system validates your password immediately. Your password must match the one you created during registration.
```

### 5. Missing Context or Prerequisites

**Problem**: Users don't know if they're ready to start

❌ Bad:
```markdown
# How to Deploy Your App
1. Run `npm run build`
...
```

✅ Good:
```markdown
# How to Deploy Your App

**Before you begin**, make sure you have:
- Node.js installed (version 14 or higher)
- Your app code downloaded
- Access to the server

**Estimated time**: 15 minutes

## Steps

1. Open your terminal
2. Navigate to your app directory: `cd /path/to/app`
3. Run `npm run build`
...
```

### 6. Long, Complex Sentences

**Problem**: Hard to read and understand

❌ Bad:
```markdown
After clicking the Save button, which is located at the bottom right corner of the screen, the system will validate your input and, if everything is correct, will save your changes to the database and display a confirmation message at the top of the page.
```

✅ Good:
```markdown
Click the **Save** button at the bottom right.

The system validates your input and saves your changes. A confirmation message appears at the top of the page if successful.
```

### 7. Vague Instructions

**Problem**: Users don't know exactly what to do

❌ Bad:
```markdown
Update your settings appropriately
```

✅ Good:
```markdown
Update these required settings:
1. **Display Name**: Enter your full name (e.g., "Sarah Johnson")
2. **Email**: Enter your work email address
3. **Time Zone**: Select your current time zone (e.g., "Pacific Time")
```

---

## Examples: Good vs Bad

### Example 1: User Guide Introduction

❌ **Bad** (Technical, passive, jargon):
```markdown
# Account Management

The system provides comprehensive account management functionality. Users are able to modify their profile information, update security settings, and configure notification preferences. Authentication is required prior to accessing account management features.
```

✅ **Good** (User-focused, active, clear):
```markdown
# Managing Your Account

Learn how to update your profile, change your password, and customize your notification settings.

**What you'll need**:
- Your current password
- 5 minutes

**In this guide**:
- Editing your profile information
- Updating your password
- Choosing notification preferences

Let's get started!
```

### Example 2: Step-by-Step Instructions

❌ **Bad** (Vague, no context):
```markdown
To reset the password:
1. Go to settings
2. Click the option
3. Enter information
4. Submit
```

✅ **Good** (Specific, clear, visual confirmation):
```markdown
## How to Reset Your Password

1. Click your profile picture in the top right corner
2. Select **Settings** from the dropdown menu
3. Click the **Security** tab on the left
4. Click **Change Password**
5. Enter your current password in the first field
6. Enter your new password in the second field (must be at least 8 characters)
7. Re-enter your new password in the third field to confirm
8. Click **Update Password**

**What you should see**: A green message appears: "Password updated successfully"

💡 **Tip**: Use a password manager to generate and store secure passwords.
```

### Example 3: Error Message Documentation

❌ **Bad** (No help, technical):
```markdown
Error: 400 Bad Request - Invalid input
```

✅ **Good** (Helpful, explains solution):
```markdown
## Error: "Email address is invalid"

**Why this happens**: The email format is incorrect

**How to fix it**:
1. Make sure your email includes the @ symbol
2. Check that your email ends with a domain (like .com or .org)
3. Remove any spaces before or after the email address

**Examples of valid emails**:
- john.doe@company.com
- sarah_smith123@email.co.uk

**Examples of invalid emails**:
- johndoe@company (missing domain extension)
- john doe@company.com (contains spaces)
- @company.com (missing username)

Still having trouble? Contact support at help@example.com
```

---

## Best Practices Summary

### Writing Checklist

**Before Writing**:
- [ ] Identify target audience (end users, admins, developers)
- [ ] Define user goals (what are they trying to accomplish?)
- [ ] Gather prerequisites (what do they need before starting?)

**During Writing**:
- [ ] Use active voice and second person ("you")
- [ ] Write short sentences (15-20 words)
- [ ] Keep paragraphs brief (3-4 sentences)
- [ ] Use simple, everyday language
- [ ] Explain jargon when necessary
- [ ] Include realistic examples
- [ ] Show expected results ("What you should see")
- [ ] Add screenshots for visual steps

**After Writing**:
- [ ] Calculate readability (target: Flesch Ease >60, Grade Level <10 for end users)
- [ ] Check for ambiguous pronouns (it, this, that)
- [ ] Verify consistent terminology
- [ ] Test instructions by following them
- [ ] Get feedback from target audience

---

These guidelines ensure documentation is accessible, helpful, and user-focused. Adapt writing style and complexity to your specific audience while maintaining clarity and precision.
