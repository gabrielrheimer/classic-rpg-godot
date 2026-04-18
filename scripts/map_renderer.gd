extends Node2D

const TILE_SIZE = 32
const COLOR_WALL = Color(0.5, 0.5, 0.5)
const COLOR_FLOOR = Color(0.2, 0.5, 0.2)
const COLOR_GRID_OUTLINE = Color(0, 0, 0, 0.3)

const VIEW_RADIUS_X = 8
const VIEW_RADIUS_Y = 6

var visual_center: Vector2

func _ready() -> void:
	var game_map = get_parent()
	visual_center = Vector2(game_map.MAP_WIDTH / 2, game_map.MAP_HEIGHT / 2)

func _draw() -> void:
	var game_map = get_parent()
	var rows = game_map.grid.size()
	var cols = game_map.grid[0].size()

	var row_start = int(floor(visual_center.y - VIEW_RADIUS_Y))
	var row_end = int(ceil(visual_center.y + VIEW_RADIUS_Y))
	var col_start = int(floor(visual_center.x - VIEW_RADIUS_X))
	var col_end = int(ceil(visual_center.x + VIEW_RADIUS_X))

	row_start = max(0, row_start)
	row_end = min(rows - 1, row_end)
	col_start = max(0, col_start)
	col_end = min(cols - 1, col_end)

	for row in range(row_start, row_end + 1):
		for col in range(col_start, col_end + 1):
			var tile = game_map.grid[row][col]
			var color = COLOR_WALL if tile == Enums.TileType.WALL else COLOR_FLOOR
			var draw_x = (col - visual_center.x + VIEW_RADIUS_X) * TILE_SIZE
			var draw_y = (row - visual_center.y + VIEW_RADIUS_Y) * TILE_SIZE
			draw_rect(Rect2(draw_x, draw_y, TILE_SIZE, TILE_SIZE), color)
			draw_rect(Rect2(draw_x, draw_y, TILE_SIZE, TILE_SIZE), COLOR_GRID_OUTLINE, false)
