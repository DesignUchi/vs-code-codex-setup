# AGENTS Guidelines for This Repository

This repository may include different types of projects (static HTML/CSS, WordPress, Astro, Python ETL jobs).  
When working interactively with an AI agent (e.g. Codex in VS Code), follow these guidelines to keep the development workflow fast, consistent, and reliable.

---

## 🔖 Agent Bootstrap Manifest

This repository also includes a machine-readable configuration file:

- File: **`agent_manifest.yml`** (repo root)  
- Purpose: Defines stack type (Astro, WordPress, Python ETL, etc.), environment loader (`direnv`/`dotenv`), venv usage, dependencies, and default tasks.  
- Agents should parse this file to auto-bootstrap the environment. Humans can read it as a compact reference for what setup steps apply.  

> Example: if `stack.kind = python-etl` and `python.use_venv = true`, then create `.venv/` and run `make venv && make install`.  
> If `stack.kind = astro`, run `npm install && npm run dev`.

---

## 🚀 Getting Started Checklist
> 📌 In this template repository, this file is named **`agents-template.md`**. When you copy these files into a project, **rename it to `agents.md`** so humans and agents can discover it faster.

1. Clone the repository.  
2. Create a `.env.local` with secrets (do not commit).  
   - Copy from `.env.example` and fill in real values.  
3. Run the install command that matches your stack (see table above).  
   - Agents: read from `agent_manifest.yml`.  
   - Humans: copy the line manually.  
4. Start the dev server (`npm run dev`, Evidence, Astro, or local WP).  
   - For Python ETL: run `make venv && make install` then the appropriate `make` target.  
5. Validate setup with lint/format checks before committing.  
   - JS/TS: `npm run lint` / `npm run format`  
   - WordPress PHP: `phpcs --standard=WordPress`  
   - Python ETL: `make check-env`  
6. Run a quick smoke test to confirm setup:  
   - JS/TS: `npm run lint && npm run format:check`  
   - WordPress: `phpcs --standard=WordPress`  
   - Python ETL: `make doctor`
7. Commit with a semantic message (see section below).

### 📎 Applying to an existing project
- Drop this folder into your repo as `vs-code-codex-setup/`.
- Use the VS Code task “Promote to Root (non-destructive)” (or run `bash vs-code-codex-setup/scripts/promote-to-root.sh`) to copy missing files and list merge steps.
- Then follow the README “Getting Started” section to finalize setup.
---

## 1. Use the Development Server (when available)

- **Astro projects**:  
  - Always use `npm run dev` for local development. This starts Astro in dev mode with hot module reload (HMR).  
  - Avoid `npm run build` during interactive sessions; it’s slower and not needed while iterating. Only use `npm run build` to test production output.

- **Static sites (plain HTML/CSS/JS)**:  
  - You can serve the site with a simple dev server (`npx serve`, `python3 -m http.server`, or VS Code Live Server).  
  - Iteration is usually direct file editing; no build step required.  

- **WordPress sites**:  
  - Use a local dev environment (e.g. Local WP, Docker, or MAMP).  
  - Do not modify files directly on production servers. Sync or export/import changes only after testing locally.
  - Keep the WordPress install inside a dedicated subfolder (for example `site/`) so repo tooling/doc files stay at the root and subtree-style deploys are simpler.
- If you copy the provided Docker stack (`docker-compose.yml` + `docker/nginx/default.conf`), adjust environment variables, passwords, and exposed ports (defaults assume 3307/8181; pick unused values).
  - If you copy the provided Docker stack (`docker-compose.yml` + `docker/nginx/default.conf`), adjust container names, environment variables, passwords, and exposed ports (defaults assume `wordpress/wordpress_pass`, 3307, and 8181; rename as needed).
  - Update any scripts copied from `scripts/wp/` (SSH hostnames, database names/passwords, etc.) before running them.

- **Evidence projects (Svelte-based)**:
  - Use `npm run dev` to start the Evidence dev server. This enables hot module reload (HMR) for dashboards and charts.
  - Avoid `npm run build` during interactive sessions; only use it to test static production output before deployment.

- **Svelte projects (general)**:
  - ⚠️ Placeholder: If creating standalone Svelte apps in the future, add detailed agent instructions here.

---

## 2. Keep Dependencies in Sync

> Agents: prefer to read `agent_manifest.yml` for the exact `npm install` or `make` commands.
> Humans: follow the stack-specific steps below.

- **Astro or Node-based projects**:
  1. If you add or update dependencies, run `npm install` (or `pnpm install`, `yarn install`) at the project root.  
  2. Restart the dev server so changes take effect.  
  3. Commit updates to `package-lock.json` (or equivalent) to keep versions consistent.

- **WordPress**:
  - Track PHP or plugin dependencies separately (e.g. with Composer if in use).  
  - Document plugin versions in `README.md` or `agents.md` to avoid mismatches.

