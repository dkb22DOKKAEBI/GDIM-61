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
const COLLISION_MASK_ABILITY_BUTTON = 32

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
	
	# Open
	if Input.is_action_just_pressed("pause_game_switch"):
		EventController.pause_game_signal.emit()
		switch_pause_menu_signal.emit()


# Handle left-click actions -> select ingredients, start dragging, start targeting
func perform_left_click_action():
	# Return if player is checking card info
	if PlayerController.curr_player_status != PlayerController.PLAYER_STATUS.IDLE:
		return
	
	# Get all cards at left click position
	var raycast_points := get_raycast_points(COLLISION_MASK_MONSTER_CARD + COLLISION_MASK_INGREDIENT_CARD + COLLISION_MASK_ABILITY_BUTTON)
	
	if raycast_points.size() > 0:
		# Find the point with highest z-index
		var point = raycast_points[0]
		for new_point in raycast_points:
			if new_point.collider.get_parent().z_index > point.collider.get_parent().z_index:
				point = new_point
		var result_collision_mask = point.collider.collision_layer
		
		# Return if it is the ability button
		if result_collision_mask == COLLISION_MASK_ABILITY_BUTTON:
			return
		
		# Select monster cards
		if result_collision_mask == COLLISION_MASK_MONSTER_CARD:
			var monster_card_found = point.collider.get_parent()
			if monster_card_found and PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.IDLE:
				if not monster_card_found.placed: # Find monster card in hand
					card_manager_reference.start_drag(monster_card_found)
					ingredient_card_manager.card_being_dragged = monster_card_found
					AudioManager.play_sound("CLICK")
					#break
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
	var raycast_points := get_raycast_points(COLLISION_MASK_MONSTER_CARD + COLLISION_MASK_BOSS)
	
	# Display monster card or boss info
	if raycast_points.size() > 0:
		var point := raycast_points[0]
		if point.collider.collision_layer == COLLISION_MASK_BOSS:
			PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
			EventController.display_boss_info_signal.emit(point.collider.get_parent().get_parent())
		elif point.collider.collision_layer == COLLISION_MASK_MONSTER_CARD:
			PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
			EventController.display_monster_card_info_signal.emit(point.collider.get_parent())


# On mouse click, use raycast to detect the points at the click position with the given collision masks
func get_raycast_points(collision_mask: int) -> Array[Dictionary]:
	# Get points
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = collision_mask
	
	return space_state.intersect_point(parameters)


# Quick fix for ingredient cards still hoverable when dragging monster card
# Another fix -> make player hand cover mouse mode to STOP
func temp_disable_ingredient_hover() -> void:
	ingredient_card_manager.card_being_dragged = null
