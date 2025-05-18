class_name PotUI
extends Node

@export var grids: Array[NinePatchRect] # Array of the four ingredient grids


# Connect signal
func _ready() -> void:
	PlayerHand.connect("selected_ingredient_change_signal", on_update_selected_ing_ui)


# Update images of selected ingredients in pot
func on_update_selected_ing_ui() -> void:
	# Clear all images in all grids
	for grid: NinePatchRect in grids:
		grid.texture = null
	
	# Add in all images for ingredients selected in order
	for i in range(PlayerHand.selected_ingredients.size()):
		var icon_path = "res://card_images/ingredient-icon/" + PlayerHand.selected_ingredients[i].card_name + "_Icon.png"
		grids[i].texture = ResourceLoader.load(icon_path)



# Attached to Pot UI ingredent buttons with corresponding indexes
# Disselect ingredient and add card view back to player's hand
func on_disselect_ingredient_1() -> void:
	disselect_ingredient(0)

func on_disselect_ingredient_2() -> void:
	disselect_ingredient(1)

func on_disselect_ingredient_3() -> void:
	disselect_ingredient(2)

func on_disselect_ingredient_4() -> void:
	disselect_ingredient(3)


# Helper function for disselect ingredients
func disselect_ingredient(index: int) -> void :
	# Check whether there is ingredient to dis-select
	if index >= PlayerHand.selected_ingredients.size():
		return
	
	var ingredient_card = PlayerHand.selected_ingredients[index]
	
	# Enable ingredient card gameobject
	ingredient_card.visible = true
	ingredient_card.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Update player selected ingredient(-) and ingredient(+) hands
	PlayerHand.selected_ingredients.erase(ingredient_card)
	PlayerHand.player_ingredient_hand.insert(0, ingredient_card)
	PlayerHand.update_hand_positions(0.3, PlayerHand.player_ingredient_hand)
