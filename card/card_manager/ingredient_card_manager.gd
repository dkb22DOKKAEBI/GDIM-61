extends CardManager

@export var deck: Node2D


# Ready
func _ready() -> void:
	# Update deck at the start of a level
	for ingredient_name: String in PlayerHand.legacy_ingredient_hand:
		deck.instantiate_ingredient_card(ingredient_name)
	PlayerHand.legacy_ingredient_hand.clear()
