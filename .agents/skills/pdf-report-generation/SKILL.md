---
name: pdf-report-generation
description: enforce reliable, branded pdf generation and delivery patterns in ruby on rails applications. use when building employee reports, exports, print-ready documents, branded summaries, or any workflow that generates, stores, or delivers pdf files from application data.
---

Apply this skill when designing, implementing, or reviewing PDF generation workflows in a Rails application.

## Core objective

Generate PDFs that are reliable, branded, readable, secure, and operationally maintainable. Treat PDF output as a product surface, not an afterthought.

## Core principles

### Make PDFs deterministic

The same valid input should reliably produce the same document structure and presentation.

- keep templates predictable
- control layout intentionally
- avoid fragile rendering dependencies where possible
- ensure output is reproducible

### Treat PDFs as user-facing deliverables

PDFs should be:

- polished
- readable
- brand-consistent
- print-safe
- operationally reliable

### Protect sensitive output

Generated documents must not leak hidden metadata, reviewer identity, or internal-only details.

## Layout and presentation rules

### Use structured templates

- keep PDF templates organized and maintainable
- separate data preparation from visual rendering
- use reusable partials or template fragments where repetition is real
- make heading hierarchy and spacing explicit

### Brand consistency

- apply the project’s visual identity consistently
- ensure fonts, spacing, borders, logo treatment, and typography match the product
- keep document styling intentional rather than browser-default

### Print readability

Design for print and PDF readability.

- ensure strong contrast
- avoid cramped spacing
- use predictable page breaks
- avoid layout overflow
- handle long text safely
- keep tables readable across pages where possible

## Data and content rules

### Prepare data before rendering

- perform heavy formatting and aggregation before template rendering
- keep templates focused on presentation
- avoid complex business logic inside the PDF template

### Protect anonymity and privacy

For employee-facing review reports:

- never include reviewer identity
- avoid identifying timestamps unless required
- remove hidden metadata that could expose internal details
- ensure ordering and labeling do not imply identity

### Content safety

- validate all content included in PDFs
- escape or sanitize input as required by the rendering approach
- prevent broken layout caused by unbounded or malformed content

## Rails architecture expectations

### Keep rendering workflow structured

Use a clear pipeline:

1. gather authorized data
2. prepare report view model or presenter
3. render HTML or document template
4. generate PDF
5. store or attach securely
6. deliver via approved workflow

### Place responsibilities clearly

- controllers trigger the workflow
- services orchestrate report generation
- presenters or view models prepare display data
- jobs handle asynchronous generation and delivery
- templates render the final visual output

## Storage and delivery rules

### Secure storage

- store generated PDFs securely
- restrict access by role and ownership
- use expiring access URLs where appropriate
- avoid public exposure of sensitive files

### Delivery rules

- deliver reports only to the intended employee or authorized admin
- ensure filenames do not expose sensitive internal identifiers
- confirm that retry behavior does not duplicate delivery unexpectedly

## Operational rules

### Use background jobs for heavy generation

PDF generation and delivery should usually run asynchronously when the process is non-trivial or batch-oriented.

### Handle failures safely

- make generation failures observable
- retry when safe
- avoid partial or corrupted outputs being treated as successful
- separate generation from delivery when that improves reliability

### Idempotency

- avoid duplicate document creation where retries occur
- ensure repeated job execution does not produce unsafe delivery duplication without control

## Accessibility and quality expectations

- use clear typographic hierarchy
- preserve text readability
- ensure key information is scannable
- do not rely solely on color for meaning
- keep branded styling from reducing legibility

## Testing expectations

Test:

- document generation success
- rendering with representative data
- long text and edge-case formatting
- authorization boundaries
- anonymity preservation
- file attachment or storage behavior
- delivery workflow behavior

## Review checklist

When applying this skill, check for:

1. PDF generation follows a clear service-oriented workflow
2. templates are presentation-focused and maintainable
3. branding is consistent and intentional
4. page layout is stable and print-friendly
5. heavy rendering and delivery work is offloaded appropriately
6. storage and download access are secure
7. filenames and metadata do not leak sensitive information
8. anonymous content remains anonymous in the final document
9. retries and failures are handled safely
10. the generated PDF feels polished and product-grade

## Output behavior

When reviewing or designing PDF workflows with this skill:

- focus on reliability, readability, branding, and privacy
- suggest Rails-friendly separation between data prep, rendering, storage, and delivery
- call out metadata or anonymity leakage risks clearly
- recommend maintainable templates over ad hoc rendering logic
- treat the PDF as a first-class user-facing deliverable
