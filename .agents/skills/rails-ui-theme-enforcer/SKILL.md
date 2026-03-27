---
name: rails-ui-theme-enforcer
description: enforce a consistent ruby on rails html.erb and tailwind ui theme based on a dark industrial mono visual system with orange accents, sharp borders, textured overlays, uppercase headings, dense admin-style layouts, and high-contrast panels. use when building or reviewing rails views, layouts, partials, tailwind utility usage, component structure, or design-system consistency against the project theme.
---

Apply this skill when generating, reviewing, or refactoring Rails UI code in `html.erb`, Tailwind classes, layout structure, and shared partials.

## Core objective

Ensure all UI work matches the project's visual system: dark, industrial, high-contrast, mono-typed, sharp-edged, orange-accented, dense, and structured. Favor consistency and discipline over decorative variation.

## Theme identity

The UI must feel:

- dark and high contrast
- industrial and system-like
- mono and technical
- sharp, bordered, and gridded
- branded with restrained orange accents
- dense but readable
- premium, serious, and operational rather than playful

Do not introduce styles that make the app feel soft, whimsical, rounded, glossy, pastel, consumer-social, or generic SaaS.

## Visual rules

### Color system

Follow this palette direction consistently:

- background: near-black
- panels: layered black and charcoal
- text: white
- muted text: gray
- brand accent: strong orange
- borders: dark gray to medium gray
- accent glow: subtle orange transparency
- textures: faint white hatch, grid, scanline, or technical overlays

### Color usage rules

- Use orange only as an accent, not as the dominant fill color everywhere
- Keep most surfaces black, charcoal, or dark gray
- Use white for primary readability
- Use muted gray for secondary text
- Use borders and contrast to define structure before using color
- Use orange to highlight key actions, active state, important labels, or focal punctuation

## Typography rules

### General typography

- Prefer mono or mono-adjacent typography for the overall application feel
- Headings should feel technical, bold, compact, and authoritative
- Uppercase headings are preferred for section titles and structural labels
- Use slightly expanded letter spacing for headings, labels, and metadata
- Body text must remain readable and not overly compressed

### Typography behavior

- Use uppercase for headings, panel labels, metadata tags, and section headers
- Keep paragraph text readable and not fully uppercase
- Favor concise, structured copy over conversational marketing copy
- Use muted text for support content, not for primary content

## Layout and composition rules

### Structural layout

- Prefer shell-style containers with bordered outer frames
- Use panel-based composition
- Use grids for organization
- Use visible section boundaries
- Use spacing deliberately, but avoid overly airy layouts
- Keep the interface feeling operational and information-dense

### Panel behavior

- Panels should feel framed and intentional
- Use dark layered surfaces
- Use subtle gradients only when they reinforce depth without adding softness
- Use borders generously to separate regions
- Prefer rectangular blocks over floating cards

### Density rules

- The UI may be compact, but must remain readable
- Avoid oversized padding that makes the app feel generic or too spacious
- Avoid cramped layouts that make scanning difficult
- Prefer balanced density with clear hierarchy

## Shape and surface rules

### Corners and borders

- Prefer sharp or minimally rounded corners
- Borders are a core part of the visual language
- Use border contrast to define layout regions, controls, and panels
- Avoid overly soft card styles and soft blobs

### Texture and overlays

This theme allows subtle visual texture.

Use sparingly:

- grid overlays
- hatch patterns
- scanline or noise-like effects
- subtle technical framing

Do not let textures reduce readability or interfere with form controls.

## Interaction design rules

### Links and buttons

- Primary interactive emphasis should come from contrast, border, and orange accent
- Hover states should brighten the orange accent or strengthen border contrast
- Buttons should feel functional and precise, not playful
- Avoid pill-shaped consumer-style buttons unless explicitly required
- Prefer controls that look system-oriented and intentional

### Form controls

- Inputs, selects, and textareas should feel integrated into the dark system
- Use dark surfaces, clear borders, white text, and restrained focus states
- Focus states should be highly visible and accessible
- Avoid browser-default styling leaking into the interface

## Tailwind usage rules

### Tailwind principles

- Use Tailwind utilities to express the theme consistently
- Prefer reusable component patterns over ad hoc styling drift
- Extract repeated UI structures into partials, helpers, or component abstractions when duplication is real
- Keep utility combinations readable and intentional

### Tailwind style direction

Favor utilities that reinforce:

- black and charcoal backgrounds
- white and muted gray text
- orange accents
- borders and dividers
- uppercase labels
- tracking for headings and metadata
- grid-based layout
- subtle shadow or glow only when restrained

Avoid utilities that push the UI toward:

- bright multicolor palettes
- soft rounded-heavy design
- pastel surfaces
- oversized blur effects
- playful animation
- generic startup landing page aesthetics

## Rails view standards

### ERB structure

- Keep templates clean and scannable
- Extract repeated sections into partials
- Use helpers for repeated presentation logic
- Avoid embedding large amounts of conditional styling logic directly in views
- Keep markup semantic and easy to maintain

### Layout consistency

- Enforce consistent wrappers, spacing patterns, heading treatments, and panel composition across pages
- Reuse shared structures for headers, shells, section containers, and action bars
- Shared UI patterns should not be reimplemented differently page by page

## Component expectations

When building UI components, prefer these traits:

- bordered container
- dark layered surface
- uppercase label or title
- strong visual hierarchy
- restrained orange accent
- technical or operational feel
- minimal decorative softness

Examples of components that should follow this rigor:

- page shells
- dashboard panels
- review cards
- tables
- filters
- form sections
- action bars
- report summaries
- navigation blocks
- status badges

## Accessibility rules

Theme consistency must not reduce usability.

- Maintain strong contrast between text and background
- Ensure orange accents remain readable on dark surfaces
- Preserve visible focus states
- Do not rely on color alone for status or meaning
- Keep textured overlays subtle enough that text remains easy to read

## Anti-patterns

Reject or refactor UI that introduces:

- bright generic SaaS blues and greens as primary brand accents
- oversized rounded corners everywhere
- soft glassmorphism
- playful gradients
- pastel backgrounds
- low-contrast gray-on-gray text
- inconsistent heading casing
- card styles that feel consumer-mobile instead of operational
- uncontrolled Tailwind utility sprawl that breaks the design language

## Review checklist

When applying this skill, check for:

1. dark industrial visual tone is preserved
2. mono and technical typography style is respected
3. orange is used as a restrained accent, not everywhere
4. panels and shells use borders and dark layered surfaces
5. headings and labels follow uppercase, structured presentation
6. layout feels dense, operational, and intentional
7. tailwind classes support the established visual system
8. repeated patterns are extracted consistently
9. accessibility and focus visibility remain strong
10. no soft, generic, pastel, or playful design drift is introduced

## Output behavior

When reviewing or generating UI code with this skill:

- enforce the existing theme before suggesting new visual patterns
- point out where the markup or tailwind classes drift from the design system
- suggest rails-friendly partial or helper extraction when consistency is at risk
- prefer practical, repeatable UI patterns over one-off styling
- preserve the project's dark industrial identity across layouts, forms, tables, dashboards, and report pages
