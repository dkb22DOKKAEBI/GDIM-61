class_name Oven
extends Boss

signal oven_regular_attack_finish_signal()
signal oven_multi_attack_finish_signal()

var self_dmg: int

# Boss abilities
enum OVEN_ABILITIES {REGULAR_ATTACK, MULTI_ATTACk}
var next_move :=  OVEN_ABILITIES.REGULAR_ATTACK


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	self_dmg =  CardDatabase.BOSS_STATS["Oven"]["Self_dmg"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Perform ability
	match next_move:
		OVEN_ABILITIES.REGULAR_ATTACK:
			oven_attack()
			await oven_regular_attack_finish_signal
		OVEN_ABILITIES.MULTI_ATTACk:
			oven_multi_attack()
			curr_cool_down = max_cool_down
			await oven_multi_attack_finish_signal
		_:
			push_error("Oven ability not found")
	
	# Self take damage
	boss_take_dmg(self_dmg)
	if boss_health <= 0:
		await PlayerController.get_tree().create_timer(1000).timeout
	
	# Signal boss action finishs
	boss_action_finish_signal.emit()


# Boss next move methods
# Update boss next move with logic
func update_next_move() -> void:
	# Choose ability to use
	if curr_cool_down == 0: # Multi-attack
		next_move = OVEN_ABILITIES.MULTI_ATTACk
	else: # Regular attack
		next_move = OVEN_ABILITIES.REGULAR_ATTACK
	
	# Update display text
	update_intended_move_text()

# Return boss next move's display name
func get_intended_move_name() -> String:
	match next_move:
		OVEN_ABILITIES.REGULAR_ATTACK:
			return "Regular Attack"
		OVEN_ABILITIES.MULTI_ATTACk:
			return "Multi Attack"
		_:
			push_error("Oven ability not found")
			return "---"


# Boss abilities
# Ability 1: Regular attack
func oven_attack() -> void:
	# Regular attack
	var target = choose_target()
	regular_attack(target, self, 1)
	await boss_regular_attack_finish_signal
	
	# Signal action over
	oven_regular_attack_finish_signal.emit()

# Ability 2: Multiple attacks
func oven_multi_attack() -> void:
	# Attack three times with monsters as priority
	for i in range(3):
		var target = multi_attack_choose_target()
		regular_attack(target, self, 2)
		await boss_regular_attack_finish_signal
	
	# Signal action over
	oven_multi_attack_finish_signal.emit()

func multi_attack_choose_target() -> Cardslot:
	if CardslotManager.cardslots[0].card_in_slot:
		return CardslotManager.cardslots[0]
	if CardslotManager.cardslots[1].card_in_slot:
		return CardslotManager.cardslots[1]
	if CardslotManager.cardslots[2].card_in_slot:
		return CardslotManager.cardslots[2]
	
	return null
