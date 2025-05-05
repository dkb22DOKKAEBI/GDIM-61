extends Node

const STARTING_HEALTH = 10
const max_cool_down := 3
const STARTING_HAND_SIZE = 3

var curr_cool_down := 3
var player_cards_on_battlefield # Dictionary

var player_health
var boss_health
var boss_damage = 3
var boss1_stats = {"Vacuum": {"HP": 10, "Attack": 3, "Block": 3, "Kill": 10}}
var monster_cards = {"Sandwich": {"HP":5, "Attack": 1}, "Pizza": {"HP":5, "Attack": 1} }
var selected_card_in_slot: Card
var is_on_player_turn: bool = true
var player_is_attacking: bool = false

@export var battle_timer: Timer
@export var cardslot_1: Node2D
@export var cardslot_2: Node2D
@export var cardslot_3: Node2D

@export var input_manager: Node2D
@export var monster_card_manager: Node2D

@export var enemy: Node2D
@export var enemy_health_text: RichTextLabel
@export var enemy_attack_text: RichTextLabel
@export var player_health_text: RichTextLabel
var player_health_text_prefix: String = "Player Health: "

# Temp for Week 6 build
@export var temp_ui: Control
@export var temp_attack_message: RichTextLabel


func _ready() ->void:
	player_health = STARTING_HEALTH
	player_health_text.text = player_health_text_prefix + str(player_health)
	
	boss_health = STARTING_HEALTH
	enemy_health_text.text = str(boss_health)
	
	player_cards_on_battlefield = {cardslot_1: null, cardslot_2: null, cardslot_3: null}
	
	enemy_attack_text.text = str(boss_damage)
	input_manager.connect("select_placed_card", _player_select_placed_card)
	input_manager.connect("player_attack", _on_player_attack)
	
	# Draw initial hand
	for i in range(STARTING_HAND_SIZE):
		$"../PlayerHand/Deck".draw_card()


func _player_select_placed_card(card: MonsterCard) -> void:
	if card.attacked_this_turn:
		return
	
	print("OUTSIDE " + str(card.get_label_vis()))
	card.selected_label_vis(!card.get_label_vis())
	temp_ui.default_card_info_text = card.card_name
	temp_attack_message.visible = true
	
	# Same card being selected
	if not card.get_label_vis():
		print("HERE")
		selected_card_in_slot = null
		temp_ui.default_card_info_text = ""
		temp_attack_message.visible = false
		return
	
	# Disable select for previous selected card
	if selected_card_in_slot:
		selected_card_in_slot.selected_label_vis(false)
	selected_card_in_slot = card


func _on_player_attack():
	if not selected_card_in_slot:
		return
	
	if not selected_card_in_slot.attacked_this_turn:
		player_is_attacking = true
		selected_card_in_slot.attacked_this_turn = true
		
		monster_attack_boss_anim(selected_card_in_slot)
		await wait(0.5)
		boss_health = max(0, boss_health - selected_card_in_slot.get_attack())
		enemy_health_text.text = str(boss_health)
		
		# Change font to double size and red
		enemy_health_text.add_theme_font_size_override("normal_font_size", 40)
		enemy_health_text.modulate = Color.RED
	
		# Play animation for health change
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_health_text, "theme_override_font_sizes/normal_font_size", 16, 1)
		tween.tween_property(enemy_health_text, "modulate", Color.BLACK, 1)
		
		if boss_health == 0:
			player_win()
		
		# Player attack end
		player_is_attacking = false;
		selected_card_in_slot.selected_label_vis(false)
		selected_card_in_slot = null
		temp_ui.default_card_info_text = ""
		temp_attack_message.visible = false

func monster_attack_boss_anim(card):
	#var new_pos_x = 440
	#var new_pos_y = 0
	var old_pos_x = card.position.x
	var old_pos_y = card.position.y
	#var new_pos = Vector2(new_pos_x, new_pos_y)
	var new_pos = enemy.global_position
	card.z_index = 5
	
	# Monster go attacking
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", new_pos, 0.5)
	await wait(0.5)
	
	# Monster Returning to original position
	var old_pos = Vector2(old_pos_x, old_pos_y)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(card, "position", old_pos, 0.5)
	card.z_index = 1
	await wait(0.5)
	

func player_win():
	$"../UI/GameConditions/WinCondition".visible = true
	enemy.visible = false

func player_lose():
	$"../UI/GameConditions/LoseCondition".visible = true


# End player turn and opponent turn starts
func _on_end_turn_button_pressed() -> void:
	# Check whether the player is attacking
	if player_is_attacking:
		return
	
	# Dis-select card selected in battlefield
	if selected_card_in_slot:
		selected_card_in_slot.selected_label_vis(false)
		selected_card_in_slot = null
		temp_ui.default_card_info_text = ""
		temp_attack_message.visible = false
	is_on_player_turn = false
	
	# Opponent Turn
	opponent_turn()


func reset_cards_attack():
	for key in player_cards_on_battlefield:
		if player_cards_on_battlefield[key]:
			player_cards_on_battlefield[key].attacked_this_turn = false


