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
- `Makefile` → Common shortcuts: `venv`, `install`, `lint`, `format`, `smoke`, plus example Codex helpers.
- `.pre-commit-config.yaml` → Prettier + Tailwind plugin, Ruff, Black, and common hygiene hooks.
- `.editorconfig` → Editor consistency across IDEs (indentation, line endings).
- `.env.example` → Template for local secrets. Copy to `.env.local` (gitignored).
- `agent_manifest.yml` → Stack-aware bootstrap manifest for agents and humans.
- `docs/` → `security.md`, `state.md` (and `state-template.md`), and `APPLYING_TO_EXISTING_PROJECT.md`.
- `package.jsonc` → JSONC template with base scripts and devDependencies; rename to `package.json` when enabling Node flows.
- `.eslintrc.jsons` → Multi-profile ESLint template; choose the relevant block and save as `.eslintrc.json` in a project.
- `scripts/` → Placeholder for helper scripts.

## Quick Start
1. Review `agent_manifest.yml` to confirm the stack and setup instructions.
2. Follow `agents-template.md` in this template repo for detailed setup steps. If you’ve copied these files into a project, rename it to `agents.md` and follow that guide there.
3. Use the provided Makefile tasks or npm/yarn commands as documented in the guide.
4. Update this README with any project-specific instructions or deviations from the guide.
5. Extract and revise relevant sections from `agents-template.md` (or `agents.md` if renamed in a project) into this README for easier reference.

## Dependencies
See `agents-template.md` → **Quick Install Commands by Stack** for per-stack npm install lines.

## Contribution Notes
- Keep `docs/state.md` updated with progress and to-dos.
- Follow `docs/security.md` for secrets handling and incident response.
- Use [Conventional Commits](https://www.conventionalcommits.org) for commit messages.
