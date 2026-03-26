---
name: rails-architecture
description: enforce idiomatic ruby on rails application architecture using clear boundaries between controllers, models, services, queries, jobs, mailers, policies, and views. use when designing new features, refactoring complex flows, reviewing app structure, or deciding where logic belongs in a rails application.
---

Apply this skill when designing, reviewing, or refactoring structure in a Ruby on Rails application.

## Core objective

Keep the codebase idiomatic, maintainable, and easy to extend by placing logic in the right layer and preserving clear responsibilities between Rails components.

## Core principles

### Prefer Rails conventions first

Use standard Rails structure before inventing custom architecture.

- Prefer controllers, models, mailers, jobs, helpers, and partials where they naturally fit
- Add service objects, query objects, form objects, and presenters only when complexity justifies them
- Do not import patterns from other ecosystems unless they clearly improve the Rails codebase

### Keep boundaries explicit

Each layer should have a clear responsibility.

- Controllers coordinate requests and responses
- Models represent persisted domain concepts and essential domain rules
- Services orchestrate multi-step workflows
- Query objects handle complex retrieval logic
- Jobs handle deferred or asynchronous work
- Policies enforce authorization
- Views and partials handle presentation only

### Favor simple composition

- Prefer small, composable objects over giant classes
- Extract only when duplication or complexity is real
- Keep object APIs intention-revealing
- Avoid deep inheritance trees

## Layer responsibilities

### Controllers

Controllers should be thin.

Allowed responsibilities:

- authenticate user
- authorize action
- load resource
- permit params
- invoke service or model method
- render or redirect

Avoid:

- business workflows
- complex branching
- heavy querying
- data formatting
- PDF construction logic
- authorization rules embedded inline when policy objects are appropriate

### Models

Models should own:

- associations
- validations
- scopes
- essential domain behavior
- simple state logic tied closely to the record

Avoid:

- multi-step orchestration
- external API coordination
- large procedural workflows
- presentation formatting
- unrelated utility logic

### Services

Use services for multi-step business workflows.

Examples:

- launching a review cycle
- generating a branded report
- submitting anonymous feedback
- delivering employee reports

Service expectations:

- one clear responsibility
- explicit input
- explicit output or result object
- predictable side effects
- easy to test in isolation

### Query objects

Use query objects when retrieval logic becomes too complex for scopes alone.

Use them for:

- multi-filter admin search
- reporting queries
- policy-aware record retrieval
- sorting and pagination orchestration

Avoid putting complex SQL or conditional filtering inside controllers.

### Form objects

Use form objects when input handling is more complex than a single ActiveRecord model.

Useful for:

- multi-step forms
- cross-model validation
- anonymous submission flows
- imported or transformed input

### Jobs

Jobs should wrap deferred work, not become a second service layer with uncontrolled logic.

Good uses:

- sending emails
- generating PDFs
- queueing reminders
- bulk notifications
- retryable background processing

Prefer delegating substantial business logic from jobs into services.

### Policies

Use policy objects to centralize authorization.

- keep authorization out of views and scattered controllers
- make permission rules explicit
- check access at the action and resource level

### Views

Views should render presentation, not business logic.

- extract repeated markup into partials
- use helpers for small presentational logic
- avoid complex conditionals in templates
- keep ERB readable and maintainable

## Architectural rules

### Put logic where it changes for the same reason

Group behavior by responsibility and change pattern.

- workflow changes belong in services
- persistence rules belong in models
- visibility rules belong in policies
- rendering rules belong in serializers, presenters, helpers, or views

### Avoid fat-everything

Do not solve complexity by dumping it into:

- fat controllers
- fat models
- fat helpers
- giant jobs
- god services

Prefer several small cohesive objects.

### Name objects by purpose

Examples:

- `LaunchReviewCycle`
- `GenerateEmployeeReportPdf`
- `ReviewCycleQuery`
- `AnonymousFeedbackForm`
- `EmployeeReportPolicy`

Avoid vague names like:

- `Manager`
- `Processor`
- `Handler`
- `Utility`

unless the domain purpose is explicit.

## Recommended structure

Use patterns like:

- `app/services`
- `app/queries`
- `app/forms`
- `app/policies`
- `app/presenters` or `app/serializers`

Keep directory structure predictable and consistent across the app.

## Transaction and workflow guidance

For multi-step workflows:

- make transaction boundaries explicit
- keep side effects intentional
- avoid partial success without handling it
- separate synchronous persistence from async follow-up work when appropriate

## Refactoring guidance

When refactoring architecture:

- preserve behavior first
- move one responsibility at a time
- add tests before moving risky logic
- improve boundaries without over-designing
- stop once the structure is clear enough

## Review checklist

When applying this skill, check for:

1. controllers are thin and focused
2. models contain core domain logic but not workflow sprawl
3. services encapsulate multi-step use cases cleanly
4. query logic is not leaking into controllers
5. jobs are used for async work and remain focused
6. policies centralize authorization
7. views remain presentation-oriented
8. naming reflects actual domain purpose
9. responsibilities are separated by reason to change
10. architecture is Rails-idiomatic rather than framework-agnostic abstraction

## Output behavior

When reviewing or designing architecture with this skill:

- suggest the most Rails-idiomatic placement first
- identify misplaced responsibilities clearly
- recommend extracting only where complexity justifies it
- prefer practical structure over theoretical purity
- keep the app easy for Rails developers to understand and extend