func opponent_turn():
	$"../UI/Buttons/EndTurnButton".disabled = true
	$"../UI/Buttons/EndTurnButton".visible = false
	
	# Opponent Turn Starts
	battle_timer.start()
	await battle_timer.timeout
	
	# Opponent Move
	curr_cool_down -= 1
	opponent_move()
	
	if curr_cool_down == 0:
		curr_cool_down = max_cool_down
	
	battle_timer.start()
	await battle_timer.timeout
	
	# Opponent Turn Ends
	start_player_turn()


func start_player_turn():
	monster_card_manager.reset_played()
	$"../UI/Buttons/EndTurnButton".disabled = false
	$"../UI/Buttons/EndTurnButton".visible = true
	
	# Draw 2 ingredients card on the start of the player turn
	for i in range(2):
		$"../PlayerHand/Deck".draw_card()
	
	reset_cards_attack()
	is_on_player_turn = true


func opponent_move():
	var skill = randi() % 3
	if curr_cool_down == 0:
		skill = 3
	var target = choose_target()
	
	match skill:
		0 :
			opponent_attack(target)
		1:
			opponent_attack(target)
		2:
			opponent_defend()
		3:
			opponent_eliminate()
		_:
			print("Skill out of range")


func choose_target() -> Cardslot:
	#for now this is how it will target cards
	if cardslot_1.card_in_slot:
		return cardslot_1
	elif cardslot_2.card_in_slot and cardslot_3.card_in_slot:
		var target = randi() % 2
		if target == 0:
			return cardslot_2
		else:
			return cardslot_3
	else:
		return null # Means the target is the player
	
	# Calculate turn numbers needed to kill player
	# and that the cards can kill the enemy
	# to decide which target to choose
	


func opponent_attack(target):
	var old_pos:Vector2 = enemy.global_position
	var boss_attack = boss1_stats["Vacuum"]["Attack"]
	if not target:
		boss_attack_player_anim()
		await wait(0.5)
		
		player_health = max(0, player_health - boss_attack)
		player_health_text.text = player_health_text_prefix + str(player_health)
	else:
		boss_attack_monster_anim(target)
		await wait(0.5)
		player_cards_on_battlefield[target].take_damage(boss_attack)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos)
	
	# Check whether player lose
	if player_health == 0:
		player_lose()
	print("Opponent Attack")


func boss_attack_player_anim():
	var new_pos_x = 280
	var new_pos = Vector2(new_pos_x, enemy.position.y)
	enemy.z_index = 5
	enemy_attack_text.visible = false
	enemy_health_text.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "global_position", new_pos, 0.5)

func boss_attack_monster_anim(target):
	var new_pos_x = target.global_position.x
	var new_pos_y = target.global_position.y
	var new_pos = Vector2(new_pos_x, new_pos_y)
	enemy.z_index = 5
	enemy_attack_text.visible = false
	enemy_health_text.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "global_position", new_pos, 0.5)


func boss_return_pos_anim(old_pos: Vector2):
	#var old_pos_x = 214.5
	#var old_pos_y = 77
	#var old_pos = Vector2(0, 0)
	enemy.z_index = 0
	var tween2 = get_tree().create_tween()
	tween2.tween_property(enemy, "position", old_pos, 0.5)
	await wait(0.5)
	enemy_attack_text.visible = true
	enemy_health_text.visible = true


func wait(wait_time):
	battle_timer.wait_time = wait_time
	battle_timer.start()
	await battle_timer.timeout


func opponent_defend():
	if boss_health == 20:
		var target = choose_target()
		opponent_attack(target)
	else:
		boss_health = min(boss_health + 3, 10)
		enemy_health_text.text = str(boss_health)
		
		# Change font to double size and green
		enemy_health_text.add_theme_font_size_override("normal_font_size", 40)
		enemy_health_text.modulate = Color.GREEN
	
		# Play animation for health change
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_health_text, "theme_override_font_sizes/normal_font_size", 16, 1)
		tween.tween_property(enemy_health_text, "modulate", Color.BLACK, 1)
		
		print("Opponent Defend")


func opponent_eliminate():
	var old_pos:Vector2 = enemy.global_position
	if cardslot_1.card_in_slot:
		boss_attack_monster_anim(cardslot_1)
		await wait(0.5)
		player_cards_on_battlefield[cardslot_1].die()
		boss_return_pos_anim(old_pos)
	elif cardslot_2.card_in_slot:
		boss_attack_monster_anim(cardslot_2)
		await wait(0.5)
		player_cards_on_battlefield[cardslot_2].die()
		boss_return_pos_anim(old_pos)
	elif cardslot_3.card_in_slot:
		boss_attack_monster_anim(cardslot_3)
		await wait(0.5)
		player_cards_on_battlefield[cardslot_3].die()
		boss_return_pos_anim(old_pos)
	else:
		opponent_attack(null)
	print("Opponent Eliminate")

func check_field():
	if not cardslot_1.card_in_slot and not cardslot_2.card_in_slot and not cardslot_3.card_in_slot:
		return true
	else:
		return false
