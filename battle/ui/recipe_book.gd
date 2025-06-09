extends Control

@export var recipe_book_visible: MarginContainer
@export var background: ColorRect

# Card Information
@export var card_content: MarginContainer




# Ready
func _ready() -> void:
	recipe_book_visible.visible = false


# Attached to Recipe button in battle scene
# Open recipe book
func _on_recipe_book_button_pressed() -> void:
	AudioManager.play_sound("CLICK")
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
	recipe_book_visible.visible = true
	background.visible = true


# Attached to Exit button in recipe book
# Exit recipe book
func _on_exit_book_pressed() -> void:
	AudioManager.play_sound("CLICK")
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
	recipe_book_visible.visible = false
	background.visible = false


# Display card info inside the recipe book
func _on_display_recipe_card_info() -> void:
	pass
