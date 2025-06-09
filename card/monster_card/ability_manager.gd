extends Node
class_name Ability

@export var cap_ability :bool
@export var monster_name : String
@export var enemy: Node2D



var cardslot_manager: Node
var waiting_for_heal_target: bool = false
var heal_source_card: Node2D
var heal_amount: int


#the dictionary will be "monster name": [do they have an ability, what type]
var monster_abilities = {
	"Pizza"			: [true, "damage"],
	"Cheesecake"	: [false],
	"Sandwich"		: [true, "block"],
	"Quesadilla"	: [true, "heal"],
	"Salad"			: [true, "heal"],
	"Taco"			: [false],
	"Trashcan"		: [false],
	"Donut"			: [false],
	"Eclair"		: [false],
	"Sushi"			: [false],
	"Crepe"			: [false],
	"Onigiri"		: [true, "block"],
	"Charcuterie"	: [false]
	}



func add_ability_card(monster_name, card):
	if not monster_abilities.has(monster_name):
		return null  # monster isn't even in the table

	if monster_abilities[monster_name][0] == false:
		return null  # monster has no ability, exit early

	var ability_type = monster_abilities[monster_name][1]

	match ability_type:
		"damage":
			return check_damage_ability(monster_name)
		"block":
			return check_block_ability(monster_name, card)
		"heal":
			return check_heal_ability(monster_name, card)
		_:
			return null  # unknown ability type


func check_damage_ability(name):
	match name:
		"Pizza":
			if enemy and enemy.get_child_count() > 0:
				var actual_boss = enemy.get_child(0)
				if actual_boss.has_method("boss_take_dmg"):
					actual_boss.boss_take_dmg(3)
				else:
					print("Boss child exists but is missing boss_take_dmg()")
			else:
				print("Enemy is null or has no children")

func check_heal_ability(name: String, card: Node2D):
	match name:
		"Quesadilla":
			return apply_heal_all(2, name)
		"Salad":
			return apply_heal_all(1, name)

func check_block_ability(name, card: Node2D):
	match name:
		"Sandwich":
			return apply_self_heal(card, 1, name)
		"Onigiri":
			return apply_self_heal(card, 1, name)


func apply_self_heal(card: MonsterCard, amount: int, monster_name: String):
	if not card or not card.has_method("heal"):
		push_error("Invalid card or card does not support healing")
		return
	
	var was_full = card.curr_health >= card.max_health
	card.heal(amount)
	
	if was_full:
		print(monster_name + " is already at full health")
	else:
		print(monster_name + " healed for " + str(amount))

func apply_heal_all(amount: int, monster_name):
	var healed_cards = []

	for slot in cardslot_manager.cardslots:
		if slot.card_in_slot != null:
			var card = slot.card_in_slot
			card.heal(amount)
			healed_cards.append(monster_name)

	return ["HealedAll", healed_cards]

func handle_target_selection(target_card: Node2D):
	if not waiting_for_heal_target:
		return
	
	waiting_for_heal_target = false
	heal_source_card = null

	if target_card == null or not target_card.has_method("heal"):
		print("Invalid target for healing")
		return
	print("Handling target selection for monster")
	target_card.heal(heal_amount)
	print("Healed monster for", heal_amount)


func heal_target(card: Node2D, amount: int ):
	waiting_for_heal_target = true
	heal_source_card = card
	heal_amount = amount
	print("Waiting to heal a target with", amount)
	return ["HealTarget"]

func set_cardslot_manager(manager: Node):
	cardslot_manager = manager
