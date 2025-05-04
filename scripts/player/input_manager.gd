extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released
signal select_placed_card(card: Card)
signal player_attack

const COLLISION_MASK_MONSTER_CARD = 1
const COLLISION_MASK_DECK = 4
const COLLISION_MASK_INGREDIENT_CARD = 8

# @onready var card_manager_reference: Node2D = $"../../MonsterCardManager"
# @onready var deck_reference: Node2D = $"../../Deck"
@export var battle_manager: Node2D
@export var card_manager_reference: Node2D
@export var deck_reference: Node2D


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
	
	if Input.is_key_pressed(KEY_SPACE):
		player_attack.emit()


# Handle card dragging, select ingredients
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		for point in result:
			var result_collision_mask = point.collider.collision_mask
			# Select monster cards
			if result_collision_mask == COLLISION_MASK_MONSTER_CARD:
				var monster_card_found = point.collider.get_parent()
				if battle_manager.is_on_player_turn and monster_card_found:
					if not monster_card_found.placed and not PlayerHand.on_ingredient_hand:
						card_manager_reference.start_drag(monster_card_found)
					elif monster_card_found.placed:
						select_placed_card.emit(monster_card_found)
			# Select ingredients cards
			elif result_collision_mask == COLLISION_MASK_INGREDIENT_CARD:
				if PlayerHand.on_ingredient_hand:
					var ingredient_card_found = point.collider.get_parent()
					ingredient_card_found.ingredient_card_selected()
			elif result_collision_mask == COLLISION_MASK_DECK:
				#Deck Clicked
				#deck_reference.draw_card()
				print("Deck click detected")
