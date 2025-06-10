class_name Boss
extends Node

signal boss_return_anim_finish_signal()
signal boss_attack_anim_finish_signal()
signal boss_regular_attack_finish_signal()
signal boss_take_damage_finish_signal()
signal boss_action_finish_signal()

var boss_name: String # Name of the boss
var boss_health_text: RichTextLabel
var boss_attack_text: RichTextLabel
var boss_max_health: int
var boss_health: int
var boss_attack: int

var max_cool_down: int # Boss ability cool down
var curr_cool_down: int

var intended_move_text: RichTextLabel
var battle_manager: Node2D # Battle manager of the level -> initialized in OnSceneStart


# Initialization
func _ready() -> void:
	# Initialize variables
	boss_max_health = CardDatabase.BOSS_STATS[boss_name]["HP"]
	boss_health = boss_max_health
	boss_attack = CardDatabase.BOSS_STATS[boss_name]["Attack"]
	max_cool_down = CardDatabase.BOSS_STATS[boss_name]["CoolDown"]
	curr_cool_down = max_cool_down
	
	boss_health_text = find_child("BossBasic").find_child("BossHealth").find_child("BossHealthText")
	boss_attack_text = find_child("BossBasic").find_child("BossAttack").find_child("BossAttackText")
	
	intended_move_text = find_child("BossBasic").find_child("IntendedMoveText")
	
	# Update boss card
	boss_health_text.text = str(boss_health)
	boss_attack_text.text = str(boss_attack)
	find_child("BossBasic").find_child("BossImage").texture = ResourceLoader.load("res://art/card_images/bosses/" + boss_name + "_Boss.png")
	update_next_move()
	
	# Connect signals
	EventController.connect("update_enemy_intended_move_signal", update_next_move)


# Boss's behavoir functions turn
func boss_turn() -> void:
	# Enter boss turn
	battle_manager.enable_end_turn_button(false)
	intended_move_text.visible = false
	
	# Boss thinking waiting time
	await get_tree().create_timer(0.5).timeout
	
	# Boss action
	if curr_cool_down != 0:
		curr_cool_down -= 1
	on_action()
	await boss_action_finish_signal
	
	# Boss aftermath waiting time
	if get_tree():
		await get_tree().create_timer(0.5).timeout
	
	# Boss turn ends
	intended_move_text.visible = true
	update_next_move()
	battle_manager.start_player_turn()


# Boss take damage
func boss_take_dmg(dmg: float):
	AudioManager.play_sound("ATTACK")
	boss_health = max(0, boss_health - dmg)
	# Check whether boss die and player win
	if boss_health <= 0:
		self.queue_free()
		battle_manager.player_win()
		SceneManager.defeat_boss()
		boss_take_damage_finish_signal.emit()
		return
	
	# Update boss health text and next move
	boss_health_text.text = str(boss_health)
	update_next_move()
	
	# Change font to double size and red
	boss_health_text.add_theme_font_size_override("normal_font_size", 42)
	boss_health_text.add_theme_color_override("default_color", Color.RED)

	# Play animation for health change
	var tween = get_tree().create_tween()
	tween.tween_property(boss_health_text, "theme_override_font_sizes/normal_font_size", 21, 1)
	tween.tween_property(boss_health_text, "theme_override_colors/default_color", Color.BLACK, 1)
	
	boss_take_damage_finish_signal.emit()


# Boss behavior logic
func on_action() -> void:
	pass


# Boss regular attack
# Target one of the cardslot (null means player); Attacker is the node for playing animation
# dmg_to_player is how many damag the player supposed to take
# dmg_coeff is the multiplier for damage
func regular_attack(target: Cardslot, attacker: Node = self, dmg_to_player: int = 1, dmg_coeff: int = 1) -> void:
	var old_pos:Vector2 = attacker.global_position
	if not target:
		boss_attack_player_anim(attacker)
		await boss_attack_anim_finish_signal
		battle_manager.player_take_dmg(dmg_to_player * dmg_coeff)
	else:
		boss_attack_monster_anim(target, attacker)
		await boss_attack_anim_finish_signal
		battle_manager.player_cards_on_battlefield[target].take_damage(boss_attack * dmg_coeff)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos, attacker)
	await boss_return_anim_finish_signal
	
	# Check whether player lose
	battle_manager.player_check_dead()
	await EventController.player_alive_signal
	boss_regular_attack_finish_signal.emit()


# Basic boss choosing target logic
func choose_target() -> Cardslot:
	#for now this is how it will target cards
	if CardslotManager.cardslots[0].card_in_slot:
		return CardslotManager.cardslots[0]
	elif CardslotManager.cardslots[1].card_in_slot and CardslotManager.cardslots[2].card_in_slot:
		var target = randi() % 2
		if target == 0:
			return CardslotManager.cardslots[1]
		else:
			return CardslotManager.cardslots[2]
	else:
		return null # Means the target is the player


# Boss update intended move methods
# Update boss's next move using enum
func update_next_move() -> void:
	# Follow below instructions:
	# 1. Boss logic implementation
	# 2. update_intended_move_text()
	push_error("update_next_move() in Boss.gd NEEDS IMPLEMENTATION")

# Update the text display for the boss's intended move -> should be called inside update_next_move() method
func update_intended_move_text() -> void: 
	intended_move_text.text = get_intended_move_name()

# Return the display name for the boss's next move
func get_intended_move_name() -> String:
	push_error("get_intended_move_text() in Boss.gd NEEDS IMPLEMENTATION")
	return "----"


# Boss attack animations
func boss_attack_player_anim(performer: Node = self):
	# Start animation
	var new_pos_x = 280
	var new_pos = Vector2(new_pos_x, performer.global_position.y)
	var tween = get_tree().create_tween()
	tween.tween_property(performer, "global_position", new_pos, 0.5)
	
	# Signal boss attack animation finished
	await tween.finished
	boss_attack_anim_finish_signal.emit()

func boss_attack_monster_anim(target, performer: Node = self):
	# Start animation
	var new_pos_x = target.global_position.x
	var new_pos_y = target.global_position.y
	var new_pos = Vector2(new_pos_x, new_pos_y)
	var tween = get_tree().create_tween()
	tween.tween_property(performer, "global_position", new_pos, 0.5)
	
	# Signal boss attack animation finished
	await tween.finished
	boss_attack_anim_finish_signal.emit()

func boss_return_pos_anim(old_pos: Vector2, performer: Node = self):
	# Start animation
	AudioManager.play_sound("ATTACK")
	var tween = get_tree().create_tween()
	tween.tween_property(performer, "global_position", old_pos, 0.5)
	
	# Signal boss return animation finished
	await tween.finished
	boss_return_anim_finish_signal.emit()
