# Review Access UI Reference

Use this feature directory for all participant magic-link entry screens.

## Where this belongs

- Route entry: `config/routes.rb`
- Controller: `app/controllers/review_access_controller.rb`
- Invalid or expired page: `app/views/review_access/invalid.html.erb`
- Active link landing page: `app/views/review_access/show.html.erb`
- Success page after consume: `app/views/review_access/confirmation.html.erb`
- Shared page styling: `app/assets/stylesheets/styles.css`

Keep these screens under `review_access` because they represent the magic-link access flow, not a generic application error state.

## When to use `invalid.html.erb`

Render this page when the submitted token cannot be used anymore, for example:

- the token does not exist
- the token is expired
- the token was already consumed
- the session scope was tampered with or no longer matches

That behavior is already wired in `ReviewAccessController`.

## UI structure

For this screen, keep the page focused and operational:

- one strong heading explaining the link is unavailable
- one short explanation of why that may happen
- one small list of next steps
- one security note reinforcing why the link cannot be reused

Avoid putting review-role-specific copy here. The link itself is generic access, while the underlying review assignment decides whether the participant is completing a self, peer, or manager review.

## Styling guidance

This repository currently has a shared CSS theme in `app/assets/stylesheets/styles.css`. If Tailwind is added later, keep the same file placement and feature boundaries:

- markup stays in `app/views/review_access/*.html.erb`
- reusable styling should still be centralized
- avoid scattering magic-link state styles across unrelated features

Follow the existing visual system:

- dark background
- sharp borders
- uppercase labels
- restrained orange accent
- dense but readable panel layout

## Implementation pattern

1. Add or update the view in `app/views/review_access/invalid.html.erb`.
2. Add shared classes in `app/assets/stylesheets/styles.css`.
3. Keep controller logic in `ReviewAccessController` limited to deciding when the page is shown.
4. Keep role-specific review logic out of this view.

## If Tailwind is introduced

If you later install Tailwind, use utility classes for layout and spacing, but keep any repeated magic-link patterns extracted into a partial or shared component. The location should still remain within the `review_access` feature.
