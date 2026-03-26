---
name: authentication-and-anonymity
description: enforce secure authentication, authorization, token handling, magic-link flows, and reviewer anonymity in ruby on rails applications. use when implementing login or access flows, anonymous submissions, role-based access, secure report delivery, or any feature where identities, permissions, or trust-sensitive data must be protected.
---

Apply this skill when designing, reviewing, or implementing authentication, access control, magic links, and anonymity-sensitive workflows.

## Core objective

Protect user trust by ensuring access is secure, permissions are enforced correctly, and anonymity cannot be broken through direct or indirect system behavior.

## Core principles

### Protect trust-sensitive flows aggressively

Authentication and anonymity are high-risk features.

- design them explicitly
- avoid shortcuts
- prefer secure defaults
- assume implementation details can leak identity if not controlled

### Separate identity from content

Where anonymous feedback exists:

- keep reviewer identity separate from review content
- restrict access to identity mappings
- avoid exposing linkage through logs, exports, notifications, timestamps, or metadata

### Enforce least privilege

- users should access only what they need
- admins should have scoped operational access
- employees must never gain access to reviewer identities
- permissions must be checked server-side on every sensitive action

## Authentication rules

### Use established Rails patterns

Prefer standard secure Rails approaches and established libraries.

- use proven authentication solutions rather than inventing custom auth
- protect sessions, cookies, and tokens appropriately
- use secure password storage when passwords exist
- invalidate or expire credentials appropriately

### Token and magic-link rules

When using magic links or tokenized access:

- tokens must be single-purpose
- tokens must expire
- tokens must be signed or otherwise tamper-resistant
- tokens must not grant broader access than intended
- one-time flows should invalidate tokens after use where appropriate
- token usage should be safe against replay and enumeration

### Prevent leakage

- do not log raw magic-link tokens
- avoid exposing tokens in analytics, referrers, screenshots, or unnecessary redirects
- ensure emails and redirects do not broaden access accidentally

## Authorization rules

### Check authorization everywhere

Authorization must not be implied by authentication.

- check access per action
- check access per resource
- scope records appropriately
- do not trust user-supplied ids or ownership claims

### Role boundaries

Make role boundaries explicit.

Examples:

- HR can create and manage review cycles
- reviewers can submit only their assigned feedback
- employees can view only their own final reports
- no employee can see reviewer identity

### Prefer policy objects

Use policy-based authorization so rules remain explicit and testable.

## Anonymity rules

### Preserve anonymity end to end

Reviewer anonymity must survive:

- database design
- background jobs
- PDF generation
- admin screens
- audit logs
- notification content
- exported files
- analytics and monitoring

### Prevent indirect identification

Reviewers can be exposed indirectly through:

- exact timestamps
- ordering of reviews
- small group sizes
- identifiable writing context
- metadata in generated files
- admin-only notes leaking downstream

Review for these explicitly.

### Aggregation and presentation

When rendering employee-facing output:

- exclude identifying metadata
- avoid exposing submission timing unless essential
- avoid layouts that imply ordering by reviewer identity
- ensure generated reports cannot reveal hidden author data

## Data handling rules

### Minimize sensitive data exposure

- collect only what is needed
- store identity mappings only when necessary
- restrict access paths tightly
- avoid duplicating sensitive mappings across systems

### Logging rules

- never log passwords, raw tokens, or reviewer identity in user-facing flows
- redact sensitive values in logs
- ensure debug output does not break anonymity

## Rails implementation expectations

### Use Rails-native secure patterns

Prefer Rails-friendly mechanisms such as:

- signed or purpose-scoped identifiers
- secure session handling
- policy objects for access control
- explicit service objects for trust-sensitive workflows

### Structure

- keep controllers thin
- put access and trust-sensitive orchestration in services
- centralize authorization rules
- isolate identity mapping from employee-facing rendering paths

## Testing expectations

Every anonymity or authentication feature should be covered by tests.

Test for:

- valid access
- invalid access
- expired magic links
- replayed tokens
- unauthorized role access
- report delivery safety
- anonymity preservation in rendered output
- regression tests for any privacy bug

## Review checklist

When applying this skill, check for:

1. authentication uses established secure patterns
2. authorization is enforced server-side for every sensitive action
3. tokens and magic links are scoped, signed, and expired correctly
4. reviewer identity is separated from feedback content
5. no employee-facing output can reveal reviewer identity
6. logs, emails, PDFs, and exports preserve anonymity
7. role boundaries are explicit and testable
8. sensitive mappings are tightly restricted
9. indirect identity leakage has been considered
10. trust-sensitive flows have strong regression coverage

## Output behavior

When reviewing or designing with this skill:

- flag any direct or indirect anonymity risk clearly
- recommend Rails-native secure patterns
- prioritize access control and privacy issues first
- preserve trust guarantees over convenience
- be especially strict with tokens, permissions, generated files, and metadata
