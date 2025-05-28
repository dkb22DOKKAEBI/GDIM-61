extends Node

@export var boss_parent: Node2D


# Called after all other nodes are created in the scene
func _ready() -> void:
	# Instantiate boss
	var boss_name = CardDatabase.BOSS_LEVEL[SceneManager.level_index]
	var boss_scene = load(CardDatabase.BOSS_PATH[boss_name])
	var boss: Node2D = boss_scene.instantiate()
	boss.boss_name = boss_name
	boss.battle_manager = $"../BattleManager"
	
	# Add boss as child of Enemy node
	boss_parent.add_child(boss)
	
	# Connect battle_manager to player
	PlayerController.battle_manager = $"../BattleManager"
	
	# Update Pot ui
	PlayerHand.selected_ingredient_change_signal.emit()
