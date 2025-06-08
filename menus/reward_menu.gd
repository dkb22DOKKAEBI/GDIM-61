class_name RewardMenu
extends Node

# Attached to Next Level button
# Proceed to the next level
func on_next_level() -> void:
	SceneManager.proceed_to_next_level()
