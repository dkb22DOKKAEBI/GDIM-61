extends Node

# Description text parts
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
	self.visible = true


# Display info for boss
func display_boss_info(boss: Boss) -> void:
	self.visible = true


# End displaying info
func display_info_end() -> void:
	# Check whether the player is checking info
	if PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.CHECKING_INFO:
		# Update player status
		PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE		
		self.visible = false
