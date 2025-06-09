class_name RecipeBookButton
extends Node

@export var monster_name: String # The name of the corresponding monster card


func _on_button_pressed() -> void:
	EventController.recipe_display_card_info_signal.emit(monster_name)
