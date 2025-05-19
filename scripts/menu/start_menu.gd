extends Node
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


# Attached to Start Game button
# Start a new game
func on_start_game() -> void:
	SceneManager.start_new_game()
	
# Attached to Exit Game button
# Exit game
func on_exit_game() -> void:
	get_tree().quit()
