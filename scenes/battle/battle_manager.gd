extends Node

var max_cool_down := 3
var curr_cool_down := 3
var opponent_health = 10

@onready var battle_timer: Timer = $"../BattleTimer"
@onready var cardslot_1: Node2D = $"../Cardslot"
@onready var cardslot_2: Node2D = $"../Cardslot2"
@onready var cardslot_3: Node2D = $"../Cardslot3"


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
	var target = choose_target()
	match skill:
		0:
			opponent_attack()
		1:
			opponent_defend()
		2:
			opponent_eliminate()
		_:
			print("Skill out of range")


func choose_target() -> Cardslot:
	if cardslot_1.card_in_slot:
		return cardslot_1
	
	# Calculate turn numbers needed to kill player
	# and that the cards can kill the enemy
	# to decide which target to choose
	
	return null # Means the target is the player


func opponent_attack():
	print("Opponent Attack")


func opponent_defend():
	print("Opponent Defend")


func opponent_eliminate():
	print("Opponent Eliminate")
