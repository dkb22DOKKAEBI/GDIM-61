extends Node

@export var boss_parent: Node2D


# Called after all other nodes are created in the scene
func _ready() -> void:
	# Instantiate boss
	var boss_name = CardDatabase.BOSS_LEVEL[SceneManager.level_index]
	var boss_scene = load(CardDatabase.BOSS_PATH[boss_name])
	var boss: Node2D = boss_scene.instantiate()
	boss.boss_name = boss_name
	
	# Add boss as child of Enemy node
	boss_parent.add_child(boss)
	
	# Connect battle_manager to player and boss
	boss.battle_manager = $"../BattleManager"
	PlayerController.battle_manager = $"../BattleManager"
