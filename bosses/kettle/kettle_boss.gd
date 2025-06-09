class_name Kettle
extends Boss

signal kettle_regular_attack_finish_signal()
signal kettle_aoe_attack_finish_signal()

var steam_attack_power: int
var range_attack_power: int

# Boss abilities
enum KETTLE_ABILITIES {REGULAR_ATTACK, AOE_ATTACK}
var next_move := KETTLE_ABILITIES.REGULAR_ATTACK


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
	
	# Perform ability
	match next_move:
		KETTLE_ABILITIES.REGULAR_ATTACK:
			kettle_attack()
			await kettle_regular_attack_finish_signal
		KETTLE_ABILITIES.AOE_ATTACK:
			kettle_aoe_attack()
			curr_cool_down = max_cool_down
			await kettle_aoe_attack_finish_signal
		_:
			push_error("Kettle ability not found")
	
	# Signal boss action finishs
	boss_action_finish_signal.emit()


# Boss next move methods
# Update boss next move with logic
func update_next_move() -> void:
	# Choose ability to use
	if curr_cool_down == 0 and kettle_aoe_attack_check(): # AOE attack
		next_move = KETTLE_ABILITIES.AOE_ATTACK
	else: # Regular attack
		next_move = KETTLE_ABILITIES.REGULAR_ATTACK
	
	# Update display text
	update_intended_move_text()

# Return boss next move's display name
func get_intended_move_name() -> String:
	match next_move:
		KETTLE_ABILITIES.REGULAR_ATTACK:
			return "Vial Toss"
		KETTLE_ABILITIES.AOE_ATTACK:
			return "Final Geyser"
		_:
			push_error("Kettle ability not found")
			return "---"


# Boss abilities
# Ability 1: Regular Attack
func kettle_attack() -> void:
	# Regular attack
	var target = choose_target()
	regular_attack(target, get_node("BossBasic"))
	await boss_regular_attack_finish_signal
	
	# Signal ability finish
	kettle_regular_attack_finish_signal.emit()

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
	
	# Signal ability finish
	await get_tree().create_timer(0.5).timeout
	kettle_aoe_attack_finish_signal.emit()

func kettle_aoe_attack_check() -> bool: # Check whether should perform aoe attack
	# Return true if either there is a monster in the front line
	# Or the backline has a monster hp greater than 1
	if CardslotManager.cardslots[0].card_in_slot:
		return true
	if CardslotManager.cardslots[1].card_in_slot and CardslotManager.cardslots[1].card_in_slot.curr_health > 1:
		return true
	if CardslotManager.cardslots[2].card_in_slot and CardslotManager.cardslots[2].card_in_slot.curr_health > 1:
		return true
	
	return false
