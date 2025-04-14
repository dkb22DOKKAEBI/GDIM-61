extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1

var card_being_dragged
var screen_size
var is_hovering_on_card
var player_hand_reference
var played_card_this_turn := false

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_clicked_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float)-> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
		clamp(mouse_pos.y, 0, screen_size.y))


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(0.45, 0.45)


func finish_drag():
	card_being_dragged.scale = Vector2(0.475, 0.475)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot and not played_card_this_turn:
			played_card_this_turn = true
			is_hovering_on_card = false
			player_hand_reference.remove_card_from_hand(card_being_dragged)
			#Card dropped in empty card slot
			card_being_dragged.global_position = card_slot_found.global_position
			#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
			card_being_dragged.placed = true
			card_slot_found.card_in_slot = true
			$"../BattleManager".player_cards_on_battlefield.append(card_being_dragged)
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_being_dragged = null


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_left_clicked_released():
	if card_being_dragged:
		finish_drag()


func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)


func on_hovered_off_card(card):
	if !card_being_dragged:
		#if not dragging
		highlight_card(card, false)
		#Check if hovered off card straight on to another card
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false


func highlight_card(card, hovered):
	#if hovered:
		#card.scale = Vector2(1, 1)
		#card.z_index = 2
	#else:
		#card.scale = Vector2(0.475, 0.475)
		#card.z_index = 1
	pass 
	# function deadass dont do nothin


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


func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null


func get_card_with_highest_z_index(cards):
	#Assume the first card in cards array has the highest z index
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	#Loop through the rest of the cards checking for higher z index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card


func reset_played():
	played_card_this_turn = false
