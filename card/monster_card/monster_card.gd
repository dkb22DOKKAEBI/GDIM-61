class_name MonsterCard
extends Card

@export var ability_button: Button
@onready var battle_manager = get_node("/root/NewBattle")
@onready var cardslot_manager = get_node("/root/CardslotManager")
@onready var ability_handler = preload("res://card/monster_card/ability_manager.gd").new()  # assuming the path is correct
@onready var boss_node = get_node("/root/NewBattle/BattleField/Enemy")  # or whatever path to the boss

@export var attack_text: RichTextLabel
@export var health_text: RichTextLabel
@export var card_image: Sprite2D

# Monster card info
var max_health: int
var curr_health: int
var attack_power: int
var placed := false # Whether is placed onto the battlefield


# Ready
func _ready() -> void:
	super._ready()
	is_monster_card = true
	ability_button.connect("pressed", Callable(self, "_on_ability_button_pressed"))
	
	# Set up ability
	ability_handler = preload("res://card/monster_card/ability_manager.gd").new()
	ability_handler.set_cardslot_manager(cardslot_manager)
	
	ability_button.disabled = true # start disabled if needed
	ability_button.hide()
	ability_button.z_index = 10  # Higher than any sprites or labels


# Initialize the monster card
func initialize_status() -> void:
	# Initialize status
	attack_power = CardDatabase.CARDS[card_name][0]
	max_health = CardDatabase.CARDS[card_name][1]
	curr_health = max_health
	card_image.texture = ResourceLoader.load("res://art/card_images/monsters/" + card_name + ".png")
	
	# Update text
	attack_text.text = str(attack_power)
	health_text.text = str(curr_health)


func update_ability_button():
	if placed:
		ability_button.show()
		ability_button.disabled = false  # allow pressing
	else:
		ability_button.hide()
		ability_button.disabled = true  # prevent pressing just in case


func _on_ability_button_pressed():
	if card_slot_on == null:
		#print("Error: Monster card is not placed in a slot.")
		return

	var slot_id = card_slot_on.card_slot_number
	var card_info = cardslot_manager.cardslot_abilities[slot_id]
	var card_name_from_slot = card_info[0]

	#print("Ability activated for", card_name_from_slot, "in", slot_id)

	# Configure the Ability instance
	ability_handler.enemy = boss_node
	var result = ability_handler.add_ability_card(card_name_from_slot, self)

	#if result == null:
		#print("No ability or ability not implemented.")
	#else:
		#print("Ability result:", result)

	# Reset cooldown
	cardslot_manager.cardslot_abilities[slot_id][1] = cardslot_manager.card_ability_cds.get(card_name_from_slot, 0)

	# Disable button after use
	ability_button.disabled = true
	ability_button.hide()


# Getters for attack power and current health
func get_attack() -> int:
	return attack_power

func get_health() -> int:
	return curr_health


# Monster card being attacked
func take_damage(dmg: int) -> void:
	var new_health = max(0, get_health() - dmg)
	if (new_health == 0):
		die()
	health_text.text = str(new_health)
	health_change_animation(Color.RED)


# Monster card being healed
func heal(amount: int) -> void:
	var current_health = get_health()
	if current_health >= max_health:
		return

	var new_health = min(current_health + amount, max_health)
	health_text.text = str(new_health)
	health_change_animation(Color.GREEN)


# Animation for health change animation as damage indicator
func health_change_animation(target_color: Color) -> void:
	health_text.add_theme_font_size_override("normal_font_size", 70)
	health_text.modulate = target_color
	
	var tween = get_tree().create_tween()
	tween.tween_property(health_text, "theme_override_font_sizes/normal_font_size", 50, 1)
	tween.tween_property(health_text, "modulate", Color.BLACK, 1)


# Monster card dies
func die():
	card_slot_on.card_in_slot = null
	queue_free()


# Override for hight functionality
func _on_area_2d_mouse_entered():
	if not placed:
		emit_signal("hovered", self)

func _on_area_2d_mouse_exited():
	if not placed:
		emit_signal("hovered_off", self)
