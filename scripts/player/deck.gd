extends Node2D

const INGREDIENT_CARD_SCENE_PATH = "res://scenes/card/ingredient_card.tscn"
const CARD_DRAW_SPEED = 1

var card_starting_position: Vector2 = Vector2(915, 525)
var player_deck = ["Tortilla", "Dough", "Cheese", 
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce"]

@export var deck_left_num_text: RichTextLabel
@export var deck_sprite: Sprite2D
@export var ingredient_card_manager: Node2D


#Called when the node enters the scene tree for the first time.
func _ready():
	player_deck.shuffle()
	deck_left_num_text.text = str(player_deck.size())


func draw_card():
	#If player drew the last card in the deck, disable the deck
	if player_deck.size() == 0:
		#$Area2D/CollisionShape2D.disabled = true
		deck_sprite.visible = false
		deck_left_num_text.visible = false
	
	if player_deck.size() > 0:
		var ingredient_name = player_deck[0]
		player_deck.erase(ingredient_name)
		deck_left_num_text.text = str(player_deck.size())
		
		# Instantiate ingredient card
		
		var card_scene = preload(INGREDIENT_CARD_SCENE_PATH)
		var new_card: Node2D = card_scene.instantiate()
		var card_image_path = str("res://Ingredients/" + ingredient_name + ".png")
		new_card.get_node("CardImage").texture = ResourceLoader.load(card_image_path)
		ingredient_card_manager.add_child(new_card)
		new_card.name = "IngredientCard"
		new_card.position = card_starting_position
		new_card.starting_position = card_starting_position
		new_card.ingredient_name = ingredient_name
		new_card.ingredient_name_label.text = ingredient_name
		PlayerHand.add_card_to_hand(new_card, CARD_DRAW_SPEED, 0)
