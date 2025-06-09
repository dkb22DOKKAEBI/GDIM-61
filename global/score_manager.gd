extends Node

# Scores for beating levels, turn used, and ingredients left
const level_scores: Array[int] = [300, 400, 600, 900, 1200]
const turn_base_score: int = 150
const turn_deduction_score: int = 10
const ingredient_base_score: int = 200

var start_ingredient_num: int
var reward_ingredient_num: int

var high_score: int = 0
var curr_score: int = 0


# Ready
func _ready() -> void:
	pass


# Calculate score
func calculate_score() -> int:
	return -1
