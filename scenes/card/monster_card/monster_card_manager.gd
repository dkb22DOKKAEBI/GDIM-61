extends CardManager


var played_card_this_turn := false


func _ready():
	super._ready()
	$"../Player/InputManager".connect("left_mouse_button_released", on_left_clicked_released)
	
	# TEST ONLY
	var card_scene = preload("res://scenes/card/monster_card/card.tscn")
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://cards/" + "Pizza" + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Attack").text = str(3)
	new_card.get_node("Health").text = str(2)
	$"../MonsterCardManager".add_child(new_card)
	new_card.name = "MonsterCard"
	$"../Player/PlayerHand".add_card_to_hand(new_card, 1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float)-> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
		clamp(mouse_pos.y, 0, screen_size.y))


func start_drag(card):
	print("Drag Start")
	card_being_dragged = card
	card.scale = Vector2(0.45, 0.45)


func on_left_clicked_released():
	if card_being_dragged:
		finish_drag()


func finish_drag():
	card_being_dragged.scale = Vector2(0.475, 0.475)
	var card_slot_found = raycast_check_for_card_slot()

	if card_slot_found and not card_slot_found.card_in_slot and not played_card_this_turn:
		played_card_this_turn = true
		is_hovering_on_card = false
		player_hand_reference.remove_card_from_hand(card_being_dragged, 1)
		
		#Card dropped in empty card slot
		card_being_dragged.get_parent().remove_child(card_being_dragged)
		card_slot_found.add_child(card_being_dragged)
		card_being_dragged.global_position = card_slot_found.global_position
		
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_being_dragged.placed = true
		card_slot_found.card_in_slot = true
		card_being_dragged.card_slot_on = card_slot_found
		$"../BattleManager".player_cards_on_battlefield[card_slot_found] = card_being_dragged
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED, 1)
	card_being_dragged = null
	player_hand_reference.test()
	print("On finish drag end")


func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null


func reset_played():
	played_card_this_turn = false
