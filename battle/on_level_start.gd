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
	
	# Update UI
	PlayerHand.selected_ingredient_change_signal.emit()
	EventController.update_ingredient_num_indicator_signal.emit()
	EventController.update_monster_num_indicator_signal.emit()
	EventController.update_player_health_signal.emit(PlayerController.player_health)
	SceneTransition.transition_into()
	
	# Start player turn
	PlayerController.turn_num = 0
	$"../BattleManager".start_player_turn()
