extends Node


var recipe = []

func ingredient_check(list: Array):
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
