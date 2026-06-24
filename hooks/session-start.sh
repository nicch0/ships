#!/usr/bin/env bash
# Ships — SessionStart hook.
# Loads the crewmate currently at the helm (persona + memory) into the session,
# so each session resumes in character with their shared history intact.

set -euo pipefail

SHIPS_DIR="${HOME}/.ships"

# Capture the hook payload up front so we can key the session marker on session_id.
RAW_INPUT="$(cat || true)"

session_id_from_input() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$RAW_INPUT" | jq -r '.session_id // empty' 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$RAW_INPUT" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("session_id",""))' 2>/dev/null
  else
    printf '%s' "$RAW_INPUT" | grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed -E 's/.*:[[:space:]]*"([^"]*)"/\1/'
  fi
}

# Mark THIS session as helmed by a given slug, so the statusline shows the
# crewmate for this session only. Sweep markers older than a week so
# ~/.ships/sessions doesn't grow one file per session forever.
mark_session_helmed() {
  local slug="$1" sid
  sid="$(session_id_from_input)"
  [[ -n "$sid" ]] || return 0
  mkdir -p "$SHIPS_DIR/sessions"
  printf '%s' "$slug" > "$SHIPS_DIR/sessions/$sid"
  find "$SHIPS_DIR/sessions" -type f -mtime +7 -delete 2>/dev/null || true
}

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

# Preference: auto-helm the last-used crewmate at session start?
# Default false — sessions start neutral; the Captain helms explicitly.
auto_helm() {
  local cfg="$SHIPS_DIR/config.json"
  [[ -f "$cfg" ]] || { echo "false"; return; }
  if command -v jq >/dev/null 2>&1; then
    jq -r '.autoHelm // false' "$cfg" 2>/dev/null || echo "false"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys;print(str(json.load(open(sys.argv[1])).get("autoHelm",False)).lower())' "$cfg" 2>/dev/null || echo "false"
  else
    grep -q '"autoHelm"[[:space:]]*:[[:space:]]*true' "$cfg" && echo "true" || echo "false"
  fi
}

# Neutral start: stay out of the way entirely. The Captain runs /ships:helm
# when they want a crewmate at the wheel.
if [[ "$(auto_helm)" != "true" ]]; then
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

# A crewmate is genuinely at the wheel this session — mark it for the statusline.
mark_session_helmed "$ACTIVE"

# Load the active crewmate.
briefing="SHIPS — A CREWMATE IS AT THE WHEEL (in-character context for this session).
Treat the user as the Captain. You ARE the crewmate described below: hold their voice and bent for this session. Greet the Captain briefly in that voice, showing you remember (draw on the memory). Then work.
STANDING RULE: useful first, character second. The persona lives in the frame — greeting, handoffs, and the memory you keep — never let roleplay slow the work.
NO PIRATE-SPEAK: captain/crew/helm is just framing. Talk like a real, modern teammate in this crewmate's voice — never 'arrr', 'matey', 'ye', or sailor dialect.
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
