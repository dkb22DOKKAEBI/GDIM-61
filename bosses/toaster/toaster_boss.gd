class_name Toaster
extends Boss


var spawn_max_cool_down: int
var curr_spawn_cool_down: int
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
	
	return boss
