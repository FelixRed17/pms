---
name: tdd-workflow
description: enforce a test-driven development workflow for ruby on rails applications. use when implementing new features, fixing bugs, refactoring behavior, reviewing pull requests, or guiding contributors to write tests before code, keep changes small, and preserve confidence through automated coverage.
---

Apply this skill when building, reviewing, or refactoring functionality in a Ruby on Rails app.

## Core objective

Enforce a disciplined Rails TDD workflow: write a failing test first, implement the smallest change that makes it pass, then refactor safely while keeping the full test suite green.

## Core principles

### Test first

Always begin with a test that captures the desired behavior before changing production code.

- Write the failing test first
- Confirm the test fails for the expected reason
- Do not implement behavior before the expectation exists
- Let the test define the contract

### Red, green, refactor

Follow the full TDD loop every time.

1. **Red** — write a failing test
2. **Green** — make the smallest code change to pass
3. **Refactor** — improve naming, structure, and duplication while keeping tests green

Do not skip directly from feature idea to implementation.

### Small steps

Keep each iteration small and easy to reason about.

- Add one behavior at a time
- Avoid large multi-concern changes
- Prefer multiple tight commits over one sweeping rewrite
- Run relevant tests frequently

### Behavior over implementation

Test what the system does, not how it is internally written.

- Prefer observable outcomes
- Avoid over-coupling tests to private methods
- Refactor internals freely as long as behavior remains correct
- Use unit, request, system, and model specs where they best capture real behavior

## Rails testing strategy

Choose the narrowest test that proves the behavior with confidence.

### Model tests

Use model specs or tests for:

- validations
- associations
- scopes
- simple domain rules
- state transitions
- pure domain methods

### Request specs

Prefer request specs for API and controller behavior.

Use them to verify:

- routing behavior
- authentication and authorization outcomes
- response codes
- response payloads
- side effects visible at the HTTP boundary

Prefer request specs over controller specs unless the project explicitly uses controller specs.

### System tests

Use system tests for:

- end-to-end user workflows
- multi-step UI interactions
- critical HTML.erb flows
- JavaScript-enhanced user paths when relevant

Test what the user sees and does, not implementation details.

### Service and PORO tests

Use unit tests for service objects, value objects, query objects, and other POROs.

- Keep service behavior explicit
- Assert outputs and side effects clearly
- Avoid bloated setup
- Use these tests to support orchestration logic that does not belong in models or controllers

### Job and mailer tests

Use dedicated tests for:

- background jobs
- mail delivery
- enqueued side effects
- retry-sensitive flows

## Workflow

### 1. Start from behavior

Before writing code, define:

- what the user or system should be able to do
- where that behavior belongs in Rails
- which test type best proves it

Translate requirements into one specific failing example first.

### 2. Write the failing test

Write the smallest meaningful test for the next behavior.

- Make the expectation explicit
- Keep setup focused
- Name the example clearly
- Run the test and verify it fails for the expected reason

### 3. Implement the minimum

Write only enough production code to satisfy the failing test.

- Do not generalize too early
- Do not pre-build future cases
- Do not refactor while still red
- Keep the change narrow

### 4. Refactor safely

Once green:

- improve names
- remove duplication
- extract helpers, methods, or objects when justified
- simplify conditionals
- align with Rails conventions

Run the relevant tests after every meaningful refactor.

### 5. Expand coverage incrementally

After the first passing behavior:

- add edge cases
- add unhappy paths
- add authorization and validation coverage
- add regression tests for bugs

Do this incrementally, not all at once before seeing a green test.

## Test design rules

### Write intention-revealing test names

Test names should explain behavior clearly.

Examples:

- `creates a review cycle with valid attributes`
- `returns forbidden for unauthorized users`
- `does not expose reviewer identity in the report`
- `marks the magic link as expired after use`

Avoid vague names such as:

- `works correctly`
- `handles case`
- `test review cycle`

### One behavior per example

Each example should focus on one clear behavior.

- Avoid giant examples with many assertions unless they describe one cohesive outcome
- Split unrelated expectations into separate examples
- Keep failure messages easy to interpret

### Keep setup minimal

Only create the data needed for the example.

- Prefer factories or fixtures that are easy to understand
- Avoid unnecessary records
- Use traits for meaningful variations
- Remove incidental setup noise

### Prefer realistic boundaries

- Use request specs for endpoint contracts
- Use system tests for UI journeys
- Use unit tests for fast domain logic
- Do not mock boundaries that should be exercised directly unless isolation is the point of the test

## What to avoid

### Do not write implementation-first code

Reject workflows where production code is written before the test exists.

### Do not over-mock

Avoid excessive mocking that makes tests brittle or meaningless.

- Do not mock Rails itself
- Do not mock the database in normal app tests
- Mock external services at the boundary
- Prefer fakes or stubs only where isolation improves speed or determinism

### Do not test private methods directly

Test behavior through public interfaces unless there is a strong project-specific reason not to.

### Do not create giant integration tests for everything

Use the correct test level.

- Not every behavior needs a system test
- Not every small rule needs a request spec
- Balance speed and confidence

### Do not skip regressions for bug fixes

Every bug fix should begin with a failing regression test that reproduces the bug.

## Rails-specific expectations

### Follow framework conventions

- Keep controllers thin
- Put domain behavior in appropriate objects
- Use services for orchestration when needed
- Keep tests aligned with the Rails layer being exercised

### Cover critical Rails behaviors

Tests should verify relevant Rails concerns such as:

- validations
- callbacks when behavior matters
- transactions when failure behavior matters
- background job enqueueing
- mail delivery
- authorization rules
- strong parameter effects through request behavior

### Prefer factories that reflect domain language

Use factories that read like the app domain and keep traits explicit.

## Refactoring rules

Refactoring is allowed only when tests are green.

During refactor:

- preserve behavior
- improve naming
- remove duplication
- simplify object responsibilities
- extract reusable objects only when duplication or complexity justifies it

Do not mix feature expansion with refactoring unless both are covered and controlled.

## Pull request expectations

When reviewing PRs with this skill, check that:

1. new behavior starts with tests
2. bug fixes include regression coverage
3. the chosen test level matches the behavior
4. tests are readable and intention-revealing
5. setup is minimal and focused
6. production code change is as small as practical
7. refactors happen only with passing tests
8. edge cases and authorization are covered where relevant
9. the test suite remains fast and maintainable
10. the change increases confidence, not just coverage numbers

## Coverage guidance

Aim for strong behavioral confidence, not vanity metrics.

- Prefer meaningful coverage over arbitrary line coverage
- Ensure core business logic, security-sensitive paths, and regression-prone workflows are protected
- Cover happy paths, failure paths, and edge cases where they matter

## Output behavior

When applying this skill:

- insist on writing the failing test first
- suggest the correct Rails test type for the change
- break large changes into smaller red-green-refactor steps
- call out implementation-first or test-after patterns
- recommend regression tests for every bug fix
- preserve Rails conventions while improving confidence through tests
