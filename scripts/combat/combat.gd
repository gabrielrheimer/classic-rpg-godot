extends Node

func resolve_attack(attacker_stats: CharacterStats, defender_stats: CharacterStats, attacker_name: String, defender_name: String) -> void:
	var hit = randi_range(0, attacker_stats.melee_skill) > randi_range(0, defender_stats.melee_skill)
	if not hit:
		print("%s missed %s" % [attacker_name, defender_name])
		return
	var damage = max(0, int(randf_range(attacker_stats.attack * 0.8, attacker_stats.attack * 1.2) - randi_range(0, defender_stats.defense)))
	defender_stats.hp -= damage
	print("%s hit %s for %d damage (HP: %d/%d)" % [attacker_name, defender_name, damage, defender_stats.hp, defender_stats.max_hp])
