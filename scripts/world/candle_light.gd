extends ColorRect

func _process(_delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		return
	var screen_size := get_viewport().get_visible_rect().size
	var world_to_screen := get_viewport().get_canvas_transform()
	var pos: Vector2 = world_to_screen * player.position
	var uv := pos / screen_size
	material.set_shader_parameter("player_screen_pos", uv)
