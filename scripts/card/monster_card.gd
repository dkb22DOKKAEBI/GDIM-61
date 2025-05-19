class_name MonsterCard
extends Card

@onready var ability_button: Button = $UIContainer/AbilityButton
@onready var battle_manager = get_node("/root/NewBattle")
@onready var cardslot_manager = get_node("/root/CardslotManager")
@onready var ability_handler = preload("res://scripts/ability_manager.gd").new()  # assuming the path is correct
@onready var boss_node = get_node("/root/NewBattle/BattleField/Enemy")  # or whatever path to the boss


func _ready() -> void:
	super._ready()
	is_monster_card = true
	ability_button.connect("pressed", Callable(self, "_on_ability_button_pressed"))
	
	# Get card name from the image file name
	var texture_path = $CardImage.texture.resource_path
	card_name = texture_path.get_file().get_basename()
	print("Loaded card name:", card_name)
	
	ability_button.disabled = true # start disabled if needed
	ability_button.hide()
	ability_button.z_index = 10  # Higher than any sprites or labels

func update_ability_button():
	if placed:
		ability_button.show()
		ability_button.disabled = false  # allow pressing
	else:
		ability_button.hide()
		ability_button.disabled = true  # prevent pressing just in case

func _on_ability_button_pressed():
	if card_slot_on == null:
		print("Error: Monster card is not placed in a slot.")
		return

	var slot_id = card_slot_on.card_slot_number
	var card_info = cardslot_manager.cardslot_abilities[slot_id]
	var card_name_from_slot = card_info[0]

	print("Ability activated for", card_name_from_slot, "in", slot_id)

	# Configure the Ability instance
	ability_handler.enemy = boss_node
	var result = ability_handler.add_ability_card(card_name_from_slot)

	if result == null:
		print("No ability or ability not implemented.")
	else:
		print("Ability result:", result)

	# Reset cooldown
	cardslot_manager.cardslot_abilities[slot_id][1] = cardslot_manager.card_ability_cds.get(card_name_from_slot, 0)

	# Disable button after use
	ability_button.disabled = true
	ability_button.hide()

func get_label_vis() -> bool:
	return selected_label.visible


func get_attack() -> int:
	return int($Attack.text)


func get_health() -> int:
	return int($Health.text)


func take_damage(dmg: int) -> void:
	var new_health = max(0, get_health() - dmg)
	if (new_health == 0):
		die()
	$Health.text = str(new_health)
	
	# Change font to double size and red
	$Health.add_theme_font_size_override("normal_font_size", 40)
	$Health.modulate = Color.RED
	
	# Play animation for health change
	var tween = get_tree().create_tween()
	tween.tween_property($Health, "theme_override_font_sizes/normal_font_size", 16, 1)
	tween.tween_property($Health, "modulate", Color.BLACK, 1)


func die():
	card_slot_on.card_in_slot = null
	queue_free()


func test():
	pass
