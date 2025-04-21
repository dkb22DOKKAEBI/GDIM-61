class_name IngredientCard
extends Card

@export var selected_label: Label 
var cooking_mechanic: Node


func ingredient_card_selected():
	selected_label.visible = !selected_label.visible
	
	# Add to cooking ingredient list
	CookingMechanic.update_selected_ingredients(self)
