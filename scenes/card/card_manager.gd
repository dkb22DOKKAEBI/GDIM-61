class_name CardManager
extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_INGREDIENT_CARD = 8
const DEFAULT_CARD_MOVE_SPEED = 0.1

var card_being_dragged # Card type
var screen_size
#var is_hovering_on_card

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	screen_size = get_viewport_rect().size


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_hovered_over_card(card):
	if not card_being_dragged:
		highlight_card(card, true)


func on_hovered_off_card(card):
	if not card_being_dragged:
		#if not dragging
		highlight_card(card, false)


func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(0.6, 0.6)
		card.set_card_z_index(2)
	else:
		card.scale = Vector2(0.475, 0.475)
		card.set_card_z_index(1)
