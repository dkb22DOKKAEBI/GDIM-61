class_name TutorialMessage
extends Node

@export var next_message: TutorialMessage # Next message
@export var activate_next: bool # Whether activate next message when finish this tutorial message


# Ready
func _ready() -> void:
	# Disable self when started
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED


# Attached to the button OK
# Try proceed to the next tutorial message
func _on_preceed_to_next_tutorial():
	# Emit signal
	EventController.preceed_tutorial_signal.emit(next_message)
	get_tree().paused = false
	
	# Check whether activate next tutorial message
	if activate_next:
		next_message.activate_self()
	
	# Destroy self
	self.queue_free()


# Enable message
func activate_self() -> void:
	self.visible = true
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	get_tree().paused = true
