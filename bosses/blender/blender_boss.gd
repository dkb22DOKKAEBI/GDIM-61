class_name Blender
extends Boss

signal blender_regular_attack_finish_signal()
signal blender_swap_finish_signal()

var double_hit_chance: float

# Boss abilities
enum BLENDER_ABILITIES {REGULAR_ATTACK, SWAP}
var next_move := BLENDER_ABILITIES.REGULAR_ATTACK


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	double_hit_chance = CardDatabase.BOSS_STATS["Blender"]["DoubleHitChance"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Perform ability
	match next_move:
		BLENDER_ABILITIES.REGULAR_ATTACK:
			blender_attack()
			await blender_regular_attack_finish_signal
		BLENDER_ABILITIES.SWAP:
			blender_swap_front_back_line()
			curr_cool_down = max_cool_down
			await blender_swap_finish_signal
		_:
			push_error("Blender ability not found")
	
	# Boss ramping attack
	blender_ramp_up_attack()
	
	# Signal boss action finishs
	boss_action_finish_signal.emit()


# Boss next move methods
# Update boss next move with logic
func update_next_move() -> void:
	# Choose ability to use
	if curr_cool_down == 0 and (CardslotManager.cardslots[1].card_in_slot or CardslotManager.cardslots[2].card_in_slot): # Swap front and backline
		next_move = BLENDER_ABILITIES.SWAP
	else: # Regular attack
		next_move = BLENDER_ABILITIES.REGULAR_ATTACK
	
	# Update display text
	update_intended_move_text()

# Return boss next move's display name
func get_intended_move_name() -> String:
	match next_move:
		BLENDER_ABILITIES.REGULAR_ATTACK:
			return "Axe Rush"
		BLENDER_ABILITIES.SWAP:
			return "Whirlwind Pull"
		_:
			push_error("Blender ability not found")
			return "---"


# Boss abilities
# Ability 1: Regular attack with chance of doulbe hit
func blender_attack() -> void:
	# Check for doubling hit
	var coefficient := 1
	var check := randf_range(0.0, 1.0)
	if check <= double_hit_chance:
		coefficient = 2
	
	# Regular attack
	var target = choose_target()
	regular_attack(target, self, 1, coefficient)
	await boss_regular_attack_finish_signal
	
	# Signal ability finish
	blender_regular_attack_finish_signal.emit()

# Ability 2: Swap frontline with backline
func blender_swap_front_back_line() -> void:
	# Get targeted backline
	var target_cardslot : Cardslot
	if CardslotManager.cardslots[1].card_in_slot:
		target_cardslot = CardslotManager.cardslots[1]
	else:
		target_cardslot = CardslotManager.cardslots[2]
	
	# Swap backline with the from line
	var front_cardslot = CardslotManager.cardslots[0]
	var temp = front_cardslot.card_in_slot
	front_cardslot.card_in_slot = target_cardslot.card_in_slot
	target_cardslot.card_in_slot = temp
	
	# Update card position and info
	if target_cardslot.card_in_slot:
		target_cardslot.card_in_slot.card_slot_on = target_cardslot
		target_cardslot.card_in_slot.reparent(target_cardslot)
		target_cardslot.card_in_slot.position = Vector2.ZERO
	
	front_cardslot.card_in_slot.card_slot_on = front_cardslot
	front_cardslot.card_in_slot.reparent(front_cardslot)
	front_cardslot.card_in_slot.position = Vector2.ZERO
	
	# Update CardslotManager's cardslot_ability tracker
	var temp2 = CardslotManager.cardslot_abilities[target_cardslot.card_slot_number]
	CardslotManager.cardslot_abilities[target_cardslot.card_slot_number] = CardslotManager.cardslot_abilities[front_cardslot.card_slot_number]
	CardslotManager.cardslot_abilities[front_cardslot.card_slot_number] = temp2
	
	# Update player_cards_on_battlefield in battle manager
	battle_manager.update_player_cards_on_battlefield()
	
	# Signal ability finish
	await get_tree().create_timer(0.5).timeout
	blender_swap_finish_signal.emit()

# Ability 3: Ramping up attack
func blender_ramp_up_attack() -> void:
	var check := randf_range(0.0, 1.0)
	if check >= 0.5:
		boss_attack += 1
		boss_attack_text.text = str(boss_attack)
