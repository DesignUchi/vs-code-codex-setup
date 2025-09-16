# 📌 Project State Log

This file is used to track **current progress, decisions, and to-dos**. It is intended for both humans and agents to have a single place to check the active state of the project.

---

## Purpose
- Provide a lightweight log of what’s been done and what’s next.
- Avoid losing context across sessions (especially useful for agents).
- Keep documentation of important changes (schema, API keys rotation, infra updates).

---

## How to Use
- **Humans**: Add bullet points or short notes as you complete tasks or make decisions.
- **Agents**: Read this file first before taking actions; append updates as tasks are executed.

---

## Example Structure

### ✅ Completed
- [2025-09-15] Initial repo setup with `Makefile`, `.env.example`, `agents-template.md`.
- [2025-09-15] Configured ESLint/Prettier for multiple stacks.

### 🔄 In Progress
- Implement database migrations for Postgres.
- Finish Stripe backfill.

### 📝 To Do
- Add `security.md` doc.
- Rotate API keys (scheduled for Q4).
- Expand smoke tests.

---

## Notes
- Keep entries short and date-stamped.
- Cross-reference files (e.g., see `security.md` for secrets policy).
- Use checkboxes (`[ ]` / `[x]`) if you prefer a task-list format.
