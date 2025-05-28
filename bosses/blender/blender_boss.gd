class_name Blender
extends Boss

var double_hit_chance: float


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	double_hit_chance = CardDatabase.BOSS_STATS["Blender"]["DoubleHitChance"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Boss action
	# Check whether has a backline
	if curr_cool_down == 0 and (CardslotManager.cardslots[1].card_in_slot or CardslotManager.cardslots[2].card_in_slot):
		blender_swap_front_back_line()
		curr_cool_down = max_cool_down
	else:
		blender_attack()
	
	# Boss ramping attack
	blender_ramp_up_attack()
	


# Boss abilities
# Ability 1: Regular attack with chance of doulbe hit
func blender_attack() -> void:
	# Choose target
	var target = choose_target()
	var coefficient := 1
	
	# Check for doubling hit
	var check = randfn(0.0, 1.0)
	if check <= double_hit_chance:
		coefficient = 2
	
	# Attack
	var old_pos:Vector2 = self.global_position
	if not target:
		boss_attack_player_anim()
		await battle_manager.wait(0.5)
		battle_manager.player_take_dmg(coefficient * 1)
	else:
		boss_attack_monster_anim(target)
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[target].take_damage(coefficient * boss_attack)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos)
	
	# Check whether player lose
	battle_manager.player_check_dead()

# Ability 2: Ramping up attack
func blender_ramp_up_attack() -> void:
	boss_attack += 1
	boss_attack_text.text = str(boss_attack)

# Ability 3: Swap frontline with backline
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
	
	# Update player_cards_on_battlefield in battle manager
	battle_manager.update_player_cards_on_battlefield()
	
