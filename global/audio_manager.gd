extends Node

# Sound stream resource dictionary
# String(UpperCase) -> AudioStream
# All sfx: CLICK, ATTACK, DRAW_CARD, END_TURN, COOKING
@export var sfx_dic: Dictionary
@export var main_menu_background_music: AudioStreamPlayer2D
@export var battle_background_music: AudioStreamPlayer2D


# Ready
func _ready() -> void:
	SceneManager.connect("new_game_started_signal", play_battle_background_music)
	SceneManager.connect("game_end_signal", play_main_menu_background_music)


# Play sound effect
func play_sound(sfx_name: String, sfx_db: float = 0) -> void:
	# Check whether has given sound effect
	if sfx_dic.has(sfx_name): # Does have sfx
		# Create new sound
		var new_2d_audio = AudioStreamPlayer2D.new()
		self.add_child(new_2d_audio)
		new_2d_audio.stream = sfx_dic[sfx_name]
		new_2d_audio.volume_db = sfx_db
		new_2d_audio.finished.connect(new_2d_audio.queue_free) # Destroy when finish playing
		
		new_2d_audio.play()
	else: # Doesn't have sfx
		push_error("No defined sound effect " + sfx_name)


# Play battle background music and Stop main menu background music
func play_battle_background_music() -> void:
	main_menu_background_music.stop()
	battle_background_music.play()


func play_main_menu_background_music() -> void:
	battle_background_music.stop()
	main_menu_background_music.play()
