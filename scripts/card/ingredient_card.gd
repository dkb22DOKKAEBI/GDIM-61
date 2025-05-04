class_name IngredientCard
extends Card

@export var ingredient_name_label: Label
@export var selected_label: Label 
var ingredient_name: String

func ingredient_card_selected():
	selected_label.visible = !selected_label.visible
	
	# Add to cooking ingredient list
	if PlayerHand.selected_ingredients.has(self):
		PlayerHand.selected_ingredients.erase(self)
	else:
		PlayerHand.selected_ingredients.append(self)
