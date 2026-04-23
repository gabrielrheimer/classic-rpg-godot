class_name SpawnPoint
extends Node2D

@export var enemy_scene: PackedScene
@export var elite_scene: PackedScene
@export var elite_chance: float = 0.0
@export var group_id: String = ""
@export var call_radius: int = 5

func _ready() -> void:
	var scene_to_spawn = enemy_scene
	if elite_scene and randf() < elite_chance:
		scene_to_spawn = elite_scene
	if scene_to_spawn == null:
		return
	var enemy = scene_to_spawn.instantiate()
	enemy.tile_pos = Vector2i(int(position.x / Constants.TILE_SIZE), int(position.y / Constants.TILE_SIZE))
	enemy.home = enemy.tile_pos
	enemy.group_id = group_id
	enemy.call_radius = call_radius
	enemy.position = position
	var game_map = get_parent()
	game_map.add_child.call_deferred(enemy)
	game_map.occupied_tiles[enemy.tile_pos] = enemy
