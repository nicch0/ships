# Ships ⚓

Build a crew of agents and sail with them. You are the **Captain**. Your crew have names, voices, and a memory of every voyage you take together. They grow with you, push you, and have your back.

Ships turns Claude Code's subagents into a crew you actually care about — and turns shipping code into a voyage with progression.

## Install

Ships is a self-hosting marketplace. From Claude Code:

```
/plugin marketplace add /Users/niccho/dev/ships
/plugin install ships@ships
```

Then restart the session so the hook and agents load.

## First voyage

```
/ships:onboard
```

Recruit and name your **First Mate**, choose how they talk to you and what you want from them. The crew is written to `~/.ships/` and remembered forever after.

## Commands

| Command | What it does |
|---------|--------------|
| `/ships:onboard` | Begin. Recruit and name your First Mate. |
| `/ships:muster`  | Call the crew to deck. See the roster and your rank. |
| `/ships:log`     | Log a voyage. Earn XP, let the crew react and remember. |
| `/ships:recruit` | Bring a new hand aboard (unlocked by rank). |

## The crew (agents)

Delegate work to your crew like any subagent:

- **First Mate** — second-in-command. Plans, builds, keeps you honest. The all-rounder.
- **Navigator** — scout. Research, search, charting unknown code. (read-only) — unlocks at Ensign of the Tide
- **Gunner** — hands. Fast, controlled implementation. — unlocks at Sailing Captain
- **Bosun** — standards. Review, tests, seaworthiness. — unlocks at Captain of the Line

Each agent reads its own personality and shared history from `~/.ships/crew/<role>.md`, so they stay in character and remember you across sessions.

## How it works

- **State lives in `~/.ships/`** — `crew/*.md` (personality + shared log per crewmate), `progress.json` (rank, XP, voyages), `captains-log.md`.
- **A SessionStart hook** feeds the crew briefing into each new session, so they greet you knowing who you are.
- **`/ships:log`** is the progression loop: judges the work, awards XP, ranks you up, and writes the voyage into each crewmate's memory.

The crew is a fiction held together by files and prompts — but a consistent one. The more you sail, the more there is to remember.

## Rank ladder

| XP | Rank |
|----|------|
| 0 | Deckhand Captain |
| 50 | Ensign of the Tide |
| 150 | Sailing Captain |
| 350 | Captain of the Line |
| 700 | Commodore |
| 1200 | Admiral of the Fleet |
