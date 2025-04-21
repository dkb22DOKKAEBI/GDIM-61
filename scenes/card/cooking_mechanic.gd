extends Node

const MONSTER_CARD_SCENE_PATH = "res://scenes/card/monster_card/card.tscn"

var card_database_reference
var recipe = []


func _ready():
	card_database_reference = preload("res://scenes/card/CardDatabase.gd")


func _on_cook() -> void:
	if PlayerHand.selected_ingredients.size() == 0:
		return
	
	# Decide monster
	var result_monster = ingredient_check(get_ingredient_string_list(PlayerHand.selected_ingredients))
	
	# Instantiate monster
	var card_scene = preload(MONSTER_CARD_SCENE_PATH)
	var new_card: Node2D = card_scene.instantiate()
	var card_image_path = str("res://Cards/" + result_monster + ".png")
	#new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("CardImage").texture = ResourceLoader.load(card_image_path)
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[result_monster][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[result_monster][1])
	$"../MonsterCardManager".add_child(new_card)
	new_card.name = "MonsterCard"
	$"../Player/PlayerHand".add_card_to_hand(new_card, 1, 1)
	
	# Clear used ingredients
	for card in PlayerHand.selected_ingredients:
		$"../Player/PlayerHand".remove_card_from_hand(card, 0)
		card.queue_free()
	PlayerHand.selected_ingredients.clear()


func get_ingredient_string_list(list: Array) -> Array:
	var result: Array
	for card in PlayerHand.selected_ingredients:
		result.append(card.ingredient_name)
	
	return result


# Get name of the food to cook
func ingredient_check(list: Array) -> String:
	if list.has("Dough"):
		if list.has("Cheese"):
			if list.has("Sugar"):
				return "Cheesecake"
			elif list.has("Tomato"):
				return "Pizza"
	elif list.has("Tomato"):
		if list.has("Ham"):
			return "Sandwich"
	elif list.has("Tortilla"):
		if list.has("Cheese"):
			return "Quesadilla"
	
	return "Trashcan"
