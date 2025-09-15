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

# Codex helpers (examples — adjust as needed)
codex-login:
	@echo "Logging into Codex CLI (interactive)…"
	@codex login

codex-run:
	@echo "Running Codex CLI with API key auth (adjust command)…"
	@OPENAI_API_KEY=$$OPENAI_API_KEY codex --config preferred_auth_method="apikey" --help

.PHONY: help venv install lint format smoke codex-login codex-run