extends Panel

func update(stats: CharacterStats) -> void:
	$VBox/LevelLabel.text = "Level: %d" % stats.level
	$VBox/XPBar.value = stats.exp
	$VBox/XPBar/XPLabel.text = "EXP: %d%%" % stats.exp
	$VBox/HPBar.max_value = stats.max_hp
	$VBox/HPBar.value = stats.hp
	$VBox/HPBar/HPLabel.text = "HP: %d / %d" % [stats.hp, stats.max_hp]
	$VBox/MeleeBar.value = stats.melee_xp
	$VBox/MeleeBar/MeleeLabel.text = "Melee: %d (%d%%)" % [stats.melee_skill, stats.melee_xp]
	$VBox/RangedBar.value = stats.ranged_xp
	$VBox/RangedBar/RangedLabel.text = "Ranged: %d (%d%%)" % [stats.ranged_skill, stats.ranged_xp]
	$VBox/MagicBar.value = stats.magic_xp
	$VBox/MagicBar/MagicLabel.text = "Magic: %d (%d%%)" % [stats.magic_skill, stats.magic_xp]
