#!/usr/bin/env bash
set -euo pipefail

echo "== Codex Template Bootstrap Guide =="

# Detect basics
has_pkg_jsonc=0; [[ -f package.jsonc ]] && has_pkg_jsonc=1
has_pkg_json=0;  [[ -f package.json ]] && has_pkg_json=1
has_eslint_templates=0; [[ -f .eslintrc.jsons ]] && has_eslint_templates=1
has_eslint=0; [[ -f .eslintrc.json ]] && has_eslint=1
has_env_example=0; [[ -f .env.example ]] && has_env_example=1
has_env_local=0; [[ -f .env.local ]] && has_env_local=1
has_manifest=0; [[ -f agent_manifest.yml ]] && has_manifest=1
has_direnv=0; command -v direnv >/dev/null 2>&1 && has_direnv=1
kind=$(grep -E "^\s*kind:\s*" agent_manifest.yml 2>/dev/null | sed -E 's/.*kind:\s*//') || kind=""

echo "- agent_manifest.yml present: $has_manifest (stack.kind: ${kind:-<unset>})"
echo "- Node config: package.jsonc=$has_pkg_jsonc package.json=$has_pkg_json"
echo "- ESLint config: .eslintrc.jsons=$has_eslint_templates .eslintrc.json=$has_eslint"
echo "- Env files: .env.example=$has_env_example .env.local=$has_env_local"

echo
echo "Recommended next steps (ask user for approval before changing files):"

if [[ "$has_pkg_json" -eq 0 && "$has_pkg_jsonc" -eq 1 ]]; then
  echo "1) Node: rename package.jsonc -> package.json, then run: npm install"
else
  echo "1) Node: npm install (if package.json exists)"
fi

if [[ "$has_eslint" -eq 0 && "$has_eslint_templates" -eq 1 ]]; then
  echo "2) ESLint: choose a block in .eslintrc.jsons matching the stack and save as .eslintrc.json"
else
  echo "2) ESLint: verify .eslintrc.json matches the chosen stack"
fi

if [[ "$has_env_local" -eq 0 && "$has_env_example" -eq 1 ]]; then
  echo "3) Env: copy .env.example -> .env.local and fill values"
else
  echo "3) Env: verify .env.local exists and is populated"
fi

if [[ "$has_direnv" -eq 1 ]]; then
  echo "4) Env loading (direnv): create .envrc with: dotenv .env.local ; then run: direnv allow"
else
  echo "4) Env loading: (optional) install direnv to auto-load .env.local"
fi

echo "5) CI: run make ci-local (uses lint/format/env/tests/smoke; skips missing parts)"
echo "6) Tests:"
echo "   - Node: enable \"test\": \"node --test\" in package.json (template in package.jsonc)"
echo "   - Python: install pytest and keep tests/test_sanity.py"
echo "7) Hooks: pre-commit install (optional)"

echo
echo "Tip: You can re-run this guide anytime: bash scripts/bootstrap-guide.sh"

