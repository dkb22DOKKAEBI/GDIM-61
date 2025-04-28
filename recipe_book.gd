extends Control

func exit():
	get_tree().paused = false
	
func pause():
	get_tree().paused = true
	
func openbook():
	pass
	
func _on_exit_book_pressed() -> void:
	pass # Replace with function body.
