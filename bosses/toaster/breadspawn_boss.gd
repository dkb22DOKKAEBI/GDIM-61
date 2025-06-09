class_name Breadspawn
extends Boss

signal breadspawn_attack_finish_signal() # Signal the finish of the breadspawn attack


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Adjust breadspawn scale
	self.scale = Vector2(0.6, 0.6)


func boss_turn() -> void:
	pass


# Do not beat the level when dead
func boss_take_dmg(dmg: float):
	AudioManager.play_sound("ATTACK")
	boss_health = max(0, boss_health - dmg)
	boss_health_text.text = str(boss_health)
	
	# Change font to double size and red
	boss_health_text.add_theme_font_size_override("normal_font_size", 42)
	boss_health_text.add_theme_color_override("default_color", Color.RED)

	# Play animation for health change
	var tween = get_tree().create_tween()
	tween.tween_property(boss_health_text, "theme_override_font_sizes/normal_font_size", 21, 1)
	tween.tween_property(boss_health_text, "theme_override_colors/default_color", Color.BLACK, 1)
	
	# Check whether boss die and player win
	if boss_health <= 0:
		self.queue_free()


# Boss abilities
# Ability 1: Regular attack
func breadspawn_attack() -> void:
	# Regular Attack
	var target = choose_target()
	regular_attack(target)
	await boss_regular_attack_finish_signal
	
	# Signal attack finished
	breadspawn_attack_finish_signal.emit()


func update_next_move() -> void:
	update_intended_move_text()

# Return the display name for the boss's next move
func get_intended_move_name() -> String:
	return "Regular Attack"
