class_name TutorialMessageDefeatBoss
extends TutorialMessage

var task_text: String = "Defeat the boss"

# Override function to emit signal to update task text
func _on_preceed_to_next_tutorial():
	super._on_preceed_to_next_tutorial()
	
	# Emit signal
	EventController.start_defeat_boss_tutorial_signal.emit(task_text)
