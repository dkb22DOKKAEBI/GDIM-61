extends Node2D

const DESIRED_WINDOW_WIDTH = 960
const SIDEBAR_WIDTH = 225
const DECK_WIDTH = 40

const CARD_WIDTH = 75
const HAND_Y_POSITION = 525
const DEFAULT_CARD_MOVE_SPEED = 0.1

var player_monster_hand: Array[Card] = [] # Player's monster hand
var player_ingredient_hand: Array[Card] = [] # Player's ingredient hand
var legacy_monster_hand: Array[String] = []
var legacy_ingredient_hand: Array[String] = []

var center_screen_x
var on_ingredient_hand: bool = true
var selected_ingredients: Array[Card]

signal update_pot_ui_signal


# Called when the node enters the scene tree for the first time.
func _ready():
	center_screen_x = (DESIRED_WINDOW_WIDTH + SIDEBAR_WIDTH - DECK_WIDTH) / 2
	SceneManager.connect("player_complete_level_signal", clear_player_hand)
	SceneManager.connect("game_end_signal", clear_player_legacy)


# Clear current player hand and transfer its record to legacy hands
# for restoring data at the start of next level
func clear_player_hand() -> void:
	# Storing card into legacy hand
	for ingredient_card: Card in player_ingredient_hand:
		legacy_ingredient_hand.append(ingredient_card.card_name)
	for monster_card: Card in player_monster_hand:
		legacy_monster_hand.append(monster_card.card_name)
	
	# Clear player hand
	player_ingredient_hand.clear()
	player_monster_hand.clear()
	
	# Reset which hand the player is on
	on_ingredient_hand = true


# Clear current player legacy hand when the game is over
func clear_player_legacy() -> void:
	legacy_ingredient_hand.clear()
	legacy_monster_hand.clear()



func get_target_hand(flag: int) -> Array:
	if flag == 0:
		return player_ingredient_hand
	else:
		return player_monster_hand


# If input 0, add to ingredient hand
# If input 1, add to monster hand
func add_card_to_hand(card: Node2D, speed, flag: int):
	var target_hand = get_target_hand(flag)
	
	if card not in target_hand:
		target_hand.insert(0, card)
		update_hand_positions(speed, target_hand)
	else:
		animate_card_to_position(card, card.starting_position, DEFAULT_CARD_MOVE_SPEED)


func update_hand_positions(speed, target_hand: Array):
	for i in range(target_hand.size()):
		#Get new card position based on index passed in
		var new_position = Vector2(calculate_card_position(i, target_hand.size()), HAND_Y_POSITION) 
		var card = target_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, speed)


func calculate_card_position(index, hand_size: int):
	var total_width = (hand_size -1) * CARD_WIDTH
	@warning_ignore("integer_division")
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)


func remove_card_from_hand(card: Card, flag: int):
	var target_hand = get_target_hand(flag)
	if target_hand.has(card):
		target_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED, target_hand)


func update_sidebar_pot_ui():
	update_pot_ui_signal.emit()
