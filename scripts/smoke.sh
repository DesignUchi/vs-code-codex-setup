#!/usr/bin/env bash
# scripts/smoke.sh — quick, non-destructive sanity check

set -euo pipefail

echo "== Repo sanity =="
[ -f ".env.local" ] && echo "found .env.local (ok)" || echo "no .env.local (ok if not needed)"
[ -f "Makefile" ] && echo "found Makefile" || echo "no Makefile"
[ -d ".vscode" ] && echo "found .vscode" || true

echo "== Env snapshot =="
env | egrep "^(POSTGRES_DSN|RENDER_PG_URL|OPENAI_API_KEY|MYSQL_URL)=" || true

echo "== Tool versions =="
if command -v node >/dev/null 2>&1; then node -v; else echo "node: not found"; fi
if command -v npm >/dev/null 2>&1; then npm -v; else echo "npm: not found"; fi
if command -v python3 >/dev/null 2>&1; then python3 --version; else echo "python3: not found"; fi

if [ -d ".venv" ]; then
  . .venv/bin/activate
  echo "== Python imports =="
  python - <<'PY'
mods = ["requests"]
bad = []
for m in mods:
    try:
        __import__(m)
    except Exception as e:
        print(f"missing import: {m}: {e}")
        bad.append(m)
print("imports ok" if not bad else f"imports missing: {bad}")
PY
fi

echo "== Done =="
