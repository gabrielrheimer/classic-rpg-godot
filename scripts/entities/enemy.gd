class_name Enemy
extends Node2D

const MOVE_DURATION = 0.3

enum Behavior { AGGRESSIVE, RETALIATING, FLEEING }

@export var behavior: Behavior = Behavior.RETALIATING
var aggroed: bool = false
var stats := CharacterStats.new()
var tile_pos: Vector2i

func _ready() -> void:
	if behavior == Behavior.AGGRESSIVE:
		aggroed = true

func take_turn(player: Node2D) -> void:
	if not aggroed:
		return
	if behavior == Behavior.FLEEING:
		return
	var diff = player.tile_pos - tile_pos
	var distance = max(abs(diff.x), abs(diff.y))
	if distance == 1:
		var combat = get_node("/root/Combat")
		combat.resolve_attack(stats, player.stats, "Enemy", "Player")
		if player.stats.hp <= 0:
			print("Player died")
	elif distance > 1:
		_move_toward(player.tile_pos)

func _move_toward(target: Vector2i) -> void:
	var diff = target - tile_pos
	var step = Vector2i(sign(diff.x), sign(diff.y))
	var new_pos = tile_pos + step
	var game_map = get_parent()
	if not game_map.is_walkable(new_pos):
		return
	game_map.occupied_tiles.erase(tile_pos)
	tile_pos = new_pos
	game_map.occupied_tiles[tile_pos] = self
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(tile_pos) * Constants.TILE_SIZE, MOVE_DURATION)

func on_attacked() -> void:
	aggroed = true
