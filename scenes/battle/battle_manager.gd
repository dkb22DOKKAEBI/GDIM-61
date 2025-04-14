extends Node

@onready var battle_timer: Timer = $"../BattleTimer"


func _on_end_turn_button_pressed() -> void:
	opponent_turn()


func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
	# Enemy Behavior
	print("Enemy Turn")
	battle_timer.start()
	await battle_timer.timeout
	print("Enemy Move") # Need implementation
	
	# End Turn
	end_opponent_turn()


func end_opponent_turn():
	$"../CardManager".reset_played()
	$"../Deck".reset_draw()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
