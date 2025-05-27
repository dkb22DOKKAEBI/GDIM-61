extends Node2D

signal left_mouse_button_clicked   # Mouse signals
signal left_mouse_button_released
signal right_mouse_button_clicked
signal right_mouse_button_released

signal select_placed_card(card: Card)
signal player_attack
signal switch_pause_menu_signal
signal targeting_start_signal(monster_card: MonsterCard) # Signal that the targeting starts

const COLLISION_MASK_MONSTER_CARD = 1
const COLLISION_MASK_DECK = 4
const COLLISION_MASK_INGREDIENT_CARD = 8
const COLLISION_MASK_BOSS = 16

@export var card_manager_reference: Node2D
@export var ingredient_card_manager: Node2D


# Check for inputs
func _input(event):
	# Check mouse left button events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			perform_left_click_action()
			emit_signal("left_mouse_button_clicked")
		else:
			emit_signal("left_mouse_button_released")
	
	# Check mouse right button events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			perform_right_click_action()
			emit_signal("right_mouse_button_clicked")
		else:
			EventController.right_mouse_button_released.emit()
	
	# Open or close pause Menu
	if Input.is_key_pressed(KEY_ESCAPE):
		switch_pause_menu_signal.emit()


# Handle left-click actions -> select ingredients, start dragging, start targeting
func perform_left_click_action():
	# Return if player is checking card info
	if PlayerController.curr_player_status != PlayerController.PLAYER_STATUS.IDLE:
		return
	
	# Get all cards at left click position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MONSTER_CARD + COLLISION_MASK_INGREDIENT_CARD
	var raycast_points := space_state.intersect_point(parameters)
	
	# Move monster card, if any, to the front
	for i in range(raycast_points.size()):
		if raycast_points[i].collider.collision_layer == COLLISION_MASK_MONSTER_CARD:
			raycast_points.insert(0, raycast_points[i])
			raycast_points.remove_at(i + 1)
	
	# Perform clicked action
	if raycast_points.size() > 0:
		for point in raycast_points:
			var result_collision_mask = point.collider.collision_layer
			
			# Select monster cards
			if result_collision_mask == COLLISION_MASK_MONSTER_CARD:
				var monster_card_found = point.collider.get_parent()
				if monster_card_found and PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.IDLE:
					if not monster_card_found.placed: # Find monster card in hand
						card_manager_reference.start_drag(monster_card_found)
						ingredient_card_manager.card_being_dragged = monster_card_found
						AudioManager.play_sound("CLICK")
						break
					elif monster_card_found.placed: # Find monster card in battle field
						#select_placed_card.emit(monster_card_found)
						targeting_start_signal.emit(monster_card_found)
						AudioManager.play_sound("CLICK")
			
			# Select ingredients cards
			elif result_collision_mask == COLLISION_MASK_INGREDIENT_CARD:
				var ingredient_card_found = point.collider.get_parent()
				ingredient_card_found.ingredient_card_selected()
				AudioManager.play_sound("CLICK")


# Handle right-click actions -> card info display
func perform_right_click_action() -> void:
	# Return if the player is targetinng to attack
	if PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.TARGETING:
		return
	
	# Get all cards at left click position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MONSTER_CARD + COLLISION_MASK_BOSS
	var raycast_points := space_state.intersect_point(parameters) # Should be size 1
	
	# Display monster card or boss info
	if raycast_points.size() > 0:
		var point := raycast_points[0]
		if point.collider.collision_layer == COLLISION_MASK_BOSS:
			PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
			EventController.display_boss_info_signal.emit(point.collider.get_parent())
		elif point.collider.collision_layer == COLLISION_MASK_MONSTER_CARD:
			PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
			EventController.display_monster_card_info_signal.emit(point.collider.get_parent())


# Quick fix for ingredient cards still hoverable when dragging monster card
# Another fix -> make player hand cover mouse mode to STOP
func temp_disable_ingredient_hover() -> void:
	ingredient_card_manager.card_being_dragged = null