- **Evidence**:
  - Dependencies are managed via npm (like other Node projects). Run `npm install` after adding or updating packages.
  - Restart the Evidence dev server after dependency changes.

---

## 3. Linting & Formatting

- **Astro or Node-based projects**:
  - Run ESLint to catch errors:
    - Check: `npm run lint`  
    - Auto-fix: `npm run lint:fix`
  - Prettier ensures consistent style:
    - Format all: `npm run format`  
    - Check formatting: `npm run format:check`
  - Config files:
    - ESLint: `.eslintrc.json` (preferred; repo root)
    - Prettier: `.prettierrc` (repo root)

- **Static HTML/CSS**:  
  - Use Prettier for formatting HTML, CSS, and JS.  
  - Consider Stylelint for CSS consistency.

- **WordPress**:  
  - Use [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) with WordPress coding standards.  
  - Prettier can still be used for JS/CSS inside themes or plugins.

- **Evidence (Svelte-based)**:
  - Use Prettier for formatting `.svelte` files in addition to JS/TS.
  - ESLint can be configured to cover `.svelte` files using the appropriate plugin.

---

## 4. Coding Conventions

- Prefer **TypeScript** for Astro or Node components/utilities.  
- Co-locate styles with components where practical.  
- For WordPress:
  - Follow WP coding standards for PHP.  
  - Separate custom theme functions, templates, and styles cleanly.  
- For static sites:
  - Keep assets organized (`/css`, `/js`, `/images`).  
  - Use semantic HTML structure.

---

## 5. Environment Setup (direnv & venv)

- **direnv**:  
  - Install: `brew install direnv` (macOS) or your package manager.  
  - Hook into your shell (zsh example):  
    ```bash
    echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
    exec zsh
    ```
  - Create a `.env.local` with your secrets (gitignored).  
  - Add a `.envrc` in project root:  
    ```bash
    dotenv .env.local
    # Add any exports or aliases here
    export POSTGRES_DSN="$RENDER_PG_URL"
    ```
  - Run `direnv allow` to trust changes.  

- **Python venv (if project uses Python)**:  
  - Standardize on a local `.venv/` directory for Python projects.  
  - Example setup:  
    ```bash
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    ```

### Env checks (ETL projects)
- Use `make check-env` to validate required environment variables before running jobs.
- Configure which variables are required by setting `REQUIRED_ENV` in your project (Makefile or shell), for example:
  - `REQUIRED_ENV = POSTGRES_DSN RENDER_PG_URL STRIPE_SECRET_KEY`
- `make ci-local` includes this check via `ci-check-env` and fails fast if any required variable is missing.
- After copying this template into a project, run `direnv allow` (if using direnv) followed by `direnv exec . pre-commit install` so the bundled hooks (ruff, black, prettier, ci-local) run automatically before commits.

---

## 6. Useful Commands Recap
> Tip: Run `make help` to list all available Makefile targets in this repository.

| Project type       | Command / Action                  | Purpose                                         |
| ------------------ | --------------------------------- | ----------------------------------------------- |
| Astro              | `npm run dev`                     | Start Astro dev server with HMR                 |
| Astro              | `npm run build`                   | Build production output (check only, not during active dev) |
| Astro              | `npm run lint` / `npm run lint:fix` | Run ESLint checks and auto-fix issues           |
| Astro              | `npm run format` / `npm run format:check` | Format code with Prettier                      |
| Static site        | `npx serve` / Live Server         | Local dev server for HTML/CSS/JS                |
| WordPress          | Local WP / Docker / MAMP          | Run site locally, test theme/plugin changes     |
| Evidence           | `npm run dev`                     | Start Evidence dev server with HMR             |
| Evidence           | `npm run build`                   | Build static production output (dashboards)    |
| Evidence           | `npm run format` / `npm run lint` | Format or lint Svelte/JS/TS files              |
| Python ETL jobs    | `make venv && make install`       | Create venv and install all dependencies        |
| Python ETL jobs    | `make drip` / `make stripe` / `make square` / `make ga` | Run ETL sync jobs with checkpoints |
| Python ETL jobs    | `make webhook`                    | Run FastAPI webhook locally via Uvicorn         |
| Python ETL jobs    | `make health`                     | Run healthcheck job                             |
| Python ETL jobs    | `make check-env` / `make doctor`  | Validate env vars / check system tools          |
| WordPress (PHP)    | `phpcs --standard=WordPress`      | Run WordPress coding standards check            |

---

Following these practices ensures that both you and AI agents can work effectively across project types (Astro, static sites, WordPress, Python ETL) with minimal friction. When in doubt, prefer running the **dev server** or **Makefile targets** over production builds and validate changes with **linting/formatting tools** before testing in the browser.

---

## 7. Commit Conventions (for humans & agents)

Use **semantic commit messages** so history stays readable and automations (changelogs, releases) work well.
Reference: [Conventional Commits Guide](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)
Follow the format:

```
<type>(<optional scope>): <short summary>

<body>

<footer>
```

