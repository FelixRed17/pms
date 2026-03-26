---
name: coding-standards
description: enforce universal coding standards and maintainable implementation patterns across ruby on rails, javascript, and tailwind css. use when reviewing code for quality, refactoring for consistency, improving naming and structure, setting up linting or formatting rules, or onboarding contributors to team coding conventions.
---

Apply these standards when reviewing, generating, or refactoring code.

## Core objective

Produce code that is readable, predictable, maintainable, and easy for a team to extend. Favor clarity over cleverness. Prefer conventions that make intent obvious to the next developer.

## General principles

### Prioritize communication through naming

Names are one of the main ways developers communicate intent. Choose names that are clear, pronounceable, and specific enough to reduce ambiguity.

- Prefer pronounceable names over abbreviations
- Prefer explicit names over clever names
- Use domain language consistently
- Avoid misleading or overloaded names
- Use short names only in very small local scopes
- Use longer, more descriptive names for broader scopes
- Global or shared variables should be very explicit and deeply descriptive

Examples:

- Good: `employee_review_report`
- Bad: `err`
- Good: `is_terminated`
- Bad: `terminatedFlag`

### Follow semantic naming by type

Use naming patterns that match what the thing represents.

- Classes and variables should usually be nouns
- Methods should usually be verbs
- Boolean variables and boolean-returning methods should read like predicates
- Enums should usually describe states or qualities, so prefer adjectives or state labels

Examples:

- Class: `ReviewCycle`
- Variable: `employee_feedback`
- Boolean variable: `is_empty`, `is_terminated`, `has_access`
- Method: `generate_report`, `submit_feedback`
- Boolean method: `valid?`, `published?`, `anonymous?`
- Enum values: `draft`, `active`, `completed`, `archived`

### Keep it simple

Apply KISS at all times.

- Choose the simplest solution that works
- Avoid unnecessary abstraction
- Avoid premature optimization
- Prefer easy-to-understand code over clever code

### Avoid repetition

Apply DRY carefully.

- Extract repeated logic into methods, helpers, or shared components
- Reuse utilities where duplication is real and recurring
- Do not create abstractions too early for one-off cases
- Remove copy-paste logic when the duplication has the same intent

### Do not build speculative features

Apply YAGNI rigorously.

- Do not add flexibility before it is needed
- Do not build extension points without a real use case
- Start simple and refactor when requirements become real
- Prefer concrete implementations over speculative frameworks

## Structure and maintainability rules

### Keep responsibilities narrow

Each class, method, component, or module should have one clear responsibility.

- Split large methods into smaller intention-revealing methods
- Avoid classes that mix orchestration, business logic, formatting, and persistence
- Prefer composition over large monolithic units

### Optimize for readability

Readable code is the default standard.

- Keep methods focused
- Avoid deep nesting
- Use guard clauses to reduce indentation
- Prefer explicit conditionals over compressed logic
- Remove dead code and commented-out code

### Make change safe

Write code that is easy to modify without causing regressions.

- Keep interfaces small and predictable
- Minimize hidden side effects
- Prefer pure transformations where practical
- Avoid mutating shared state unless necessary and obvious

## Ruby on Rails standards

### Follow Rails conventions first

Prefer standard Rails conventions before introducing custom patterns.

- Use Rails naming and file structure conventions
- Keep controllers thin
- Keep models focused on persistence and core domain behavior
- Move orchestration and multi-step workflows into service objects when needed
- Use query objects or scopes for complex querying
- Use presenters, serializers, or decorators for presentation concerns

### Ruby naming conventions

- Classes and modules: `CamelCase`
- Files, methods, variables, symbols: `snake_case`
- Predicate methods must end in `?`
- Bang methods must only be used when there is a meaningful dangerous or mutating counterpart

Examples:

- `active?`
- `anonymous?`
- `save!`

### Ruby method design

- Prefer short, intention-revealing methods
- A method should do one thing
- Extract conditionals into well-named predicates when it improves readability
- Prefer guard clauses over nested `if` trees
- Avoid long parameter lists; prefer value objects or keyword arguments where appropriate

### Rails controller standards

- Controllers should coordinate request handling, not hold business logic
- Validate and permit params clearly
- Return consistent response structures
- Delegate complex workflows to services
- Keep actions concise and predictable

### Rails model standards

- Keep validations, associations, scopes, and essential domain behavior in models
- Do not overload models with unrelated workflow logic
- Avoid callback-heavy designs when explicit service orchestration is clearer
- Prefer explicit domain methods over generic helpers

## JavaScript standards

### Prefer clarity and predictability

- Use descriptive variable and function names
- Prefer small, pure functions where possible
- Avoid mutating objects and arrays unless necessary
- Prefer `const` by default, then `let` only when reassignment is required
- Avoid `var`

### Function design

- Functions should do one thing
- Boolean-returning functions should read like predicates
- Avoid large functions with multiple responsibilities
- Prefer early returns over nested branches

Examples:

- `isAnonymous()`
- `hasPermission()`
- `generatePdfReport()`

### JavaScript structure

- Keep business logic separate from UI logic
- Extract shared utilities when duplication is real
- Avoid deeply nested conditionals
- Prefer explicitness over implicit side effects
- Use linting and formatting to enforce consistency

## Tailwind CSS standards

### Use Tailwind for consistency, not chaos

- Prefer clean, composable utility usage
- Group classes logically
- Avoid unreadable class strings when abstraction would improve clarity
- Extract repeated UI patterns into components
- Do not create premature component abstractions for one-off styling

### Tailwind maintainability rules

- Keep layout, spacing, typography, and state classes readable
- Prefer consistent spacing and sizing scales
- Avoid arbitrary values unless there is a strong reason
- Reuse design tokens and theme values where available
- When class lists become too long or repeated, extract a component or helper

## Review checklist

When applying this skill, check for:

1. Clear, pronounceable, intention-revealing names
2. Methods and functions with one responsibility
3. Boolean names written as predicates
4. Simplicity over cleverness
5. Real duplication removed without over-abstracting
6. No speculative architecture or unnecessary flexibility
7. Rails conventions followed where applicable
8. JavaScript logic kept predictable and maintainable
9. Tailwind usage kept consistent and reusable
10. Code organized so future changes are easy and safe

## Output behavior

When reviewing or refactoring code with this skill:

- Identify naming issues clearly
- Explain why a pattern reduces maintainability
- Suggest convention-aligned improvements
- Prefer practical fixes over theoretical purity
- Preserve working behavior while improving readability and structure
- Recommend linting, formatting, or type-checking rules only when they support consistency and maintainability
