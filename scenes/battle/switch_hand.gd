extends Node

@export var ingredient_card_manager: Node2D
@export var monster_card_manager: Node2D
var on_ingredient_hand = true

func _on_switch_hand() -> void:
	on_ingredient_hand = !on_ingredient_hand
	ingredient_card_manager.visible = on_ingredient_hand
	monster_card_manager.visible = ! on_ingredient_hand
