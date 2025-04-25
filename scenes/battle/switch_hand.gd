extends Node

@export var ingredient_card_manager: Node2D
@export var monster_card_manager: Node2D
@export var player_hand: Node2D

func _on_switch_hand() -> void:
	# Update whether on ingredient hand in PlayerHand script
	player_hand.on_ingredient_hand = !player_hand.on_ingredient_hand
	
	# Toggel visibility
	ingredient_card_manager.visible = player_hand.on_ingredient_hand
	for card in ingredient_card_manager.get_children():
		card.visible = player_hand.on_ingredient_hand
	monster_card_manager.visible = !player_hand.on_ingredient_hand
	for card in monster_card_manager.get_children():
		card.visible = !player_hand.on_ingredient_hand
