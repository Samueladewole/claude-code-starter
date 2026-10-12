#!/usr/bin/env bash
# Install this starter into ~/.claude.
#
# Safe to run more than once. Anything already there is backed up to
# ~/.claude/backup-<timestamp>/ before being replaced, and CLAUDE.md is never
# overwritten once you have edited it.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"
# Outside ~/.claude on purpose: a backup copy of commands/ or agents/
# left inside it would be loaded as a second set of commands.
BACKUP="${HOME}/.claude-backups/${STAMP}"

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }
note() { printf '  %s\n' "$*"; }

command -v claude >/dev/null 2>&1 || {
  echo "Claude Code is not installed yet." >&2
  echo "Install it first:  npm install -g @anthropic-ai/claude-code" >&2
  exit 1
}

mkdir -p "$DEST"

backup_if_present() {
  local rel="$1"
  if [[ -e "${DEST}/${rel}" ]]; then
    mkdir -p "$(dirname "${BACKUP}/${rel}")"
    cp -R "${DEST}/${rel}" "${BACKUP}/${rel}"
    note "backed up existing ${rel}"
  fi
}

say "Installing into ${DEST}"

# Directories: copied wholesale, existing versions backed up first.
for d in rules commands agents hooks skills; do
  backup_if_present "$d"
  mkdir -p "${DEST}/${d}"
  cp -R "${SRC}/${d}/." "${DEST}/${d}/"
  note "${d}/"
done
chmod +x "${DEST}"/hooks/*.py 2>/dev/null || true

# CLAUDE.md: yours once you edit it. Never clobbered.
if [[ -f "${DEST}/CLAUDE.md" ]]; then
  note "CLAUDE.md already exists — left alone (template at ${SRC}/CLAUDE.md)"
else
  cp "${SRC}/CLAUDE.md" "${DEST}/CLAUDE.md"
  note "CLAUDE.md  <-- edit this first, it is the highest-leverage file"
fi

# settings.json: merged rather than replaced, so existing config survives.
if [[ -f "${DEST}/settings.json" ]]; then
  backup_if_present "settings.json"
  python3 - "$SRC/settings.json" "$DEST/settings.json" <<'PY'
import json, sys, collections
new = json.load(open(sys.argv[1]))
cur = json.load(open(sys.argv[2]), object_pairs_hook=collections.OrderedDict)
hooks = cur.setdefault("hooks", {})
added = 0
for event, entries in new.get("hooks", {}).items():
    existing = hooks.setdefault(event, [])
    have = json.dumps(existing)
    for e in entries:
        if json.dumps(e) not in have:
            existing.append(e); added += 1
json.dump(cur, open(sys.argv[2], "w"), indent=2)
open(sys.argv[2], "a").write("\n")
print(f"  merged settings.json ({added} hook entr{'y' if added==1 else 'ies'} added)")
PY
else
  cp "${SRC}/settings.json" "${DEST}/settings.json"
  note "settings.json"
fi

[[ -d "$BACKUP" ]] && note "backups in ${BACKUP}"

say "Done."
cat <<'NEXT'
  Next, in this order:

  1. Open ~/.claude/CLAUDE.md and answer the TODOs. Ten minutes here is worth
     more than every other file combined.
  2. cd into a real project and run:  claude
  3. Read docs/01-first-week-with-max.md

  MCP servers are optional and come later. When you want them, copy
  mcp.json.example to ~/.claude/mcp.json and set the keys in your shell profile.
NEXT
