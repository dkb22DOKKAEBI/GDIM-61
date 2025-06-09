extends Control

@export var recipe_book_visible: MarginContainer
@export var background: ColorRect

# Card Information
@export var card_content: MarginContainer




# Ready
func _ready() -> void:
	recipe_book_visible.visible = false
	EventController.connect("recipe_display_card_info_signal", on_display_recipe_card_info)


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
func on_display_recipe_card_info(monster_name: String) -> void:
	print("Display Info " + monster_name)
	card_content.visible = true


# Attached to Back button in recipe card info page
# Return back to the recipe book main page
func _on_exit_recipe_info() -> void:
	card_content.visible = false
