extends Node2D

const INSET = 4
const COLOR_PLAYER = Color(0.1, 0.1, 0.6)
const MOVE_DURATION = 0.3

var tile_pos: Vector2i
var is_moving: bool = false

func _ready() -> void:
	var game_map = get_parent()
	tile_pos = Vector2i(game_map.MAP_WIDTH / 2, game_map.MAP_HEIGHT / 2)
	get_parent().get_node("MapRenderer").visual_center = Vector2(tile_pos)

func _input(event: InputEvent) -> void:
	if is_moving:
		return

	var direction := Vector2i.ZERO
	if event.is_action_pressed("move_right"):
		direction = Vector2i(1, 0)
	elif event.is_action_pressed("move_left"):
		direction = Vector2i(-1, 0)
	elif event.is_action_pressed("move_down"):
		direction = Vector2i(0, 1)
	elif event.is_action_pressed("move_up"):
		direction = Vector2i(0, -1)
	else:
		return

	var game_map = get_parent()
	var new_pos = tile_pos + direction
	if not game_map.is_walkable(game_map.grid[new_pos.y][new_pos.x]):
		return

	tile_pos = new_pos
	is_moving = true

	var map_renderer = get_parent().get_node("MapRenderer")
	var tween = create_tween()
	tween.tween_property(map_renderer, "visual_center", Vector2(tile_pos), MOVE_DURATION)
	tween.parallel().tween_method(func(_v): map_renderer.queue_redraw(), 0.0, 1.0, MOVE_DURATION)
	tween.tween_callback(func(): is_moving = false)

func _draw() -> void:
	var map_renderer = get_parent().get_node("MapRenderer")
	var tile_size = map_renderer.TILE_SIZE
	var draw_x = map_renderer.VIEW_RADIUS_X * tile_size + INSET
	var draw_y = map_renderer.VIEW_RADIUS_Y * tile_size + INSET
	var size = tile_size - INSET * 2
	draw_rect(Rect2(draw_x, draw_y, size, size), COLOR_PLAYER)
