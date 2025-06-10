extends Node

@export var high_score_num: RichTextLabel
@export var new_score_num: RichTextLabel


# Ready
func _ready() -> void:
	# Update high and new score texts
	SceneTransition.transition_into()
	high_score_num.text = str(PlayerController.high_score)
	new_score_num.text = str(PlayerController.curr_score)


# Attached to Start Menu button
# Return to the start menu
func on_return_to_start_menu():
	SceneManager.back_to_start_menu()
