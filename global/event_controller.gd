extends Node

# Mouse signals
signal right_mouse_button_released()

# Tutorial signals
signal preceed_tutorial_signal(next_message: TutorialMessage)
signal start_cook_tutorial_signal(task_text: String) # Cook tutorial
signal finish_cook_tutorial_signal()
signal start_place_monster_tutorial_signal(task_text: String) # Place monster tutorial
signal finish_place_monster_tutorial_signal()
signal start_defeat_boss_tutorial_signal(task_text: String) # Defeat boss tutorial
signal finish_defeat_boss_tutorial_signal()

# Battle signals
signal player_turn_end_signal()
signal update_player_health_signal(health: int)
signal display_monster_card_info_signal(monster_card: MonsterCard) # Display info page for monster card or boss
signal display_boss_info_signal(boss: Boss)

# Pause game
signal pause_game_signal()
