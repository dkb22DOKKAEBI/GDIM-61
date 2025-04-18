extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released
signal select_placed_card(card: Card)
signal player_attack

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

@onready var card_manager_reference: Node2D = $"../../CardManager"
@onready var deck_reference: Node2D = $"../../Deck"

func _ready() -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
	
	if Input.is_key_pressed(KEY_SPACE):
		player_attack.emit()



func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			#Card Clicked
			var card_found = result[0].collider.get_parent()
			if card_found:
				if not card_found.placed:
					card_manager_reference.start_drag(card_found)
				else:
					select_placed_card.emit(card_found)
		elif result_collision_mask == COLLISION_MASK_DECK:
			#Deck Clicked
			deck_reference.draw_card()
