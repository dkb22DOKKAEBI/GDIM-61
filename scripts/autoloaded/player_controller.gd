# Player hand check player hand autoloaded
extends Node

const STARTING_HEALTH = 10
const STARTING_HAND_SIZE = 2

# Player's deck -> initially 28
var deck: Array[String] = ["Tortilla", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla",
"Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", 
"Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat"]

var player_health: int # Player health


func _ready() -> void:
	# Add 2 initial ingredient cards after shuffling and 1 pizza to player hand
	# at the beginning of a new game
	deck.shuffle()
	for i in range(STARTING_HAND_SIZE):
		var ingredient_name = deck[0]
		deck.erase(ingredient_name)
		PlayerHand.legacy_ingredient_hand.append(ingredient_name)
		PlayerHand.legacy_monster_hand.append("Pizza")
	
	# Initialize player health
	player_health = STARTING_HEALTH
