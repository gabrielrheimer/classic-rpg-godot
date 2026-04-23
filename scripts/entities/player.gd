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

	var game_map = get_parent()
	var in_combat = game_map.is_in_combat()
	var direction := Vector2i.ZERO
	if (in_combat and Input.is_action_just_pressed("move_right")) or (not in_combat and Input.is_action_pressed("move_right")):
		direction = Vector2i(1, 0)
	elif (in_combat and Input.is_action_just_pressed("move_left")) or (not in_combat and Input.is_action_pressed("move_left")):
		direction = Vector2i(-1, 0)
	elif (in_combat and Input.is_action_just_pressed("move_down")) or (not in_combat and Input.is_action_pressed("move_down")):
		direction = Vector2i(0, 1)
	elif (in_combat and Input.is_action_just_pressed("move_up")) or (not in_combat and Input.is_action_pressed("move_up")):
		direction = Vector2i(0, -1)
	else:
		return

	var new_pos = tile_pos + direction
	if not game_map.is_walkable(new_pos):
		return

	tile_pos = new_pos
	is_moving = true

	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(tile_pos) * Constants.TILE_SIZE, MOVE_DURATION)
	tween.tween_callback(func():
		get_parent().run_enemy_turns(self)
		is_moving = false
	)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return
	var clicked_tile = Vector2i(get_global_mouse_position() / Constants.TILE_SIZE)
	var diff = clicked_tile - tile_pos
	var distance = max(abs(diff.x), abs(diff.y))
	var game_map = get_parent()

	if event.button_index == MOUSE_BUTTON_LEFT:
		if is_moving or distance != 1:
			return
		if not game_map.is_walkable(clicked_tile):
			return
		tile_pos = clicked_tile
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(tile_pos) * Constants.TILE_SIZE, MOVE_DURATION)
		tween.tween_callback(func():
			game_map.run_enemy_turns(self)
			is_moving = false
		)

	elif event.button_index == MOUSE_BUTTON_RIGHT:
		if distance != 1:
			return
		if not game_map.occupied_tiles.has(clicked_tile):
			return
		var enemy = game_map.occupied_tiles[clicked_tile]
		enemy.on_attacked()
		var combat = get_node("/root/Combat")
		combat.resolve_attack(stats, enemy.stats, "Player", "Enemy")
		if enemy.stats.hp <= 0:
			game_map.occupied_tiles.erase(clicked_tile)
			enemy.queue_free()
		game_map.run_enemy_turns(self)
