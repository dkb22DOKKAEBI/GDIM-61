extends Node

const START_MENU_PATH = "res://scenes/menus/start_menu.tscn" # Path to start menu scene
const REWARD_SCENE_PATH = "res://scenes/menus/reward.tscn" # Path to reward scene
const BATTLE_SCENE_PATH = "res://scenes/battle/battle.tscn" # Path to battle scene
const TUTORIAL_SCENE_PATH = "res://scenes/tutorial.tscn" # Path to tutorial scene
const GAME_OVER_WIN = "res://scenes/menus/game_over_win.tscn" # Path to game over win scene
const GAME_OVER_LOSE = "res://scenes/menus/game_over_lose.tscn" # Path to game over lose scene

var level_index: int # Level index

signal new_game_started_signal # Signal emited when a new game started
signal player_complete_level_signal # Signal emited when player complete a level
signal game_end_signal # Signal emited when game is over


# Start a new game
func start_new_game() -> void:
	new_game_started_signal.emit()
	level_index = 0;
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


# Start tutorial level
func start_tutorial() -> void:
	new_game_started_signal.emit()
	get_tree().change_scene_to_file(TUTORIAL_SCENE_PATH)


# Player defeat boss -> Update level index and check whether player wins
func defeat_boss() -> void:
	# Emit signal of completing a level
	player_complete_level_signal.emit()
	
	# Update level
	level_index += 1
	
	# Check whether all bosses defeated and game clear
	if PlayerController.is_on_tutorial: # Player complete tutorial
		EventController.finish_defeat_boss_tutorial_signal.emit()
	elif level_index >= CardDatabase.BOSS_LEVEL.size(): # Player wins
		transfer_to_game_over_win()
	else: # Still left bosses
		transfer_to_reward()


# Transfer to the reward scene
func transfer_to_reward() -> void:
	get_tree().change_scene_to_file(REWARD_SCENE_PATH)


# Proceed to the next level
func proceed_to_next_level() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


# Return back to the start menu
func back_to_start_menu() -> void:
	game_end_signal.emit()
	get_tree().change_scene_to_file(START_MENU_PATH)


# Game over and player wins
func transfer_to_game_over_win() -> void:
	get_tree().change_scene_to_file(GAME_OVER_WIN)


# Game over and player loses
func transfer_to_game_over_lose() -> void:
	get_tree().change_scene_to_file(GAME_OVER_LOSE)
