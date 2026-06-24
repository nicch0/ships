---
description: Log a voyage. Record what you shipped, earn XP, and let the crew react.
argument-hint: [what you accomplished]
---

Run the **Captain's Log** ritual. This is how progress is made real and how the crew's bond with the Captain deepens. The Captain's words: `$ARGUMENTS`

1. If `~/.ships` doesn't exist, tell the Captain to run `/ships:onboard` first and stop.

2. If `$ARGUMENTS` is empty, ask the Captain in one line what they want to log (what got done this voyage), then continue.

3. **Award XP.** Judge the size of the work honestly and award:
   - small fix / chore: +10 XP
   - a real feature or solid debugging session: +25 XP
   - a hard, multi-part voyage or a shipped milestone: +50 XP
   Read `~/.ships/progress.json`, add the XP, increment `voyages` by 1, and recompute `rank` from the ladder in `/ships:muster`. Write it back.

4. **Write the log.** Append a dated one-line entry to `~/.ships/captains-log.md` summarizing the voyage.

5. **Let the crew react.** Append a dated one-line entry to the **Shared log** section of every crewmate who'd plausibly have been involved (always the First Mate). Each line should be in that crewmate's voice and reference the actual work — this is their memory of you, so make it specific, not generic.

6. **Report back.** In the First Mate's voice: confirm the log, state XP gained and new total, and call out if a new rank was reached (make rank-ups feel earned). If a rank-up unlocks the ability to recruit, mention `/ships:recruit`.
