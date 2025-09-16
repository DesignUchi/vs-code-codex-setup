# SECURITY.md

## Scope
Covers local dev + hosted services (Render, etc.) for all stacks (Static, Astro, Evidence/Svelte, WordPress, Python ETL).

## Secrets
- **Where to store**: `.env.local` only (gitignored). Load via `direnv` (`.envrc` uses `dotenv .env.local`).
- **Never commit**: `.env.local`, API keys, DB URLs, service account JSON.
- **Rotation**: Rotate API keys/DB URLs quarterly or after any suspected exposure. Update:
  1) Provider secret vault (Render/Stripe/etc.)
  2) Local `.env.local`
  3) Any CI/automation (if used later)

## Access & Least Privilege
- **Database**: use app-specific user with minimal grants (read/write only required schemas). No superuser.
- **APIs**: use environment-scoped/test keys for non-prod. Prefer fine-grained tokens where supported.
- **Local logs**: `logs/local/` are gitignored; avoid writing raw payloads or secrets.

## Data Handling
- **PII**: email addresses are PII. Mask/hash in logs and examples.
- **Exports**: store ad-hoc CSVs under `sandbox/` or `backups/` (gitignored). Remove when no longer needed.
- **Retention**: raw API tables may grow—set retention policy per table (e.g., keep 24 months) once marts are stable.

## Development Hygiene
- **Do**: `make check-env` before running jobs; `make doctor` as smoke.
- **Don’t**: echo env vars to shell history; print credentials in stack traces/logs.
- **Dependencies**: update `npm`/`pip` routinely; run `npm audit fix` / review Python pins.

## Incident Response (solo-friendly)
1. **Contain**: revoke/rotate leaked keys; disable affected tokens.
2. **Assess**: check provider logs (Render, Stripe, etc.) for misuse.
3. **Remediate**: patch code to prevent re-leak (redact logs, tighten roles).
4. **Document**: add a short note to `STATE.md` (date, impact, fix).

## Environment Notes
- **Direnv**: `direnv allow` only in trusted repos. Review `.envrc` diffs.
- **Backups**: rely on provider backups + keep `sql/schema/current_schema.sql` snapshots in repo.
- **Machine security**: enable full-disk encryption; lock screen; keep OS and VS Code extensions updated.

## Quick Checklist
- [ ] `.env.local` present, **not** checked in
- [ ] Provider secrets set in Render (staging/prod separated)
- [ ] DB user = least privilege
- [ ] Logs don’t contain PII/secrets
- [ ] Keys rotated in last 90 days (or scheduled)