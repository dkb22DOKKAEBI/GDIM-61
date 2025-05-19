class_name Boss
extends Node

var boss_name: String # Name of the boss
@export var boss_health_text: RichTextLabel
@export var boss_attack_text: RichTextLabel
var boss_health: int
var boss_attack: int

var max_cool_down: int # Boss ability cool down
var curr_cool_down: int

var battle_manager: Node2D # Battle manager of the level -> initialized in OnSceneStart


# Initialization
func _ready() -> void:
	# Initialize variables
	boss_health = CardDatabase.BOSS_STATS[boss_name]["HP"]
	boss_attack = CardDatabase.BOSS_STATS[boss_name]["Attack"]
	max_cool_down = CardDatabase.BOSS_STATS[boss_name]["CoolDown"]
	curr_cool_down = max_cool_down
	
	# Update boss health and attack text
	boss_health_text.text = str(boss_health)
	boss_attack_text.text = str(boss_attack)


# Boss's behavoir functions turn
func boss_turn() -> void:
	# Disable end turn button
	battle_manager.enable_end_turn_button(false)
	
	# Boss thinking waiting time
	battle_manager.battle_timer.start()
	await battle_manager.battle_timer.timeout
	
	# Boss action
	curr_cool_down -= 1
	on_action()
	
	if curr_cool_down == 0:
		curr_cool_down = max_cool_down
	
	# Boss aftermath waiting time
	battle_manager.battle_timer.start()
	await battle_manager.battle_timer.timeout
	
	# Boss turn ends
	battle_manager.start_player_turn()


# Boss take damage
func boss_take_dmg(dmg: float):
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
		battle_manager.player_win()
		await battle_manager.wait(1)
		SceneManager.defeat_boss()


# Boss behavior logic
func on_action() -> void:
	pass


# Boss choosing target logic
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


# Boss attack animations
func boss_attack_player_anim():
	var new_pos_x = 280
	var new_pos = Vector2(new_pos_x, battle_manager.enemy.position.y)
	battle_manager.enemy.z_index = 5
	boss_attack_text.visible = false
	boss_health_text.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(battle_manager.enemy, "global_position", new_pos, 0.5)

func boss_attack_monster_anim(target):
	var new_pos_x = target.global_position.x
	var new_pos_y = target.global_position.y
	var new_pos = Vector2(new_pos_x, new_pos_y)
	battle_manager.enemy.z_index = 5
	boss_attack_text.visible = false
	boss_health_text.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(battle_manager.enemy, "global_position", new_pos, 0.5)

func boss_return_pos_anim(old_pos: Vector2):
	battle_manager.enemy.z_index = 0
	var tween2 = get_tree().create_tween()
	tween2.tween_property(battle_manager.enemy, "position", old_pos, 0.5)
	await battle_manager.wait(0.5)
	boss_attack_text.visible = true
	boss_health_text.visible = true
