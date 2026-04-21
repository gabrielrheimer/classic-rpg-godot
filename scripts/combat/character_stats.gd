class_name CharacterStats
extends Resource

@export var max_hp: int = 10
@export var hp: int = 10
@export var attack: int = 5
@export var defense: int = 2
@export var melee_skill: int = 1
@export var melee_xp: int = 0
@export var ranged_skill: int = 1
@export var ranged_xp: int = 0
@export var magic_skill: int = 1
@export var magic_xp: int = 0
@export var level: int = 1
@export var exp: int = 0

func add_exp(amount: int) -> void:
	exp += amount
	if exp >= 100:
		level += 1
		exp -= 100

func add_skill_xp(skill: String, amount: int) -> void:
	match skill:
		"melee":
			melee_xp += amount
			if melee_xp >= 100:
				melee_skill += 1
				melee_xp -= 100
		"ranged":
			ranged_xp += amount
			if ranged_xp >= 100:
				ranged_skill += 1
				ranged_xp -= 100
		"magic":
			magic_xp += amount
			if magic_xp >= 100:
				magic_skill += 1
				magic_xp -= 100
