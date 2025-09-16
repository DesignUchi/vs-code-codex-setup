#!/usr/bin/env bash
set -euo pipefail

echo "== Codex Template Materialize =="

# Read stack.kind from agent_manifest.yml if present
kind=""
if [[ -f agent_manifest.yml ]]; then
  kind=$(grep -E "^\s*kind:\s*" agent_manifest.yml | sed -E 's/.*kind:\s*//') || kind=""
  # trim whitespace
  kind=$(echo "${kind}" | xargs || true)
fi

echo "stack.kind=${kind:-<unset>}"

# 1) Ensure .envrc exists (from template)
if [[ ! -f .envrc ]]; then
  if [[ -f .envrc.template ]]; then
    cp .envrc.template .envrc
    echo ".envrc created from template (dotenv .env.local). If using direnv, run: direnv allow"
  else
    echo "No .envrc.template found; skipping .envrc creation"
  fi
else
  echo ".envrc already exists; leaving as-is"
fi

# 2) Node materialization for Node stacks (astro|static|wordpress|evidence)
is_node_stack=0
case "$kind" in
  astro|static|wordpress|evidence)
    is_node_stack=1 ;;
esac

if [[ "$is_node_stack" -eq 1 ]]; then
  if [[ -f package.json ]]; then
    echo "package.json exists; ensuring test scripts are present"
    node -e '
      const fs=require("fs");
      const p="package.json";
      const j=JSON.parse(fs.readFileSync(p,"utf8"));
      j.scripts ||= {};
      if(!j.scripts.test) j.scripts.test = "node --test";
      if(!j.scripts["test:watch"]) j.scripts["test:watch"] = "node --test --watch";
      fs.writeFileSync(p, JSON.stringify(j,null,2)+"\n");
    '
    echo "Node test scripts ensured."
  elif [[ -f package.jsonc ]]; then
    echo "Creating package.json from template with tests enabled"
    cat > package.json <<'JSON'
{
  "name": "project-starter",
  "private": true,
  "scripts": {
    "test": "node --test",
    "test:watch": "node --test --watch",
    "format": "prettier . --write",
    "format:check": "prettier . --check",
    "lint": "eslint ."
  },
  "devDependencies": {
    "prettier": "^3.3.3",
    "prettier-plugin-tailwindcss": "^0.6.8",
    "eslint": "^8.57.0"
  }
}
JSON
    echo "package.json created. Run: npm install"
  else
    echo "No package.json or package.jsonc found; skipping Node materialization"
  fi
else
  echo "Non-Node stack or stack.kind unset; skipping Node materialization"
fi

echo "Materialization complete. Next: fill .env.local and run make ci-local."
