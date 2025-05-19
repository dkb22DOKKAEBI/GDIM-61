class_name TutorialMessagePlaceMonster
extends TutorialMessage

var task_text: String = "Place the pizza onto the battlefield"

# Override function to emit signal to update task text
func _on_preceed_to_next_tutorial():
	super._on_preceed_to_next_tutorial()
	
	# Emit signal
	EventController.start_place_monster_signal.emit(task_text)
