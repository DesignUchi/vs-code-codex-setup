# VS Code Codex Setup

This repository contains configuration, templates, and helpers for working with Codex in VS Code.

## Key Docs
- **agents-template.md** → Human- and agent-readable guide for setting up environments across stacks (Astro, WordPress, Python ETL, Evidence).
- **agent_manifest.yml** → Machine-readable manifest defining stack type, env loader, venv usage, and default tasks. Agents can parse this file to auto-bootstrap a new project.

## Quick Start
1. Review `agent_manifest.yml` to confirm the stack and setup instructions.
2. Follow `agents-template.md` for detailed setup steps depending on your tech stack.
3. Use the provided Makefile tasks or npm/yarn commands as documented in the template.
4. Update this README with any project-specific instructions or deviations from the template.
5. Extract and revise relevant sections from `agents-template.md` into this README for easier reference.