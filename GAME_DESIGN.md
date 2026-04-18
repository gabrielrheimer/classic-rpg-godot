# Game Design Document (WIP)

> Last updated: 2026-04-18

---

## Concept — World RPG

A top-down grid RPG with a handcrafted world, clear beginning and end. Inspired by Tibia's mechanics and WoW's class/lore identity.

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
- **Combat:** Turn-based, regular attacks and abilities with cooldowns
- **Classes:** WoW-inspired. Warrior and Mage to start; system designed to support more
- **Progression:** Unlock new abilities as you level up; improve stats with equipment
- **Loot:** Creatures may drop equipment

### Map Structure
- One large map (200x200) with several layers. Every layer is a grid with the complete map size.
- Difficulty scales with distance from the city, no hard gates
- Some areas may have access locked behind key items (rope, shovel)

### Enemies
- Fixed spawn points on the map
- Enemies roam around their spawn point
- Enemies respawn over time
- Aggro range — idle until player is close, then chase
- Pursuit is persistent — aggroed enemies don't give up easily
- Some enemies have ranged attacks, forcing the player to engage or find a path around
- No grinding prevention for now

### Death
- On death: teleport back to the city, lose nothing
- Death is a soft boundary — venturing too far too early is expected and non-punishing

### Items
- **Equipment slots:** Weapon, Off-hand, Bow, Arrows, Armor, Legs, Helmet, Boots
- **Key items:** Rope, Shovel, and similar tools that unlock access to new areas as the player progresses
- **Sources:** enemy drops, chests at fixed locations, quest rewards
- **Effect:** stat bonuses only (attack, defense, HP, etc.)
