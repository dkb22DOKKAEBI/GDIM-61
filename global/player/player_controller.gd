# Player hand check player hand autoloaded
extends Node

const STARTING_HEALTH := 10
const STARTING_HAND_SIZE := 0
const MAX_INGREDIENT_HAND_NUM := 6 # Maximum number of ingredient cards in hand
const MAX_MONSTER_HAND_NUM := 4 # Maximum number of monster cards in hand
const REWARD_INGREDIENT_NUM := 5

# Player status
enum PLAYER_STATUS {IDLE, TARGETING, CHECKING_INFO, WAITING_TURN, REWARD}

# Player's deck -> initially 28
const ORIGINAL_DECK: Array[String] = ["Tortilla", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", "Tortilla",
"Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", 
"Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", 
"Chocolate", "Grain", "Grain", "Grain", "Grain"]

# Reference to other scripts
var battle_manager: Node2D

# Member variables
var deck: Array[String] # Player deck
var player_health: int # Player health
var is_on_player_turn: bool = true # Whether is on player's turn
var is_on_tutorial: bool = false # Whether the player is in totorial
var curr_player_status: PLAYER_STATUS = PLAYER_STATUS.IDLE # Current player status


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
	
	# Initialize player status
	player_health = STARTING_HEALTH
	EventController.update_player_health_signal.emit(player_health)
	is_on_player_turn = true
	curr_player_status = PLAYER_STATUS.IDLE
