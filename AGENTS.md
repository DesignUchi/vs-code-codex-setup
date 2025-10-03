# Agents: Working In This Template Repo

Scope: This file guides AI agents operating inside this template repository (vs-code-codex-setup). It explains what to do here, what to ask the user, and how to bootstrap when these files are copied into a new project.

Important: This is a template. Do not rename `agents-template.md` here. When these files are copied into a project, rename it to `agents.md` in that project.

Agent Quickstart
- Read `agent_manifest.yml` to learn the intended stack (`stack.kind`) and conventions.
- Run `make ci-local` to validate the environment non-destructively. Steps skip gracefully when tools aren’t configured.
- Use the “Bootstrap (guide)” VS Code task or run `bash scripts/bootstrap-guide.sh` for a concise checklist and next actions.
- To apply safe defaults automatically, use the “Bootstrap (materialize)” task or run `bash scripts/bootstrap-materialize.sh`.
- For existing projects, prefer the “Promote to Root (non-destructive)” task (or `bash vs-code-codex-setup/scripts/promote-to-root.sh`) to copy missing files and get a merge checklist before making changes.
 - Note: Some VS Code tasks use `direnv exec .`. If direnv isn’t installed, run the underlying Make targets directly (e.g., `make ci-local`).

What To Ask The User (new project)
- Stack confirmation: “What is your stack.kind? astro | static | wordpress | evidence | python-etl?” If unknown, infer from files.
- Node materialization: “May I rename `package.jsonc` to `package.json` and run npm install?”
- ESLint config: “Which `.eslintrc.jsons` block should I save as `.eslintrc.json` (Static/WordPress, Astro, Evidence)?”
- WordPress layout: “Should we keep the WordPress webroot inside a subfolder such as `site/` so tooling/docs can stay at the repo root and subtree-style deploys remain easy?”
- WordPress helper scripts: “Do you want to use the bundled scripts under `scripts/wp/`? If so, which SSH host/DB credentials should I configure before running them? Also confirm local ports before standing up Docker (defaults assume 3307 for DB and 8181 for HTTP).”
- WordPress git/SSH: “Do we already have SSH aliases and bare repos? If not, should I create an alias (e.g., `wp-prod`), `git init` in the project root (not the webroot), and set up a bare repo under `~/git/` so `.git/` never lives in the public directory?”
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

Promote-to-root Behavior (existing projects)
- Non-destructive: copies missing files/dirs; prints a manual merge checklist for items that already exist.
- Typical items: `.vscode/`, `.editorconfig`, `.pre-commit-config.yaml`, `Makefile`, `docs/`, `AGENTS.md`, `.envrc.template`, `.env.example`, `agents-template.md`, `agent_manifest.yml`, `.eslintrc.jsons`, `package.jsonc`.
- After promotion, ask before merging `.vscode/tasks.json`, `.pre-commit-config.yaml`, `Makefile` targets, and converting `agents-template.md` → `agents.md` at the project root.

Safety & Style
- Prefer Makefile and VS Code tasks over ad-hoc commands.
- Keep changes minimal; ask before destructive actions (rename/install). 
- Document decisions in `docs/state.md` when applied to a real project.

## WordPress Git/SSH Setup Checklist
- **Local repo:** run `git init` in the project root (keep `.git/` out of the public webroot), add the WordPress ignore patterns from the template, then commit and push to GitHub.
- **SSH alias:** add a host entry such as `wp-prod` in `~/.ssh/config` so `ssh wp-prod` lands in the production account.
- **Server bare repo:** on the host, create `~/git/` and run `git init --bare ~/git/<project>.git`. Leave the live `public_html`/webroot untouched so `.git/` never lives there.
- **Configure remotes:** locally run `git remote add prod ssh://wp-prod/~/git/<project>.git`. Stay on a `site/` subtree (or similar) so only deployable files push to production.
- **Deploy alias:** configure the `git deploy` alias (supports `--dry-run`, `--progress`) to run a subtree push followed by a remote `git checkout -f`. Test with `git deploy --dry-run --progress prod` before doing the real push.
- **First publish:** after a successful dry run, run `git deploy --progress prod`, then verify the site before further work.
