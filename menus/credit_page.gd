class_name CreditPage
extends Node


# Ready
func _ready() -> void:
	SceneTransition.transition_into()


# Attached to Main Menu button
# Return to the main menu
func on_return_start_menu():
	SceneManager.back_to_start_menu()
