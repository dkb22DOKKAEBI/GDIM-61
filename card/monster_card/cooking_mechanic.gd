extends Node

const MONSTER_CARD_SCENE_PATH = "res://card/monster_card/monster_card.tscn"

var card_starting_position: Vector2 = Vector2(100, 525)
var recipe = []

@export var battle_manager: Node2D
@export var monster_card_manager: Node2D
@export var pot_ui: Control


# Cook to create new monster card
func _on_cook() -> void:
	# Check player monster hand size
	if PlayerHand.player_monster_hand.size() >= 4:
		return
	
	# Try cook to create monster
	if PlayerController.is_on_player_turn:
		if PlayerHand.selected_ingredients.size() == 0:
			return
		
		# Decide monster
		var result_monster = ingredient_check(get_ingredient_string_list(PlayerHand.selected_ingredients))
		if result_monster == "None":
			return
		
		# Instantiate and initialize monster card
		AudioManager.play_sound("COOKING")
		var card_scene = preload(MONSTER_CARD_SCENE_PATH)
		var new_card: Node2D = card_scene.instantiate()
		monster_card_manager.add_child(new_card)
		new_card.name = "MonsterCard"
		new_card.card_name = result_monster
		new_card.initialize_status()
		
		# Add to player hand
		new_card.position = card_starting_position
		PlayerHand.add_card_to_hand(new_card, 1, 1)
		
		# Clear used ingredients & update sidebar pot ui
		for card in PlayerHand.selected_ingredients:
			PlayerHand.remove_card_from_hand(card, 0)
			card.queue_free()
		PlayerHand.selected_ingredients.clear()
		
		PlayerHand.selected_ingredient_change_signal.emit()
		EventController.update_ingredient_num_indicator_signal.emit()
		EventController.update_monster_num_indicator_signal.emit()
		pot_ui.clear_after_cook()


func get_ingredient_string_list(list: Array) -> Array:
	var result: Array
	for card in PlayerHand.selected_ingredients:
		result.append(card.card_name)
	
	return result


# Get name of the food to cook
func ingredient_check(list: Array) -> String:
	var ingredients := []
	for i in list:
		ingredients.append(i)

	# Turn into sorted string for easier matching
	ingredients.sort()
	var key = ",".join(ingredients)
	
	match key:
		"Cheese,Dough,Sugar":
			return "Cheesecake"
		"Cheese,Dough,Tomato":
			return "Pizza"
		"Dough,Lettuce,Mystery_Meat,Tomato":
			return "Sandwich"
		"Cheese,Tortilla":
			return "Quesadilla"
		"Mystery_Meat,Tomato,Tortilla":
			return "Taco"
		"Lettuce,Tomato":
			return "Salad"
		"Chocolate,Dough,Sugar":
			return "Donut"
		"Chocolate,Dough,Sugar,Sugar":
			return "Eclair"
		"Grain,Mystery_Meat":
			return "Sushi"
		#"Chocolate,Tortilla":
			#return "Crepe"
		"Grain,Grain,Lettuce,Lettuce":
			return "Onigiri"
		"Cheese,Mystery_Meat":
			return "Charcuterie"
		_:
			var list_size = int(list.size())
			#print("Trashcan")
			if list_size >= 2:
				#print("Trashcan")
				return "Trashcan"
			else:
				return "None"


func update_cooking_result_check() -> void:
	if PlayerHand.selected_ingredients.size() == 0:
		return
	
	var result_monster = ingredient_check(get_ingredient_string_list(PlayerHand.selected_ingredients))
