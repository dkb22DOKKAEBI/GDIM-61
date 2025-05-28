extends Node

const ingredient_reward_deck: Array[String] = ["Tortilla", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", "Tortilla",
"Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", 
"Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", 
"Chocolate"]

var reward_claimed: bool = false

# Attached to Next Level button
# Proceed to the next level
func on_next_level() -> void:
	SceneManager.proceed_to_next_level()


# Attached to Claim Reward button
# Claim reward from completion of previous level
func on_claim_reward() -> void:
	# Check whether reward claimed
	if not reward_claimed:
		reward_claimed = true
		
		# Add 5 random ingredient rewards to player's deck
		ingredient_reward_deck.shuffle()
		for i in range(5):
			PlayerController.deck.append(ingredient_reward_deck[i])
		PlayerController.deck.shuffle()
