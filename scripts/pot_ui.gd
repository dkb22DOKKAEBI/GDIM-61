class_name PotUI
extends Node

@export var grids: Array[NinePatchRect] # Array of the four ingredient grids


# Connect signal
func _ready() -> void:
	PlayerHand.connect("selected_ingredient_change_signal", on_update_selected_ing_ui)


# Update images of selected ingredients in pot
func on_update_selected_ing_ui() -> void:
	print("On Update Selected Ingredient UI ------------------------")
	# Clear all images in all grids
	for grid: NinePatchRect in grids:
		grid.texture = null
	
	# Add in all images for ingredients selected in order
	for i in range(PlayerHand.selected_ingredients.size()):
		print("Adding " + PlayerHand.selected_ingredients[i].card_name)
		var icon_path = "res://card_images/ingredient-icon/" + PlayerHand.selected_ingredients[i].card_name + "_Icon.png"
		grids[i].texture = ResourceLoader.load(icon_path)
	
	print("On Update End -------------------------------------------")
	pass
