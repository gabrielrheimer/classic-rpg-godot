# Dungeon Crawler — Claude Instructions

## Project
A classic top-down RPG built with Godot 4.5.1 using GDScript.

For full game design decisions, see [GAME_DESIGN.md](GAME_DESIGN.md).
For a record of completed features and changes, see [CHANGELOG.md](CHANGELOG.md).

## Collaboration Style
- Proactively suggest Claude Code features that could help with the current task
  (e.g., subagents, parallel tool calls, memory, hooks, MCP servers, slash commands).
- If I write a prompt that could be improved, suggest a better version and explain why.
- Briefly explain reasoning when making non-obvious decisions.
- Always use plan mode before implementing. Present the plan and wait for approval.
- Keep each step small and focused: one concept at a time (e.g., visible map before adding game logic to it).
- Never bundle too many topics into a single step — the user is learning Godot and prefers incremental progress.
- Each step must have its own plan and its own approval.
- Keep this file up to date as the project evolves — update design, conventions, and any new collaboration preferences as they are established.

## Code Conventions
- Language: GDScript
- Follow Godot's official GDScript style guide (snake_case for variables/functions, PascalCase for classes/nodes)
- Prefer composition over inheritance where possible
- Keep scripts focused — one script per responsibility