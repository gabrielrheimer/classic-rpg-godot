extends Node2D

enum LightingMode { CAVE, OUTDOOR }

var grid: Dictionary = {}  # Vector2i -> Enums.TileType
var occupied_tiles: Dictionary = {}  # Vector2i -> Enemy
var _tilemap: TileMapLayer
var _astar := AStarGrid2D.new()

@onready var _post_process_rect := $PostProcessLayer/PostProcessRect
@onready var _mat_cave: ShaderMaterial = _post_process_rect.material
var _mat_outdoor := preload("res://materials/outdoor_lighting.tres")

const STRING_TO_TILE_TYPE = {
	"floor": Enums.TileType.FLOOR,
	"wall":  Enums.TileType.WALL,
	"water": Enums.TileType.WATER,
}

func _ready() -> void:
	_tilemap = $TileMapLayer
	for cell in _tilemap.get_used_cells():
		var tile_data = _tilemap.get_cell_tile_data(cell)
		var type_str = tile_data.get_custom_data("tile_type")
		grid[cell] = STRING_TO_TILE_TYPE.get(type_str, Enums.TileType.FLOOR)
	_build_astar()
	set_lighting(LightingMode.OUTDOOR)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_N:
		if _post_process_rect.material == _mat_cave:
			set_lighting(LightingMode.OUTDOOR)
		else:
			set_lighting(LightingMode.CAVE)

func _build_astar() -> void:
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	for tile in grid:
		if tile.x < min_x: min_x = tile.x
		if tile.y < min_y: min_y = tile.y
		if tile.x > max_x: max_x = tile.x
		if tile.y > max_y: max_y = tile.y
	_astar.region = Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	_astar.update()
	for tile in grid:
		var tile_data = _tilemap.get_cell_tile_data(tile)
		if tile_data == null or not tile_data.get_custom_data("walkable"):
			_astar.set_point_solid(tile, true)

func get_tile_path(from: Vector2i, to: Vector2i, exclude: Array[Vector2i] = []) -> Array[Vector2i]:
	for tile in occupied_tiles:
		if tile != from and tile != to and not tile in exclude:
			_astar.set_point_solid(tile, true)
	var raw = _astar.get_id_path(from, to)
	for tile in occupied_tiles:
		if tile != from and tile != to and not tile in exclude:
			_astar.set_point_solid(tile, false)
	var result: Array[Vector2i] = []
	for i in range(1, raw.size()):
		result.append(raw[i])
	return result

func is_walkable(tile_pos: Vector2i) -> bool:
	if occupied_tiles.has(tile_pos):
		return false
	return is_passable(tile_pos)

func is_passable(tile_pos: Vector2i) -> bool:
	var tile_data = _tilemap.get_cell_tile_data(tile_pos)
	if tile_data == null:
		return false
	return tile_data.get_custom_data("walkable")

func get_path_length(from: Vector2i, to: Vector2i) -> int:
	var raw: Array = _astar.get_id_path(from, to)
	if raw.is_empty():
		return INF
	return raw.size() - 1

func run_enemy_turns(player: Node2D) -> void:
	for enemy in occupied_tiles.values():
		enemy.take_turn(player)

func is_in_combat() -> bool:
	for enemy in occupied_tiles.values():
		if enemy.aggroed:
			return true
	return false

func set_lighting(mode: LightingMode) -> void:
	match mode:
		LightingMode.CAVE:
			_post_process_rect.material = _mat_cave
		LightingMode.OUTDOOR:
			_post_process_rect.material = _mat_outdoor
