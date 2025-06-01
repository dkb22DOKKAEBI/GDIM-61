class_name Oven
extends Boss

signal oven_action_finish_signal()

var self_dmg: int
@onready var new_battle: Node2D = $"."
@onready var attacksfx = new_battle.get_node("attacksfx")

# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	self_dmg =  CardDatabase.BOSS_STATS["Oven"]["Self_dmg"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Choose ability to perform
	if curr_cool_down == 0:
		oven_multi_attack()
		curr_cool_down = max_cool_down
	else:
		oven_attack()
	await oven_action_finish_signal
	
	# Self take damage
	boss_take_dmg(self_dmg)


# Boss abilities
# Ability 1: Regular attack
func oven_attack() -> void:
	# Regular attack
	var target = choose_target()
	regular_attack(target)
	await boss_regular_attack_finish_signal
	
	# Signal action over
	oven_action_finish_signal.emit()

# Ability 2: Multiple attacks
func oven_multi_attack() -> void:
	# Attack three times with monsters as priority
	for i in range(3):
		var target = multi_attack_choose_target()
		regular_attack(target)
		await boss_regular_attack_finish_signal
	
	# Signal action over
	oven_action_finish_signal.emit()

func multi_attack_choose_target() -> Cardslot:
	if CardslotManager.cardslots[0].card_in_slot:
		return CardslotManager.cardslots[0]
	if CardslotManager.cardslots[1].card_in_slot:
		return CardslotManager.cardslots[1]
	if CardslotManager.cardslots[2].card_in_slot:
		return CardslotManager.cardslots[2]
	
	return null
