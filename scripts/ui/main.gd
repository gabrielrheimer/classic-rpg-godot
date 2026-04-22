extends Control

func _ready() -> void:
	var game_map = $SubViewportContainer/SubViewport/GameMap
	game_map.player_stats_changed.connect($HUD.update)
