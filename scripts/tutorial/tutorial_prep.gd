extends Node

const TUTORIAL_DECK: Array[String] = ["Tomato", "Dough", "Cheese", "Lettuce",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Tortilla", "Dough"]

@export var cooking_mechanics: Node2D # Reference to cooking mechanics
@export var task_text: RichTextLabel # Reference to task text

@export var curr_message: TutorialMessage # Current tutorial message
var pizza: MonsterCard = null
var pizza_placed: bool = false

@export var cook_button: Button # Buttons
@export var recipe_button: Button
@export var end_turn_button: Button


# Ready
func _ready():
	# Connect signals
	EventController.connect("preceed_tutorial_signal", update_curr_message)
	EventController.connect("start_cook_tutorial_signal", start_cook_tutorial)
	EventController.connect("finish_cook_tutorial_signal", finish_cook_tutorial)
	EventController.connect("finish_place_monster_signal", finish_place_monster)
	
	# Update player setup for tutorial
	PlayerHand.legacy_monster_hand.clear()
	PlayerController.deck = TUTORIAL_DECK.duplicate()
	
	# Disable buttons
	cook_button.disabled = true
	recipe_button.disabled = true
	end_turn_button.disabled = true


func _process(delta: float) -> void:
	if not pizza_placed and pizza:
		if pizza.placed:
			pizza_placed = true
			EventController.finish_place_monster_signal.emit()


# Update current tutorial message
func update_curr_message(next_message: TutorialMessage):
	curr_message = next_message


# Cooking tutorial
func start_cook_tutorial(text: String) -> void:
	task_text.visible = true
	task_text.text = text
	
	cook_button.disabled = false
	recipe_button.disabled = false

func finish_cook_tutorial() -> void:
	task_text.visible = false
	task_text.text = ""
	curr_message.activate_self()


# Placing Mosnter tutorial
func finish_place_monster() -> void:
	task_text.visible = false
	task_text.text = ""
	
	end_turn_button.disabled = false
	#curr_message.activate_self()


# Tutorial "overriden" functions
func tutorial_on_cook() -> void:
	if PlayerHand.selected_ingredients.size() == 0:
		return
		
	# Decide monster
	var result_monster = cooking_mechanics.ingredient_check(cooking_mechanics.get_ingredient_string_list(PlayerHand.selected_ingredients))
	if result_monster != "Pizza":
		return
	
	cooking_mechanics._on_cook()
	EventController.finish_cook_tutorial_signal.emit()
