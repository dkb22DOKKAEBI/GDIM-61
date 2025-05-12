# Player hand check player hand autoloaded
extends Node

const STARTING_HEALTH = 10
const STARTING_HAND_SIZE = 2

# Player's deck -> initially 28
const ORIGINAL_DECK: Array[String] = ["Tortilla", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla",
"Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", 
"Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat"]

var deck: Array[String] # Player deck
var player_health: int # Player health


# Ready function
func _ready() -> void:
	SceneManager.connect("new_game_started_signal", new_game_started)


# Reset player stats when a new game started
func new_game_started() -> void:
	# Reset player deck and shuffle
	deck = ORIGINAL_DECK.duplicate()
	deck.shuffle()
	
	# Add initial ingredient and monster cards after shuffling to player hand
	for i in range(STARTING_HAND_SIZE):
		var ingredient_name = deck[0]
		deck.erase(ingredient_name)
		PlayerHand.legacy_ingredient_hand.append(ingredient_name)
	PlayerHand.legacy_monster_hand.append("Pizza")
	
	# Initialize player health
	player_health = STARTING_HEALTH
