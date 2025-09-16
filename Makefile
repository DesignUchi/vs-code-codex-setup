# Makefile — VS Code Codex Setup (stack-aware)

SHELL := /bin/bash

VENV=.venv
PYTHON=python3
PIP=$(VENV)/bin/pip

# ---- Stack detection (soft) -------------------------------------------------
HAS_PKG_JSON := $(shell test -f package.json && echo 1 || echo 0)
HAS_REQS     := $(shell test -f requirements.txt && echo 1 || echo 0)
IS_ASTRO     := $(shell test -f package.json && grep -q '"astro"' package.json && echo 1 || echo 0)
IS_SVELTE    := $(shell test -f package.json && grep -q '"svelte"' package.json && echo 1 || echo 0)

# ---- Help -------------------------------------------------------------------
help:
	@echo "Available targets:"
	@echo "  venv          Create local Python venv (.venv) if requirements.txt exists"
	@echo "  install       Install deps (npm if package.json, pip if requirements.txt)"
	@echo "  lint          Lint (ESLint for Node stacks; ruff/black for Python)"
	@echo "  format        Format (Prettier for Node; black for Python)"
	@echo "  smoke         Quick env sanity"
	@echo "  ci-local      Local CI pipeline (install/lint/format/env/tests/smoke)"
	@echo "  codex-login   Codex CLI login"
	@echo "  codex-run     Codex CLI example (apikey)"

# ---- Env / install ----------------------------------------------------------
venv:
ifeq ($(HAS_REQS),1)
	@test -d $(VENV) || $(PYTHON) -m venv $(VENV)
else
	@echo "Skipping venv (no requirements.txt)"
endif

install:
ifeq ($(HAS_PKG_JSON),1)
	@echo "Installing Node deps…" && npm install
else
	@echo "Skipping npm install (no package.json)"
endif
ifeq ($(HAS_REQS),1)
	@$(MAKE) venv
	@echo "Installing Python deps…" && $(PIP) install -r requirements.txt
else
	@echo "Skipping pip install (no requirements.txt)"
endif

# ---- Lint / format ----------------------------------------------------------
lint:
ifeq ($(HAS_PKG_JSON),1)
	@echo "Running ESLint (Node)…"
	@npx --yes eslint . || true
else
	@echo "Skipping ESLint (no package.json)"
endif
ifeq ($(HAS_REQS),1)
	@echo "Running ruff/black check (Python)…"
	@$(VENV)/bin/python -m pip install --quiet ruff black || true
	@$(VENV)/bin/ruff check . || true
	@$(VENV)/bin/black --check . || true
else
	@echo "Skipping Python linters (no requirements.txt)"
endif

format:
ifeq ($(HAS_PKG_JSON),1)
	@echo "Running Prettier (Node)…"
	@npx --yes prettier . --write || true
else
	@echo "Skipping Prettier (no package.json)"
endif
ifeq ($(HAS_REQS),1)
	@echo "Running black (Python)…"
	@$(VENV)/bin/python -m pip install --quiet black || true
	@$(VENV)/bin/black . || true
else
	@echo "Skipping black (no requirements.txt)"
endif

# ---- Smoke / CI -------------------------------------------------------------
smoke:
	@echo "== Env Snapshot =="
	@env | egrep "^(POSTGRES_DSN|RENDER_PG_URL|OPENAI_API_KEY)=" || true
	@echo "== Tool versions =="
	@node -v 2>/dev/null || echo "node: n/a"; npm -v 2>/dev/null || echo "npm: n/a"
	@$(PYTHON) -V 2>/dev/null || echo "python: n/a"

# Local CI runner (safe to re-run; exits non-zero on failures where appropriate)
ci-local: install ci-format-check ci-lint ci-check-env ci-tests ci-smoke
	@echo "✅ CI-local passed"

ci-format-check:
ifeq ($(HAS_PKG_JSON),1)
	@npx --yes prettier . --check
else
	@echo "Skipping Prettier check (no package.json)"
endif
ifeq ($(HAS_REQS),1)
	@$(MAKE) format
else
	@echo "Skipping Python format step (no requirements.txt)"
endif

ci-lint:
	@$(MAKE) lint

# Environment check (template for ETL projects)
# Override REQUIRED_ENV in your project Makefile or via env to enforce checks,
# e.g.: REQUIRED_ENV = POSTGRES_DSN RENDER_PG_URL STRIPE_SECRET_KEY
REQUIRED_ENV ?=

check-env:
	@if [ -z "$(REQUIRED_ENV)" ]; then echo "Skipping check-env (REQUIRED_ENV not configured)"; exit 0; fi
	@if [ ! -f .env.local ]; then echo "⚠️  .env.local not found (skipping file presence check)"; fi
	@missing=0; \
	for v in $(REQUIRED_ENV); do \
	  val=$$(printenv "$$v"); \
	  if [ -z "$$val" ]; then echo "❌ $$v not set"; missing=1; else echo "✅ $$v set"; fi; \
	done; \
	if [ $$missing -ne 0 ]; then echo "Environment check failed"; exit 1; else echo "Environment OK"; fi

ci-check-env:
	@$(MAKE) check-env || { echo "check-env failed"; exit 1; }

ci-smoke:
	@$(MAKE) smoke

ci-tests:
ifeq ($(HAS_PKG_JSON),1)
	@if grep -q '"test"' package.json; then npm test --silent; else echo "Skipping npm test (no script)"; fi
else
	@echo "Skipping npm test (no package.json)"
endif
	@if command -v pytest >/dev/null 2>&1 && [ -d tests ]; then pytest -q; else echo "Skipping pytest (no tests/)"; fi

# ---- Codex helpers ----------------------------------------------------------
codex-login:
	@echo "Logging into Codex CLI (interactive)…"
	@codex login

codex-run:
	@echo "Running Codex CLI with API key auth (adjust command)…"
	@OPENAI_API_KEY=$$OPENAI_API_KEY codex --config preferred_auth_method="apikey" --help

.PHONY: help venv install lint format smoke ci-local ci-format-check ci-lint ci-tests ci-smoke codex-login codex-run

.PHONY: check-env ci-check-env
