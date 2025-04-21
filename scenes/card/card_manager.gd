class_name CardManager
extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_INGREDIENT_CARD = 8
const DEFAULT_CARD_MOVE_SPEED = 0.1

var card_being_dragged
var screen_size
var is_hovering_on_card
@onready var player_hand_reference: Node2D = $"../Player/PlayerHand"
var played_card_this_turn := false

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	screen_size = get_viewport_rect().size


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


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
