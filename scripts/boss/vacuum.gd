class_name Vacuum
extends Boss

var boss_block: float
var boss_elimination: float


# Initialization of boss stats
func _ready():
	boss_health = CardDatabase.BOSS_STATS["Vacuum"]["HP"]
	boss_attack = CardDatabase.BOSS_TATSS["Vacuum"]["Attack"]
	boss_block = CardDatabase.BOSS_STATS["Vacuum"]["Block"]
	boss_elimination = CardDatabase.BOSS_STATS["Vacuum"]["Elimination"]


# Boss behavior logic
func on_action() -> void:
	pass
