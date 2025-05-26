class_name Card
extends Node2D

signal hovered
signal hovered_off

var starting_position
var placed := false # Whether the card is placed inside the cardslot
var attacked_this_turn := false
var card_slot_on: Cardslot
var card_name: String

var is_monster_card: bool = false
var is_in_animation: bool = false
var is_highlighted: bool = false

@export var selected_label: Label 
@export var collision: CollisionObject2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#All cards must be a child of CardManager
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)


func set_card_z_index(index: int) -> void:
	self.z_index = index
	get_child(1).get_child(0).z_index = index


func selected_label_vis(flag: bool):
	selected_label.visible = flag


func set_pickable(flag: bool):
	collision.input_pickable = flag
