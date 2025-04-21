extends Node2D

const INGREDIENT_CARD_SCENE_PATH = "res://scenes/card/ingredient_card/ingredient_card.tscn"
const CARD_DRAW_SPEED = 1
const STARTING_HAND_SIZE = 3

var player_deck = ["Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Ham", "Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Ham"]
var drawn_card_this_turn := false

#Called when the node enters the scene tree for the first time.
func _ready():
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	# Draw initial hand
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_card_this_turn = false
	drawn_card_this_turn = false


func draw_card():
	if  drawn_card_this_turn:
		return
	drawn_card_this_turn = true

	#If player drew the last card in teh deck, disable the deck
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	var ingredient_name = player_deck[0]
	player_deck.erase(ingredient_name)
	$RichTextLabel.text = str(player_deck.size())
	
	# Instantiate ingredient card
	var card_scene = preload(INGREDIENT_CARD_SCENE_PATH)
	var new_card: Node2D = card_scene.instantiate()
	$"../IngredientCardManager".add_child(new_card)
	new_card.name = "IngredientCard"
	new_card.ingredient_name = ingredient_name
	new_card.ingredient_name_label.text = ingredient_name
	$"../Player/PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED, 0)


func reset_draw():
	drawn_card_this_turn = false
