extends Node2D

func _process(_delta: float) -> void:
	var tile = Vector2i(get_global_mouse_position() / Constants.TILE_SIZE)
	position = Vector2(tile) * Constants.TILE_SIZE
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, Constants.TILE_SIZE, Constants.TILE_SIZE), Color(1, 1, 1, 0.6), false, 1.5)
