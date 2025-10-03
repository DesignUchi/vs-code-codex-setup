#!/usr/bin/env bash
# WordPress uploads sync. Set REMOTE_HOST/REMOTE_ROOT (defaults below) or
# export them before running. Requires rsync access to the remote server.
set -euo pipefail

command -v rsync >/dev/null 2>&1 || {
  echo "rsync is required" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

REMOTE_HOST="${REMOTE_HOST:-wp-prod}"
REMOTE_ROOT="${REMOTE_ROOT:-wordpress.example.com}"
REMOTE_UPLOADS_PATH="${REMOTE_UPLOADS_PATH:-wp-content/uploads/}"
REMOTE="${REMOTE_HOST}:~/${REMOTE_ROOT}/${REMOTE_UPLOADS_PATH}"
LOCAL="${REPO_ROOT}/site/wp-content/uploads/"

mkdir -p "${LOCAL}"

RSYNC_FLAGS=("-az" "--partial" "--progress" "--inplace" "--update")

DELETE_MODE="false"
EXTRA_ARGS=()
for arg in "$@"; do
  if [[ "$arg" == "--delete" ]]; then
    DELETE_MODE="true"
  else
    EXTRA_ARGS+=("$arg")
  fi
done

if [[ "$DELETE_MODE" == "true" ]]; then
  RSYNC_FLAGS+=("--delete" "--delete-during")
  echo "[warn] --delete enabled; local files missing on remote will be removed"
fi

echo "[info] Syncing from ${REMOTE}"
rsync "${RSYNC_FLAGS[@]}" "${EXTRA_ARGS[@]}" "${REMOTE}" "${LOCAL}"

echo "[done] Uploads synced to ${LOCAL}"
