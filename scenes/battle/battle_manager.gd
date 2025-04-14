extends Node

var max_cool_down := 4
var curr_cool_down := 4
var opponent_health = 10
var player_cards_on_battlefield = []

var player_health = 3
var boss1_stats = {"Vacuum": {"HP": 10, "Attack": 2, "Block": 2, "Kill": 10}}
var monster_cards = {"Sandwich Knight": {"HP":5, "Attack": 1}}


@onready var battle_timer: Timer = $"../BattleTimer"
@onready var cardslot_1: Node2D = $"../Cardslot"
@onready var cardslot_2: Node2D = $"../Cardslot2"
@onready var cardslot_3: Node2D = $"../Cardslot3"


func _on_end_turn_button_pressed() -> void:
	opponent_turn()


func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
	#Check boss hp if zero end game
	
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
	start_player_turn()

func start_player_turn():
	#player chooses card to play
	#card attacks
	var chosen_card
	var player_card_attacker = chosen_card
	opponent_attack("Boss", "player") #adjust boss so that it attacks the boss card
	#make it so played card cannot be played against, 
	#(possibly by storing the cardslots that have already attacked into an array and 
	#preventing them from being played again)
	
	
	opponent_turn()

func end_opponent_turn():
	$"../CardManager".reset_played()
	$"../Deck".reset_draw()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true



func opponent_move():
	var skill = randi() % 2
	if curr_cool_down == 0:
		skill = 2
	var target = choose_target()
	
	match skill:
		0:
			opponent_attack(target, "boss")
		1:
			opponent_defend()
		2:
			opponent_eliminate(target)
		_:
			print("Skill out of range")


func choose_target() -> Cardslot:
	if cardslot_1.card_in_slot:
		return cardslot_1
	
	# Calculate turn numbers needed to kill player
	# and that the cards can kill the enemy
	# to decide which target to choose
	
	return null # Means the target is the player


func opponent_attack(target, attacker):
	if attacker == "boss":
		var boss_attack = boss1_stats["Vacuum"]["Attack"]
		print("Opponent Attack")
	elif attacker == "player":
		var player_attack = monster_cards[attacker]["Attack"]
		print("Player Attack")


func opponent_defend():
	boss1_stats["Vacuum"]["HP"] +=2
	print("Opponent Defend")


func opponent_eliminate(target):
	var boss_attack = boss1_stats["Vacuum"]["Kill"]
	print("Opponent Eliminate")
