# State Documentation
This file tracks the state of the vs-code-codex-setup project. If copying these starter files into another project, delete this log and use state-template.md as a starting point.

## State Log Usage
- Use this file to track current progress, decisions, and to-dos.
- Intended for both humans and agents to have a single place to check the active state of the project.
- See `docs/state-template.md` for usage notes and example structure. 

## To-dos
- [ ] Add local CI setup instructions 
   - [ ] make ci-local
   - make install (idempotent)
   - make lint
   - npm run format:check (if Node project) or make format (Python ETL)
   - make check-env (ETL)
   - make smoke or make doctor
   - (placeholder) run tests if present

   Drop in code:
    ```Makefile
    # Makefile additions

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
    ```
pre-commit-config.yaml additions:
```yaml
# .pre-commit-config.yaml (add/merge this block)
repos:
  - repo: local
    hooks:
      - id: ci-local
        name: ci-local
        entry: make ci-local
        language: system
        pass_filenames: false
    ```
.vscode/tasks.json additions:
```json
// .vscode/tasks.json (add a one-click local CI task)
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "CI (local)",
      "type": "shell",
      "command": "direnv exec . make ci-local",
      "presentation": { "reveal": "always", "panel": "dedicated" },
      "problemMatcher": []
    }
  ]
}
```
## Notes
   - Language-agnostic: the Make target checks if package.json exists to decide how to format-check. Your Python ETL path still uses make format/make doctor.
   - Fail-fast: any step returning non-zero fails the whole run, just like CI.
   - Scales up: when/if you add tests later (npm test, pytest), drop them into ci-local.

Optional extras
   - If you ever adopt GitHub Actions later, you can run them locally with act to mimic cloud CI.
   - You can also add a pre-push hook (pre-commit install --hook-type pre-push) to force ci-local before pushing.