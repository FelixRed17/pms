---
name: security-review
description: review and enforce secure implementation patterns across authentication, authorization, input handling, secrets management, api endpoints, file uploads, third-party integrations, and sensitive features such as anonymity. use when building or reviewing features that process user input, store or transmit sensitive data, expose external interfaces, or introduce security risk.
---

Apply this skill when reviewing, designing, or implementing code that could affect confidentiality, integrity, access control, or user trust.

## Core objective

Prevent security flaws before they ship. Favor secure defaults, explicit validation, least privilege, and designs that reduce the chance of accidental data exposure or abuse.

## General principles

### Default to secure behavior

Choose the safer default even when it adds small implementation effort.

- Deny by default
- Require explicit access grants
- Minimize exposed data
- Expire access where possible
- Validate all external input
- Avoid trusting client-provided state

### Protect trust-sensitive features

Treat anonymity, authentication, and sensitive workflows as high-risk domains.

- Design anonymity so identities cannot be inferred through application behavior, logs, metadata, or report outputs
- Separate access to identities from access to content when both exist
- Prevent privilege escalation through indirect paths
- Avoid implementation shortcuts that weaken trust guarantees

### Reduce attack surface

Keep external interfaces narrow and predictable.

- Expose only necessary endpoints
- Accept only required inputs
- Return only required fields
- Disable unused functionality
- Limit third-party permissions and scopes

### Fail safely

When something goes wrong, do not leak secrets, identities, internals, or sensitive data.

- Return safe error messages
- Log enough for debugging without exposing sensitive values
- Avoid revealing whether protected records exist unless required
- Handle invalid, expired, or replayed tokens safely

## Authentication and authorization

### Authentication rules

- Use established authentication mechanisms instead of inventing custom auth flows
- Store credentials securely using approved hashing algorithms and framework defaults
- Require strong session and token handling
- Expire tokens appropriately
- Revoke access when credentials or permissions change
- Protect authentication flows from replay, brute force, and enumeration

### Authorization rules

- Check authorization on every sensitive action
- Enforce authorization on the server, never only in the client
- Use least privilege for users, services, and integrations
- Separate roles clearly
- Prevent users from accessing records by guessing identifiers
- Re-check permissions at the resource level, not only at login time

### Session and token handling

- Use signed, tamper-resistant tokens
- Set expiration and purpose restrictions
- Bind tokens to the minimum scope necessary
- Invalidate one-time or magic-link tokens after use where appropriate
- Never place sensitive secrets in URLs unless the mechanism is intentionally designed for that purpose and properly protected
- Prevent token leakage through logs, analytics, referrers, and browser history where possible

## Input handling and validation

### Validate all external input

Treat all user input, uploaded files, headers, query params, webhook payloads, and third-party responses as untrusted.

- Validate type, format, length, range, and allowed values
- Prefer allowlists over blocklists
- Normalize input before processing where appropriate
- Reject malformed or unexpected input early
- Avoid passing raw input directly into queries, templates, file paths, or system commands

### Prevent injection vulnerabilities

- Use parameterized queries
- Escape output for the correct context
- Avoid string-building SQL
- Avoid unsafe shell execution
- Sanitize HTML or rich text with approved libraries
- Be explicit about trusted versus untrusted content boundaries

## API and endpoint security

### Endpoint design

- Authenticate and authorize every protected endpoint
- Validate request bodies, params, and headers
- Return only necessary fields
- Avoid over-broad list endpoints
- Paginate potentially large responses
- Rate-limit abuse-prone operations
- Protect sensitive mutations with appropriate anti-abuse controls

### Response safety

- Do not leak stack traces, secrets, internal IDs, or unnecessary system details
- Use generic errors where detailed errors would aid attackers
- Keep security-sensitive response behavior consistent to reduce enumeration risks

## Secrets and credentials

### Secret handling rules

- Never hardcode secrets
- Never commit secrets to source control
- Use environment variables or approved secret managers
- Rotate secrets when exposure is suspected
- Scope secrets to the minimum permissions required
- Separate development, staging, and production credentials

### Logging and observability

- Never log passwords, tokens, API keys, session identifiers, or private user data unless explicitly required and safely redacted
- Redact sensitive values in logs and error reporting
- Be cautious with debug logs in authentication and anonymity flows
- Ensure monitoring does not become a data leak vector

## Sensitive data handling

### Data minimization

- Collect only what is needed
- Store only what is needed
- Retain data only as long as required
- Avoid duplicating sensitive data across systems unless necessary

### Storage and transmission

- Encrypt sensitive data in transit
- Use secure storage mechanisms for sensitive files and records
- Restrict access to sensitive data by role and purpose
- Avoid exposing sensitive data in client-visible payloads, URLs, filenames, or metadata

## File uploads and generated files

### Upload safety

- Validate content type, extension, and size
- Do not trust the client-reported MIME type alone
- Scan or quarantine files where appropriate
- Store uploads outside directly executable paths
- Generate safe filenames
- Prevent path traversal and unsafe file access

### Generated documents

- Ensure generated PDFs, exports, or reports do not expose hidden metadata, internal identifiers, or reviewer identities
- Confirm access controls on stored files and download URLs
- Use expiring links where appropriate
- Verify branded outputs do not accidentally include private implementation details

## Third-party integrations

### Integration safety

- Grant the minimum permissions required
- Validate inbound webhook signatures
- Handle third-party failures safely
- Avoid over-trusting external payloads
- Protect secrets used for integrations
- Review what data is sent to third parties and whether it is necessary

## Anonymity-specific rules

When implementing anonymous feedback or similar trust-sensitive workflows:

- Never expose reviewer identity to recipients
- Prevent identity leakage through timestamps, ordering, metadata, or small-group aggregation
- Separate feedback content from identity mapping in storage and access paths
- Restrict identity visibility to the minimum administrative boundary, if visibility exists at all
- Ensure logs, analytics, notifications, exports, and generated documents preserve anonymity
- Review whether combinations of fields could indirectly identify a reviewer

## Review checklist

When applying this skill, check for:

1. Authentication uses established, secure mechanisms
2. Authorization is enforced server-side for every sensitive action
3. Tokens, sessions, and magic links are scoped, signed, and expired correctly
4. All external input is validated and treated as untrusted
5. SQL, template, command, and file handling paths are injection-safe
6. Secrets are not hardcoded, leaked, or over-scoped
7. APIs expose only necessary data and are protected against abuse
8. Logs and errors do not reveal sensitive information
9. Sensitive data is minimized, protected, and transmitted securely
10. Anonymous workflows cannot leak identity directly or indirectly

## Output behavior

When reviewing or advising with this skill:

- Call out concrete risks clearly
- Explain why the implementation is unsafe
- Suggest secure alternatives that fit the existing stack
- Prioritize high-impact vulnerabilities first
- Preserve functionality while strengthening security
- Be especially strict with anonymity, credentials, auth flows, and data exposure paths
