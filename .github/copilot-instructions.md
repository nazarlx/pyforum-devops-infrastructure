# Copilot / AI Agent Instructions — PyForum

Purpose: give an AI coding agent the minimum, actionable knowledge to be productive in this repo.

- **Big picture**: This is a Django monolith (project: `forum_sandbox`) composed of small apps (`authentication`, `profiles`, `administration`). It exposes a REST API (Django REST Framework + Djoser) and serves templates/static assets. Runtime is a 3-service stack: web (Gunicorn + Django), PostgreSQL, and nginx for static/media. Infrastructure and observability are managed under `terraform/` and `monitorring/`.

- **Auth & API**: token authentication (DRF Token) and Djoser are used. Custom user model: `authentication.CustomUser` (see `authentication/models.py`). Permission decisions are often done at view level (settings default is `AllowAny`).

- **How the app starts**: container entry runs `wait-for-db.sh`, then `manage.py migrate`, `collectstatic`, and `gunicorn forum_sandbox.wsgi:application` (see `docker-compose.dev.yml` and `gunicorn.conf.py`). Static files are served via Whitenoise in the app and via nginx in production compose.

- **Key files to inspect**:
  - [README.md](README.md) — developer notes and env vars
  - [forum_sandbox/settings.py](forum_sandbox/settings.py) — central config (decouple/env-driven)
  - [Dockerfile](Dockerfile) and [docker-compose.dev.yml](docker-compose.dev.yml) — container build/run flow
  - [wait-for-db.sh](wait-for-db.sh) — DB readiness
  - [gunicorn.conf.py](gunicorn.conf.py) — runtime worker/thread settings
  - [requirements.txt](requirements.txt) — pinned libs
  - `authentication/`, `profiles/`, `administration/` — example app structure (views/serializers/models)

- **Local developer workflows (explicit commands)**
  - Install deps: `pip install -r requirements.txt`
  - Create `.env` with keys from `README.md` (SECRET_KEY, PG_* vars, EMAIL_*) — `settings.py` uses python-decouple
  - DB + migrations:
    - Load dump (if provided): `psql -U postgres -d forum < dump_forum.sql`
    - `python manage.py makemigrations` then `python manage.py migrate`
  - Create admin: `python manage.py createsuperuser`
  - Run dev server: `python manage.py runserver`
  - Run tests: `python manage.py test` (note: `settings.py` switches to fast MD5 hasher during tests)

- **Docker / containerized dev**
  - Quick: `docker build -t pyforum:dev . && IMAGE_TAG=dev docker compose -f docker-compose.dev.yml up`
  - Compose entrypoint relies on `.env.prod` in compose file; for local runs create an env-file matching the expected keys.
  - Healthcheck endpoint for the web service is expected at `/health/` (see compose healthcheck).

- **Conventions & project-specific patterns**
  - Apps are small and named lowercase; add to `INSTALLED_APPS` in `forum_sandbox/settings.py` to enable.
  - API serializers live in `*/serializers.py`, views in `*/views.py`, and URL wiring in `*/urls.py`.
  - View-level permissions are preferred — settings use `AllowAny` globally; secure endpoints should explicitly set permissions.
  - Environment-driven configuration: prefer adding new sensitive config to env and access via `decouple.config()`.

- **Integration points / infra**
  - PostgreSQL (see `docker-compose.dev.yml` / `postgres.tf` in `terraform/`).
  - SMTP is env-configured; tests may require mocks or local SMTP stub.
  - Monitoring and logging: `monitorring/` and `terraform/` contain Prometheus/Grafana/cadvisor pieces; app logs go to `logs/django.log` (settings).

- **Debug & troubleshooting tips**
  - If static files are missing, run `python manage.py collectstatic` and check `STATIC_ROOT` / `STATICFILES_DIRS` in `settings.py`.
  - Check `logs/django.log` for server-side exceptions; Gunicorn logs are configured to stdout.
  - Ensure DB env vars match `settings.py` keys: `PG_DB`, `PG_USER`, `PG_PASSWORD`, `DB_HOST`, `DB_PORT`.

- **When you change code**
  - Add the app to `INSTALLED_APPS` and create migrations: `makemigrations` → `migrate`.
  - Update API serializers and register URLs in the app `urls.py` and include them from `forum_sandbox/urls.py`.

If any of these sections are unclear or you want more examples (typical PR edits, test authoring pattern, or infra deploy steps), tell me which area to expand or validate and I'll iterate.
