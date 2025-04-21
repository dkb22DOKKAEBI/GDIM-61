extends Node

const MONSTER_CARD_SCENE_PATH = "res://scenes/card/monster_card/card.tscn"

var card_database_reference
var recipe = []
var selected_ingredients: Array


func _ready():
	card_database_reference = preload("res://scenes/card/CardDatabase.gd")


func update_selected_ingredients(card: IngredientCard) -> void:
	if selected_ingredients.has(card):
		selected_ingredients.erase(card)
	else:
		selected_ingredients.append(card)


func _on_cook() -> void:
	# Decide monster
	var result_monster = ingredient_check(get_ingredient_string_list(selected_ingredients))
	
	# Instantiate monster
	var card_scene = preload(MONSTER_CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://cards/" + result_monster + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[result_monster][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[result_monster][1])
	$"../MonsterCardManager".add_child(new_card)
	new_card.name = "MonsterCard"
	$"../Player/PlayerHand".add_card_to_hand(new_card, 1, 1)
	
	# Clear used ingredients


func get_ingredient_string_list(list: Array) -> Array:
	var result: Array
	for card in selected_ingredients:
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
			if list.has("Ham"):
				return "Quesadilla"
	
	return "Trashcan"
