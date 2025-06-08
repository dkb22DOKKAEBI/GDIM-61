extends Node

@export var input_manager: Node2D

func _ready() -> void:
	input_manager.connect("switch_pause_menu_signal", switch_pause_menu_on)


func _input(event) -> void:
	# Close pause Menu
	if Input.is_action_just_pressed("pause_game_switch"):
		await get_tree().create_timer(0.05).timeout
		on_resume_game()


# Switch pause menu on
func switch_pause_menu_on():
	get_tree().paused = true
	self.visible = true


# Attached to Resume Game button
# Switch off pause menu
func on_resume_game() -> void:
	get_tree().paused = false
	self.visible = false


# Attached to Start Menu button
# Return to start menu
func on_return_start_menu():
	get_tree().paused = false
	self.visible = false
	SceneManager.back_to_start_menu()
