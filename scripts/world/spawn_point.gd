@tool
class_name SpawnPoint
extends Node2D

enum SpawnBehavior { INHERIT, AGGRESSIVE, RETALIATING, FLEEING }
enum RoamOverride { INHERIT, ROAM, IDLE }

const BEHAVIOR_MAP = {
	SpawnBehavior.AGGRESSIVE: Enemy.Behavior.AGGRESSIVE,
	SpawnBehavior.RETALIATING: Enemy.Behavior.RETALIATING,
	SpawnBehavior.FLEEING: Enemy.Behavior.FLEEING,
}

@export var enemy_scene: PackedScene:
	set(value):
		enemy_scene = value
		if is_node_ready():
			_update_editor_sprite()
@export var elite_scene: PackedScene
@export var elite_chance: float = 0.0
@export var group_id: String = ""
@export var call_radius: int = -1
@export var roams: RoamOverride = RoamOverride.INHERIT
@export var behavior: SpawnBehavior = SpawnBehavior.INHERIT

func _update_editor_sprite() -> void:
	if not Engine.is_editor_hint():
		return
	var sprite = get_node_or_null("Sprite2D")
	if sprite == null or enemy_scene == null:
		return
	var enemy = enemy_scene.instantiate()
	var enemy_sprite = enemy.get_node_or_null("Sprite2D")
	if enemy_sprite:
		sprite.texture = enemy_sprite.texture
	enemy.free()

func _ready() -> void:
	_update_editor_sprite()
	if Engine.is_editor_hint():
		return
	var scene_to_spawn = enemy_scene
	if elite_scene and randf() < elite_chance:
		scene_to_spawn = elite_scene
	if scene_to_spawn == null:
		return
	var enemy = scene_to_spawn.instantiate()
	enemy.tile_pos = Vector2i(int(position.x / Constants.TILE_SIZE), int(position.y / Constants.TILE_SIZE))
	enemy.home = enemy.tile_pos
	if group_id != "":
		enemy.group_id = group_id
	if call_radius != -1:
		enemy.call_radius = call_radius
	if roams != RoamOverride.INHERIT:
		enemy.roams = roams == RoamOverride.ROAM
	if behavior != SpawnBehavior.INHERIT:
		enemy.behavior = BEHAVIOR_MAP[behavior]
	enemy.position = position
	var game_map = get_parent()
	game_map.add_child.call_deferred(enemy)
	game_map.occupied_tiles[enemy.tile_pos] = enemy
