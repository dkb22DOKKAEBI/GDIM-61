class_name Toaster
extends Boss


var spawn_max_cool_down: int
var curr_spawn_cool_down: int
var low_hp_line: int = 7
@export var breadspwan_1: Node2D
@export var breadspwan_2: Node2D

# Initialization of boss stats
func _ready():
	# Boss basic stats
	super._ready()
	
	# Boss unique stats
	spawn_max_cool_down = CardDatabase.BOSS_STATS["Toaster"]["SpawnCoolDown"]
	curr_spawn_cool_down = spawn_max_cool_down
	
	# Spawn breads at the beginning
	spawn_bread()



# Boss behavior logic
func on_action() -> void:
	super.on_action()
	# Update cool down
	if curr_spawn_cool_down != 0:
		curr_spawn_cool_down -= 1
	
	# Breadspawn attack
	if breadspwan_1.get_child_count() != 0:
		breadspwan_1.get_child(0).breadspawn_attack()
	if breadspwan_2.get_child_count() != 0:
		breadspwan_2.get_child(0).breadspawn_attack()
	
	# Toaster action
	if breadspwan_1.get_child_count() == 0 and breadspwan_2.get_child_count() == 0 and curr_spawn_cool_down == 0:
		spawn_bread()
		curr_spawn_cool_down = spawn_max_cool_down
	elif boss_health < low_hp_line and (breadspwan_1.get_child_count() != 0 or breadspwan_2.get_child_count() != 0):
		if breadspwan_1.get_child_count() != 0:
			toaster_exchange_health(breadspwan_1.get_child(0))
		else:
			toaster_exchange_health(breadspwan_2.get_child(0))
	else:
		toaster_attack()
	


# Boss abilities
# Ability 1: Spawn up to two breadspawns
func spawn_bread() -> void:
	# Spawn bread if there is not one in the position already
	if breadspwan_1.get_child_count() == 0:
		breadspwan_1.add_child(spawn_bread_helper())
	if breadspwan_2.get_child_count() == 0:
		breadspwan_2.add_child(spawn_bread_helper())

func spawn_bread_helper() -> Node2D:
	var boss_scene = load(CardDatabase.BOSS_PATH["Breadspawn"])
	var boss: Node2D = boss_scene.instantiate()
	boss.boss_name ="Breadspawn"
	boss.battle_manager = battle_manager
	if not battle_manager:
		print("NO Battle manager")
	
	return boss

# Ability 2: Attack
func toaster_attack() -> void:
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

# Ability 3: Exchange breadspawn for health
func toaster_exchange_health(breadspawn: Breadspawn) -> void:
	# Restore health
	boss_health += breadspawn.boss_health
	boss_health = min(boss_health, CardDatabase.BOSS_STATS["Toaster"]["HP"])
	boss_health_text.text = str(boss_health)
	
	# Change font to double size and green
	boss_health_text.add_theme_font_size_override("normal_font_size", 40)
	boss_health_text.modulate = Color.GREEN

	# Play animation for health change
	var tween = get_tree().create_tween()
	tween.tween_property(boss_health_text, "theme_override_font_sizes/normal_font_size", 16, 1)
	tween.tween_property(boss_health_text, "modulate", Color.BLACK, 1)
	
	# Delete breadspawn
	breadspawn.queue_free()
