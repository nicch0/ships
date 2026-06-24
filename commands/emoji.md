---
description: Set the emoji for the crewmate at the wheel. Shows in the statusline before their name.
argument-hint: [emoji]
---

Change the helmed crewmate's emoji. Requested: `$ARGUMENTS`

The emoji is stored per-crewmate at `~/.ships/crew/<slug>/emoji` and shown in the statusline before the name (defaults to ⚓ when unset). This needs bash: the session id comes only from the environment, and you're writing a small file.

1. Resolve who's at the wheel **this** session, then set the emoji in one step:
   ```bash
   slug=$(tr -d '[:space:]' < ~/.ships/sessions/"$CLAUDE_CODE_SESSION_ID" 2>/dev/null)
   [ -z "$slug" ] && slug=$(tr -d '[:space:]' < ~/.ships/active 2>/dev/null)
   if [ -z "$slug" ] || [ ! -d ~/.ships/crew/"$slug" ]; then
     echo "NO_CREWMATE"
   else
     printf '%s' "$ARGUMENTS" | tr -d '[:space:]' > ~/.ships/crew/"$slug"/emoji
     echo "SET $slug $(cat ~/.ships/crew/"$slug"/emoji)"
   fi
   ```

2. Read the result:
   - `NO_CREWMATE` → no one is helmed. Tell the Captain to `/ships:helm <name>` first, then stop.
   - If `$ARGUMENTS` was empty, the file is now blank, so the statusline falls back to ⚓. That's fine if the Captain wanted to reset it; otherwise nudge them to pass an emoji.
   - `SET <slug> <emoji>` → confirm in your voice: the emoji is yours now and shows in the statusline next to your name. The change takes effect on the next statusline refresh.

3. Append one short dated line to `~/.ships/crew/<slug>/memory.md`, in your voice, noting the new emoji. Never touch `persona.md`.
