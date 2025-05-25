extends Node2D

signal left_mouse_button_clicked   # Mouse signals
signal left_mouse_button_released
signal right_mouse_button_clicked

signal select_placed_card(card: Card)
signal player_attack
signal switch_pause_menu_signal
signal targeting_start_signal(monster_card: MonsterCard) # Signal that the targeting starts

const COLLISION_MASK_MONSTER_CARD = 1
const COLLISION_MASK_DECK = 4
const COLLISION_MASK_INGREDIENT_CARD = 8

@export var card_manager_reference: Node2D
@onready var clicksfx: AudioStreamPlayer = $"../../clicksfx"


# Check for inputs
func _input(event):
	# Check mouse left button events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
	
	# Check mouse right button events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			emit_signal("right_mouse_button_clicked")
	
	# Player tempeory attack
	if Input.is_key_pressed(KEY_SPACE):
		player_attack.emit()
	
	# Open or close pause Menu
	if Input.is_key_pressed(KEY_ESCAPE):
		switch_pause_menu_signal.emit()


# Handle card dragging, select ingredients
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		for point in result:
			var result_collision_mask = point.collider.collision_layer
			
			# Select monster cards
			clicksfx.play()
			if result_collision_mask == COLLISION_MASK_MONSTER_CARD:
				var monster_card_found = point.collider.get_parent()
				if PlayerController.is_on_player_turn and monster_card_found:
					if not monster_card_found.placed: # Find monster card in hand
						card_manager_reference.start_drag(monster_card_found)
					elif monster_card_found.placed: # Find monster card in battle field
						#select_placed_card.emit(monster_card_found)
						targeting_start_signal.emit(monster_card_found)
			
			# Select ingredients cards
			elif result_collision_mask == COLLISION_MASK_INGREDIENT_CARD:
				clicksfx.play()
				var ingredient_card_found = point.collider.get_parent()
				ingredient_card_found.ingredient_card_selected()
