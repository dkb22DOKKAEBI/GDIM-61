class_name Vacuum
extends Boss

signal vacuum_regular_attack_finish_signal()
signal vacuum_defend_finish_signal()
signal vacuum_elimination_finish_signal()

var boss_block: float
var boss_elimination: float


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	boss_block = CardDatabase.BOSS_STATS["Vacuum"]["Block"]
	boss_elimination = CardDatabase.BOSS_STATS["Vacuum"]["Elimination"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Choose ability to use
	if curr_cool_down == 0 and not CardslotManager.check_battlefield_empty(): # Elimination
		vacuum_eliminate()
		curr_cool_down = max_cool_down
		await vacuum_elimination_finish_signal
	else: # Defend or Regular attack
		var check := randf_range(0.0, 1.0) # Determine whether to attack or slef heal with probability
		if check <= (float(boss_health) / float(boss_max_health)) + 0.2:
			var target = choose_target()
			vacuum_attack(target)
			await vacuum_regular_attack_finish_signal
		else:
			vacuum_defend()
			await vacuum_defend_finish_signal
	
	# Signal boss action finishs
	boss_action_finish_signal.emit()


# Boss abilities
# Ability 1: Boss attack
func vacuum_attack(target):
	# Regular attack
	var old_pos:Vector2 = self.global_position
	regular_attack(target)
	await boss_regular_attack_finish_signal
	
	# Signal vacuum regular attack finish
	vacuum_regular_attack_finish_signal.emit()


# Ability 2: Boss defend
func vacuum_defend():
	if boss_health == CardDatabase.BOSS_STATS["Vacuum"]["HP"]:
		var target = choose_target()
		vacuum_attack(target)
	else:
		boss_health = min(boss_health + 3, CardDatabase.BOSS_STATS["Vacuum"]["HP"])
		boss_health_text.text = str(boss_health)
		
		# Change font to double size and green
		boss_health_text.add_theme_font_size_override("normal_font_size", 42)
		boss_health_text.add_theme_color_override("default_color", Color.GREEN)
	
		# Play animation for health change
		var tween = get_tree().create_tween()
		tween.tween_property(boss_health_text, "theme_override_font_sizes/normal_font_size", 21, 1)
		tween.tween_property(boss_health_text, "theme_override_colors/default_color", Color.BLACK, 1)
	
	# Signal vacuum defend finish
	vacuum_defend_finish_signal.emit()


# Ability 3: Boss eliminate
func vacuum_eliminate():
	var old_pos:Vector2 = battle_manager.enemy.global_position
	if CardslotManager.cardslots[0].card_in_slot:
		boss_attack_monster_anim(CardslotManager.cardslots[0])
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[CardslotManager.cardslots[0]].die()
		boss_return_pos_anim(old_pos)
	elif CardslotManager.cardslots[1].card_in_slot:
		boss_attack_monster_anim(CardslotManager.cardslots[1])
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[CardslotManager.cardslots[1]].die()
		boss_return_pos_anim(old_pos)
	elif CardslotManager.cardslots[2].card_in_slot:
		boss_attack_monster_anim(CardslotManager.cardslots[2])
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[CardslotManager.cardslots[2]].die()
		boss_return_pos_anim(old_pos)
	else:
		vacuum_attack(null)
	
	# Signal vacuum elimination finish
	vacuum_elimination_finish_signal.emit()
