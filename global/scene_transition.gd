extends Control

@export var cover: ColorRect


# Transition out of a scene
func transition_out() -> void:
	# Fade in cover
	cover.modulate = Color(0, 0, 0, 0)
	var tween := get_tree().create_tween()
	tween.tween_property(cover, "modulate", Color(0, 0, 0, 1), 0.5)
	tween.set_pause_mode(2)
	get_tree().paused = true
	
	# Animation finished
	await tween.finished
	get_tree().paused = false
	EventController.scene_transition_animation_finished_signal.emit()


# Transition into a new scene
func transition_into() -> void:
	# Fade out cover
	cover.modulate = Color(0, 0, 0, 1)
	var tween := get_tree().create_tween()
	tween.tween_property(cover, "modulate", Color(0, 0, 0, 0), 0.5)
