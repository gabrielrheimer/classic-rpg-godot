extends Node2D

const MOVE_DURATION = 0.3

var stats := CharacterStats.new()
var tile_pos: Vector2i
var is_moving: bool = false

func _ready() -> void:
	tile_pos = Vector2i(10, 10)
	position = Vector2(tile_pos) * Constants.TILE_SIZE

func _process(_delta: float) -> void:
	if is_moving:
		return

	var direction := Vector2i.ZERO
	if Input.is_action_pressed("move_right"):
		direction = Vector2i(1, 0)
	elif Input.is_action_pressed("move_left"):
		direction = Vector2i(-1, 0)
	elif Input.is_action_pressed("move_down"):
		direction = Vector2i(0, 1)
	elif Input.is_action_pressed("move_up"):
		direction = Vector2i(0, -1)
	else:
		return

	var game_map = get_parent()
	var new_pos = tile_pos + direction
	if not game_map.is_walkable(new_pos):
		return

	tile_pos = new_pos
	is_moving = true

	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(tile_pos) * Constants.TILE_SIZE, MOVE_DURATION)
	tween.tween_callback(func(): is_moving = false)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_RIGHT or not event.pressed:
		return
	var clicked_tile = Vector2i(get_global_mouse_position() / Constants.TILE_SIZE)
	var diff = clicked_tile - tile_pos
	if abs(diff.x) + abs(diff.y) != 1:
		return
	var game_map = get_parent()
	if not game_map.occupied_tiles.has(clicked_tile):
		return
	var enemy = game_map.occupied_tiles[clicked_tile]
	Combat.resolve_attack(stats, enemy.stats, "Player", "Enemy")
	if enemy.stats.hp <= 0:
		game_map.occupied_tiles.erase(clicked_tile)
		enemy.queue_free()
		return
	Combat.resolve_attack(enemy.stats, stats, "Enemy", "Player")
	if stats.hp <= 0:
		print("Player died")
