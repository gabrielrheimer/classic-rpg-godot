class_name Enemy
extends Node2D

const MOVE_DURATION = 0.3

enum Behavior { AGGRESSIVE, RETALIATING, FLEEING }

@export var behavior: Behavior = Behavior.RETALIATING
@export var roam_radius: int = 4
@export var roam_interval: float = 2.0
@export var roam_variance: float = 0.3
@export var sight_radius: int = 4
@export var call_radius: int = 5

var aggroed: bool = false
var stats := CharacterStats.new()
var tile_pos: Vector2i
var home: Vector2i
var group_id: String = ""
var roams: bool = true

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = randf_range(roam_interval - roam_variance, roam_interval + roam_variance)
	timer.autostart = true
	timer.timeout.connect(_on_roam_timer)
	add_child(timer)

func _on_roam_timer() -> void:
	if not is_inside_tree():
		return
	var game_map = get_parent()
	var player = game_map.get_node("Player")
	var dist_to_player = max(abs(player.tile_pos.x - tile_pos.x), abs(player.tile_pos.y - tile_pos.y))

	var path_len: int = game_map.get_path_length(tile_pos, player.tile_pos)
	if behavior == Behavior.AGGRESSIVE and not aggroed and dist_to_player <= sight_radius and path_len <= sight_radius * 2:
		on_attacked()
		return

	if behavior == Behavior.FLEEING:
		if game_map.is_in_combat():
			return
		if dist_to_player <= sight_radius:
			_flee_from(player.tile_pos, game_map)
		elif roams:
			_roam(game_map)
		return

	if not roams or aggroed or game_map.is_in_combat():
		return
	_roam(game_map)

func _roam(game_map: Node2D) -> void:
	var candidates: Array[Vector2i] = []
	for dir in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
		var n = tile_pos + dir
		if not game_map.is_walkable(n):
			continue
		if max(abs(n.x - home.x), abs(n.y - home.y)) > roam_radius:
			continue
		candidates.append(n)
	if candidates.is_empty():
		return
	_do_move(candidates[randi() % candidates.size()], game_map)

func take_turn(player: Node2D) -> void:
	if not aggroed or not is_inside_tree():
		return
	if behavior == Behavior.FLEEING:
		_flee_from(player.tile_pos, get_parent())
		return
	var diff = player.tile_pos - tile_pos
	var distance = max(abs(diff.x), abs(diff.y))
	if distance == 1:
		var combat = get_node("/root/Combat")
		combat.resolve_attack(stats, player.stats, "Enemy", "Player")
		if player.stats.hp <= 0:
			print("Player died")
	elif distance > 1:
		_move_toward(player.tile_pos)

func _flee_from(player_pos: Vector2i, game_map: Node2D) -> void:
	var best_tile: Vector2i
	var best_dist: int = -1
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
			var n = tile_pos + Vector2i(dx, dy)
			if not game_map.is_walkable(n):
				continue
			var d = max(abs(n.x - player_pos.x), abs(n.y - player_pos.y))
			if d > best_dist:
				best_dist = d
				best_tile = n
	if best_dist >= 0:
		_do_move(best_tile, game_map)

func _move_toward(target: Vector2i) -> void:
	var game_map = get_parent()
	var exclude: Array[Vector2i] = [tile_pos]
	var path = game_map.get_tile_path(tile_pos, target, exclude)
	if path.is_empty():
		return
	var next = path[0]
	if next == target:
		return  # would land on player tile
	_do_move(next, game_map)

func _do_move(new_pos: Vector2i, game_map: Node2D) -> void:
	if not game_map.is_passable(new_pos) or game_map.occupied_tiles.has(new_pos):
		return
	game_map.occupied_tiles.erase(tile_pos)
	tile_pos = new_pos
	game_map.occupied_tiles[tile_pos] = self
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(tile_pos) * Constants.TILE_SIZE, MOVE_DURATION)

func on_attacked() -> void:
	if aggroed:
		return
	aggroed = true
	if group_id == "" or call_radius == 0:
		return
	var game_map = get_parent()
	for enemy in game_map.occupied_tiles.values():
		if enemy == self or enemy.group_id != group_id:
			continue
		var dist = max(abs(enemy.tile_pos.x - tile_pos.x), abs(enemy.tile_pos.y - tile_pos.y))
		if dist <= call_radius:
			enemy.on_attacked()
