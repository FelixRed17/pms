# Repository Guidelines

## Project Structure & Module Organization
This repository is a Rails 8 application for the Performance Review System. Core MVC code lives in `app/`: controllers in `app/controllers`, models in `app/models`, views in `app/views`, mailers in `app/mailers`, jobs in `app/jobs`, and shared front-end behavior in `app/javascript/controllers` via Stimulus. Stylesheets live in `app/assets/stylesheets`, and public static files live in `public/`. Database setup and seeds are under `db/`. Tests follow Rails defaults in `test/`, with subfolders such as `test/models`, `test/controllers`, and `test/integration`.

## Build, Test, and Development Commands
Use the provided scripts instead of ad hoc commands when possible:

- `bin/setup` installs gems, prepares the database, clears logs/tmp files, and starts the server.
- `bin/setup --skip-server` performs setup only; useful for CI or a clean local reset.
- `bin/dev` starts the Rails server.
- `bin/rails db:prepare` creates and migrates the local database.
- `bin/rails test` runs the Minitest suite.
- `bin/ci` runs the full local quality gate: setup, RuboCop, security audits, tests, and seed validation.

## Coding Style & Naming Conventions
Follow standard Rails conventions: singular model names (`EmployeeReview`), plural controllers (`ReviewsController`), and RESTful routes. Ruby style is enforced with `rubocop-rails-omakase`; run `bin/rubocop` before opening a PR. Prefer 2-space indentation in Ruby files and keep method names, variables, and file names in `snake_case`. Keep Stimulus controllers named `*_controller.js` under `app/javascript/controllers`.

## Testing Guidelines
This project uses Minitest with fixtures enabled in `test/test_helper.rb`. Add unit tests next to the layer you change, for example `test/models/...` for model logic or `test/integration/...` for request flows. Name test files with the `_test.rb` suffix. Run `bin/rails test` locally before pushing; if you touch seed data or onboarding flows, also run `env RAILS_ENV=test bin/rails db:seed:replant`.

## Commit & Pull Request Guidelines
Recent history uses short, imperative commit messages such as `Add detailed description to README.md`. Keep that pattern: start with a verb, describe one logical change, and avoid noisy WIP commits. PRs should include a concise summary, note any schema or seed changes, link the relevant issue if one exists, and add screenshots for UI changes.

## Security & Configuration Tips
Do not commit secrets or decrypted credentials. Review changes against the existing security checks in `bin/ci`, especially `bin/brakeman`, `bin/bundler-audit`, and `bin/importmap audit`.
