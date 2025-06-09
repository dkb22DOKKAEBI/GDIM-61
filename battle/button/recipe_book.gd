extends Control

@onready var recipe_book_visible: PanelContainer = $RecipeBookVisible
@export var background: ColorRect

# Card Information
@export var card_content: MarginContainer




func _ready() -> void:
	recipe_book_visible.visible = false

func _on_recipe_book_button_pressed() -> void:
	AudioManager.play_sound("CLICK")
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
	recipe_book_visible.visible = true
	background.visible = true
	
func _on_exit_book_pressed() -> void:
	AudioManager.play_sound("CLICK")
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
	recipe_book_visible.visible = false
	background.visible = false
