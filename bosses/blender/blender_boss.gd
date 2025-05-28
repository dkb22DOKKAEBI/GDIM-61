class_name Blender
extends Boss

var ramp_cool_down: int


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	ramp_cool_down = CardDatabase.BOSS_STATS["Blender"]["RampCoolDown"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Boss action
	# Check whether has a backline
	if CardslotManager.cardslots[1].card_in_slot or CardslotManager.cardslots[2].card_in_slot:
		swap_front_back_line()
		curr_cool_down = max_cool_down


# Boss abilities
# Ability 1: Regular attack with chance of doulbe hit

# Ability 2: Ramping up attack

# Ability 3: Swap frontline with backline
func swap_front_back_line() -> void:
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
	
