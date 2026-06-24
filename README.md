# Ships ⚓

Build a **standing crew** and sail with them. You are the **Captain**. Each crewmate is a persona you can put at the wheel — they have a voice, a bent, and a memory of every voyage you've taken together.

Ships is a productivity tool wearing a game's skin. The crew earn their keep by being genuinely good at the work; the fun rides on top and never gets in the way.

## The core idea

- A crewmate is a **folder**: `~/.ships/crew/<name>/`
  - `persona.md` — who they are (voice, bent, quirks). **Yours to edit, forever.** Highly customizable.
  - `memory.md` — what you've been through. **Auto-written**, hands-off.
- You **helm one crewmate at a time**. `/ships:helm <name>` loads their persona + memory and that crewmate runs the session — same window, their voice.
- Whoever's at the wheel is remembered between sessions, so you pick up right where you left off, in character.
- **Standing crew only.** One Piece rules — loyalty over mercenaries. You start with a First Mate and grow the crew when you genuinely outgrow one pair of hands.

## Install

```
/plugin marketplace add /Users/niccho/dev/ships
/plugin install ships@ships
```

Restart the session so the hook and commands load.

## First voyage

```
/ships:onboard
```

Recruit and name your First Mate, choose their voice and bent. They're written to `~/.ships/crew/` and put at the wheel. Next session, they're already there.

## Commands

| Command | What it does |
|---------|--------------|
| `/ships:onboard` | Begin. Recruit and name your First Mate. |
| `/ships:helm <name>` | Put a crewmate at the wheel for this session. |
| `/ships:muster` | See the crew, and who's currently helming. |
| `/ships:recruit` | Bring a new standing crewmate aboard. |
| `/ships:autohelm [on\|off]` | Auto-resume your last crewmate at session start, or stay neutral (default: off). |

## How it works

- **State lives in `~/.ships/`** — `crew/<name>/persona.md` + `memory.md`, and `active` (the slug of whoever's at the wheel).
- **A SessionStart hook** reads the active crewmate and loads their persona + recent memory into the session, so they greet you knowing who you are.
- **Memory builds itself** — the helmed crewmate jots a short, dated line into their `memory.md` as real work gets done. No chore, no `/log` to remember.

The crew is a fiction held together by files and a load command — but a consistent one. The more you sail, the more there is to remember. And because it's just files, you own and can rewrite all of it.

## The one rule

Useful first, character second. The persona lives in the *frame* — the greeting, the handoffs, the memory it keeps. Mid-task, your crewmate is a damn good engineer who happens to have a name.
