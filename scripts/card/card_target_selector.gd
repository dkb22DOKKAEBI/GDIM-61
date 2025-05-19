extends Node2D

const ARC_POINTS: int = 11
const START_X_OFFSET: int = 15 # Offset in x of starting point of aiming arc on card

@export var area_2d: Area2D
@export var aiming_arc: Line2D
@export var input_manager: Node2D

var curr_card: MonsterCard # The card that is targeting
var targeting: bool = false # Whether playering is targeting


# Ready
func _ready() -> void:
	# Connect signals
	input_manager.connect("targeting_start_signal", _on_targeting_start)
	input_manager.connect("left_mouse_button_released", _on_targeting_end)


# Process
func _process(_delta: float) -> void:
	if not targeting:
		return
	
	# Selector following mouse
	area_2d.global_position = get_global_mouse_position()
	aiming_arc.points = get_points()


# Calculate the points for aiming arc
func get_points() -> Array:
	var points: Array[Vector2] = []
	
	# Get starting position <- middle of right edge
	var start := curr_card.global_position
	start.x += PlayerHand.CARD_WIDTH - START_X_OFFSET
	start.y += PlayerHand.CARD_HEIGHT / 2.0
	
	# Add in starting and middle points
	var target := get_global_mouse_position()
	var distance := target - start
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x  + (distance.x / ARC_POINTS) * i
		var y := ease_out_cubic(t) + distance.y
		points.append(Vector2(x, y))
	
	# Add in the end point
	points.append(target)
	
	# Return
	return points

# Curve function to make the arc a curve
# Should return value between 0 and 1
func ease_out_cubic(number: float) -> float:
	var result := 1.0 - pow(1 - number, 3.0)
	return result


# Targeting starts
# Listen to targeting_start_signal
func _on_targeting_start(monster_card: MonsterCard) -> void:
	print("On target Start")
	# Set targeting info
	targeting = true
	curr_card = monster_card
	
	# Enable target selector
	area_2d.monitoring = true
	area_2d.monitorable = true


# Targeting ends
# Listen to left_mouse_button_released
func _on_targeting_end() -> void:
	print("On target Start")
	# Clear targeting info
	targeting = false
	curr_card = null
	
	# Disable target selector
	aiming_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false
