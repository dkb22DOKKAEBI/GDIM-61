extends Node

@export var input_manager: Node2D
@export var background_music_slider: Slider
@export var sound_effect_slider: Slider


func _ready() -> void:
	input_manager.connect("switch_pause_menu_signal", switch_pause_menu_on)


func _input(event) -> void:
	# Close pause Menu
	if Input.is_action_just_pressed("pause_game_switch"):
		# Check whether on tutorial
		if PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.TUTORIAL and self.visible:
			self.visible = false
			return
		elif PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.TUTORIAL and not self.visible:
			self.visible = true
			return
		
		await get_tree().create_timer(0.05).timeout
		on_resume_game()


# Switch pause menu on
func switch_pause_menu_on():
	# Pause Game
	get_tree().paused = true
	self.visible = true
	
	# Set volume slide bar
	background_music_slider.value = AudioManager.background_music_volume
	sound_effect_slider.value = AudioManager.sound_effect_volume


# Attached to Resume Game button
# Switch off pause menu
func on_resume_game() -> void:
	# Check whether on tutorial
	if PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.TUTORIAL:
		self.visible = false
		return
	
	get_tree().paused = false
	self.visible = false


# Attached to Start Menu button
# Return to start menu
func on_return_start_menu() -> void:
	get_tree().paused = false
	SceneManager.back_to_start_menu()
	#self.visible = false
	
	# Exit tutorial level if is on
	if PlayerController.is_on_tutorial:
		PlayerController.is_on_tutorial = false


# Attached to Background Music Slider
# Change of background music volume
func on_background_music_volumne_changed(new_volume: float) -> void:
	AudioManager.change_background_music_volume(new_volume)


# Attached to Sound Effect Slider
# Change of sound effect volume
func on_sound_effect_volumne_changed(new_volume: float) -> void:
	AudioManager.change_sound_effect_volume(new_volume)
