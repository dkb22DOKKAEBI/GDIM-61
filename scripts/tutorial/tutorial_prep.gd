extends Node

const TUTORIAL_DECK: Array[String] = ["Tomato", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough"]
@export var curr_message: TutorialMessage


# Ready
func _ready():
	# Connect signals
	EventController.connect("preceed_tutorial_signal", update_curr_message)
	
	# Update player setup for tutorial
	PlayerHand.legacy_monster_hand.clear()
	PlayerController.deck = TUTORIAL_DECK.duplicate()
	
	# Disable buttons


# Update current tutorial message
func update_curr_message(next_message: TutorialMessage):
	curr_message = next_message
