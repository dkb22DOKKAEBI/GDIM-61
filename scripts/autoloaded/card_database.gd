extends Node

# Stats for monster cards
const CARDS = { #attack, health
	"Quesadilla" 	: [2, 3],
	"Cheesecake" 	: [3, 4],
	"Sandwich"	 	: [4, 5],
	"Trashcan"		: [0, 3],
	"Pizza"			: [1, 2],
	"Salad"			: [1, 1],
	"Taco"			: [1, 6],
	"Bunuelos"		: [0, 4]
}


# Level index to boss name
# Change order here to change level order
# eg. Level 1 has index of 0
const BOSS_LEVEL = {
	0: "Vacuum",
	1: "Vacuum"
}


# Path to boss scenes
const VACUUM_SCENE_PATH = "res://scenes/boss/vacuum.tscn"
const LIGHTBULB_SCENE_PATH = "res://scenes/boss/lightbulb.tscn"
const BOSS_PATH = {
	"Lightbulb": LIGHTBULB_SCENE_PATH,
	"Vacuum": VACUUM_SCENE_PATH
}


# Stats for boss
const BOSS_STATS = {
	"Lightbulb": {"HP": 2, "Attack": 0, "CoolDown": 0}, # Tutorial Boss
	"Vacuum": {"HP": 12, "Attack": 3, "CoolDown": 3, "Block": 3, "Elimination": 10}
}
