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

- **Evidence projects (Svelte-based)**:
  - Use `npm run dev` to start the Evidence dev server. This enables hot module reload (HMR) for dashboards and charts.
  - Avoid `npm run build` during interactive sessions; only use it to test static production output before deployment.

- **Svelte projects (general)**:
  - ⚠️ Placeholder: If creating standalone Svelte apps in the future, add detailed agent instructions here.

---

## 2. Keep Dependencies in Sync

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
    - ESLint: `.eslintrc.cjs` (repo root)  
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
