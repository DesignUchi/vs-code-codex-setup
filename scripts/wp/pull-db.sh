#!/usr/bin/env bash
# Sync the production WordPress database to a local dump file.
# Update REMOTE_HOST/REMOTE_ROOT defaults (or export them) to match your server.
# Requires WP-CLI on the remote host and SSH access.

set -euo pipefail

REMOTE_HOST=${REMOTE_HOST:-wp-prod}
REMOTE_ROOT=${REMOTE_ROOT:-wordpress.example.com}
if [[ "${REMOTE_ROOT}" == /* ]]; then
  REMOTE_PATH="${REMOTE_ROOT}"
else
  REMOTE_PATH="~/${REMOTE_ROOT}"
fi
SSH_OPTIONS_DEFAULT=(-T "-o" "RemoteCommand=none")
OUTPUT_DIR=${OUTPUT_DIR:-backups/db}
PREFIX=${PREFIX:-wp-db}
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
GZIP_OUTPUT=true

ARGS=()
SSH_OPTS=()
SSH_OPTS+=("${SSH_OPTIONS_DEFAULT[@]}")
if [[ -n "${SSH_OPTIONS:-}" ]]; then
  # shellcheck disable=SC2206
  EXTRA_OPTS=(${SSH_OPTIONS})
  SSH_OPTS+=("${EXTRA_OPTS[@]}")
fi
while (($#)); do
  case "$1" in
    --no-gzip)
      GZIP_OUTPUT=false
      shift
      ;;
    --output|-o)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        exit 1
      fi
      OUTPUT_PATH=$2
      shift 2
      ;;
    --ssh-option)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        exit 1
      fi
      SSH_OPTS+=("$2")
      shift 2
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#ARGS[@]} -gt 0 ]]; then
  echo "Unused arguments: ${ARGS[*]}" >&2
  exit 1
fi

if [[ -z ${OUTPUT_PATH:-} ]]; then
  mkdir -p "${OUTPUT_DIR}"
  OUTPUT_PATH="${OUTPUT_DIR}/${PREFIX}-${TIMESTAMP}.sql"
fi

remote_exec() {
  local script="$1"
  ssh "${SSH_OPTS[@]}" "${REMOTE_HOST}" bash <<EOF
set -euo pipefail
cd ${REMOTE_PATH}
${script}
EOF
}

if ! remote_exec "command -v wp >/dev/null 2>&1" >/dev/null; then
  echo "wp CLI not found on remote host or path invalid. Aborting." >&2
  exit 1
fi

if [[ "${GZIP_OUTPUT}" == true ]]; then
  OUTPUT_PATH+=".gz"
  echo "[info] Exporting database to ${OUTPUT_PATH} (gzipped)"
  remote_exec "wp db export -" | gzip -c > "${OUTPUT_PATH}"
else
  echo "[info] Exporting database to ${OUTPUT_PATH}"
  remote_exec "wp db export -" > "${OUTPUT_PATH}"
fi

echo "[done] Database dump saved to ${OUTPUT_PATH}"
