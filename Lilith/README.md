# Lilith

A Windower addon for farming Lilith in FFXI, including monthly Ambuscade
primer key item gathering.

## Layout

```
Lilith/
├── Lilith.lua              # Addon entry point + //lilith commands
├── bot/                    # Shared bot library (reference implementation)
│   ├── bot.lua             # Core helpers: movement, combat, dialogs, packets
│   ├── events.lua          # Event registration workaround for Windower
│   ├── merits.lua          # Merit/limit point tracking (from pointwatch)
│   └── debuffs.lua         # Mob debuff tracking (from Debuffed plugin)
├── setup/
│   └── homepoint.lua       # Set the character's home point in Mhaura
├── ambuscade/
│   ├── ambuscade.lua       # KI farming orchestrator (loads month + family data)
│   ├── months/             # One file per month: which family per volume
│   │   ├── template.lua    # Copy this each month when the rotation changes
│   │   └── 2026-07.lua     # July 2026: Vol.1 = Qiqirn, Vol.2 = Lizard
│   └── families/           # One file per monster family: where/what to kill
│       ├── qiqirn.lua
│       └── lizard.lua
└── farm/
    └── lilith.lua          # The actual Lilith farming loop (stub)
```

## Workflow

1. **`//lilith hp`** — sets the character's home point in Mhaura. Must be
   done once per character before farming.
2. **`//lilith ki 1`** / **`//lilith ki 2`** — farms the Ambuscade primer
   key item for the given volume. The current month's rotation file
   (`ambuscade/months/YYYY-MM.lua`) decides which monster family to hunt:
   - Volume One KI: kill XP-yielding mobs of the Vol.1 family
     (July 2026: **Qiqirn**).
   - Volume Two KI: kill XP-yielding mobs of the Vol.2 family
     (July 2026: **Lizard**).
3. **`//lilith farm`** — runs the Lilith farming loop (requires both KIs).
4. **`//lilith stop`** — stops the current task.

## Monthly maintenance

When the Ambuscade rotation changes:

1. Copy `ambuscade/months/template.lua` to `ambuscade/months/YYYY-MM.lua`
   and fill in the two families.
2. If a family is new, add `ambuscade/families/<family>.lua` with camps
   (zone, coordinates, mob names, travel route) — use `qiqirn.lua` as a
   reference for the shape.

## Status

This is the initial structure. Stubs marked `TODO` still need real data /
implementation:

- Mhaura home point crystal coordinates and dialog menu options.
- Travel routes (Mhaura → camps, camp → Lilith entrance).
- Camp data for Qiqirn and Lizard (zones, coordinates, mob names).
- The Lilith fight loop itself.
