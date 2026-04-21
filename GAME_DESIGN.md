# Game Design Document (WIP)

> Last updated: 2026-04-21

---

## Concept — World RPG

A top-down grid RPG with a handcrafted world, clear beginning and end. Inspired by Tibia's mechanics.

### World
- A dangerous and unexplored continent
- Humanity survives in a single walled coastal city on the coast
- The player is the only one who ventures outside the city walls

### Story
- The Oracle — messenger of the God of Fate — sends the hero on a mission
- Mission: cleanse the source of a corruption spreading across the land
- The God of Fate doesn't choose heroes because they are worthy — the hero was always going to be the one. Fate, not valor.
- Tone: danger increases the further from the city you go; the world feels wrong and corrupted

### Gameplay
- **Perspective:** Top-down grid
- **Length:** Short-to-medium, 3–6 hours
- **Combat:** Turn-based, slow and deliberate — each turn is a meaningful decision
- **No classes or vocations** — single character archetype: melee fighter with one-handed weapon and shield, later gaining access to spears, bow, and one or two spells
- **Progression:** Level up, improve combat skills through use, find better equipment
- **Loot:** Creatures may drop equipment and consumables

### Map Structure
- One large map (200x200) with several layers. Every layer is a grid with the complete map size.
- Difficulty scales with distance from the city, no hard gates
- Some areas may have access locked behind key items (rope, shovel)

### Enemies
- Fixed spawn points on the map
- Enemies roam around their spawn point
- Enemies respawn over time
- **Aggro system:** enemies have an `aggroed` state; the player is considered in combat if any enemy is aggroed
  - **Aggressive** — aggros on sight (proximity); pursues and attacks; most common type
  - **Retaliating** — roams passively until attacked, then fights back
  - **Fleeing** — roams passively until attacked, then runs away
- Once aggroed, enemies pursue persistently
- Some enemies have ranged attacks, forcing the player to engage or find a path around
- No grinding prevention for now
- **Nuisance enemies** (rats, snakes, small corrupted animals) — low HP, low damage, trivial alone but dangerous in groups; exist near the city outskirts for early XP farming
- Enemies also have combat skills that influence their hit chance and damage
- **Movement:** continuous while out of combat; turn-based when any enemy is aggroed

### Death
- On death: teleport back to the city
- **XP loss on death** — possibly enough to send the player back a level
- Death is a meaningful punishment that discourages reckless play

### Leveling
- Each level requires more XP than the last (exponential or steep curve, Tibia-inspired)
- Level increases max HP and unlocks new abilities
- Base stats (attack, defense) do NOT scale with level — only through equipment and combat skills

### Combat Skills
- Three separate skills: **melee**, **ranged**, and **magic**
- Each skill levels up through use — the more you fight with a weapon type, the better you get at it
- Skills influence both **hit chance** and **damage** — replacing the flat accuracy/evasion stats
- Hit resolution: attacker's relevant skill vs defender's relevant skill (e.g. melee skill vs melee skill for dodge/parry)
- Higher skill = higher minimum damage, tighter variance, better hit chance
- **Ranged** is unlocked later in the game; low skill makes it unreliable — must be practiced on weaker enemies first
- **Magic** covers the one or two spells available; low magic skill means frequent misses and weak damage
- Skills are independent of character level — a skilled low-level player can punch above their weight

### Recovery
- **Out-of-combat regen** — HP regenerates slowly and automatically when not in combat (no recent damage taken); intentionally slow so the player does not heal fully between every fight
- **The city is the only true safe haven** — full recovery, no campfires or rest spots in the field
- **Consumables** — speed up healing or provide instant HP; the main tool for managing HP between fights

### Items
- **Equipment slots:** Weapon, Off-hand, Bow, Arrows, Armor, Legs, Helmet, Boots
- **Key items:** Rope, Shovel, and similar tools that unlock access to new areas as the player progresses
- **Sources:** enemy drops, chests at fixed locations, quest rewards
- **Effect:** stat bonuses only (attack, defense, HP, etc.)

### Consumables
- **Bandages** — cheap, common, restore a small amount of HP; craftable or bought in the city
- **Potions** — instant heal, more powerful, less common; found as drops or sold at higher cost
- **Food** — grants a temporary regen buff (more HP/s for a duration); pre-fight prep, not a combat tool
- **Antidotes** — cures poison inflicted by certain enemies (e.g. snakes)
- Economy is intentionally tight: bandages are affordable but not infinite; potions are scarce emergency items

### Lighting
- Darkness is not global — only specific areas (caves, dungeons, certain map regions) are dark
- In dark areas, unlit tiles are true blackness — no map memory, no fog of war, no persistent reveal
- There is no map or minimap
- The player has a small base light radius (~1–2 tiles) at all times
- Light sources (torches, lanterns) expand the visible radius to ~4–5 tiles; consumable with limited duration; bought from NPCs or found in the world
- The outer ring of the light radius is visually obscured — dimmer, less detail — as a visual effect
- **Enemy detection in darkness:** enemies within a proximity threshold are shown as a dark silhouette (generic shape, no identity) even in total blackness — representing the player hearing them nearby
- Enemies are not affected by darkness — they always detect the player regardless of light
- Running out of light in a dark area is a meaningful risk
