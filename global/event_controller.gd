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
signal recipe_display_card_info_signal(monster_name: String) # Display monster card info inside recipe book
signal update_ingredient_num_indicator_signal()
signal update_monster_num_indicator_signal()
signal forward_to_reward_signal()
signal update_enemy_intended_move_signal()
signal player_alive_signal()

# Pause game
signal pause_game_signal()

# Scene transition
signal scene_transition_animation_finished_signal() # Signal the scene transition animation finished
