extends Node

@export var tutorial_prep: Node2D


func _ready() -> void:
	# Tutorial additional settings
	#end_turn_button.disabled = true
	
	await get_tree().create_timer(1).timeout
	tutorial_prep.curr_message.activate_self()
