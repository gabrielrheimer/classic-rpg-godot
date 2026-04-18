extends Node2D

enum TileType { FLOOR, WALL }

const MAP_WIDTH = 50
const MAP_HEIGHT = 50

var grid: Array = []

func _ready() -> void:
	for row in range(MAP_HEIGHT):
		var row_data: Array = []
		for col in range(MAP_WIDTH):
			var is_border = row == 0 or row == MAP_HEIGHT - 1 or col == 0 or col == MAP_WIDTH - 1
			row_data.append(TileType.WALL if is_border else TileType.FLOOR)
		grid.append(row_data)
