---
name: background-jobs
description: enforce reliable background job patterns for ruby on rails applications using active job and queue-backed processing for async, retryable, and batch workflows. use when implementing email delivery, pdf generation, reminders, notifications, imports, scheduled tasks, or any work that should not block the request cycle.
---

Apply this skill when designing, implementing, or reviewing asynchronous work in a Rails application.

## Core objective

Keep background processing reliable, safe, observable, and easy to reason about. Use jobs for deferred execution without turning them into uncontrolled workflow containers.

## Core principles

### Use jobs for the right reasons

Background jobs are appropriate when work is:

- slow
- retryable
- external
- batch-oriented
- non-interactive
- unnecessary to complete inside the request cycle

Avoid using jobs to hide poor synchronous design.

### Keep jobs small and focused

A job should:

- accept minimal input
- perform one clear async responsibility
- delegate substantial business logic to a service when needed
- be safe to retry when possible

### Design for retries

Assume jobs may run:

- more than once
- later than expected
- after partial failure
- out of order relative to other async work

Build with this reality in mind.

## Job design rules

### Minimal arguments

Pass lightweight, stable identifiers instead of large serialized objects.

Prefer:

- record ids
- signed identifiers where appropriate
- simple scalar arguments

Avoid:

- huge payloads
- stale object snapshots
- unnecessary derived data that can be reloaded safely

### Re-load fresh state

Jobs should load current state from the database where appropriate.

- do not assume the world looks the same when the job runs
- verify the record still exists and is still eligible for processing
- handle missing or changed state safely

### Delegate workflow logic

If the job is orchestrating significant business behavior, delegate to a service object.

Pattern:

- job locates inputs
- job invokes service
- service contains workflow logic

## Reliability rules

### Idempotency

Jobs should be safe to retry.

- avoid duplicate emails, reports, or state changes where retries can occur
- guard against repeated execution
- use explicit deduplication or idempotency controls where necessary

### Failure handling

- allow retry only where retry is actually safe and useful
- surface permanent failures clearly
- do not swallow exceptions silently
- distinguish transient failures from logic bugs

### Ordering awareness

Do not assume queue execution order is guaranteed unless the infrastructure explicitly guarantees it and the design depends on it safely.

## Performance rules

### Keep jobs efficient

- avoid unnecessary queries
- avoid N+1 patterns in batch jobs
- chunk large work into smaller units when appropriate
- avoid giant long-running jobs when fan-out is safer

### Batch processing

For bulk workflows:

- split work into manageable units
- track progress explicitly when required
- isolate failures where possible
- avoid one failure collapsing the entire batch unless intended

## Operational patterns

### Good uses for jobs

- sending emails
- generating PDFs
- launching reminders
- batch notifications
- report regeneration
- webhook handling
- recurring scheduled tasks

### Poor uses for jobs

- hiding authorization mistakes
- avoiding proper request validation
- moving all business logic into queue workers
- creating untraceable side effects

## Rails expectations

### Use Active Job idiomatically

- follow the app’s queueing conventions
- name jobs by intent
- keep queue usage consistent
- use queue priorities intentionally where supported

### Naming

Examples:

- `GenerateEmployeeReportJob`
- `DeliverReviewReportJob`
- `SendReviewReminderJob`

Avoid vague names like:

- `WorkerJob`
- `AsyncProcessor`
- `TaskRunner`

## Observability and tracing

### Make async work visible

- log enough to debug safely
- track job start, success, retry, and failure meaningfully
- avoid leaking secrets or private data in logs
- ensure critical business operations are operationally traceable

## Security and privacy rules

- do not log sensitive payloads unnecessarily
- preserve reviewer anonymity in queued workflows
- ensure queued delivery does not expose unauthorized data
- validate eligibility again before performing sensitive actions

## Testing expectations

Test:

- enqueuing behavior
- execution behavior
- retry-safe behavior
- idempotency where relevant
- missing-record handling
- authorization or eligibility checks for sensitive jobs
- integration with mailers, PDFs, or downstream services

## Review checklist

When applying this skill, check for:

1. the work truly belongs in a background job
2. job arguments are minimal and stable
3. business logic is not bloating the job unnecessarily
4. retry behavior is safe and intentional
5. idempotency risks are addressed
6. missing or stale records are handled safely
7. batch jobs are split and managed sensibly
8. logs are useful without leaking sensitive data
9. async flows preserve authorization and anonymity constraints
10. jobs remain small, observable, and maintainable

## Output behavior

When reviewing or designing background jobs with this skill:

- recommend async boundaries clearly
- push substantial workflow logic into services when appropriate
- call out retry and duplication risks explicitly
- prefer minimal arguments and fresh state loading
- keep the queueing model reliable, understandable, and Rails-idiomatic
