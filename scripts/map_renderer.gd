extends Node2D

const TILE_SIZE = 32
const COLOR_WALL = Color(0.5, 0.5, 0.5)
const COLOR_FLOOR = Color(0.2, 0.5, 0.2)

const VIEW_RADIUS_X = 12
const VIEW_RADIUS_Y = 8

var center: Vector2i

func _ready() -> void:
	var game_map = get_parent()
	center = Vector2i(game_map.MAP_WIDTH / 2, game_map.MAP_HEIGHT / 2)

func _draw() -> void:
	var game_map = get_parent()
	var rows = game_map.grid.size()
	var cols = game_map.grid[0].size()

	var row_start = max(0, center.y - VIEW_RADIUS_Y)
	var row_end = min(rows - 1, center.y + VIEW_RADIUS_Y)
	var col_start = max(0, center.x - VIEW_RADIUS_X)
	var col_end = min(cols - 1, center.x + VIEW_RADIUS_X)

	for row in range(row_start, row_end + 1):
		for col in range(col_start, col_end + 1):
			var tile = game_map.grid[row][col]
			var color = COLOR_WALL if tile == game_map.TileType.WALL else COLOR_FLOOR
			var draw_x = (col - col_start) * TILE_SIZE
			var draw_y = (row - row_start) * TILE_SIZE
			draw_rect(Rect2(draw_x, draw_y, TILE_SIZE, TILE_SIZE), color)
