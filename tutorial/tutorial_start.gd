extends Node

@export var tutorial_prep: Node2D


func _ready() -> void:
	# Tutorial additional settings
	tutorial_prep.cook_button.disabled = true
	tutorial_prep.recipe_button.disabled = true
	tutorial_prep.end_turn_button.disabled = true
	tutorial_prep.cook_button.disconnect("pressed", tutorial_prep.cooking_mechanics._on_cook)
	tutorial_prep.cook_button.connect("pressed", tutorial_prep.tutorial_on_cook)
	
	await get_tree().create_timer(1.5).timeout
	tutorial_prep.curr_message.activate_self()
