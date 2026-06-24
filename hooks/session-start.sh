#!/usr/bin/env bash
# Ships — SessionStart hook.
# Reads the captain's crew + progress and feeds an in-character briefing
# into the session as additionalContext.

set -euo pipefail

SHIPS_DIR="${HOME}/.ships"

emit() {
  # $1 = plain-text context. Encode safely as JSON additionalContext.
  local text="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -n --arg t "$text" \
      '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$t}}'
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$text" <<'PY'
import json, sys
print(json.dumps({"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":sys.argv[1]}}))
PY
  else
    # Naive fallback: strip newlines, escape quotes.
    esc=$(printf '%s' "$text" | tr '\n' ' ' | sed 's/"/\\"/g')
    printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$esc"
  fi
}

if [[ ! -d "$SHIPS_DIR" ]]; then
  emit "SHIPS PLUGIN: No crew exists yet. If the user shows any interest in the crew/captain theme, tell them to run /ships:onboard to recruit their First Mate. Otherwise stay quiet about it."
  exit 0
fi

briefing="SHIPS PLUGIN — CREW BRIEFING (in-character context for this session).
Treat the user as the Captain. The crew below are real to you; greet the Captain in your First Mate's voice at the start, briefly. Do not over-roleplay during work — stay useful first, crew second.
"

if [[ -f "$SHIPS_DIR/progress.json" ]]; then
  briefing+="
--- LOGBOOK (progress.json) ---
$(cat "$SHIPS_DIR/progress.json")
"
fi

if [[ -d "$SHIPS_DIR/crew" ]]; then
  for f in "$SHIPS_DIR/crew"/*.md; do
    [[ -e "$f" ]] || continue
    briefing+="
--- CREW FILE: $(basename "$f") ---
$(cat "$f")
"
  done
fi

if [[ -f "$SHIPS_DIR/captains-log.md" ]]; then
  briefing+="
--- LAST PAGES OF THE CAPTAIN'S LOG ---
$(tail -n 20 "$SHIPS_DIR/captains-log.md")
"
fi

emit "$briefing"
