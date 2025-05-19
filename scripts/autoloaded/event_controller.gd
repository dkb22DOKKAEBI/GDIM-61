extends Node

# Tutorial signals
signal preceed_tutorial_signal(next_message: TutorialMessage)
signal start_cook_tutorial_signal(task_text: String) # Cook tutorial
signal finish_cook_tutorial_signal()
signal start_place_monster_tutorial_signal(task_text: String) # Place monster tutorial
signal finish_place_monster_tutorial_signal()
signal start_defeat_boss_tutorial_signal(task_text: String) # Defeat boss tutorial


signal player_turn_end_signal()
