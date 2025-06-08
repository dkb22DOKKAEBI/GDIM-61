class_name RewardMenu
extends Node

const rewards: Array[String] = ["Cheese", "Dough", "Lettuce", "Tortilla", "Tomato",
   "Sugar", "Mystery_Meat", "Grain", "Chocolate"]

@export var menu: Control # The reward menu window


# Ready
func _ready() -> void:
	EventController.connect("forward_to_reward_signal", display_reward)


# Show the reward scene
func display_reward() -> void:
	# Update player status
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.REWARD
	
	# Display reward window 
	menu.scale = Vector2(0.1, 0.1)
	self.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(menu, "scale", Vector2(1, 1), 0.3)
	
	# Get 5 new ingredients as the reward
	for i in range(5):
		var new_ingredient = rewards[randi_range(0, 8)]
		PlayerController.deck.insert(randi_range(0, PlayerController.deck.size()), new_ingredient)


# Attached to Next Level button
# Proceed to the next level
func on_next_level() -> void:
	SceneManager.proceed_to_next_level()
