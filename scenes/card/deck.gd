extends Node2D

const INGREDIENT_CARD_SCENE_PATH = "res://scenes/card/ingredient_card/ingredient_card.tscn"
const CARD_DRAW_SPEED = 1

var player_deck = ["Tortilla", "Dough", "Cheese", 
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce"]


#Called when the node enters the scene tree for the first time.
func _ready():
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())


func draw_card():
	#If player drew the last card in the deck, disable the deck
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	if player_deck.size() > 0:
		var ingredient_name = player_deck[0]
		player_deck.erase(ingredient_name)
		$RichTextLabel.text = str(player_deck.size())
		
		# Instantiate ingredient card
		
		var card_scene = preload(INGREDIENT_CARD_SCENE_PATH)
		var new_card: Node2D = card_scene.instantiate()
		var card_image_path = str("res://Ingredients/" + ingredient_name + ".png")
		new_card.get_node("CardImage").texture = ResourceLoader.load(card_image_path)
		$"../IngredientCardManager".add_child(new_card)
		new_card.name = "IngredientCard"
		new_card.ingredient_name = ingredient_name
		new_card.ingredient_name_label.text = ingredient_name
		$"../Player/PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED, 0)
