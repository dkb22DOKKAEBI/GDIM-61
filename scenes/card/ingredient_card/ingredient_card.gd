class_name IngredientCard
extends Card

@export var ingredient_name_label: Label
@export var selected_label: Label 
var ingredient_name: String

func ingredient_card_selected():
	selected_label.visible = !selected_label.visible
	
	# Add to cooking ingredient list
	CookingMechanic.update_selected_ingredients(self)
