extends Node

var cardslots: Array[Cardslot]


func test():
	for cardslot in cardslots:
		if cardslot.card_in_slot:
			print(cardslot.card_in_slot.card_name)
	print("-------------------------------")
