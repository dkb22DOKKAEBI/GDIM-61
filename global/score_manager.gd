extends Node

# Scores for beating levels, turn used, and ingredients left
const LEVEL_SCORES: Array[int] = [300, 400, 600, 900, 1200]
const TURN_BASE_SCORE: int = 150
const TURN_DEDUCTION_SCORE: int = 10
const INGREDIENT_BASE_SCORE: int = 200

var start_ingredient_num: int
var reward_ingredient_num: int

var high_score: int = 0
var curr_score: int = 0


# Ready
func _ready() -> void:
	start_ingredient_num = PlayerController.ORIGINAL_DECK.size()
	reward_ingredient_num = PlayerController.REWARD_INGREDIENT_NUM


# Calculate score
func calculate_score() -> int:
	var result: int
	
	# Calculate level points
	
	
	# Calculate turn points
	
	
	# Calculate ingredient points
	
	
	return result
