extends Node

@export var ingredient_card_manager: Node2D
@export var monster_card_manager: Node2D



func _ready() -> void:
	print("On Ready")

func _on_switch_hand() -> void:
	print("On Switch Hand")
	# Update whether on ingredient hand in PlayerHand script
	PlayerHand.on_ingredient_hand = !PlayerHand.on_ingredient_hand
	
	if not ingredient_card_manager:
		print("No Ingredient")
	
	if not monster_card_manager:
		print("No Monster")
	
	# Toggel visibility
	ingredient_card_manager.visible = PlayerHand.on_ingredient_hand
	for card in ingredient_card_manager.get_children():
		card.get_child(1).get_child(0).disabled = int(!PlayerHand.on_ingredient_hand)
	monster_card_manager.visible = !PlayerHand.on_ingredient_hand
	for card in monster_card_manager.get_children():
		card.get_child(1).get_child(0).disabled = int(PlayerHand.on_ingredient_hand)
