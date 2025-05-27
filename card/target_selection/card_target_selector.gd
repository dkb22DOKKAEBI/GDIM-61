extends Node2D

const ARC_POINTS: int = 11 # How many points aiming arc line2d has besides end point

@export var area_2d: Area2D
@export var aiming_arc: Line2D
@export var input_manager: Node2D
@onready var attacksfx: AudioStreamPlayer = $AudioStreamPlayer

var curr_card: MonsterCard # The card that is targeting
var target_boss: Boss = null # The boss to be attacked


# Ready
func _ready() -> void:
	# Connect signals
	input_manager.connect("targeting_start_signal", _on_targeting_start)
	input_manager.connect("left_mouse_button_released", _on_targeting_end)
	input_manager.connect("right_mouse_button_clicked", _on_targeting_canceled)


# Process
func _process(_delta: float) -> void:
	if PlayerController.curr_player_status != PlayerController.PLAYER_STATUS.TARGETING:
		return
	
	# Selector following mouse
	area_2d.position = get_local_mouse_position()
	aiming_arc.points = get_points()


# Calculate the points for aiming arc
func get_points() -> Array:
	var points: Array[Vector2] = []
	
	# Get starting position <- middle of right edge
	var start := curr_card.global_position
	start.x += PlayerHand.CARD_WIDTH / 2.0
	start.y += PlayerHand.CARD_HEIGHT / 2.0
	
	# Add in starting and middle points
	var target := get_local_mouse_position()
	var distance := target - start
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x  + (distance.x / ARC_POINTS) * i
		var y := start.y + (distance.y / ARC_POINTS) * i
		points.append(Vector2(x, y))
	
	# Add in the end point
	points.append(target)
	
	# Return
	return points


# Targeting starts
# Listen to targeting_start_signal
func _on_targeting_start(monster_card: MonsterCard) -> void:
	# Check whether monster card can attack this turn
	if not monster_card.attacked_this_turn:
		# Set targeting info
		PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.TARGETING
		curr_card = monster_card
		
		# Enable target selector
		area_2d.monitoring = true
		area_2d.monitorable = true


# Targeting ends
# Listen to left_mouse_button_released
func _on_targeting_end() -> void:
	# Try attack if has boss target
	if target_boss:
		print("Attack")
		curr_card.attacked_this_turn = true
		target_boss.boss_take_dmg(curr_card.get_attack())

	# Clear targeting info
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
	curr_card = null
	
	# Disable target selector
	aiming_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false


# Targeting canceled
# Listen to right_mouse_button_released
func _on_targeting_canceled() -> void:
	# Clear targeting info
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
	curr_card = null
	
	# Disable target selector
	aiming_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false


# Detect boss card entered and update boss target
func _on_area_2d_area_entered(area: Area2D) -> void:
	target_boss = area.get_parent()


# Detect boss card entered and update boss target
func _on_area_2d_area_exited(area: Area2D) -> void:
	target_boss = null
