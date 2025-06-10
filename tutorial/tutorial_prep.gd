extends Node

const TUTORIAL_DECK: Array[String] = ["Tomato", "Dough", "Cheese", "Tortilla",
"Tomato", "Sugar", "Mystery_Meat", "Lettuce", "Cheese", "Dough"]

@export var task_text: RichTextLabel # Reference to task text
@export var curr_message: TutorialMessage # Current tutorial message

var cooking_mechanics: Node2D # Reference to cooking mechanics
var battle_manager: Node2D
var cook_button: Button # Buttons
var recipe_button: Button
var end_turn_button: Button

var cooked: bool = false
var pizza: MonsterCard = null
var pizza_placed: bool = false
var end_turn_pressed: bool = false



# Ready
func _ready():
	# Initialize
	cooking_mechanics = get_parent().find_child("CookingMechanic")
	battle_manager = get_parent().find_child("BattleManager")
	cook_button = get_parent().find_child("CookButton")
	recipe_button = get_parent().find_child("RecipeButton")
	end_turn_button = get_parent().find_child("EndTurnButton")
	
	# Connect signals
	EventController.connect("preceed_tutorial_signal", update_curr_message)
	EventController.connect("start_cook_tutorial_signal", start_cook_tutorial)
	EventController.connect("finish_cook_tutorial_signal", finish_cook_tutorial)
	EventController.connect("start_place_monster_tutorial_signal", start_place_monster_tutorial)
	EventController.connect("finish_place_monster_tutorial_signal", finish_place_monster_tutorial)
	EventController.connect("start_defeat_boss_tutorial_signal",start_defeat_boss_tutorial)
	EventController.connect("finish_defeat_boss_tutorial_signal",finish_defeat_boss_tutorial)
	EventController.connect("player_turn_end_signal", start_end_turn_tutorial)
	
	# Update player setup for tutorial
	PlayerHand.legacy_monster_hand.clear()
	PlayerController.deck = TUTORIAL_DECK.duplicate()
	PlayerController.is_on_tutorial = true
	
	# Disable buttons
	cook_button.disabled = true
	recipe_button.disabled = true
	end_turn_button.disabled = true


func _process(delta: float) -> void:
	if not pizza_placed and pizza:
		if pizza.placed:
			pizza_placed = true
			EventController.finish_place_monster_tutorial_signal.emit()


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


# Placing mosnter tutorial
func start_place_monster_tutorial(text: String) -> void:
	task_text.visible = true
	task_text.text = text

func finish_place_monster_tutorial() -> void:
	task_text.visible = false
	task_text.text = ""
	
	curr_message.activate_self()


# Defeat boss tutorial
func start_defeat_boss_tutorial(text: String) -> void:
	task_text.visible = true
	task_text.text = text
	
	end_turn_button.connect("pressed", battle_manager._on_end_turn_button_pressed)

func finish_defeat_boss_tutorial() -> void:
	PlayerController.is_on_tutorial = false
	curr_message.activate_self()


# End turn tutorial
func start_end_turn_tutorial() -> void:
	if not end_turn_pressed:
		end_turn_pressed = true
		curr_message.activate_self()


# Return to the start menu
func back_to_start_menu() -> void:
	get_tree().paused = false
	SceneManager.back_to_start_menu()


# Tutorial "overriden" functions
func tutorial_on_cook() -> void:
	if not cooked:
		if PlayerHand.selected_ingredients.size() == 0:
			return
			
		# Decide monster
		var result_monster = cooking_mechanics.ingredient_check(cooking_mechanics.get_ingredient_string_list(PlayerHand.selected_ingredients))
		if result_monster != "Pizza":
			return
		
		cooked = true
		cooking_mechanics._on_cook()
		pizza = PlayerHand.player_monster_hand[0]
		await get_tree().create_timer(1).timeout
		EventController.finish_cook_tutorial_signal.emit()
	else:
		cooking_mechanics._on_cook()
