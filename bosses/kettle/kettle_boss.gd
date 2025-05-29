class_name Kettle
extends Boss

var steam_sprite_pos: Vector2
var steam_attack_power: int
var range_attack_power: int


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	steam_attack_power = CardDatabase.BOSS_STATS["Kettle"]["SteamAttackPower"]
	range_attack_power = CardDatabase.BOSS_STATS["Kettle"]["RangeAttackPower"]
	# Set up steam sprite position
	


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Steam attack the backline
	kettle_scalding_steam()
	
	# Boss actions
	if curr_cool_down == 0 and not CardslotManager.check_battlefield_empty():
		kettle_aoe_attack()
		curr_cool_down = max_cool_down
	else:
		kettle_attack()


# Boss abilities
# Ability 1: Regular Attack
func kettle_attack() -> void:
	# Choose target
	var target = choose_target()
	
	var old_pos:Vector2 = battle_manager.enemy.global_position
	if not target:
		boss_attack_player_anim()
		await battle_manager.wait(0.5)
		battle_manager.player_take_dmg(1)
	else:
		boss_attack_monster_anim(target)
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[target].take_damage(boss_attack)
	
	# Enemy return to original position
	boss_return_pos_anim(old_pos)
	
	# Check whether player lose
	battle_manager.player_check_dead()

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
