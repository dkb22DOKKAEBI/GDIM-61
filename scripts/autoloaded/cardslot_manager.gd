extends Node

var cardslots: Array[Cardslot]
var cardslot_abilities = {"cardslot1": ["name",0], "cardslot2": ["name",0], "cardslot3": ["name",0]}
var card_ability_cds = {
	"Pizza": 2,
	"Cheesecake": 0,
	"Sandwich": 2,
	"Quesadilla": 2,
	"Salad": 2,
	"Taco": 0,
	"Trashcan": 0}


# Connect signals
func _ready() -> void:
	SceneManager.connect("player_complete_level_signal", clear_cardslots)
	SceneManager.connect("game_end_signal", clear_cardslots)


# Clear cardslots array when player completing a level
func clear_cardslots() -> void:
	cardslots.clear()


func test():
	for cardslot in cardslots:
		var slot_id = cardslot.card_slot_number

		if cardslot.card_in_slot:
			var current_name = cardslot_abilities[slot_id][0]
			var new_name = cardslot.card_in_slot.card_name

			if current_name != new_name:
				# Only update if the card changed
				cardslot_abilities[slot_id][0] = new_name
				cardslot_abilities[slot_id][1] = card_ability_cds.get(new_name, 0)  # fallback to 0 if not found
		else:
			cardslot_abilities[slot_id][0] = "None"
			cardslot_abilities[slot_id][1] = 0
	#print(cardslot_abilities)
	#print("-------------------------------")
