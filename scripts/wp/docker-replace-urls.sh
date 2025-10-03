#!/usr/bin/env bash
# WordPress URL replacer. Adjust docker-compose service names or supply
# extra WP-CLI flags if your project differs from the default setup.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <from-url> <to-url> [wp-cli flags...] [--update-options]" >&2
  exit 1
fi

FROM_URL="$1"
TO_URL="$2"
shift 2

UPDATE_OPTIONS=false
EXTRA_ARGS=()
for arg in "$@"; do
  if [[ "$arg" == "--update-options" ]]; then
    UPDATE_OPTIONS=true
  else
    EXTRA_ARGS+=("$arg")
  fi
done

if ! docker compose ps db &>/dev/null; then
  echo "Containers not running. Start the stack with 'docker compose up -d'." >&2
  exit 1
fi

echo "[info] Rewriting URLs: ${FROM_URL} -> ${TO_URL}"
docker compose run --rm wp-cli search-replace "${FROM_URL}" "${TO_URL}" --all-tables --skip-columns=guid "${EXTRA_ARGS[@]}"

echo "[done] Search/replace complete"

if [[ "${UPDATE_OPTIONS}" == true ]]; then
  echo "[info] Updating WordPress home/siteurl to ${TO_URL}"
  docker compose run --rm wp-cli option update home "${TO_URL}"
  docker compose run --rm wp-cli option update siteurl "${TO_URL}"
  echo "[done] home/siteurl updated"
fi
