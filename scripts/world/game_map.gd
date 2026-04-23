extends Node2D

var grid: Dictionary = {}  # Vector2i -> Enums.TileType
var occupied_tiles: Dictionary = {}  # Vector2i -> Enemy
var _tilemap: TileMapLayer
var _astar := AStar2D.new()
var _astar_offset := Vector2i.ZERO

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

func _tile_id(tile: Vector2i) -> int:
	var t = tile - _astar_offset
	return t.x * 10000 + t.y

func _build_astar() -> void:
	var min_x = INF
	var min_y = INF
	for tile in grid:
		if tile.x < min_x:
			min_x = tile.x
		if tile.y < min_y:
			min_y = tile.y
	_astar_offset = Vector2i(min_x, min_y)
	for tile in grid:
		var tile_data = _tilemap.get_cell_tile_data(tile)
		if tile_data == null or not tile_data.get_custom_data("walkable"):
			continue
		_astar.add_point(_tile_id(tile), Vector2(tile))
	for tile in grid:
		if not _astar.has_point(_tile_id(tile)):
			continue
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				if dx == 0 and dy == 0:
					continue
				var neighbor = tile + Vector2i(dx, dy)
				if _astar.has_point(_tile_id(neighbor)):
					_astar.connect_points(_tile_id(tile), _tile_id(neighbor), false)

func get_tile_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var raw = _astar.get_point_path(_tile_id(from), _tile_id(to))
	var result: Array[Vector2i] = []
	for i in range(1, raw.size()):  # skip index 0 (current tile)
		result.append(Vector2i(raw[i]))
	return result

func is_walkable(tile_pos: Vector2i) -> bool:
	if occupied_tiles.has(tile_pos):
		return false
	var tile_data = _tilemap.get_cell_tile_data(tile_pos)
	if tile_data == null:
		return false
	return tile_data.get_custom_data("walkable")

func run_enemy_turns(player: Node2D) -> void:
	for enemy in occupied_tiles.values():
		enemy.take_turn(player)

func is_in_combat() -> bool:
	for enemy in occupied_tiles.values():
		if enemy.aggroed:
			return true
	return false
