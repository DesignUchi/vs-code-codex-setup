# Applying Starter Files to an Existing Project

When using this repository’s starter files in an **existing project**, follow these steps to integrate them smoothly:

1. **Review the existing project files**  
   - Check current configs (`.eslintrc`, `.prettierrc`, `.env`, `Makefile`, etc.).
   - Note overlaps or conflicts with files provided in `vs-code-codex-setup/`.

2. **Review the starter files**  
   - Go through each file in `vs-code-codex-setup/` (README, `agents.md`, `agent_manifest.yml`, Makefile, `.env.example`, etc.).
   - Understand what conventions and processes are being introduced.

3. **Revise existing files**  
   - Merge applicable guidelines and commands from the starter files into the existing project’s files.
   - Ensure consistency with linting, formatting, environment handling, and commit conventions.

4. **Add missing files**  
   - Copy over any missing files from `vs-code-codex-setup/` into the project root (e.g., `docs/security.md`, `docs/state.md`, `.eslintrc.json`).
   - These files improve clarity and make the project agent/human friendly.

5. **Update the state log**  
   - Edit `docs/state.md` to record the integration process. For example:  
     - Installed ESLint/Prettier.  
     - Ran `npm run lint` and fixed errors.  
     - Created `.env.local` and verified secrets loading.  
   - This keeps a transparent record for future contributors and agents.

---

📌 Place this folder into an existing project like: my-existing-project/vs-code-codex-setup/[all starter files]
Agents and humans should use this file as the checklist for adoption.
