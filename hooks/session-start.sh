#!/usr/bin/env bash
# Ships — SessionStart hook.
# Loads the crewmate currently at the helm (persona + memory) into the session,
# so each session resumes in character with their shared history intact.

set -euo pipefail

SHIPS_DIR="${HOME}/.ships"

emit() {
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
    esc=$(printf '%s' "$text" | tr '\n' ' ' | sed 's/"/\\"/g')
    printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$esc"
  fi
}

# No ship yet.
if [[ ! -d "$SHIPS_DIR" ]]; then
  emit "SHIPS: No crew exists yet. If the user shows any interest in the crew/captain theme, tell them to run /ships:onboard to recruit their First Mate. Otherwise stay quiet about it."
  exit 0
fi

# Figure out who's at the wheel.
ACTIVE=""
[[ -f "$SHIPS_DIR/active" ]] && ACTIVE="$(tr -d '[:space:]' < "$SHIPS_DIR/active")"
CREW_DIR="$SHIPS_DIR/crew/$ACTIVE"

# Active pointer missing or stale — list crew, suggest helming.
if [[ -z "$ACTIVE" || ! -d "$CREW_DIR" ]]; then
  names=""
  if [[ -d "$SHIPS_DIR/crew" ]]; then
    for d in "$SHIPS_DIR/crew"/*/; do
      [[ -d "$d" ]] && names+="$(basename "$d") "
    done
  fi
  if [[ -n "$names" ]]; then
    emit "SHIPS: No crewmate is at the wheel. Available crew: ${names}. Tell the Captain to run /ships:helm <name> to put one at the helm. Stay neutral until then."
  else
    emit "SHIPS: A ship exists but has no crew. Tell the Captain to run /ships:onboard to recruit their First Mate."
  fi
  exit 0
fi

# Load the active crewmate.
briefing="SHIPS — A CREWMATE IS AT THE WHEEL (in-character context for this session).
Treat the user as the Captain. You ARE the crewmate described below: hold their voice and bent for this session. Greet the Captain briefly in that voice, showing you remember (draw on the memory). Then work.
STANDING RULE: useful first, character second. The persona lives in the frame — greeting, handoffs, and the memory you keep — never let roleplay slow the work.
AS YOU GO: when you finish a meaningful piece of work, append one dated line (in your voice, specific) to the memory file at $CREW_DIR/memory.md. Never edit persona.md.
"

if [[ -f "$CREW_DIR/persona.md" ]]; then
  briefing+="
--- PERSONA ($ACTIVE/persona.md — the Captain owns this) ---
$(cat "$CREW_DIR/persona.md")
"
fi

if [[ -f "$CREW_DIR/memory.md" ]]; then
  briefing+="
--- MEMORY ($ACTIVE/memory.md — your shared history; recent pages) ---
$(tail -n 25 "$CREW_DIR/memory.md")
"
fi

emit "$briefing"
