extends Node2D

const TILE_SIZE = 32
const COLOR_WALL = Color(0.75, 0.75, 0.75)
const COLOR_FLOOR = Color(0.2, 0.2, 0.2)

func _draw() -> void:
	var game_map = get_parent()
	for row in range(game_map.grid.size()):
		for col in range(game_map.grid[row].size()):
			var tile = game_map.grid[row][col]
			var color = COLOR_WALL if tile == game_map.TileType.WALL else COLOR_FLOOR
			draw_rect(Rect2(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE), color)
