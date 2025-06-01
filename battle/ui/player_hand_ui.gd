class_name PlayerHandUI
extends Control

@export var ingredient_num_text: RichTextLabel
@export var monster_num_text: RichTextLabel
var ingredient_num_suffix: String = " / 6 ingredients"
var monster_num_suffix: String = " / 4 monsters"


# Ready
func _ready() -> void:
	EventController.connect("update_ingredient_num_indicator_signal", update_ingredient_num_text)
	EventController.connect("update_monster_num_indicator_signal", update_monster_num_text)


# Update ingredient num text
func update_ingredient_num_text() -> void:
	ingredient_num_text.text = str(PlayerHand.player_ingredient_hand.size() + PlayerHand.selected_ingredients.size()) + ingredient_num_suffix


# Update monster num text
func update_monster_num_text() -> void:
	monster_num_text.text = str(PlayerHand.player_monster_hand.size()) + monster_num_suffix
