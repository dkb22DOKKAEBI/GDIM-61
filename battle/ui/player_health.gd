class_name PlayerHealth
extends Node

@export var player_health_bar: Panel
@export var player_health_text: RichTextLabel


# Ready
func _ready() -> void:
	EventController.connect("update_player_health_signal", update_player_health)


# Update the player health UI
func update_player_health(health: int):
	player_health_bar.scale = Vector2(float(health) / PlayerController.STARTING_HEALTH, 1)
	player_health_text.text = str(health)
