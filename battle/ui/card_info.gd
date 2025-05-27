extends Node


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


func display_info_end() -> void:
	if PlayerController.curr_player_status == PlayerController.PLAYER_STATUS.CHECKING_INFO:
		PlayerController.curr_player_status = PlayerController.PLAYER_STATUS.IDLE
		self.visible = false
