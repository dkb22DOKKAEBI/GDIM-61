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
	"Bunuelos"		: [0, 4],
	"Donut"			: [3, 1],
	"Eclair"		: [5, 2],
}


# Level index to boss name
# Change order here to change level order
# eg. Level 1 has index of 0
const BOSS_LEVEL = {
	0: "Vacuum",
	1: "Vacuum"
}


# Path to boss scenes
const VACUUM_SCENE_PATH = "res://bosses/first_level/vacuum.tscn"
const LIGHTBULB_SCENE_PATH = "res://bosses/tutorial_level/lightbulb.tscn"
const BOSS_PATH = {
	"Lightbulb": LIGHTBULB_SCENE_PATH,
	"Vacuum": VACUUM_SCENE_PATH
}


# Stats for boss
const BOSS_STATS = {
	"Lightbulb": {"HP": 2, "Attack": 0, "CoolDown": 0}, # Tutorial Boss
	"Vacuum": {"HP": 12, "Attack": 3, "CoolDown": 3, "Block": 3, "Elimination": 10}
}



# Info for monster cards and bosses
const DISPLAY_NAME = {
	"Trashcan"   : "Trashcan",               # Monster Cards
	"Pizza"      : "Pizza Ninja",
	"Quesadilla" : "Quesadilla Bard",
	"Cheesecake" : "Cheesecake Cannoneer",
	"Sandwich"   : "Sandwich Knight",
	"Taco"       : "Taco Tank",
	"Salad"      : "Salad Cleric",
	"Sushi"      : "Sushi Samurai",
	"Donut"      : "Doughnut Machine Gunner",
	"Eclair"     : "Eclair Knight",
	"Lightbulb"  : "Lightbulb",              # Bosses
	"Vacuum"     : "Vacuum",
	"Toaster"    : "The Burnt Apostle",
	"Breadspawn" : "Breadspawn",
	"Oven"       : "The Blazing Inferno"
}
