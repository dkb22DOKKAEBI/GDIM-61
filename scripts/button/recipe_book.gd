extends Control

@onready var recipe_book_visible: PanelContainer = $RecipeBookVisible

func _ready() -> void:
	recipe_book_visible.visible = false

func _on_recipe_book_button_pressed() -> void:
	recipe_book_visible.visible = true
	
func _on_exit_book_pressed() -> void:
	recipe_book_visible.visible = false
