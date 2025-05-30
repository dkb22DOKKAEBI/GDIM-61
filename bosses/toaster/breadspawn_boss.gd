class_name Breadspawn
extends Boss


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()


func boss_turn() -> void:
	pass


# Do not beat the level when dead
func boss_take_dmg(dmg: float):
	AudioManager.play_sound("ATTACK")
	boss_health = max(0, boss_health - dmg)
	boss_health_text.text = str(boss_health)
	
	# Change font to double size and red
	boss_health_text.add_theme_font_size_override("normal_font_size", 40)
	boss_health_text.modulate = Color.RED

	# Play animation for health change
	var tween = get_tree().create_tween()
	tween.tween_property(boss_health_text, "theme_override_font_sizes/normal_font_size", 16, 1)
	tween.tween_property(boss_health_text, "modulate", Color.BLACK, 1)
	
	# Check whether boss die and player win
	if boss_health <= 0:
		#await battle_manager.wait(1)
		SceneManager.defeat_boss()


# Boss abilities
# Ability 1: Regular attack
func breadspawn_attack() -> void:
	# Choose target
	var target = choose_target()
	
	var old_pos:Vector2 = self.global_position
	if not target:
		boss_attack_player_anim()
		await battle_manager.wait(0.5)
		battle_manager.player_take_dmg(1)
	else:
		boss_attack_monster_anim(target)
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[target].take_damage(boss_attack)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos)
	
	# Check whether player lose
	battle_manager.player_check_dead()
