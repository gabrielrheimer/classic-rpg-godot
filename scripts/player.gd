extends Node2D

const INSET = 4
const COLOR_PLAYER = Color(0.1, 0.1, 0.6)

func _draw() -> void:
	var map_renderer = get_parent().get_node("MapRenderer")
	var tile_size = map_renderer.TILE_SIZE
	var draw_x = map_renderer.VIEW_RADIUS_X * tile_size + INSET
	var draw_y = map_renderer.VIEW_RADIUS_Y * tile_size + INSET
	var size = tile_size - INSET * 2
	draw_rect(Rect2(draw_x, draw_y, size, size), COLOR_PLAYER)
