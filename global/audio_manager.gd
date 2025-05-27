extends Node

# Sound stream resource dictionary
# String(UpperCase) -> AudioStream
# All sfx: CLICK
@export var sfx_dic: Dictionary


# Play sound
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
