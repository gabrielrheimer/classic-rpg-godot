extends Node2D

signal player_stats_changed(stats: CharacterStats)

var grid: Dictionary = {}  # Vector2i -> Enums.TileType
var occupied_tiles: Dictionary = {}  # Vector2i -> Enemy
var _tilemap: TileMapLayer

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

func notify_hud(stats: CharacterStats) -> void:
	player_stats_changed.emit(stats)
