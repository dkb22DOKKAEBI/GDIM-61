extends Node

const STARTING_HEALTH = 10
const STARTING_HAND_SIZE = 3
const MONSTER_CARD_SCENE_PATH = "res://scenes/card/card.tscn"

var player_cards_on_battlefield # Dictionary

var player_health
var selected_card_in_slot: Card
var is_on_player_turn: bool = true
var player_is_attacking: bool = false

@export var battle_timer: Timer

@export var input_manager: Node2D
@export var monster_card_manager: Node2D

@export var enemy: Node2D
@export var player_health_text: RichTextLabel
var player_health_text_prefix: String = "Player Health: "

# Temp for Week 6 build
@export var temp_ui: Control
@export var temp_attack_message: RichTextLabel

@export var ability_manager: Node2D # never used
var card_starting_position: Vector2 = Vector2(100, 525)


# ready function
func _ready() -> void:
	# Set up
	player_health = STARTING_HEALTH
	player_health_text.text = player_health_text_prefix + str(player_health)
	player_cards_on_battlefield = {CardslotManager.cardslots[0]: null, CardslotManager.cardslots[1]: null, CardslotManager.cardslots[2]: null}
	
	input_manager.connect("select_placed_card", _player_select_placed_card)
	input_manager.connect("player_attack", _on_player_attack)
	
	# Draw initial hand
	for i in range(STARTING_HAND_SIZE):
		$"../PlayerHand/Deck".draw_card()


func _player_select_placed_card(card: MonsterCard) -> void:
	if card.attacked_this_turn or player_is_attacking:
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
	
	if not player_is_attacking and not selected_card_in_slot.attacked_this_turn:
		player_is_attacking = true
		selected_card_in_slot.attacked_this_turn = true
		
		monster_attack_boss_anim(selected_card_in_slot)
		await wait(0.5)
		if selected_card_in_slot.get_attack() > 0:
			enemy.get_child(0).boss_take_dmg(selected_card_in_slot.get_attack())
		
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
	enemy.get_child(0).boss_turn()


func reset_cards_attack():
	for key in player_cards_on_battlefield:
		if player_cards_on_battlefield[key]:
			player_cards_on_battlefield[key].attacked_this_turn = false


# Enable or Disable end turn button when boss attacking
func enable_end_turn_button(enable: bool) -> void:
	$"../UI/Buttons/EndTurnButton".disabled = !enable
	$"../UI/Buttons/EndTurnButton".visible = enable


# Player being attacked
func player_take_dmg(boss_attack: float) -> void:
	player_health = max(0, player_health - boss_attack)
	player_health_text.text = player_health_text_prefix + str(player_health)


# Check whether player dead
func player_check_dead() -> void:
	if player_health == 0:
		player_lose()


func start_player_turn():
	monster_card_manager.reset_played()
	enable_end_turn_button(true)
	
	# Draw 2 ingredients card on the start of the player turn
	for i in range(2):
		$"../PlayerHand/Deck".draw_card()
	
	reset_cards_attack()
	check_ability_cds()
	is_on_player_turn = true


func check_ability_cds():
	for cardslot in CardslotManager.cardslots:
		var slot_id = cardslot.card_slot_number

		if CardslotManager.cardslot_abilities[slot_id][1] == 0:
			var card_name = CardslotManager.cardslot_abilities[slot_id][0]
			if card_name == "None":
				continue  # Skip if nothing is in the slot

			var card_scene = preload(MONSTER_CARD_SCENE_PATH)
			var ability_instance = Ability.new()
			var result_ability = ability_instance.add_ability_card(card_name)
			if result_ability == null:
				continue  # this card has no ability, skip it
			var ability_name = result_ability[0]

			var new_card: Node2D = card_scene.instantiate()
			new_card.get_node("CardImage").texture = ResourceLoader.load("res://cards/" + ability_name + ".png")
			new_card.get_node("Attack").text = str(result_ability[1])
			monster_card_manager.add_child(new_card)

			if monster_card_manager.visible:
				new_card.set_card_z_index(1)
			else:
				new_card.set_card_z_index(0)

			new_card.name = "AbilityCard"
			new_card.card_name = ability_name
			new_card.position = card_starting_position
			PlayerHand.add_card_to_hand(new_card, 1, 1)

			CardslotManager.cardslot_abilities[slot_id][1] = CardslotManager.card_ability_cds[card_name]
		else:
			CardslotManager.cardslot_abilities[slot_id][1] -= 1
			print("Decreased cooldown for", slot_id, "to", CardslotManager.cardslot_abilities[slot_id][1])


func wait(wait_time):
	battle_timer.wait_time = wait_time
	battle_timer.start()
	await battle_timer.timeout


func check_field():
	if not CardslotManager.cardslots[0].card_in_slot and not CardslotManager.cardslots[1].card_in_slot and not CardslotManager.cardslots[2].card_in_slot:
		return true
	else:
		return false
