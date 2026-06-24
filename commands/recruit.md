---
description: Bring a new hand aboard. Recruit and name another crewmate for your ship.
argument-hint: [role: navigator | gunner | bosun]
---

Run the **recruit** ritual — add a crewmate to the ship. Requested role: `$ARGUMENTS`

1. If `~/.ships` doesn't exist, tell the Captain to run `/ships:onboard` first and stop.

2. Read `~/.ships/progress.json`. Recruiting beyond the First Mate costs standing — gate it by rank:
   - **Navigator** (research & scouting) unlocks at **Ensign of the Tide** (50 XP)
   - **Gunner** (fast implementation) unlocks at **Sailing Captain** (150 XP)
   - **Bosun** (review & quality) unlocks at **Captain of the Line** (350 XP)
   If the Captain hasn't earned the rank, say so in-character and point them to `/ships:log`. Don't recruit.

3. If a role wasn't given, offer the unlocked roles with **AskUserQuestion** and let the Captain pick.

4. Ask the Captain to **name** the new crewmate (plain text).

5. Write `~/.ships/crew/<role>.md` in the same shape as `first-mate.md` (Name, Role, Voice, Wants, Joined, Who they are, How we work, Shared log). Give them a distinct personality that fits the role and stands apart from the existing crew — read the other crew files first so voices don't collide. Add the role to the `crew` array in progress.json.

6. Have the new crewmate say their first words, and have the **First Mate** welcome them aboard in their own voice — the crew is a crew, they know each other now.
