---
description: Toggle whether sessions auto-resume your last crewmate, or start neutral.
argument-hint: [on | off]
---

Set the **auto-helm** preference. Requested: `$ARGUMENTS`

This controls what happens at the start of every new session:
- **off** (default) — sessions start **neutral**. No crewmate is loaded; the Captain runs `/ships:helm <name>` when they want one at the wheel. Stays out of the way.
- **on** — sessions **auto-resume** the last crewmate you helmed, in character, with their memory.

1. If `~/.ships` doesn't exist, tell the Captain to run `/ships:onboard` first and stop.

2. Read `~/.ships/config.json` (treat a missing file as `{ "autoHelm": false }`).

3. Interpret `$ARGUMENTS`:
   - "on" / "true" / "yes" → set `autoHelm` to `true`
   - "off" / "false" / "no" → set `autoHelm` to `false`
   - empty → just report the current setting and what it means; don't change anything.

4. Write the updated value back to `~/.ships/config.json`, preserving any other keys.

5. Confirm the new setting in one line and what the Captain will see next session.
