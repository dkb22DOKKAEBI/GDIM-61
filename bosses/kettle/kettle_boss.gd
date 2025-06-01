class_name Kettle
extends Boss

signal kettle_action_finish_signal

var steam_attack_power: int
var range_attack_power: int


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	steam_attack_power = CardDatabase.BOSS_STATS["Kettle"]["SteamAttackPower"]
	range_attack_power = CardDatabase.BOSS_STATS["Kettle"]["RangeAttackPower"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Steam attack the backline
	kettle_scalding_steam()
	
	# Boss actions
	if curr_cool_down == 0 and not CardslotManager.check_battlefield_empty(): # AOE attack
		kettle_aoe_attack()
		curr_cool_down = max_cool_down
	else: # Regular attack
		kettle_attack()
	await kettle_action_finish_signal


# Boss abilities
# Ability 1: Regular Attack
func kettle_attack() -> void:
	# Regular attack
	var target = choose_target()
	regular_attack(target, get_node("BossBasic"))
	await boss_regular_attack_finish_signal
	
	# Signal boss action finish
	kettle_action_finish_signal.emit()

# Ability 2: Scalding Steam
func kettle_scalding_steam() -> void:
	if CardslotManager.cardslots[1].card_in_slot:
		CardslotManager.cardslots[1].card_in_slot.take_damage(steam_attack_power)
	if CardslotManager.cardslots[2].card_in_slot:
		CardslotManager.cardslots[2].card_in_slot.take_damage(steam_attack_power)

# Ability 3: Final Gayser (AOE attack)
func kettle_aoe_attack() -> void:
	for cardslot in CardslotManager.cardslots:
		if cardslot.card_in_slot:
			cardslot.card_in_slot.take_damage(range_attack_power)
	
	# Signal boss action finish
	kettle_action_finish_signal.emit()
