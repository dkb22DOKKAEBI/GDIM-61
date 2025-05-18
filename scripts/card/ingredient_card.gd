class_name IngredientCard
extends Card

@export var ingredient_name_label: Label
var selected: bool = false
var ingredient_name: String


# Overriden constructor
func _init(ingredient_name: String = "") -> void:
	self.ingredient_name = ingredient_name


# Select or Dis-select ingredient card
func ingredient_card_selected():
	# Check whether exist selected ingredients limit of 4
	if not selected and PlayerHand.selected_ingredients.size() >= 4:
		return
	
	# Update status and select or dis-select ingredient
	selected = !selected
	selected_label.visible = selected
	
	if PlayerHand.selected_ingredients.has(self): # Dis-select ingredient card
		PlayerHand.selected_ingredients.erase(self)
	else: # Select ingredient card
		PlayerHand.selected_ingredients.append(self)
	
	# Notify pot ui selected ingredients changed
	PlayerHand.selected_ingredient_change_signal.emit()
