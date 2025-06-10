class_name TutorialBoss
extends Boss

@export var voice_text: RichTextLabel


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Show text of voice for 2 second
	voice_text.visible = true
	await get_tree().create_timer(2.0).timeout
	voice_text.visible = false
	
	# Signal boss action finishs
	boss_action_finish_signal.emit()


func update_next_move() -> void:
	update_intended_move_text()

# Return the display name for the boss's next move
func get_intended_move_name() -> String:
	return "BRRRRR"
