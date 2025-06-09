extends Node

const START_MENU_PATH = "res://menus/start_menu.tscn" # Path to start menu scene
const BATTLE_SCENE_PATH = "res://battle/battle.tscn" # Path to battle scene
const TUTORIAL_SCENE_PATH = "res://tutorial/tutorial.tscn" # Path to tutorial scene
const CREDIT_SCENE_PATH = "res://menus/credit_page.tscn" # Path to reward scene

const GAME_OVER_WIN_SCENE_PATH = "res://menus/game_over_win.tscn" # Path to game over win scene
const GAME_OVER_LOSE_SCENE_PATH = "res://menus/game_over_lose.tscn" # Path to game over lose scene

var level_index: int # Level index

signal new_game_started_signal # Signal emited when a new game started
signal player_complete_level_signal # Signal emited when player complete a level
signal game_end_signal # Signal emited when game is over


# Start a new game
func start_new_game() -> void:
	new_game_started_signal.emit()
	level_index = 0;
	SceneTransition.transition_out()
	await EventController.scene_transition_animation_finished_signal
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


# Start tutorial level
func start_tutorial() -> void:
	new_game_started_signal.emit()
	get_tree().change_scene_to_file(TUTORIAL_SCENE_PATH)


# Player defeat boss -> Update level index and check whether player wins
func defeat_boss() -> void:
	# Emit signal of completing a level
	PlayerController.update_player_score(level_index)
	player_complete_level_signal.emit()
	
	# Update level
	level_index += 1
	
	# Check whether all bosses defeated and game clear
	if PlayerController.is_on_tutorial: # Player complete tutorial
		EventController.finish_defeat_boss_tutorial_signal.emit()
	elif level_index >= CardDatabase.BOSS_LEVEL.size(): # Player wins
		transfer_to_game_over_win()
	else: # Still left bosses
		EventController.forward_to_reward_signal.emit()


# Proceed to the next level
func proceed_to_next_level() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE_PATH)


# Return back to the start menu
func back_to_start_menu() -> void:
	player_complete_level_signal.emit()
	game_end_signal.emit()
	get_tree().change_scene_to_file(START_MENU_PATH)


# Game over and player wins
func transfer_to_game_over_win() -> void:
	get_tree().change_scene_to_file(GAME_OVER_WIN_SCENE_PATH)


# Game over and player loses
func transfer_to_game_over_lose() -> void:
	# Emit signal of completing a level
	player_complete_level_signal.emit()
	get_tree().change_scene_to_file(GAME_OVER_LOSE_SCENE_PATH)


func transfer_to_credit_page() -> void:
	get_tree().change_scene_to_file(CREDIT_SCENE_PATH)
