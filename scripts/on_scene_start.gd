extends Node

@export var boss_parent: Node2D


func _ready() -> void:
	# Instantiate boss
	var boss_name = CardDatabase.BOSS_LEVEL[SceneManager.level_index]
	var boss_scene = load(CardDatabase.BOSS_PATH[boss_name])
	var boss: Node2D = boss_scene.instantiate()
	
	# Add boss as child of Enemy node
	boss_parent.add_child(boss)
	
	boss.battle_manager = $"../BattleManager"
