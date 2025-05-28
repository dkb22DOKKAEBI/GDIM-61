class_name Breadspawn
extends Boss


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()


func boss_turn() -> void:
	pass


# Boss abilities
# Ability 1: Regular attack
func breadspawn_attack() -> void:
	# Choose target
	var target = choose_target()
	
	var old_pos:Vector2 = self.global_position
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
