class_name RecipeBookButton
extends Node

@export var monster_name: String # The name of the corresponding monster card


func _on_button_pressed() -> void:
	print(monster_name)
