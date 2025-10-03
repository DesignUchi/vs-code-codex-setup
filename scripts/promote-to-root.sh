#!/usr/bin/env bash
set -euo pipefail

# Promote files from this template folder into a project root non-destructively.
# Usage:
# - From project root that contains vs-code-codex-setup/:
#     bash vs-code-codex-setup/scripts/promote-to-root.sh
# - Or from inside the vs-code-codex-setup/ folder:
#     bash scripts/promote-to-root.sh

info() { echo "[info] $*"; }
warn() { echo "[warn] $*"; }
ok()   { echo "[done] $*"; }

# Detect SRC (template folder) and DEST (project root)
if [[ -d ./vs-code-codex-setup ]]; then
  SRC="./vs-code-codex-setup"
  DEST="."
elif [[ "$(basename "$PWD")" == "vs-code-codex-setup" ]]; then
  SRC="."
  DEST=".."
else
  echo "Error: run from project root (with vs-code-codex-setup/) or from inside vs-code-codex-setup/." >&2
  exit 1
fi

info "Source: $SRC"
info "Destination: $DEST"

# Helper to copy directories without overwriting
copy_dir_no_overwrite() {
  local src_dir="$1"; local dest_root="$2"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --ignore-existing "$src_dir" "$dest_root/"
  else
    # Fallback: iterate entries and copy if missing
    local name; name="$(basename "$src_dir")"
    if [[ ! -e "$dest_root/$name" ]]; then
      cp -R "$src_dir" "$dest_root/"
    else
      warn "Exists, needs merge: $name/"
    fi
  fi
}

# Helper to copy files without overwriting
copy_file_no_overwrite() {
  local src_file="$1"; local dest_root="$2"
  local name; name="$(basename "$src_file")"
  if [[ -e "$dest_root/$name" ]]; then
    warn "Exists, needs merge: $name"
  else
    cp "$src_file" "$dest_root/$name"
    ok "Copied: $name"
  fi
}

echo "--- Promoting to project root (no overwrites) ---"

# Items to promote (non-destructive)
TO_COPY_DIRS=(
  ".vscode"
  "docs"
  "scripts"
  "tests"
)

TO_COPY_FILES=(
  ".editorconfig"
  ".pre-commit-config.yaml"
  "Makefile"
  "AGENTS.md"
  ".envrc.template"
  ".env.example"
  "agents-template.md"
  "agent_manifest.yml"
  ".eslintrc.jsons"
  "package.jsonc"
)

# Track merges required
MERGE_LIST=()

# Directories
for d in "${TO_COPY_DIRS[@]}"; do
  if [[ -d "$SRC/$d" ]]; then
    if [[ -e "$DEST/$(basename "$d")" ]]; then
      MERGE_LIST+=("$d/")
      warn "Exists, needs merge: $d/"
    else
      copy_dir_no_overwrite "$SRC/$d" "$DEST"
      ok "Copied dir: $d/"
    fi
  fi
done

# If project stack is WordPress, materialize wp scripts into scripts/
if [[ -f "$DEST/agent_manifest.yml" ]]; then
  stack_kind=$(grep -E '^\s*kind\s*:' "$DEST/agent_manifest.yml" | awk -F: '{print $2}' | xargs)
  if [[ "$stack_kind" == "wordpress" && -d "$SRC/scripts/wp" ]]; then
    info "Detected WordPress stack; copying WordPress helper scripts"
    mkdir -p "$DEST/scripts"
    if command -v rsync >/dev/null 2>&1; then
      rsync -a --ignore-existing "$SRC/scripts/wp/" "$DEST/scripts/"
    else
      cp -n "$SRC"/scripts/wp/*.sh "$DEST/scripts/" 2>/dev/null || true
    fi
    ok "Copied WordPress scripts into scripts/"
  fi
fi

# Files
for f in "${TO_COPY_FILES[@]}"; do
  if [[ -f "$SRC/$f" ]]; then
    if [[ -e "$DEST/$(basename "$f")" ]]; then
      MERGE_LIST+=("$f")
      warn "Exists, needs merge: $f"
    else
      copy_file_no_overwrite "$SRC/$f" "$DEST"
    fi
  fi
done

echo
echo "--- Manual merge checklist (if present at destination) ---"
if ((${#MERGE_LIST[@]}==0)); then
  echo "None"
else
  for item in "${MERGE_LIST[@]}"; do echo "- $item"; done
fi

echo
echo "Notes:"
echo "- Keep existing package.json; use package.jsonc only as a reference."
echo "- Create/rename agents-template.md to agents.md at the project root."
echo "- Merge .vscode/tasks.json, .pre-commit-config.yaml, and Makefile targets rather than overwriting."
echo "- After promotion: create .env.local, pick an ESLint block from .eslintrc.jsons -> .eslintrc.json, then run CI (local)."

ok "Promotion complete (non-destructive)."
