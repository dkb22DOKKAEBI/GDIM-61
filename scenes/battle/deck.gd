extends Node2D

const CARD_SCENE_PATH = "res://scenes/battle/card.tscn"
const CARD_DRAW_SPEED = 1
const STARTING_HAND_SIZE = 1

var player_deck = ["Knight", "Archer", "Demon", "Knight"]
var card_database_reference
var drawn_card_this_turn := false

#Called when the node enters the scene tree for the first time.
func _ready():
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://scenes/battle/CardDatabase.gd")
	# Draw initial hand
	for i in range(STARTING_HAND_SIZE):
		draw_card()
	drawn_card_this_turn = false


func draw_card():
	if  drawn_card_this_turn:
		return
	
	drawn_card_this_turn = true
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)

	#If player drew the last card in teh deck, disable the deck
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false

	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Cards/"+card_drawn_name+"Card.png")
	#new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])

	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)


func reset_draw():
	drawn_card_this_turn = false
