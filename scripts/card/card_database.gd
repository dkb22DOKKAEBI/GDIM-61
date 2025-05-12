extends Node

# Stats for monster cards
const CARDS = { #attack, health
	"Quesadilla" 	: [2, 3],
	"Cheesecake" 	: [3, 4],
	"Sandwich"	 	: [4, 5],
	"Trashcan"		: [0, 3],
	"Pizza"			: [3, 2],
	"Salad"			: [1, 1],
	"Taco"			: [1, 6],
	"Bunuelos"		: [0, 4]
}


# Level index to boss name
# Change order here to change level order
# eg. Level 1 has index of 0
const VACUUM_NAME = "Vacuum"
const BOSS_INDEX = {
	0: VACUUM_NAME
}


# Path to boss scenes
const VACUUM_SCENE_PATH = "res://scenes/boss/vacuum.tscn"
const BOSS_PATH = {
	"Vacuum": VACUUM_SCENE_PATH
}


# Stats for boss
const BOSS_STATS = {
	"Vacuum": {"HP": 20, "Attack": 3, "CoolDown": 3, "Block": 3, "Elimination": 10}
}
