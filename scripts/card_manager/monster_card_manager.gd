extends CardManager

var played_card_this_turn := false
@export var input_manager: Node2D
@export var battle_manager: Node2D

func _ready():
	super._ready()
	input_manager.connect("left_mouse_button_released", on_left_clicked_released)
	
	# Restore monster hand at the start of a level
	for monster_name: String in PlayerHand.legacy_monster_hand:
		var card_scene = preload("res://scenes/card/card.tscn")
		var new_card = card_scene.instantiate()
		var card_image_path = str("res://cards/" + monster_name + ".png")
		new_card.get_node("CardImage").texture = ResourceLoader.load(card_image_path)
		new_card.get_node("Attack").text = str(CardDatabase.CARDS[monster_name][0])
		new_card.get_node("Health").text = str(CardDatabase.CARDS[monster_name][1])
		self.add_child(new_card)
		new_card.name = "MonsterCard"
		new_card.card_name = monster_name
		new_card.position = Vector2(100, 525)
		new_card.scale = Vector2(1, 1)
		PlayerHand.add_card_to_hand(new_card, 1, 1)
		if self.visible:
			new_card.set_card_z_index(1)
		else:
			new_card.set_card_z_index(0)
	PlayerHand.legacy_monster_hand.clear()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float)-> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
		clamp(mouse_pos.y, 0, screen_size.y))


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)


func on_left_clicked_released():
	if card_being_dragged:
		finish_drag()


func finish_drag():
	card_being_dragged.scale = Vector2(1, 1)
	var card_slot_found = raycast_check_for_card_slot()
	
	# Check whether card goes into  cardslot or goes back to hand
	if card_slot_found and not card_slot_found.card_in_slot and not played_card_this_turn:
		#played_card_this_turn = true
		PlayerHand.remove_card_from_hand(card_being_dragged, 1)
		
		#Card dropped in empty card slot
		card_being_dragged.get_parent().remove_child(card_being_dragged)
		card_slot_found.add_child(card_being_dragged)
		card_being_dragged.global_position = card_slot_found.global_position
		card_being_dragged.scale = Vector2(1.3, 1.3) * 1.2
		
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_being_dragged.placed = true
		card_slot_found.card_in_slot = card_being_dragged
		CardslotManager.test() # Only for test purpose
		card_being_dragged.card_slot_on = card_slot_found
		battle_manager.player_cards_on_battlefield[card_slot_found] = card_being_dragged
	else:
		PlayerHand.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED, 1)
	
	# Check if mouse hovering on any card
	var new_card_hovered = raycast_check_for_card()
	card_being_dragged = null
	if new_card_hovered:
		super.highlight_card(new_card_hovered, true)


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


func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD + COLLISION_MASK_INGREDIENT_CARD
	var result = space_state.intersect_point(parameters)
	
	# Turn collider array into Card array
	var cards: Array[Card]
	for col in result:
		cards.append(col.collider.get_parent())
	
	# Get rid of dragged card for raycast check
	if cards.has(card_being_dragged):
		cards.erase(card_being_dragged)
	if cards.size() > 0:
		return get_card_with_highest_z_index(cards)
	return null


func get_card_with_highest_z_index(cards):
	#Assume the first card in cards array has the highest z index
	var highest_z_card = cards[0]
	var highest_z_index = highest_z_card.z_index
	
	#Loop through the rest of the cards checking for higher z index
	for i in range(1, cards.size()):
		var current_card = cards[i]
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
