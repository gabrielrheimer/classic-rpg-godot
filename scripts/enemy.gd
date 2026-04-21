class_name Enemy
extends Node2D

enum Behavior { AGGRESSIVE, RETALIATING, FLEEING }

@export var behavior: Behavior = Behavior.AGGRESSIVE
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
	if max(abs(diff.x), abs(diff.y)) == 1:
		var combat = get_node("/root/Combat")
		combat.resolve_attack(stats, player.stats, "Enemy", "Player")
		if player.stats.hp <= 0:
			print("Player died")

func on_attacked() -> void:
	aggroed = true
