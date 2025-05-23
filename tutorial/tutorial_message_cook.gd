class_name TutorialMessageCook
extends TutorialMessage

var task_text: String = "Make a pizza monster with tomato, cheese, and dough"

# Override function to emit signal to update task text
func _on_preceed_to_next_tutorial():
	super._on_preceed_to_next_tutorial()
	
	# Emit signal
	EventController.start_cook_tutorial_signal.emit(task_text)
