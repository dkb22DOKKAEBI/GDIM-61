extends Node

const START_MENU_PATH = "res://scenes/menus/start_menu.tscn" # Path to start menu scene
const REWARD_SCENE_PATH = "res://scenes/menus/reward.tscn" # Path to reward scene
const BATTLE_SCENE_PATH = "res://scenes/battle/new_battle.tscn" # Path to battle scene

var level_index: int # Level index


# Transfer to the reward scene
func transfer_to_reward() -> void:
	get_tree().change_scene_to_file(REWARD_SCENE_PATH)


# Update level index and ransfer to the next level
func transfer_to_next_level() -> void:
	level_index += 1
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


# Start a new game
func start_new_game() -> void:
	level_index = 0;
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


# Return back to the start menu
func back_to_start_menu() -> void:
	get_tree().change_scene_to_file(START_MENU_PATH)
