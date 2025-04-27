extends Node

const STARTING_HEALTH = 10
const max_cool_down := 3
const STARTING_HAND_SIZE = 3

var curr_cool_down := 3
var player_cards_on_battlefield # Dictionary

var player_health
var boss_health
var boss_damage = 3
var boss1_stats = {"Vacuum": {"HP": 10, "Attack": 3, "Block": 3, "Kill": 10}}
var monster_cards = {"Sandwich": {"HP":5, "Attack": 1}, "Pizza": {"HP":5, "Attack": 1} }
var selected_card_in_slot: Card
var is_on_player_turn: bool = true

@onready var battle_timer: Timer = $"../BattleTimer"
@onready var cardslot_1: Node2D = $"../Cardslots/Cardslot"
@onready var cardslot_2: Node2D = $"../Cardslots/Cardslot2"
@onready var cardslot_3: Node2D = $"../Cardslots/Cardslot3"

func _ready() ->void:
	player_health = STARTING_HEALTH
	$"../Player/PlayerHealth".text = str(player_health)
	
	boss_health = STARTING_HEALTH
	$"../BossHealth".text = str(boss_health)
	
	player_cards_on_battlefield = {cardslot_1: null, cardslot_2: null, cardslot_3: null}
	
	$"../BossAttack".text = str(boss_damage)
	$"../Player/InputManager".connect("select_placed_card", _player_select_placed_card)
	$"../Player/InputManager".connect("player_attack", _on_player_attack)
	
	# Draw initial hand
	for i in range(STARTING_HAND_SIZE):
		$"../Deck".draw_card()


func _player_select_placed_card(card: MonsterCard) -> void:
	card.selected_label_vis(!card.get_label_vis())
	
	# Same card being selected
	if not card.get_label_vis():
		selected_card_in_slot = null
		return
	
	# Disable select for previous selected card
	if selected_card_in_slot:
		selected_card_in_slot.selected_label_vis(false)
	selected_card_in_slot = card
	
	
	# Check if it is the same card being clicked
	#if selected_card_in_slot and selected_card_in_slot.visible == true:
		#selected_card_in_slot.selected_label_vis(false)
		#selected_card_in_slot = null
		#return
	
	# Disable selected label for previous card
	#if selected_card_in_slot:
		#selected_card_in_slot.selected_label_vis(false)
	#selected_card_in_slot = card
	#
	#selected_card_in_slot.selected_label_vis(true)


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
	$"../Enemy".visible = false
	$"../BossAttack".visible = false
	$"../BossHealth".visible = false
	

func player_lose():
	$"../Lose".visible = true


# End player turn and opponent turn starts
func _on_end_turn_button_pressed() -> void:
	print("Not On Player Turn")
	# Dis-select card selected in battlefield
	if selected_card_in_slot:
		selected_card_in_slot.selected_label_vis(false)
		selected_card_in_slot = null
	is_on_player_turn = false
	
	# Opponent Turn
	opponent_turn()


func reset_cards_attack():
	for key in player_cards_on_battlefield:
		if player_cards_on_battlefield[key]:
			player_cards_on_battlefield[key].attacked_this_turn = false


func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
	# Opponent Turn Starts
	battle_timer.start()
	await battle_timer.timeout
	
	# Opponent Move
	curr_cool_down -= 1
	opponent_move()
	
	if curr_cool_down == 0:
		curr_cool_down = max_cool_down
	
	battle_timer.start()
	await battle_timer.timeout
	
	# Opponent Turn Ends
	start_player_turn()


func start_player_turn():
	$"../MonsterCardManager".reset_played()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
	
	# Draw 2 ingredients card on the start of the player turn
	for i in range(2):
		$"../Deck".draw_card()
	
	reset_cards_attack()
	is_on_player_turn = true
	print("On Player Turn")


func opponent_move():
	var skill = randi() % 3
	if curr_cool_down == 0:
		skill = 3
	var target = choose_target()
	
	match skill:
		0 :
			opponent_attack(target)
		1:
			opponent_attack(target)
		2:
			opponent_defend()
		3:
			opponent_eliminate()
		_:
			print("Skill out of range")


func choose_target() -> Cardslot:
	#for now this is how it will target cards
	if cardslot_1.card_in_slot:
		return cardslot_1
	elif cardslot_2.card_in_slot and cardslot_3.card_in_slot:
		var target = randi() % 2
		if target == 0:
			return cardslot_2
		else:
			return cardslot_3
	else:
		return 
	
	# Calculate turn numbers needed to kill player
	# and that the cards can kill the enemy
	# to decide which target to choose
	
	return null # Means the target is the player


func opponent_attack(target):
	var boss_attack = boss1_stats["Vacuum"]["Attack"]
	if not target:
		boss_attack_player_anim()
		await wait(0.5)
		
		player_health = max(0, player_health - boss_attack)
		$"../Player/PlayerHealth".text = str(player_health)
		boss_return_pos_anim()
		if player_health == 0:
			player_lose()
	else:
		boss_attack_monster_anim(target)
		await wait(0.5)
		player_cards_on_battlefield[target].take_damage(boss_attack)
		boss_return_pos_anim()
		
	print("Opponent Attack")

func boss_attack_player_anim():
	var new_pos_x = 25
	var new_pos = Vector2(new_pos_x, $"../Enemy".position.y)
	$"../Enemy".z_index = 5
	$"../BossAttack".visible = false
	$"../BossHealth".visible = false
	var tween = get_tree().create_tween()
	tween.tween_property($"../Enemy", "position", new_pos, 0.5)

func boss_attack_monster_anim(target):
	var new_pos_x = target.position.x
	var new_pos_y = target.position.y
	var new_pos = Vector2(new_pos_x, new_pos_y)
	$"../Enemy".z_index = 5
	$"../BossAttack".visible = false
	$"../BossHealth".visible = false
	var tween = get_tree().create_tween()
	tween.tween_property($"../Enemy", "position", new_pos, 0.5)



func boss_return_pos_anim():
	var old_pos_x = 214.5
	var old_pos_y = 77
	var old_pos = Vector2(old_pos_x, old_pos_y)
	$"../Enemy".z_index = 0
	var tween2 = get_tree().create_tween()
	tween2.tween_property($"../Enemy", "position", old_pos, 0.5)
	await wait(0.5)
	$"../BossAttack".visible = true
	$"../BossHealth".visible = true

func wait(wait_time):
	battle_timer.wait_time = wait_time
	battle_timer.start()
	await battle_timer.timeout

func opponent_defend():
	if boss_health == 20:
		var target = choose_target()
		opponent_attack(target)
	else:
		boss_health = min(boss_health + 3, 10)
		$"../BossHealth".text = str(boss_health)
		print("Opponent Defend")


func opponent_eliminate():
	if cardslot_1.card_in_slot:
		boss_attack_monster_anim(cardslot_1)
		await wait(0.5)
		player_cards_on_battlefield[cardslot_1].die()
		boss_return_pos_anim()
	elif cardslot_2.card_in_slot:
		boss_attack_monster_anim(cardslot_2)
		await wait(0.5)
		player_cards_on_battlefield[cardslot_2].die()
		boss_return_pos_anim()
	elif cardslot_3.card_in_slot:
		boss_attack_monster_anim(cardslot_3)
		await wait(0.5)
		player_cards_on_battlefield[cardslot_3].die()
		boss_return_pos_anim()
	else:
		opponent_attack(null)
	print("Opponent Eliminate")

func check_field():
	if not cardslot_1.card_in_slot and not cardslot_2.card_in_slot and not cardslot_3.card_in_slot:
		return true
	else:
		false
