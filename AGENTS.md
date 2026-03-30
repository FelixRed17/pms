# PMS (Performance Review System)

Building a system where HR launches a review cycle, peers submit anonymous feedback via secure magic links, and the system automatically generates and delivers a branded PDF report to the employee with reviews being anonymous, HR can reduce review administration time by 60–80%, restore trust in the peer feedback process, and scale reviews without manual overhead.

## Core Principles

1. **Agent-First** — Delegate to specialized agents for domain tasks
2. **Test-Driven** — Write tests before implementation, 80%+ coverage required
3. **Security-First** — Never compromise on security; validate all inputs
4. **Immutability** — Always create new objects, never mutate existing ones
5. **Plan Before Execute** — Plan complex features before writing code

## Available Agents

| Agent                        | Purpose                                                          | When to Use                                                        |
| ---------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------ |
| coding-standard              | Enforce clean, readable, maintainable code                       | Complex features, refactoring, PR reviews                          |
| rails-ui-theme-enforcer      | Maintain consistent Rails + Tailwind UI styling                  | Building or reviewing views, partials, layouts, and components     |
| tdd-workflow                 | Enforce red-green-refactor development workflow                  | New features, bug fixes, behavior changes                          |
| security-review              | Detect vulnerabilities and enforce secure implementation         | Auth, input handling, secrets, anonymous and sensitive features    |
| rails-architecture           | Maintain idiomatic Rails structure and responsibility boundaries | Designing new flows, refactoring services, queries, and app layers |
| authentication-and-anonymity | Protect authentication flows and reviewer anonymity              | Magic links, permissions, anonymous submissions, secure delivery   |
| pdf-report-generation        | Standardize branded, secure, reliable PDF workflows              | Report generation, exports, print layouts, PDF delivery            |
| background-jobs              | Standardize async processing and retry-safe job design           | Emails, reminders, scheduled work, batch processing, heavy tasks   |

## Reference Diagrams

Consult the Mermaid diagrams in `.agents/diagrams/` before modifying architecture-sensitive areas.

- `createNewCycle.mmd` — review cycle creation flow
- `cycles.mmd` — review cycle flow including system components
- `cyclesWithoutSystemComponents.mmd` — review cycle flow without system components
- `people.mmd` — people and participant-related flow or relationships
- `reports.mmd` — report generation and delivery flow including system components
- `reportsWithoutSystemComponents.mmd` — report flow without system components
- `reviewers.mmd` — reviewer journey, roles, or review submission flow

## Security Guidelines

**Before ANY commit:**

- No hardcoded secrets (API keys, passwords, tokens)
- All user inputs validated
- SQL injection prevention (parameterized queries)
- XSS prevention (sanitized HTML)
- CSRF protection enabled
- Authentication/authorization verified
- Rate limiting on all endpoints
- Error messages don't leak sensitive data

**Secret management:** NEVER hardcode secrets. Use environment variables or a secret manager. Validate required secrets at startup. Rotate any exposed secrets immediately.

**If security issue found:** STOP → use security-reviewer agent → fix CRITICAL issues → rotate exposed secrets → review codebase for similar issues.

## Coding Style

**Immutability (CRITICAL):** Always create new objects, never mutate. Return new copies with changes applied.

**File organization:** Many small files over few large ones. 200-400 lines typical, 800 max. Organize by feature/domain, not by type. High cohesion, low coupling.

**Error handling:** Handle errors at every level. Provide user-friendly messages in UI code. Log detailed context server-side. Never silently swallow errors.

**Input validation:** Validate all user input at system boundaries. Use schema-based validation. Fail fast with clear messages. Never trust external data.

**Code quality checklist:**

- Functions small (<50 lines), files focused (<800 lines)
- No deep nesting (>4 levels)
- Proper error handling, no hardcoded values
- Readable, well-named identifiers

## Testing Requirements

**Minimum coverage: 80%**

Test types (all required):

1. **Unit tests** — Individual functions, utilities, components
2. **Integration tests** — API endpoints, database operations

**TDD workflow (mandatory):**

1. Write test first (RED) — test should FAIL
2. Write minimal implementation (GREEN) — test should PASS
3. Refactor (IMPROVE) — verify coverage 80%+

Troubleshoot failures: check test isolation → verify mocks → fix implementation (not tests, unless tests are wrong).

## Development Workflow

1. **Plan** — Use planner agent, identify dependencies and risks, break into phases
2. **TDD** — Use tdd-guide agent, write tests first, implement, refactor
3. **Review** — Use code-reviewer agent immediately, address CRITICAL/HIGH issues
4. **Capture knowledge in the right place**
   - Personal debugging notes, preferences, and temporary context → auto memory
   - Team/project knowledge (architecture decisions, API changes, runbooks) → the project's existing docs structure
   - If the current task already produces the relevant docs or code comments, do not duplicate the same information elsewhere
   - If there is no obvious project doc location, ask before creating a new top-level file

## Architecture Patterns

**API response format:**  
Use a consistent JSON response envelope across controllers:

- `success` (boolean)
- `data` (serialized resource or collection)
- `error` (message or structured errors)
- `meta` (pagination or additional metadata)

Leverage Rails serializers (e.g., ActiveModel::Serializer or fast_jsonapi) to standardize responses.

**Service-oriented design (over Repository pattern):**  
Encapsulate business logic in service objects (e.g., `CreateReviewCycle`, `GenerateReportPdf`) instead of fat controllers or models.

- Controllers handle request/response only
- Models handle persistence and simple domain logic
- Services orchestrate workflows and complex operations

**Query abstraction (ActiveRecord scopes & query objects):**  
Use ActiveRecord scopes and query objects instead of a traditional repository pattern:

- Scopes for reusable filters (`.active`, `.completed`)
- Query objects for complex queries (`ReviewCycleQuery`)

Avoid leaking raw SQL into controllers or services.

**Form objects (for complex inputs):**  
Use form objects (e.g., with `ActiveModel`) to handle validation and transformation of complex inputs like review submissions.

**Background jobs:**  
Use ActiveJob (with Sidekiq/Resque) for:

- PDF generation
- Email delivery
- Bulk processing during review cycles

**Immutable data handling (Rails-friendly):**  
Avoid mutating critical review data (especially submitted feedback). Prefer:

- Creating new records instead of overwriting
- Versioning where necessary (e.g., reports)

**Authorization & access control:**  
Use policies (e.g., Pundit) to enforce:

- HR-only actions (cycle creation, report access)
- Secure access to anonymous feedback
- Strict boundaries between roles

**Secure token-based access (magic links):**  
Implement expiring, signed tokens using Rails built-ins (`has_secure_token`, `ActiveSupport::MessageVerifier`, or `signed_id`) for anonymous review access.

**Pagination & metadata:**  
Use gems like Kaminari or Pagy and include pagination details in the `meta` field of API responses.

**File generation & storage:**  
Generate PDFs using background jobs and store them via Active Storage (e.g., S3), ensuring secure, time-limited access URLs.

## Performance

**Context management:** Avoid last 20% of context window for large refactoring and multi-file features. Lower-sensitivity tasks (single edits, docs, simple fixes) tolerate higher utilization.

**Build troubleshooting:** Use build-error-resolver agent → analyze errors → fix incrementally → verify after each fix.

## Success Metrics

- All tests pass with 80%+ coverage
- No security vulnerabilities
- Code is readable and maintainable
- Performance is acceptable
- User requirements are met
