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


# Attached to Pot UI ingredent buttons
# Disselect ingredient and add card view back to player's hand
func on_disselect_ingredient() -> void :
	print("On Dis-select")
	
	pass
