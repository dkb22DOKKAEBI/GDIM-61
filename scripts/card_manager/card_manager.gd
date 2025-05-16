class_name CardManager
extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_INGREDIENT_CARD = 8
const DEFAULT_CARD_MOVE_SPEED = 0.1

var card_being_dragged # Card type
var screen_size
#var is_hovering_on_card
@export var temp_ui: Control
@export var cover: ColorRect


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	screen_size = get_viewport_rect().size


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_hovered_over_card(card):
	if card_being_dragged:
		return
	
	# Check whether is monster card
	if card.is_monster_card:
		# Disable all detection for ingredient cards hover
		for ingredient_card in PlayerHand.player_ingredient_hand:
			if ingredient_card.scale.x == 1.2:
				highlight_card(ingredient_card, false)
			ingredient_card.set_pickable(false)
		
		# Make cover for ingredient cards visible
		cover.visible = true
	
	highlight_card(card, true)
	
	# Update sidebar UI
	temp_ui.update_card_info(card.card_name)


func on_hovered_off_card(card):
	if card_being_dragged:
		return
	
	# Check whether is monster card
	if card.is_monster_card:
		# Enable all detection for ingredient cards hover
		for ingredient_card in PlayerHand.player_ingredient_hand:
			ingredient_card.set_pickable(true)
		
		# Make cover for ingredient cards invisible
		cover.visible = false
	
	highlight_card(card, false)
	
	# Update sidebar UI
	temp_ui.update_card_info(temp_ui.default_card_info_text)


func highlight_card(card, hovered):
	if hovered:
		#card.scale = Vector2(1.25, 1.25)
		card.scale *= 1.2
		card.set_card_z_index(2)
		
		# Move up monster card
		if card.is_monster_card:
			var new_position: Vector2 = card.position
			new_position.y -= PlayerHand.MONSTER_CARD_Y_OFFSET
			PlayerHand.animate_card_to_position(card, new_position, 0.1)
	else:
		#card.scale = Vector2(1, 1)
		card.scale /= 1.2
		card.set_card_z_index(0)
		
		# Move down monster card
		if card.is_monster_card:
			var new_position: Vector2 = card.position
			new_position.y += PlayerHand.MONSTER_CARD_Y_OFFSET
			PlayerHand.animate_card_to_position(card, new_position, 0.1)
