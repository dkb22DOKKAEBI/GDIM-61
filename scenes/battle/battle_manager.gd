extends Node

const STARTING_HEALTH = 10

var max_cool_down := 4
var curr_cool_down := 4
var opponent_health = 10
var player_cards_on_battlefield = []

var player_health
var boss_health
var boss_damage = 2
var boss1_stats = {"Vacuum": {"HP": 10, "Attack": 2, "Block": 2, "Kill": 10}}
var monster_cards = {"Sandwich": {"HP":5, "Attack": 1}, "Pizza": {"HP":5, "Attack": 1} }

@onready var battle_timer: Timer = $"../BattleTimer"
@onready var cardslot_1: Node2D = $"../Cardslot"
@onready var cardslot_2: Node2D = $"../Cardslot2"
@onready var cardslot_3: Node2D = $"../Cardslot3"

func _ready() ->void:
	player_health = STARTING_HEALTH
	$"../PlayerHealth".text = str(player_health)
	
	boss_health = STARTING_HEALTH
	$"../BossHealth".text = str(boss_health)
	
	$"../BossAttack".text = str(boss_damage)
	

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
	start_player_turn()


func start_player_turn():
	$"../CardManager".reset_played()
	$"../Deck".reset_draw()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
	
		#maybe whenever card is played add it to an dictionary so that the new dictionary
	#can keep track of the cards on the field rather than the original
	#I still do not know how to copy a variable from another dictionary into a new dictionary -kai
	#the dictionary would look something like this
	#var playing_field = {cardslot_1 : {}, cardslot_2: {}, cardslot_3: {}}
	#player chooses card to play
	#card attacks
	var chosen_card
	var player_card_attacker = chosen_card
	opponent_attack("Boss", "player") #adjust boss so that it attacks the boss card
	#make it so played card cannot be played against, 
	#(possibly by storing the cardslots that have already attacked into an array and 
	#preventing them from being played again)
	
	#create an if function that checks boss's health at the end of the turn as if it is zero then the player has won





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
	#for now this is how it will target cards
	if cardslot_1.card_in_slot:
		return cardslot_1
	elif cardslot_2.card_in_slot:
		return cardslot_2
	elif cardslot_3.card_in_slot:
		return cardslot_3
	
	# Calculate turn numbers needed to kill player
	# and that the cards can kill the enemy
	# to decide which target to choose
	
	return null # Means the target is the player


func opponent_attack(target, attacker):
	if attacker == "boss":
		var boss_attack = boss1_stats["Vacuum"]["Attack"]
		player_health = max(0, player_health - boss_attack)
		$"../PlayerHealth".text = str(player_health)
		print("Opponent Attack")
	#elif attacker == "player":
		#var player_attack = monster_cards[attacker]["Attack"]
		##attacker needs to reference the cards in CardDatabase.gd
		#boss_health = max(0, boss_health - player_attack)
		#$"../BossHealth".text = str(boss_health)
		#print("Player Attack")


func opponent_defend():
	boss_health = min(boss_health + 2, 10)
	$"../BossHealth".text = str(boss_health)
	print("Opponent Defend")


func opponent_eliminate(target):
	var boss_attack = boss1_stats["Vacuum"]["Kill"]
	print("Opponent Eliminate")
