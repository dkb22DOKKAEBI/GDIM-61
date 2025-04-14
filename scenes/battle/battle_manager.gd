extends Node

var max_cool_down := 3
var curr_cool_down := 3
@onready var battle_timer: Timer = $"../BattleTimer"


func _on_end_turn_button_pressed() -> void:
	opponent_turn()


func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
	# Enemy Turn
	print("Enemy Turn")
	battle_timer.start()
	await battle_timer.timeout
	
	print("Enemy Move") # Need implementation
	curr_cool_down -= 1
	opponent_move()
	if curr_cool_down == 0:
		curr_cool_down = max_cool_down
	
	battle_timer.start()
	await battle_timer.timeout
	
	# End Turn
	end_opponent_turn()


func end_opponent_turn():
	$"../CardManager".reset_played()
	$"../Deck".reset_draw()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true


func opponent_move():
	var available_skills := 2
	if curr_cool_down == 0:
		available_skills += 1
	
	# Decide which skill to use
	var skill = randi() % available_skills
	match skill:
		0:
			print("Attack")
			choose_target()
		1:
			print("Get Shield")
		2:
			print("Eliminate")
			choose_target()
		_:
			print("Skill out of range")


func choose_target():
	pass
