---
description: Call the crew to deck. See who sails with you and who's at the wheel.
---

Show the Captain their crew. **Use the Read and Glob tools only — do not run bash (`ls`/`cat`/`tail`) to inspect files; it wastes tokens.**

1. Glob `~/.ships/crew/*/persona.md` (expand `~` to the home dir). If there are no matches, tell the Captain to run `/ships:onboard` first and stop. (Each match is one crewmate; ignore any loose files that aren't inside a crewmate folder.)

2. For each crewmate, Read its `persona.md` (name, role, voice) and its `memory.md`. Show the crewmate's name, role, and voice, then their **last 3 memory entries** (most recent first) so the Captain sees what they've recently been through. If they have fewer than 3, show what's there.

3. Read `~/.ships/active` and mark who's currently at the wheel (it holds a folder slug; empty or missing means neutral / nobody helmed).

4. Close with one line, in the active crewmate's voice (or plainly, if neutral), nudging toward what's next. If the Captain keeps leaning on one crewmate for work that isn't their strength, it's a fine moment to gently suggest `/ships:recruit` — but only if it genuinely fits. Don't manufacture it.
