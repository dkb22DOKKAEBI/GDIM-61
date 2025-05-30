class_name Vacuum
extends Boss

var boss_block: float
var boss_elimination: float
@onready var new_battle: Node2D = $"."
@onready var attacksfx = new_battle.get_node("attacksfx")


# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	boss_block = CardDatabase.BOSS_STATS["Vacuum"]["Block"]
	boss_elimination = CardDatabase.BOSS_STATS["Vacuum"]["Elimination"]


# Boss behavior logic
func on_action() -> void:
	super.on_action()
	
	# Choose ability to use
	var skill = randi() % 3
	if curr_cool_down == 0:
		skill = 3
	var target = choose_target()
	
	match skill:
		0 :
			vacuum_attack(target)
		1:
			vacuum_attack(target)
		2:
			vacuum_defend()
		3:
			vacuum_eliminate()
			curr_cool_down = max_cool_down
		_:
			print("Skill out of range")


# Boss abilities
# Ability 1: Boss attack
func vacuum_attack(target):
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


# Ability 2: Boss defend
func vacuum_defend():
	if boss_health == CardDatabase.BOSS_STATS["Vacuum"]["HP"]:
		var target = choose_target()
		vacuum_attack(target)
	else:
		boss_health = min(boss_health + 3, CardDatabase.BOSS_STATS["Vacuum"]["HP"])
		boss_health_text.text = str(boss_health)
		
		# Change font to double size and green
		boss_health_text.add_theme_font_size_override("normal_font_size", 40)
		boss_health_text.modulate = Color.GREEN
	
		# Play animation for health change
		var tween = get_tree().create_tween()
		tween.tween_property(boss_health_text, "theme_override_font_sizes/normal_font_size", 16, 1)
		tween.tween_property(boss_health_text, "modulate", Color.BLACK, 1)


# Ability 3: Boss eliminate
func vacuum_eliminate():
	var old_pos:Vector2 = battle_manager.enemy.global_position
	if CardslotManager.cardslots[0].card_in_slot:
		boss_attack_monster_anim(CardslotManager.cardslots[0])
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[CardslotManager.cardslots[0]].die()
		boss_return_pos_anim(old_pos)
	elif CardslotManager.cardslots[1].card_in_slot:
		boss_attack_monster_anim(CardslotManager.cardslots[1])
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[CardslotManager.cardslots[1]].die()
		boss_return_pos_anim(old_pos)
	elif CardslotManager.cardslots[2].card_in_slot:
		boss_attack_monster_anim(CardslotManager.cardslots[2])
		await battle_manager.wait(0.5)
		battle_manager.player_cards_on_battlefield[CardslotManager.cardslots[2]].die()
		boss_return_pos_anim(old_pos)
	else:
		vacuum_attack(null)
