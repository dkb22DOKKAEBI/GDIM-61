class_name CardManager
extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_INGREDIENT_CARD = 8
const DEFAULT_CARD_MOVE_SPEED = 0.1

var card_being_dragged # Card type
var screen_size
@export var temp_ui: Control
@export var cover: ColorRect


# Ready
func _ready()->void:
	screen_size = get_viewport_rect().size


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


# Hover over card
func on_hovered_over_card(card):
	# Return if the card is being dragged or is in animation
	if card_being_dragged or card.is_in_animation:
		return
	
	# Return if not able to hover over
	if card.is_highlighted:
		return
	
	# Highlight card
	card.is_highlighted = true
	card.scale *= 1.2
	card.set_card_z_index(2)
	
	# Check whether is monster card
	if card.is_monster_card and not card.placed:
		# Update PlayerHand for how many monster card hovered over
		PlayerHand.hovering_monster_num += 1
		
		# Disable all detection for ingredient cards hover
		for ingredient_card in PlayerHand.player_ingredient_hand:
			if ingredient_card.scale.x == 1.2:
				#highlight_card(ingredient_card, false)
				on_hovered_off_card(ingredient_card)
			ingredient_card.set_pickable(false)
		
		# Move monster card up
		var new_position: Vector2 = card.position
		new_position.y -= PlayerHand.MONSTER_CARD_UP_Y_OFFSET
		PlayerHand.animate_card_to_position(card, new_position, 0)
		
		# Make cover for ingredient cards visible
		if PlayerHand.hovering_monster_num != 0:
			cover.visible = true
	
	# Update sidebar UI
	temp_ui.update_card_info(card.card_name)


# Hover off card
func on_hovered_off_card(card):
	# Return if the card is being dragged or is in animation
	if card_being_dragged or card.is_in_animation:
		return
	
	# Return if the card is not able to hover off
	if not card.is_highlighted:
		return
	
	# Dis-highlight card
	card.is_highlighted = false
	card.scale /= 1.2
	card.set_card_z_index(0)
	
	# Check whether is monster card
	if card.is_monster_card and not card.placed:
		# Update PlayerHand for how many monster card hovered over
		PlayerHand.hovering_monster_num -= 1
		
		# Enable all detection for ingredient cards hover
		for ingredient_card in PlayerHand.player_ingredient_hand:
			ingredient_card.set_pickable(true)
		
		# Move monster card down
		var new_position: Vector2 = card.position
		new_position.y += PlayerHand.MONSTER_CARD_UP_Y_OFFSET
		PlayerHand.animate_card_to_position(card, new_position, 0)
		
		# Make cover for ingredient cards invisible if no monster card hovered over
		if PlayerHand.hovering_monster_num == 0:
			cover.visible = false
	
	# Update sidebar UI
	temp_ui.update_card_info(temp_ui.default_card_info_text)
