# State Documentation
This file tracks the state of the vs-code-codex-setup project. If copying these starter files into another project, delete this log and use state-template.md as a starting point.

## State Log Usage
- Use this file to track current progress, decisions, and to-dos.
- Intended for both humans and agents to have a single place to check the active state of the project.
- See `docs/state-template.md` for usage notes and example structure. 

## To-dos
- [x] Add local CI setup instructions 
   - [x] make ci-local
   - [x] make install (idempotent)
   - [x] make lint
   - [x] Format check (Prettier for Node, `make format` for Python)
   - [x] make check-env (optional; runs if target exists)
   - [x] make smoke or make doctor (via ci-smoke)
   - [x] Tests placeholder (optional; Node scripts.test or pytest if present)

Summary:
- Local CI runner (`make ci-local`) now chains: install → lint → format-check → optional env check → optional tests → smoke/doctor with fail-fast behavior.
- Added VS Code task “CI (local)” and pre-commit hook to run `make ci-local`.
- Format step auto-selects Prettier check for Node projects or `make format` for Python.
- Env check runs if a `check-env` Make target exists; tests run if `npm test` is defined in `package.json` or `pytest` is available with a `tests/` directory.
## Notes
   - Language-agnostic: the Make target checks if package.json exists to decide how to format-check. Your Python ETL path still uses make format/make doctor.
   - Fail-fast: any step returning non-zero fails the whole run, just like CI.
   - Scales up: when/if you add tests later (npm test, pytest), drop them into ci-local.

Optional extras
   - If you ever adopt GitHub Actions later, you can run them locally with act to mimic cloud CI.
   - You can also add a pre-push hook (pre-commit install --hook-type pre-push) to force ci-local before pushing.
