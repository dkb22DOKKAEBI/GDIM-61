class_name TutorialBoss
extends Boss

@export var voice_text: RichTextLabel


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Show text of voice for 1 second
	voice_text.visible = true
	await get_tree().create_timer(1.0).timeout
	voice_text.visible = false
