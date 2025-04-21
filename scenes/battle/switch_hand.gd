extends Node

@export var ingredient_card_manager: Node2D
@export var monster_card_manager: Node2D
@export var player_hand: Node2D

func _on_switch_hand() -> void:
	player_hand.on_ingredient_hand = !player_hand.on_ingredient_hand
	ingredient_card_manager.visible = player_hand.on_ingredient_hand
	monster_card_manager.visible = !player_hand.on_ingredient_hand
