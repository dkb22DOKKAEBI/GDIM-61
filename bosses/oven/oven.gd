class_name Oven
extends Boss

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
	
	# Choose skills
	var skill = 0
	if curr_cool_down == 0:
		skill = 1
	
	match skill:
		0:
			oven_attack()
		1:
			oven_multi_attack()
	
	# Self take damage
	boss_take_dmg(self_dmg)


# Boss abilities
# Ability 1: Regular attack
func oven_attack() -> void:
	# Choose target
	var target = choose_target()
	
	var old_pos:Vector2 = battle_manager.enemy.global_position
	if not target:
		boss_attack_player_anim()
		await battle_manager.wait(0.5)
		battle_manager.player_take_dmg(2)
	else:
		boss_attack_monster_anim(target)
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[target].take_damage(boss_attack)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos)
	
	# Check whether player lose
	battle_manager.player_check_dead()

# Ability 2: Multiple attacks
func oven_multi_attack() -> void:
	# Attack three targets
	for i in range(3):
		var target = multi_attack_choose_target()
		if not target:
			battle_manager.player_take_dmg(2)
		else:
			battle_manager.player_cards_on_battlefield[target].take_damage(boss_attack)
	
	# Play attack animation
	var old_pos:Vector2 = battle_manager.enemy.global_position
	boss_attack_player_anim()
	await battle_manager.wait(0.5)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos)

func multi_attack_choose_target() -> Cardslot:
	if CardslotManager.cardslots[0].card_in_slot:
		return CardslotManager.cardslots[0]
	if CardslotManager.cardslots[1].card_in_slot:
		return CardslotManager.cardslots[1]
	if CardslotManager.cardslots[2].card_in_slot:
		return CardslotManager.cardslots[2]
	
	return null
