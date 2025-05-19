extends Node

const TUTORIAL_DECK: Array[String] = ["Tomato", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough"]


# Ready
func _ready():
	print("Tutorial Prep")
	# Update player setup for tutorial
	PlayerHand.legacy_monster_hand.clear()
	PlayerController.deck = TUTORIAL_DECK.duplicate()
	
	# Disable buttons
