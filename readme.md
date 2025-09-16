# VS Code Codex Setup

This repository contains configuration, templates, and helpers for working with Codex in VS Code.

## Key Docs
- **agents-template.md** → Human- and agent-readable guide for setting up environments across stacks (Astro, WordPress, Python ETL, Evidence). In this template repo it remains `agents-template.md`. When you copy these files into a project, rename it to `agents.md` for easier discovery.
- **agent_manifest.yml** → Machine-readable manifest defining stack type, env loader, venv usage, and default tasks. Agents can parse this file to auto-bootstrap a new project.
- **docs/state.md** → Living log of project state, completed work, and to-dos for both humans and agents.
- **docs/security.md** → Security policy, secrets management, and incident response guide.
- **docs/APPLYING_TO_EXISTING_PROJECT.md** → Step-by-step guide for integrating these starter files into an existing project.

## What’s Included
- `.vscode/settings.json` and `.vscode/tasks.json` → Prettier-on-save, ESLint integration, and one-click tasks for `make lint`, `make format`, `make smoke`.
- VS Code tasks: “Bootstrap (guide)”, “Bootstrap (materialize)”, and “Promote to Root (non-destructive)” to help agents/users initialize and merge into existing projects quickly.
- `Makefile` → Common shortcuts: `venv`, `install`, `lint`, `format`, `smoke`, plus example Codex helpers.
- `Makefile (CI-local & env checks)` → `make ci-local` chains install → lint → format-check → optional env check → optional tests → smoke. Configure required env vars by setting `REQUIRED_ENV` in a project; run `make check-env` to validate.
- `.pre-commit-config.yaml` → Prettier + Tailwind plugin, Ruff, Black, and common hygiene hooks.
- `.editorconfig` → Editor consistency across IDEs (indentation, line endings).
- `.env.example` → Template for local secrets. Copy to `.env.local` (gitignored).
- `.envrc.template` → Minimal direnv config (`dotenv .env.local`).
- `agent_manifest.yml` → Stack-aware bootstrap manifest for agents and humans.
- `docs/` → `security.md`, `state.md` (and `state-template.md`), and `APPLYING_TO_EXISTING_PROJECT.md`.
- `package.jsonc` → JSONC template with base scripts and devDependencies; rename to `package.json` when enabling Node flows.
- `.eslintrc.jsons` → Multi-profile ESLint template; choose the relevant block and save as `.eslintrc.json` in a project.
- `scripts/` → Placeholder for helper scripts.
  - `scripts/promote-to-root.sh` → Non-destructive helper to copy/merge this folder’s assets to the project root.

## Getting Started
- Default workflow: drop this folder into an existing project, then promote/merge files to the project root.

1. Copy this folder into the project root as `my-project/vs-code-codex-setup/`.
2. In `vs-code-codex-setup/agent_manifest.yml`, set `project_name` and `stack.kind` (astro | static | wordpress | evidence | python-etl).
3. Ask your agent to review `vs-code-codex-setup/agents-template.md` and `AGENTS.md` to plan promotion/merges.
4. Promote/merge to the project root (don’t overwrite without review):
   - `.vscode/`, `.editorconfig`, `.pre-commit-config.yaml`, `Makefile`, `docs/`, `AGENTS.md`.
   - `.envrc` (from `.envrc.template`).
   - `agents-template.md` → rename to `agents.md` at the project root.
5. Node projects: keep the existing `package.json`; use `package.jsonc` only as a reference. Optionally add `"test": "node --test"` to enable Node’s test runner.
6. ESLint: choose a block in `.eslintrc.jsons` and save it as root `.eslintrc.json`.
7. Validate from the project root:
   - Create `.env.local` from `.env.example` and fill values.
   - Run the “Bootstrap (guide)” task to confirm setup, then “CI (local)” or `make ci-local`.
   - Optional: use the “Promote to Root (non-destructive)” VS Code task to copy missing files and get a merge checklist.

Tip: You can run the VS Code task “Promote to Root (non-destructive)” or execute `bash vs-code-codex-setup/scripts/promote-to-root.sh` from the project root to copy missing files safely and list what needs manual merging.

- Alternative (new project): use this folder as the project root, then follow steps 2, 4–7 above (skip promotion/merge).

## Local CI and Env Checks
- Run `make ci-local` to validate formatting, linting, environment, tests, and a smoke step locally with fail-fast behavior.
- Env validation: set `REQUIRED_ENV` in your project (Makefile or shell) to enforce required variables. Example:
  - `REQUIRED_ENV = POSTGRES_DSN RENDER_PG_URL STRIPE_SECRET_KEY`
- Manual check: `make check-env` prints which variables are set and fails if any are missing.

## Tests Scaffolding
- Node (built-in runner)
  - Template test at `tests/node/smoke.test.js`.
  - Enable by adding scripts to your `package.json` (uncomment in `package.jsonc`):
    - `"test": "node --test"`
    - `"test:watch": "node --test --watch"`
  - `make ci-local` runs `npm test` only if a `test` script exists.
- Python (pytest)
  - Template test at `tests/test_sanity.py`.
  - `make ci-local` runs `pytest -q` if pytest is available and `tests/` exists.
- See `tests/README.md` for quick usage notes.

## Quick Start
- Copy `vs-code-codex-setup/` into your repo root → set `project_name` + `stack.kind` → promote `.vscode/`, `.editorconfig`, `.pre-commit-config.yaml`, `Makefile`, `docs/`, `.envrc` (from template), and rename `agents-template.md` → `agents.md` at root → create `.env.local` → run “Bootstrap (guide)” then “CI (local)”.

## Dependencies
See `agents-template.md` → **Quick Install Commands by Stack** for per-stack npm install lines.

## Contribution Notes
- Keep `docs/state.md` updated with progress and to-dos.
- Follow `docs/security.md` for secrets handling and incident response.
- Use [Conventional Commits](https://www.conventionalcommits.org) for commit messages.
