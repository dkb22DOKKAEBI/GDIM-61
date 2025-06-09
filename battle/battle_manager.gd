extends Node

var player_cards_on_battlefield # Dictionary

var selected_card_in_slot: Card
var player_is_attacking: bool = false
var has_an_abilities = {
	"Pizza"		:true,
	"Cheesecake":false,
	"Sandwich"	:true,
	"Quesadilla":true,
	"Salad"		:true,
	"Taco"		:false,
	"Trashcan"	:false,
	"Eclair"	:false,
	"Donut"		:false,
	"Sushi"		:false,
	"Crepe"		:false,
	"Onigiri"	:true,
	"Charcuterie":false
	}


@export var enemy: Node2D

var card_starting_position: Vector2 = Vector2(100, 525)

# ready function
func _ready() -> void:
	# Display player starting health for each level
	player_cards_on_battlefield = {CardslotManager.cardslots[0]: null, CardslotManager.cardslots[1]: null, CardslotManager.cardslots[2]: null}


func monster_attack_boss_anim(card):
	var old_pos_x = card.position.x
	var old_pos_y = card.position.y
	#var new_pos = Vector2(new_pos_x, new_pos_y)
	var new_pos = enemy.global_position
	card.z_index = 5
	
	# Monster go attacking
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", new_pos, 0.5)
	await get_tree().create_timer(0.5).timeout
	
	# Monster Returning to original position
	var old_pos = Vector2(old_pos_x, old_pos_y)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(card, "position", old_pos, 0.5)
	card.z_index = 1
	await get_tree().create_timer(0.5).timeout
	

func player_win():
	enemy.visible = false

func player_lose():
	# Change scene to Game Over Win scene
	await get_tree().create_timer(0.5).timeout
	SceneManager.transfer_to_game_over_lose()


# End player turn and opponent turn starts
func _on_end_turn_button_pressed() -> void:
	EventController.player_turn_end_signal.emit()
	# Check whether the player is attacking
	AudioManager.play_sound("END_TURN")
	if player_is_attacking:
		return
	
	# Dis-select card selected in battlefield
	if selected_card_in_slot:
		selected_card_in_slot.selected_label_vis(false)
		selected_card_in_slot = null
	PlayerController.is_on_player_turn = false
	
	# Opponent Turn
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.WAITING_TURN
	enemy.get_child(0).boss_turn()


func reset_cards_attack():
	for key in player_cards_on_battlefield:
		if player_cards_on_battlefield[key]:
			player_cards_on_battlefield[key].attacked_this_turn = false


func update_player_cards_on_battlefield() -> void:
	for cardslot in CardslotManager.cardslots:
		player_cards_on_battlefield[cardslot] = cardslot.card_in_slot


# Enable or Disable end turn button when boss attacking
func enable_end_turn_button(enable: bool) -> void:
	$"../UI/Buttons/EndTurnButton".disabled = !enable
	$"../UI/Buttons/EndTurnButton".visible = enable


# Player being attacked
func player_take_dmg(boss_attack: int) -> void:
	PlayerController.player_health = max(0, PlayerController.player_health - boss_attack)
	EventController.update_player_health_signal.emit(PlayerController.player_health)


# Check whether player dead
func player_check_dead() -> void:
	if PlayerController.player_health <= 0:
		player_lose()


# Player's turn starts
func start_player_turn():
	if PlayerController.deck.size() > 0:
		# Return ingredients in player's hand
		PlayerHand.redraw_clear_hand()
		await PlayerHand.return_ingredients_finished_signal
		
		# Redraw ingredients
		var ingredient_num := PlayerHand.selected_ingredients.size()
		for i in range(PlayerController.MAX_INGREDIENT_HAND_NUM - ingredient_num):
			$"../PlayerHand/Deck".draw_card()
		EventController.update_ingredient_num_indicator_signal.emit()
	
	# Update player's and monster cards' status
	reset_cards_attack()
	PlayerController.is_on_player_turn = true
	PlayerController.turn_num += 1
	check_ability_cds()
	
	# Player's turn start
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
	enable_end_turn_button(true)
	
	print("Turn is: " + str(PlayerController.turn_num))


func check_ability_cds():
	for cardslot in CardslotManager.cardslots:
		var slot_id = cardslot.card_slot_number

		if CardslotManager.cardslot_abilities[slot_id][1] == 0:
			var card_name = CardslotManager.cardslot_abilities[slot_id][0]
			
			if card_name == "None":
				continue  # Skip if nothing is in the slot
			
			var has_ability = has_an_abilities[card_name]
			if has_ability:
				var monster_card = cardslot.card_in_slot
				if monster_card and monster_card.has_method("update_ability_button"):
					monster_card.update_ability_button(0)
			else:
				continue

		else:
			CardslotManager.cardslot_abilities[slot_id][1] -= 1
			cardslot.card_in_slot.update_ability_button(CardslotManager.cardslot_abilities[slot_id][1])


func check_field():
	if not CardslotManager.cardslots[0].card_in_slot and not CardslotManager.cardslots[1].card_in_slot and not CardslotManager.cardslots[2].card_in_slot:
		return true
	else:
		return false
