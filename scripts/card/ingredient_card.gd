class_name IngredientCard
extends Card

@export var ingredient_name_label: Label
# var selected: bool = false
var ingredient_name: String


# Overriden constructor
func _init(ingredient_name: String = "") -> void:
	self.ingredient_name = ingredient_name


# Select ingredient card
func ingredient_card_selected():	
	# Check whether exist selected ingredients limit of 4
	if PlayerHand.selected_ingredients.size() >= 4:
		return
	
	# Update player selected ingredient(+) and ingredient(-) hands
	PlayerHand.selected_ingredients.append(self)
	PlayerHand.player_ingredient_hand.erase(self)
	PlayerHand.update_hand_positions(0.3, PlayerHand.player_ingredient_hand)
	
	# Update card position to the pot position
	self.position = Vector2(270, 525)
	
	# Notify pot ui selected ingredients changed
	PlayerHand.selected_ingredient_change_signal.emit()
	
	# Disable ingredient card gameobject in hand
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
