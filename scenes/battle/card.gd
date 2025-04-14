class_name Card
extends Node2D

signal hovered
signal hovered_off

var starting_position
var placed := false
var attacked_this_turn := false

# Called when the node enters the scene tree for the first time.
func _ready():
	#All cards must be a child of CardMamager or this will error
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)


func selected_label_vis(flag: bool):
	$SelectedLabel.visible = flag


func get_attack() -> int:
	return int($Attack.text)


func get_health() -> int:
	return int($Health.text)


func set_health(new_health: int) -> void:
	$Health.text = str(new_health)
