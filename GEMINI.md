# GEMINI.md - Project Context

This file provides instructional context for Gemini CLI when working in this project.

## Project Overview

- **Name:** PMS (Performanance Review System)
- **Description:** A system where HR launches a review cycle, peers and managers submit anonymous feedback via
secure magic links, and the system automatically generates a branded PDF report. HR can
reduce review administration time by 60–80%, restore trust in the peer feedback process,
and scale reviews without manual overhead.
- **Type:** Ruby on Rails 8.1.2 Application
- **Architecture:** Modern Rails Monolith with Hotwire (Turbo/Stimulus) and SQLite.
- **Primary Technologies:**
  - **Framework:** Rails 8.1.2
  - **Database:** SQLite 3 (used for Primary, Cache, Queue, and Action Cable)
  - **Frontend:** Hotwire (Turbo, Stimulus), Importmaps, Propshaft (Asset Pipeline)
  - **Background Jobs:** Solid Queue
  - **Caching:** Solid Cache
  - **Real-time:** Solid Cable
  - **Deployment:** Kamal (Docker-based)
  - **Web Server:** Puma + Thruster (HTTP asset caching/compression)

## Building and Running

### Prerequisites
- Ruby (check `.ruby-version` for exact version, likely 3.4.x)
- SQLite 3
- Docker (for deployment/testing Kamal setup)

### Core Commands
- **Setup:** `bin/setup` (installs gems, creates/seeds databases)
- **Development Server:** `bin/dev` (runs Puma and asset watchers)
- **Testing:** `bin/rails test` (unit/integration) and `bin/rails test:system` (system tests)
- **Console:** `bin/rails console`
- **Database Migrations:** `bin/rails db:migrate`

### Maintenance & Security
- **Linting:** `bin/rubocop` (uses `rubocop-rails-omakase`)
- **Security Audit:** `bin/brakeman` and `bin/bundler-audit`
- **Deployment:** `bin/kamal deploy`

## Development Conventions

- **Rails Omakase:** Follow standard Rails conventions and the "Omakase" styling for Ruby.
- **Database-Backed Services:** This project uses the "Solid" suite (Solid Cache, Solid Queue, Solid Cable) to run everything on SQLite, avoiding the need for Redis or other sidecar services in small-to-medium deployments.
- **Frontend:** Avoid heavy JS frameworks. Use Stimulus controllers for light interactivity and Turbo for navigation/page updates.
- **Deployment:** Managed via `config/deploy.yml`. Production uses SQLite databases stored in persistent Docker volumes (`/rails/storage`).
- **Puma Config:** Solid Queue is configured to run inside the Puma process in development/production by default (`SOLID_QUEUE_IN_PUMA: true`).

## Key Directories

- `app/controllers/`: Application logic controllers.
- `app/models/`: Data models and business logic.
- `app/views/`: ERB templates and PWA manifests.
- `app/javascript/controllers/`: Stimulus controllers.
- `config/`: Application configuration (routes, database, deployment).
- `db/`: Database migrations and seeds. Note separate migration paths for cache/queue/cable in production.
- `storage/`: Local development SQLite databases and Active Storage files.
