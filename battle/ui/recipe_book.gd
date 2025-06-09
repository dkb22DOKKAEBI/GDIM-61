extends Control

@export var recipe_book_visible: MarginContainer
@export var background: ColorRect

# Card Information
@export var card_content: MarginContainer
@export var character_image: TextureRect
@export var character_name_text: RichTextLabel
@export var character_attack_text: RichTextLabel
@export var character_health_text: RichTextLabel
@export var character_ability_texts: Array[RichTextLabel]
@export var character_description_text: RichTextLabel


# Ready
func _ready() -> void:
	recipe_book_visible.visible = false
	EventController.connect("recipe_display_card_info_signal", on_display_recipe_card_info)


# Attached to Recipe button in battle scene
# Open recipe book
func _on_recipe_book_button_pressed() -> void:
	AudioManager.play_sound("CLICK")
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.CHECKING_INFO
	recipe_book_visible.visible = true
	background.visible = true


# Attached to Exit button in recipe book
# Exit recipe book
func _on_exit_book_pressed() -> void:
	AudioManager.play_sound("CLICK")
	PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
	recipe_book_visible.visible = false
	background.visible = false


# Display card info inside the recipe book
func on_display_recipe_card_info(monster_name: String) -> void:
	# Display info
	character_image.texture = ResourceLoader.load("res://art/card_images/monsters/" + monster_name + ".png")
	character_name_text.text = CardDatabase.DISPLAY_NAME[monster_name]
	character_attack_text.text = str(CardDatabase.CARDS[monster_name][0])
	character_health_text.text = str(CardDatabase.CARDS[monster_name][1])
	for i in range(CardDatabase.ABILITY_DESCRIPTION[monster_name].size()): # Set up descriptions for abilites
		character_ability_texts[i].text = CardDatabase.ABILITY_DESCRIPTION[monster_name][i]
	for i in range(3 - CardDatabase.ABILITY_DESCRIPTION[monster_name].size()): # Clear all ability descriptions for additional slots
		character_ability_texts[2 - i].text = ""
	character_description_text.text = CardDatabase.CHARACTER_DESCRIPTION[monster_name]
	
	# Set content visibility
	card_content.visible = true


# Attached to Back button in recipe card info page
# Return back to the recipe book main page
func _on_exit_recipe_info() -> void:
	# Reset info
	character_image.texture = null
	character_name_text.text = ""
	character_attack_text.text = ""
	character_health_text.text = ""
	for i in range(3): # Set up descriptions for abilites
		character_ability_texts[i].text = ""
	character_description_text.text = ""
	
	# Set content visibility
	card_content.visible = false
