extends Node

@export var card_info_text: RichTextLabel
@export var pot_text: RichTextLabel
var default_card_info_text = ""

func update_card_info(food_name: String):
	card_info_text.text = food_name


func update_pot(food_nmae: String):
	pot_text.text = food_nmae
