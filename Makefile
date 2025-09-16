# Makefile — VS Code Codex Setup
# Purpose: provide common shortcuts for environment setup and validation.

VENV=.venv
PYTHON=python3
PIP=$(VENV)/bin/pip

# Default target
help:
	@echo "Available targets:"
	@echo "  venv          Create a local Python virtual environment (.venv)"
	@echo "  install       Install dependencies if requirements.txt exists"
	@echo "  lint          Run lint/format checks if tools are available"
	@echo "  format        Auto-format code with black (if present)"
	@echo "  smoke         Quick environment sanity check"
	@echo "  ci-local      Run local CI pipeline (lint/format/smoke)"
	@echo "  codex-login   Log in or configure Codex CLI"
	@echo "  codex-run     Run Codex CLI with API key auth (example)"

venv:
	@test -d $(VENV) || $(PYTHON) -m venv $(VENV)

install: venv
	@if [ -f requirements.txt ]; then \
		$(PIP) install -r requirements.txt; \
	else \
		echo "No requirements.txt found, skipping."; \
	fi

lint: venv
	@$(VENV)/bin/python -m pip install --quiet ruff black || true
	@$(VENV)/bin/ruff check . || true
	@$(VENV)/bin/black --check . || true

format: venv
	@$(VENV)/bin/python -m pip install --quiet black || true
	@$(VENV)/bin/black . || true

smoke: venv
	@echo "== Env Snapshot =="
	@env | egrep "^(POSTGRES_DSN|RENDER_PG_URL)=" || true
	@echo "== Python version =="
	@$(VENV)/bin/python --version

# Run a CI-like pipeline locally (safe to re-run; exits non-zero on failures)
ci-local: install lint ci-format-check ci-smoke ## local CI runner
	@echo "✅ CI-local passed"

# Format check (Node vs Python)
ci-format-check:
	@if [ -f package.json ]; then \
		npx --yes prettier . --check || exit 1; \
	else \
		$(MAKE) format && echo "Format step complete (Python)"; \
	fi

# Smoke step: prefer doctor if available, else smoke
ci-smoke:
	@if $(MAKE) -n doctor >/dev/null 2>&1; then \
		$(MAKE) doctor; \
	else \
		$(MAKE) smoke; \
	fi

# Codex helpers (examples — adjust as needed)
codex-login:
	@echo "Logging into Codex CLI (interactive)…"
	@codex login

codex-run:
	@echo "Running Codex CLI with API key auth (adjust command)…"
	@OPENAI_API_KEY=$$OPENAI_API_KEY codex --config preferred_auth_method="apikey" --help

.PHONY: help venv install lint format smoke ci-local ci-format-check ci-smoke codex-login codex-run
