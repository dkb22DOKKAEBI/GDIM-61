class_name IngredientCard
extends Card

@export var ingredient_name_label: Label
var ingredient_name: String


# Overriden constructor
func _init(ingredient_name: String = "") -> void:
	self.ingredient_name = ingredient_name


# Select or Dis-select ingredient card
func ingredient_card_selected():
	selected_label.visible = !selected_label.visible
	
	if PlayerHand.selected_ingredients.has(self): # Dis-select ingredient card
		PlayerHand.selected_ingredients.erase(self)
	else: # Select ingredient card
		PlayerHand.selected_ingredients.append(self)
	
	# Notify pot ui selected ingredients changed
	PlayerHand.selected_ingredient_change_signal.emit()
