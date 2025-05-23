class_name Cardslot
extends Node2D

const CARDSLOT_MANAGER_PATH = "res://scripts/cardslot_manager.gd"
var card_in_slot: Card = null
@export var card_slot_number : String

func _ready():
	CardslotManager.cardslots.append(self)
