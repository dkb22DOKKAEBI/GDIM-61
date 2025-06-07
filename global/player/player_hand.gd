extends Node2D

const PLAYER_HAND_CENTER = 516 # Center of player's hand
const DECK_WIDTH = 40 # Deck width
const INGREDIENT_CARD_WIDTH = 85 # Ingredient card width
const MONSTER_CARD_WIDTH = 100 # Monster card width
const CARD_HEIGHT = 40 # Card height

const HAND_Y_POSITION = 519 # Y position for ingredient card
const MONSTER_CARD_Y_OFFSET = 90 # Y offset for monster cards' position in hand
const MONSTER_CARD_UP_Y_OFFSET = 55 # Y offset for monster card when hovered over
const DEFAULT_CARD_MOVE_SPEED = 0.1 # Default card animation speed
const DECK_POSITION := Vector2(900, 540)

var player_monster_hand: Array[Card] = [] # Player's monster hand
var player_ingredient_hand: Array[Card] = [] # Player's ingredient hand
var selected_ingredients: Array[Card] # Selected ingredients; Max size should be 4 (Not included simultaniously in player_ingredient_hand)

var legacy_monster_hand: Array[String] = [] # Record of player's monster hand after completion of a level
var legacy_ingredient_hand: Array[String] = [] # Record of player's ingredient hand after completion of a level

var hovering_monster_num: int = 0 # 0 indicates no monster card hovered over
var center_screen_x

signal selected_ingredient_change_signal()
signal return_ingredients_finished_signal() # Signal the end of returning ingredient cards at the start of the turn


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	center_screen_x = PLAYER_HAND_CENTER
	SceneManager.connect("game_end_signal", clear_player_legacy)


# Clear current player hand and transfer its record to legacy hands
# for restoring data at the start of next level
func clear_player_hand() -> void:
	# Storing card into legacy hand
	for ingredient_card: Card in player_ingredient_hand:
		legacy_ingredient_hand.append(ingredient_card.card_name)
	for ingredient_card: Card in selected_ingredients:
		legacy_ingredient_hand.append(ingredient_card.card_name)
	for monster_card: Card in player_monster_hand:
		legacy_monster_hand.append(monster_card.card_name)
	
	# Clear player hand
	player_ingredient_hand.clear()
	player_monster_hand.clear()


# Clear both player current and legacy hands when the game is over
func clear_player_legacy() -> void:
	legacy_ingredient_hand.clear()
	legacy_monster_hand.clear()
	player_ingredient_hand.clear()
	player_monster_hand.clear()


# Clear ingredient cards in player's hand at the start of the turn to redraw ingredients
func redraw_clear_hand() -> void:
	var return_speed := 0.15
	
	# Return ingredients
	for ingredient_card in player_ingredient_hand:
		PlayerController.deck.insert(randi_range(0, PlayerController.deck.size()), ingredient_card.card_name)
		animate_card_to_position(ingredient_card, DECK_POSITION, return_speed)
	
	await get_tree().create_timer(return_speed).timeout
	for ingredient_card in player_ingredient_hand:
		ingredient_card.queue_free()
	player_ingredient_hand.clear()
	await get_tree().create_timer(0.05).timeout
	
	# Signal returning ingredients end
	return_ingredients_finished_signal.emit()


# Get desired player hand
# Return ingredient hand with input 0
# Return monster hand with input 1
func get_target_hand(flag: int) -> Array:
	if flag == 0:
		return player_ingredient_hand
	else:
		return player_monster_hand


# Add a new card to player hand
# If input 0, add to ingredient hand
# If input 1, add to monster hand
func add_card_to_hand(card: Node2D, speed, flag: int):
	var target_hand = get_target_hand(flag)
	
	if card not in target_hand:
		target_hand.insert(0, card)
		update_hand_positions(speed, target_hand)
	else:
		animate_card_to_position(card, card.starting_position, DEFAULT_CARD_MOVE_SPEED)


# Update player hand cards' positions
# If drew is true, card is not drew from the deck but returned from dis-select card
func update_hand_positions(speed, target_hand: Array):
	for i in range(target_hand.size()):
		# Get new card position based on index passed in
		var new_position = Vector2(calculate_card_position(i, target_hand.size(), target_hand), HAND_Y_POSITION) 
		
		# Check whether is mosnter card
		if target_hand == player_monster_hand:
			new_position.y += MONSTER_CARD_Y_OFFSET
		
		var card = target_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, speed)


# Calculate new card x-position in hand
func calculate_card_position(index, hand_size: int, target_hand: Array):
	# Determine which card width to use
	var card_width: int
	if target_hand == player_ingredient_hand:
		card_width = INGREDIENT_CARD_WIDTH
	else:
		card_width = MONSTER_CARD_WIDTH
	
	# Calculate position
	var total_width = (hand_size -1) * card_width
	var x_offset = center_screen_x + index * card_width - total_width / 2.0
	return x_offset


# Animate card to the new position with specified speed
func animate_card_to_position(card, new_position, speed = 0.1):
	# Start card animation
	card.is_in_animation = true
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
	# Card animation ends
	await tween.finished
	if card: # Check whether the card still exists
		card.is_in_animation = false


func remove_card_from_hand(card: Card, flag: int):
	var target_hand = get_target_hand(flag)
	if target_hand.has(card):
		target_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED, target_hand)
