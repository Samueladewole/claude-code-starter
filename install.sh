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
WANT_SKILLS=true

usage() {
  cat <<'USAGE'
Install the Claude Code starter into ~/.claude.

  ./install.sh                rules, commands, agents, hooks, plus five skills
  ./install.sh --no-skills    skip the skills, install everything else
  ./install.sh --help         this message

Safe to run more than once. Replaced files are backed up to
~/.claude-backups/, a CLAUDE.md you have edited is never overwritten, and an
existing settings.json is merged rather than replaced.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-skills) WANT_SKILLS=false; shift ;;
    -h|--help)   usage; exit 0 ;;
    *)
      # A mistyped flag should say so, not be quietly ignored.
      echo "Unknown option: $1" >&2; echo >&2; usage >&2; exit 2 ;;
  esac
done
# Outside ~/.claude on purpose: a backup copy of commands/ or agents/
# left inside it would be loaded as a second set of commands.
BACKUP="${HOME}/.claude-backups/${STAMP}"

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }
note() { printf '  %s\n' "$*"; }

# Collected and printed at the end rather than thrown as the script goes, so a
# missing tool never leaves a half-installed setup with the reason scrolled off.
WARNINGS=()
warn() { WARNINGS+=("$1"); }

command -v claude >/dev/null 2>&1 || warn \
  "Claude Code was not found on your PATH. The config is installed and will
     work as soon as it is:  npm install -g @anthropic-ai/claude-code
     If you just installed it, open a new terminal."

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
for d in rules commands agents hooks; do
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

# ── Skills ──────────────────────────────────────────────────────────
# Skills live in one place, github.com/Samueladewole/claude-skills, and are
# linked from there. Copying them here would mean the same file in two repos,
# which drifts. Five are linked by default; the rest are one flag away.
SKILLS_REPO="${CLAUDE_SKILLS_REPO:-https://github.com/Samueladewole/claude-skills.git}"
SKILLS_DIR="${HOME}/.agents/skills"
STARTER_SKILLS=(writing-plans executing-plans verifying-before-done
                debugging-systematically reducing-entropy)

if [[ "$WANT_SKILLS" == true ]]; then
  say "Skills"
  if [[ -d "${SKILLS_DIR}/.git" ]]; then
    note "already cloned at ${SKILLS_DIR}"
  elif command -v git >/dev/null 2>&1; then
    if git clone --quiet "$SKILLS_REPO" "$SKILLS_DIR" 2>/dev/null; then
      note "cloned the skills collection to ${SKILLS_DIR}"
    else
      rmdir "$SKILLS_DIR" 2>/dev/null || true   # don't leave a stub that blocks a retry
      warn "Could not reach GitHub, so skills were skipped. Everything else\n     installed fine. Rerun ./install.sh when you are back online."
    fi
  else
    warn "git was not found, so skills were skipped. Install git and rerun\n     ./install.sh to add them."
  fi

  if [[ -x "${SKILLS_DIR}/install.sh" ]]; then
    "${SKILLS_DIR}/install.sh" --only "${STARTER_SKILLS[@]}" | sed 's/^/  /'
    note "that is 5 of them. For the rest: ${SKILLS_DIR}/install.sh"
  fi
else
  note "skills skipped (--no-skills)"
fi

[[ -d "$BACKUP" ]] && note "backups in ${BACKUP}"

# ── What actually landed ────────────────────────────────────────────
# Reported by looking at the filesystem, not by assuming the steps above
# worked. If something is missing, it says so here rather than claiming success.
say "What you have now"
# Pure bash: no external command to be missing, and no stray newline in the
# count the way a `find | wc -l` substitution produces.
count_in() {
  local d="$1" n=0 e
  [[ -d "$d" ]] || { printf 0; return; }
  for e in "$d"/* "$d"/.[!.]*; do [[ -e "$e" || -L "$e" ]] && n=$((n+1)); done
  printf '%s' "$n"
}
printf '  %-11s %s\n' "CLAUDE.md"  "$([[ -f "${DEST}/CLAUDE.md" ]] && echo 'yes — edit this first' || echo 'MISSING')"
printf '  %-11s %s\n' "rules"      "$(count_in "${DEST}/rules") files"
printf '  %-11s %s\n' "commands"   "$(count_in "${DEST}/commands") commands"
printf '  %-11s %s\n' "agents"     "$(count_in "${DEST}/agents") agents"
printf '  %-11s %s\n' "hooks"      "$(count_in "${DEST}/hooks") hooks"
printf '  %-11s %s\n' "skills"     "$(count_in "${DEST}/skills") linked"

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  say "Worth knowing"
  for w in "${WARNINGS[@]}"; do printf '  - %b\n' "$w"; done
fi

[[ -d "$BACKUP" ]] && note "" && note "Replaced files were backed up to ${BACKUP}"

say "Next"
cat <<'NEXT'
  1. Open ~/.claude/CLAUDE.md and answer the TODOs. Ten minutes there is worth
     more than every other file combined.
  2. cd into a real project and run:  claude
  3. Read docs/01-first-week-with-max.md

  MCP servers are optional and come later. When you want them, copy
  mcp.json.example to ~/.claude/mcp.json and set the keys in your shell profile.
NEXT
