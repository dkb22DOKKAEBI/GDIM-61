extends Node

var recipe = []
var selected_ingredients: Array


func update_selected_ingredients(card: IngredientCard) -> void:
	if selected_ingredients.has(card):
		selected_ingredients.erase(card)
	else:
		selected_ingredients.append(card)


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
	
	return "Trash"
