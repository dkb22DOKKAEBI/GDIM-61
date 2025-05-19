extends Control

@onready var recipe_book_visible: PanelContainer = $RecipeBookVisible
@onready var clicksfx: AudioStreamPlayer = $"../../clicksfx"

func _ready() -> void:
	recipe_book_visible.visible = false

func _on_recipe_book_button_pressed() -> void:
	clicksfx.play()
	recipe_book_visible.visible = true
	
func _on_exit_book_pressed() -> void:
	clicksfx.play()
	recipe_book_visible.visible = false
