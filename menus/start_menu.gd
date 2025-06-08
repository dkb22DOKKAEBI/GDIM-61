extends Node
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


# Attached to Start Game button
# Start a new game
func on_start_game() -> void:
	SceneManager.start_new_game()


# Attached to Start Game button
# Enter the tutorial level
func on_enter_tutorial() -> void:
	SceneManager.start_tutorial()


# Attached to Credit button
# Enter the credit page
func on_enter_credit() -> void:
	SceneManager.transfer_to_credit_page()


# Attached to Exit Game button
# Exit game
func on_exit_game() -> void:
	get_tree().quit()