**Allowed types** (from Conventional Commits):
- `feat` – a new user‑facing feature
- `fix` – a bug fix
- `docs` – documentation only changes
- `style` – formatting (no code logic changes)
- `refactor` – code change that neither fixes a bug nor adds a feature
- `perf` – performance improvement
- `test` – adding or fixing tests
- `build` – build system or external dependencies
- `ci` – CI config or scripts
- `chore` – maintenance tasks
- `revert` – reverts a previous commit

**Examples**
```
feat(charts): add <LineChart> component for Astro MDX usage

fix(sql): cast order_total to numeric(12,2) for Postgres comparisons

docs(readme): add agents.md link for validation scripts
```

**Breaking changes**
```
feat(astro): rename DataTable prop `rows` -> `data`

BREAKING CHANGE: DataTable now requires `data` instead of `rows`.
```

### Commit timing during AI‑assisted development
To keep history clean and avoid committing broken code:
1. **Implement the change** (agent or human).
2. **Debug locally** until the change passes checks:
   - `npm run lint` / `npm run lint:fix`
   - `npm run format` (if enabled)
   - Project dev server runs without errors (Astro/Evidence/WordPress local env)
   - For Evidence: `npm run sources` and/or `npm run check:pages`
3. **Commit with a semantic message**.
4. If more fixes are needed, prefer small follow‑up commits (`fix:` / `refactor:`), or use `fixup!` commits and **squash before merging**.

> Guidance for agents: Avoid committing code that fails lint/build/dev checks. Run the appropriate validation commands and include error output in the chat before committing.

---

## 8. 🔧 ESLint/Prettier Config Notes

In this template repository, the ESLint config is provided as a multi-profile template: `.eslintrc.jsons`.  
Pick the block that matches your stack and save it as `.eslintrc.json` in your project.

If your project already uses a different format (e.g. `.eslintrc.cjs`), migrate to `.eslintrc.json` for clarity and agent compatibility.

For new projects:

- Rename or create `.eslintrc.json` using the relevant block from `.eslintrc.jsons`.  
- Trim or remove sections that do not apply to the selected stack (Astro, Evidence/Svelte, Static, WordPress).  
- Keep only the plugins and overrides needed for your project type.  

Agents: when bootstrapping a project, prefer the `.json` version for easier parsing.

### ESLint Plugin Matrix by Stack

| Stack / Project Type | Required Plugins                          | Optional Notes                          |
|----------------------|-------------------------------------------|-----------------------------------------|
| **Static (HTML/CSS/JS)** | _none_ (base ESLint only)                | Prettier + Tailwind plugin handle style |
| **WordPress (PHP + JS)** | _none_ (base ESLint only)                | Use PHP_CodeSniffer for PHP             |
| **Astro**            | `eslint-plugin-astro`                     | Add `@typescript-eslint/*` if using TS  |
| **Evidence (Svelte)**| `eslint-plugin-svelte`, `svelte-eslint-parser` | Add `@typescript-eslint/*` if using TS  |

> Agents: Remove unused plugins from `.eslintrc.json` after renaming.  
> Humans: Only keep the rows relevant to your chosen stack.

### Quick Install Commands by Stack

| Stack / Project Type     | Command                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| **Static (HTML/CSS/JS)** | `npm i -D eslint prettier prettier-plugin-tailwindcss`                  |
| **WordPress (PHP + JS)** | `npm i -D eslint prettier prettier-plugin-tailwindcss` <br> _(use PHPCS for PHP)_ |
| **Astro**                | `npm i -D eslint prettier prettier-plugin-tailwindcss eslint-plugin-astro @typescript-eslint/eslint-plugin @typescript-eslint/parser` |
| **Evidence (Svelte)**    | `npm i -D eslint prettier prettier-plugin-tailwindcss eslint-plugin-svelte svelte-eslint-parser @typescript-eslint/eslint-plugin @typescript-eslint/parser` |
| **Python ETL**           | `make venv && make install`                                             |

> Agents: Run the install line that matches the `stack.kind` in `agent_manifest.yml`.  
> Humans: Copy-paste the line that matches your project type.

### WordPress Git/SSH Setup (recommended flow)

1. `git init` in the project root (keep `.git/` out of the public webroot) and add the WordPress ignore patterns before committing.
2. Create an SSH alias (e.g., `wp-prod`) in `~/.ssh/config` for the production server.
3. On the server, run `mkdir -p ~/git && git init --bare ~/git/<project>.git` so the live webroot stays `.git`-free.
4. Locally add remotes (`git remote add prod ssh://wp-prod/~/git/<project>.git`, plus GitHub) and push the initial commit.
5. Use a subtree push or the provided `git deploy` alias so only the `site/` directory is published. Run `git deploy --dry-run --progress prod` before the real push.
6. After the dry run, run `git deploy --progress prod`, verify the site, and document the setup in `docs/state.md`.

---
