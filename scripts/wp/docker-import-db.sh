#!/usr/bin/env bash
# WordPress local DB importer. Update the defaults below (names/passwords)
# or export WP_LOCAL_DB_* / MYSQL_ROOT_PASSWORD before running.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

DEFAULT_GLOB="backups/db/*.sql*"
DB_NAME="${WP_LOCAL_DB_NAME:-wordpress}"
DB_USER="${WP_LOCAL_DB_USER:-wordpress}"
DB_PASSWORD="${WP_LOCAL_DB_PASSWORD:-wordpress_pass}"
ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-mysql_root_pass}"
DB_HOST="${WP_LOCAL_DB_HOST:-127.0.0.1}"
DB_PORT="${WP_LOCAL_DB_PORT:-3306}"

if [[ $# -gt 0 ]]; then
  DUMP_FILE="$1"
else
  DUMP_FILE=$(ls -t ${DEFAULT_GLOB} 2>/dev/null | head -n 1 || true)
fi

if [[ -z "${DUMP_FILE}" ]]; then
  echo "No dump file found under backups/db/. Provide a file path." >&2
  exit 1
fi

if [[ ! -f "${DUMP_FILE}" ]]; then
  echo "Dump file not found: ${DUMP_FILE}" >&2
  exit 1
fi

if ! docker compose ps db &>/dev/null; then
  echo "Database container not running. Start stack with 'docker compose up -d'." >&2
  exit 1
fi

echo "[info] Waiting for database to be ready"
READY=false
for _ in {1..30}; do
  if docker compose exec -T db mysqladmin ping -h "${DB_HOST}" -P "${DB_PORT}" -u root -p"${ROOT_PASSWORD}" --silent >/dev/null 2>&1; then
    READY=true
    break
  fi
  sleep 2
done

if [[ "${READY}" != true ]]; then
  echo "Database is not responding. Check container logs." >&2
  exit 1
fi

echo "[info] Resetting database ${DB_NAME}"
SQL=$(cat <<SQL
DROP DATABASE IF EXISTS \`${DB_NAME}\`;
CREATE DATABASE \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL
)

docker compose exec -T db mysql -h "${DB_HOST}" -P "${DB_PORT}" -u root -p"${ROOT_PASSWORD}" -e "${SQL}"

IMPORT_CMD=(docker compose exec -T db mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}")

if [[ "${DUMP_FILE}" == *.gz ]]; then
  echo "[info] Importing gzipped dump ${DUMP_FILE}"
  gunzip -c "${DUMP_FILE}" | "${IMPORT_CMD[@]}"
else
  echo "[info] Importing dump ${DUMP_FILE}"
  cat "${DUMP_FILE}" | "${IMPORT_CMD[@]}"
fi

echo "[done] Database import complete"
