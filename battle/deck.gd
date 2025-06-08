extends Node2D

const INGREDIENT_CARD_SCENE_PATH = "res://card/ingredient_card/ingredient_card.tscn"
var CARD_DRAW_SPEED = 1

var card_starting_position: Vector2 = Vector2(915, 525)

@export var deck_left_num_text: RichTextLabel
@export var ingredient_card_manager: Node2D


# Ready
func _ready():
	# Update left number info
	deck_left_num_text.text = str(PlayerController.deck.size())


# Player draw card
func draw_card():
	# If player drew the last card in the deck, disable the deck
	if PlayerController.deck.size() == 0:
		self.visible = false
		return
	
	# Draw card there is still card left
	AudioManager.play_sound("DRAW_CARD")
	var ingredient_name: String = PlayerController.deck[0]
	PlayerController.deck.erase(ingredient_name)
	deck_left_num_text.text = str(PlayerController.deck.size())
	
	# Instantiate ingredient card into player hand
	instantiate_ingredient_card(ingredient_name)


# Instantiate new ingredient cards into scene
# with ingredient name provided
func instantiate_ingredient_card(ingredient_name: String) -> void:
	var new_card = instantiate_ingredient_card_helper(ingredient_name)
	PlayerHand.add_card_to_hand(new_card, CARD_DRAW_SPEED, 0)

# Helper function for instantiating ingredient card
# Returning the reference to the newly created card of type Node2D
func instantiate_ingredient_card_helper(ingredient_name: String) -> Node2D:
	# Instantiate
	var card_scene = preload(INGREDIENT_CARD_SCENE_PATH)
	var new_card: Node2D = card_scene.instantiate()
	var card_image_path = str("res://art/card_images/ingredients/" + ingredient_name + ".png")
	new_card.get_node("CardImage").texture = ResourceLoader.load(card_image_path)
	ingredient_card_manager.add_child(new_card)
	new_card.name = "IngredientCard"
	new_card.position = card_starting_position
	new_card.starting_position = card_starting_position
	new_card.card_name = ingredient_name
	
	# Return
	return new_card
