extends Node
class_name Ability

@export var cap_ability :bool
@export var monster_name : String

#the dictionary will be "monster name": [do they have an ability, what type]
var monster_abilities = {
	"Pizza":[true, "damage"],
	"Cheesecake": [false],
	"Sandwich": [false, "block"],
	"Quesadilla": [false, "heal"],
	"Salad": [false, "heal"],
	"Taco": [false],
	"Trashcan": [false]
	}



func add_ability_card(monster_name):
	if not monster_abilities.has(monster_name):
		return null  # monster isn't even in the table

	if monster_abilities[monster_name][0] == false:
		return null  # monster has no ability, exit early

	var ability_type = monster_abilities[monster_name][1]

	match ability_type:
		"damage":
			return check_damage_ability(monster_name)
		"block":
			return check_block_ability(monster_name)
		"heal":
			return check_heal_ability(monster_name)
		_:
			return null  # unknown ability type


func check_damage_ability(name):
	match name:
		"Pizza":
			return ["Attack", 3]

func check_heal_ability(name):
	match name:
		"Quesadilla":
			return ["Heal", 2]
		"Salad":
			return ["Heal", 1]

func check_block_ability(name):
	match name:
		"Sandwich":
			return ["Block", 1]
