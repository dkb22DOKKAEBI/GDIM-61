extends Node2D

const CARD_WIDTH = 25
const HAND_Y_POSITION = 1
const DEFAULT_CARD_MOVE_SPEED = 0.1

var player_monster_hand: Array[Card] = []
var player_ingredient_hand: Array[Card] = []
var center_screen_x
var on_ingredient_hand = true
var selected_ingredients: Array[Card]

func test():
	print("Ingredients: " + str(player_ingredient_hand.size()))
	print("Monster: " + str(player_monster_hand.size()))
	print("-----------------------------------------------------")


# Called when the node enters the scene tree for the first time.
func _ready():
	center_screen_x = get_viewport().size.x / 16


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
	
	test()


func update_hand_positions(speed, target_hand: Array):
	for i in range(target_hand.size()):
		#Get new card position based on index passed in
		var new_position = Vector2(calculate_card_position(i, target_hand.size()), HAND_Y_POSITION) 
		var card = target_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, speed)


func calculate_card_position(index, hand_size: int):
	var total_width = (hand_size -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)


func remove_card_from_hand(card: Card, flag: int):
	var target_hand = get_target_hand(flag)
	if target_hand.has(card):
		print("Erased!")
		target_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED, target_hand)
		test()
