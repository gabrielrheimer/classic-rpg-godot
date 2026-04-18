extends RefCounted

const WALL_SEGMENTS = 40
const SPAWN_BUFFER = 3

static func fill(grid: Array, map_width: int, map_height: int) -> void:
	var center = Vector2i(map_width / 2, map_height / 2)

	for i in range(WALL_SEGMENTS):
		var col = randi_range(1, map_width - 2)
		var row = randi_range(1, map_height - 2)
		var length = randi_range(2, 5)
		var horizontal = randi() % 2 == 0

		for j in range(length):
			var c = col + (j if horizontal else 0)
			var r = row + (0 if horizontal else j)
			if c <= 0 or c >= map_width - 1 or r <= 0 or r >= map_height - 1:
				break
			if abs(c - center.x) <= SPAWN_BUFFER and abs(r - center.y) <= SPAWN_BUFFER:
				continue
			grid[r][c] = 1
