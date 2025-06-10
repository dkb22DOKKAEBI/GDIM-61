# Player hand check player hand autoloaded
extends Node

# Player variables
const STARTING_HEALTH := 10
const STARTING_HAND_SIZE := 0
const MAX_INGREDIENT_HAND_NUM := 6 # Maximum number of ingredient cards in hand
const MAX_MONSTER_HAND_NUM := 4 # Maximum number of monster cards in hand
const REWARD_INGREDIENT_NUM := 5

# Player status
enum PLAYER_STATUS {IDLE, TARGETING, CHECKING_INFO, WAITING_TURN, REWARD, TUTORIAL}

# Player's deck -> initially 37
const ORIGINAL_DECK: Array[String] = ["Tortilla", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", "Tortilla", "Dough", 
"Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", "Tortilla",
"Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Chocolate", 
"Tortilla", "Dough", "Cheese", "Tomato", "Sugar", "Mystery_Meat", "Lettuce", 
"Chocolate", "Grain", "Grain", "Grain", "Grain"]

# Scores for beating levels, turn used, and ingredients left
const LEVEL_SCORES: Array[int] = [300, 400, 600, 900, 1200]
const TURN_BASE_SCORE: int = 150
const TURN_DEDUCTION_SCORE: int = 10
const INGREDIENT_BASE_SCORE: int = 200
const PLAYER_HEALTH_UNIT_SCORE: int = 10

# Reference to other scripts
var battle_manager: Node2D

# Member variables
var deck: Array[String] # Player deck
var player_health: int # Player health
var is_on_player_turn: bool = true # Whether is on player's turn
var is_on_tutorial: bool = false # Whether the player is in totorial
var curr_player_status: PLAYER_STATUS = PLAYER_STATUS.IDLE # Current player status
var turn_num: int = 0 # Which turn the player is on
var high_score: int
var curr_score: int


# Ready function
func _ready() -> void:
	SceneManager.connect("new_game_started_signal", new_game_started)
	high_score = 0


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
	curr_score = 0


# Update player score
func update_player_score(level_index: int):
	# Update current score
	curr_score += LEVEL_SCORES[level_index]                  # Level score
	curr_score += max(0, (150 - 10 * turn_num))              # Turn score
	var fraction := (float(deck.size() + PlayerHand.selected_ingredients.size() + PlayerHand.player_ingredient_hand.size())
					/ float(ORIGINAL_DECK.size() + (level_index - 1) * 5))
	curr_score += int(INGREDIENT_BASE_SCORE * fraction)      # Ingredient score
	curr_score += PLAYER_HEALTH_UNIT_SCORE * player_health   # Player health score
	
	# Update high score
	if curr_score > high_score:
		high_score = curr_score
