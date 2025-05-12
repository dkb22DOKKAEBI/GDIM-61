class_name IngredientCard
extends Card

@export var ingredient_name_label: Label
var ingredient_name: String


# Overriden constructor
func _init(ingredient_name: String = "") -> void:
	self.ingredient_name = ingredient_name


func ingredient_card_selected():
	selected_label.visible = !selected_label.visible
	
	# Add to cooking ingredient list
	if PlayerHand.selected_ingredients.has(self):
		PlayerHand.selected_ingredients.erase(self)
	else:
		PlayerHand.selected_ingredients.append(self)

	# Update pot ui predicted cooking result
	PlayerHand.update_sidebar_pot_ui()
