extends Node

@export var tutorial_prep: Node2D
@export var boss_parent: Node2D


func _ready() -> void:
	# Instantiate boss
	var boss_name = "Lightbulb"
	var boss_scene = load(CardDatabase.BOSS_PATH[boss_name])
	var boss: Node2D = boss_scene.instantiate()
	boss.boss_name = boss_name
	
	# Add boss as child of Enemy node
	boss_parent.add_child(boss)
	
	boss.battle_manager = $"../BattleManager"
	
	# Start Tutorial
	tutorial_prep.curr_message.activate_self()
