extends Node

const STARTING_HEALTH = 10

var max_cool_down := 4
var curr_cool_down := 4
var player_cards_on_battlefield # Dictionary

var player_health
var boss_health
var boss_damage = 2
var boss1_stats = {"Vacuum": {"HP": 10, "Attack": 2, "Block": 2, "Kill": 10}}
var monster_cards = {"Sandwich": {"HP":5, "Attack": 1}, "Pizza": {"HP":5, "Attack": 1} }
var selected_card_in_slot: Card

@onready var battle_timer: Timer = $"../BattleTimer"
@onready var cardslot_1: Node2D = $"../Cardslot"
@onready var cardslot_2: Node2D = $"../Cardslot2"
@onready var cardslot_3: Node2D = $"../Cardslot3"

func _ready() ->void:
	player_health = STARTING_HEALTH
	$"../PlayerHealth".text = str(player_health)
	
	boss_health = STARTING_HEALTH
	$"../BossHealth".text = str(boss_health)
	
	player_cards_on_battlefield = {cardslot_1: null, cardslot_2: null, cardslot_3: null}
	
	$"../BossAttack".text = str(boss_damage)
	$"../InputManager".connect("select_placed_card", _player_select_placed_card)
	$"../InputManager".connect("player_attack", _on_player_attack)


func _player_select_placed_card(card: Card):
	if selected_card_in_slot:
		selected_card_in_slot.selected_label_vis(false)
	selected_card_in_slot = card
	selected_card_in_slot.selected_label_vis(true)


func _on_player_attack():
	if not selected_card_in_slot:
		return
	
	if not selected_card_in_slot.attacked_this_turn:
		selected_card_in_slot.attacked_this_turn = true
		boss_health = max(0, boss_health - selected_card_in_slot.get_attack())
		$"../BossHealth".text = str(boss_health)
		if boss_health == 0:
			player_win()
		selected_card_in_slot.selected_label_vis(false)


func player_win():
	$"../Win".visible = true


func _on_end_turn_button_pressed() -> void:
	selected_card_in_slot = null
	reset_cards_attack()
	opponent_turn()


func reset_cards_attack():
	print("Clear function reached")
	for key in player_cards_on_battlefield:
		if player_cards_on_battlefield[key]:
			player_cards_on_battlefield[key].attacked_this_turn = false


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
	start_player_turn()


func start_player_turn():
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
			opponent_attack(target)
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
	
	# Calculate turn numbers needed to kill player
	# and that the cards can kill the enemy
	# to decide which target to choose
	
	return null # Means the target is the player


func opponent_attack(target):
	var boss_attack = boss1_stats["Vacuum"]["Attack"]
	if not target:
		player_health = max(0, player_health - boss_attack)
		$"../PlayerHealth".text = str(player_health)
	else:
		player_cards_on_battlefield[target].take_damage(boss_attack)
		
	print("Opponent Attack")


func opponent_defend():
	boss_health = min(boss_health + 2, 10)
	$"../BossHealth".text = str(boss_health)
	print("Opponent Defend")


func opponent_eliminate(target):
	if target:
		player_cards_on_battlefield[target].die()
	print("Opponent Eliminate")
