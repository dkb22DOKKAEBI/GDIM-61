extends Node

# Description text parts
@export var character_image: Sprite2D
@export var character_name_text: RichTextLabel
@export var character_attack_text: RichTextLabel
@export var character_health_text: RichTextLabel
@export var character_ability_texts: Array[RichTextLabel] # Of size 3
@export var character_description_text: RichTextLabel


# Ready
func _ready() -> void:
	# Connect signals
	EventController.connect("display_monster_card_info_signal", display_monster_card_info)
	EventController.connect("display_boss_info_signal", display_boss_info)
	EventController.connect("right_mouse_button_released", display_info_end)


# Display info for monster card
func display_monster_card_info(monster_card: MonsterCard) -> void:
	# Set up info
	var monster_name := monster_card.card_name
	character_image.texture = ResourceLoader.load("res://art/card_images/monsters/" + monster_name + ".png")
	character_name_text.text = CardDatabase.DISPLAY_NAME[monster_name]
	character_attack_text.text = str(monster_card.attack_power)
	character_health_text.text = str(monster_card.max_health)
	for i in range(CardDatabase.ABILITY_DESCRIPTION[monster_name].size()): # Set up descriptions for abilites
		character_ability_texts[i].text = CardDatabase.ABILITY_DESCRIPTION[monster_name][i]
	for i in range(3 - CardDatabase.ABILITY_DESCRIPTION[monster_name].size()): # Clear all ability descriptions for additional slots
		character_ability_texts[2 - i].text = ""
	character_description_text.text = CardDatabase.CHARACTER_DESCRIPTION[monster_name]
	
	self.visible = true


# Display info for boss
func display_boss_info(boss: Boss) -> void:
	# Set up info
	var boss_name := boss.boss_name
	character_image.texture = ResourceLoader.load("res://art/card_images/monsters/" + boss_name + "_boss.png")
	character_name_text.text = CardDatabase.DISPLAY_NAME[boss_name]
	character_attack_text.text = str(boss.boss_attack)
	character_health_text.text = str(boss.boss_max_health)
	for i in range(CardDatabase.ABILITY_DESCRIPTION[boss_name].size()): # Set up descriptions for abilites
		character_ability_texts[i].text = CardDatabase.ABILITY_DESCRIPTION[boss_name][i]
	for i in range(3 - CardDatabase.ABILITY_DESCRIPTION[boss_name].size()): # Clear all ability descriptions for additional slots
		character_ability_texts[2 - i].text = ""
	character_description_text.text = CardDatabase.CHARACTER_DESCRIPTION[boss_name]
	
	self.visible = true


# End displaying info
func display_info_end() -> void:
	# Check whether the player is checking info
	if PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.CHECKING_INFO:
		# Update player status
		PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE		
		self.visible = false
