# Agents: Working In This Template Repo

Scope: This file guides AI agents operating inside this template repository (vs-code-codex-setup). It explains what to do here, what to ask the user, and how to bootstrap when these files are copied into a new project.

Important: This is a template. Do not rename `agents-template.md` here. When these files are copied into a project, rename it to `agents.md` in that project.

Agent Quickstart
- Read `agent_manifest.yml` to learn the intended stack (`stack.kind`) and conventions.
- Run `make ci-local` to validate the environment non-destructively. Steps skip gracefully when tools aren’t configured.
- Use the “Bootstrap (guide)” VS Code task or run `bash scripts/bootstrap-guide.sh` for a concise checklist and next actions.
- To apply safe defaults automatically, use the “Bootstrap (materialize)” task or run `bash scripts/bootstrap-materialize.sh`.

What To Ask The User (new project)
- Stack confirmation: “What is your stack.kind? astro | static | wordpress | evidence | python-etl?” If unknown, infer from files.
- Node materialization: “May I rename `package.jsonc` to `package.json` and run npm install?”
- ESLint config: “Which `.eslintrc.jsons` block should I save as `.eslintrc.json` (Static/WordPress, Astro, Evidence)?”
- Env loading: “Should I create `.env.local` from `.env.example` and, if using direnv, write `.envrc` with `dotenv .env.local`?”
- ETL env checks: “Do you want to enforce env vars? If so, I’ll set `REQUIRED_ENV` in the Makefile (e.g., `POSTGRES_DSN RENDER_PG_URL …`).”
- Tests: “Enable Node tests by adding `\"test\": \"node --test\"` to `package.json`? Install pytest for Python tests?”
- Hooks: “Install pre-commit hooks now (`pre-commit install`), so `ci-local` runs before commits?”

Bootstrap Actions (non-destructive by default)
- Node: If user approves, rename `package.jsonc` → `package.json`, then `npm install`.
- ESLint: Create `.eslintrc.json` from the chosen block in `.eslintrc.jsons`.
- Env: Copy `.env.example` → `.env.local` and optionally add `.envrc` with `dotenv .env.local` (then run `direnv allow`).
- CI: Run `make ci-local`. If failures occur, surface logs and propose fixes.
- Tests: For Node, add a `test` script; for Python, ensure `pytest` is installed and keep `tests/` scaffold.

Materialize Script Behavior
- `.envrc`: creates from `.envrc.template` if missing.
- Node stacks (astro/static/wordpress/evidence):
  - If `package.json` exists, ensures `test` and `test:watch` scripts are present.
  - If only `package.jsonc` exists, writes a minimal `package.json` with test scripts enabled and base devDependencies; user should run `npm install` next.

Safety & Style
- Prefer Makefile and VS Code tasks over ad-hoc commands.
- Keep changes minimal; ask before destructive actions (rename/install). 
- Document decisions in `docs/state.md` when applied to a real project.
