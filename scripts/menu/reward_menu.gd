extends Node

const ingredient_reward: Array[String] = ["Cheese", "Tomato", "Cheese", "Tomato", "Dough"]
const monster_reward: Array[String] = ["Pizza"]


# Attached to Next Level button
# Proceed to the next level
func on_next_level() -> void:
	SceneManager.proceed_to_next_level()


# Attached to Claim Reward button
# Claim reward from completion of previous level
func on_claim_reward() -> void:
	# Add ingredient reward to player's deck
	for reward_ingredient: String in ingredient_reward:
		PlayerController.deck.append(reward_ingredient)
	PlayerController.deck.shuffle()
	
	# Add monster reward to player's hand
	for reward_monster: String in monster_reward:
		PlayerHand.legacy_monster_hand.append(reward_monster)
