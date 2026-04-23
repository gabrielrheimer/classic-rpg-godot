extends Node2D

const MOVE_DURATION = 0.3

var stats := CharacterStats.new()
var tile_pos: Vector2i
var is_moving: bool = false
var _path: Array[Vector2i] = []

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

	_path.clear()
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
		if is_moving:
			return
		if game_map.is_in_combat():
			if distance == 1:
				if not game_map.is_walkable(clicked_tile):
					return
				_do_move(clicked_tile, game_map)
			else:
				var step: Vector2i
				if abs(diff.x) >= abs(diff.y):
					step = Vector2i(sign(diff.x), 0)
				else:
					step = Vector2i(0, sign(diff.y))
				var next = tile_pos + step
				if not game_map.is_walkable(next):
					return
				_do_move(next, game_map)
		else:
			if distance == 0:
				return
			if distance == 1:
				if not game_map.is_walkable(clicked_tile):
					return
				_path.clear()
				_do_move(clicked_tile, game_map)
			else:
				_path = game_map.get_tile_path(tile_pos, clicked_tile)
				_walk_next_step()

	elif event.button_index == MOUSE_BUTTON_RIGHT:
		if distance != 1:
			return
		if not game_map.occupied_tiles.has(clicked_tile):
			return
		_path.clear()
		var enemy = game_map.occupied_tiles[clicked_tile]
		enemy.on_attacked()
		var combat = get_node("/root/Combat")
		combat.resolve_attack(stats, enemy.stats, "Player", "Enemy")
		if enemy.stats.hp <= 0:
			game_map.occupied_tiles.erase(clicked_tile)
			enemy.queue_free()
		game_map.run_enemy_turns(self)

func _do_move(target: Vector2i, game_map: Node2D) -> void:
	tile_pos = target
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(tile_pos) * Constants.TILE_SIZE, MOVE_DURATION)
	tween.tween_callback(func():
		game_map.run_enemy_turns(self)
		is_moving = false
		_walk_next_step()
	)

func _walk_next_step() -> void:
	if _path.is_empty():
		return
	var game_map = get_parent()
	if game_map.is_in_combat():
		_path.clear()
		return
	var next_tile = _path.pop_front()
	if not game_map.is_walkable(next_tile):
		_path.clear()
		return
	_do_move(next_tile, game_map)
