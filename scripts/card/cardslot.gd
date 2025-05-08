class_name Cardslot
extends Node2D

var card_in_slot: Card = null


func _ready():
	CardslotManager.cardslots.append(self)
