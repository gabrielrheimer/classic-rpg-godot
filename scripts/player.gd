extends Node2D

const TILE_SIZE = 32
const MOVE_DURATION = 0.3

var tile_pos: Vector2i
var is_moving: bool = false

func _ready() -> void:
	tile_pos = Vector2i(10, 10)
	position = Vector2(tile_pos) * TILE_SIZE

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
	tween.tween_property(self, "position", Vector2(tile_pos) * TILE_SIZE, MOVE_DURATION)
	tween.tween_callback(func(): is_moving = false)
