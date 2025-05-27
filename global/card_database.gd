extends Node


# Level index to boss name
# Change order here to change level order
# eg. Level 1 has index of 0
const BOSS_LEVEL = {
	0: "Vacuum",
	1: "Vacuum"
}


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


# Stats for boss
const BOSS_STATS = {
	"Lightbulb": {"HP": 2, "Attack": 0, "CoolDown": 0}, # Tutorial Boss
	"Vacuum": {"HP": 12, "Attack": 3, "CoolDown": 3, "Block": 3, "Elimination": 10}
}


# Path to boss scenes
const VACUUM_SCENE_PATH = "res://bosses/first_level/vacuum.tscn"
const LIGHTBULB_SCENE_PATH = "res://bosses/tutorial_level/lightbulb.tscn"
const BOSS_PATH = {
	"Lightbulb": LIGHTBULB_SCENE_PATH,
	"Vacuum": VACUUM_SCENE_PATH
}



# Info for monster cards and bosses
# Display names
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

# Descriptions
const CHARACTER_DESCRIPTION = {
	"Trashcan"   : "The damned… ",                               # Monster Cards
	"Pizza"      : "A silent and deadly assassin. Don’t let his appearance fool you his pepperoni ninja stars and lethal pizza slaps will hurt more than any pizza cutter.",
	"Quesadilla" : "The life of the party. The quesadilla bard will never fail to raise the spirits of your modest party. Together with his trusty old guitar and maraca he’ll ensure your party’s safety.",
	"Cheesecake" : "The cheesecake cannoneer fuelled by his insatiable desire for sugar blasts his way through any amount of enemies. Anything walking in this brutes path will be drowned under dozens of frosting blasts ",
	"Sandwich"   : "A trusty and loyal servant. The sandwich knight born from the mighty magic pot will always come to your aid armed with his tomato buckler and his trusty breadstick blade.",
	"Taco"       : "The taco tank will guard you well with his trusty tortilla hammer. Stand behind him and don’t fret.",
	"Salad"      : "The salad cleric will drown your team in ranch blessings. Believe in his holy ranch power and he’ll ensure your party lives through any encounter.",
	"Sushi"      : "Sushi Samurai needs some more words",
	"Donut"      : "Stand down the doughnut machine gunner is here! He’ll mow down the enemies with a hailstorm of sprinkles get low or prepare to be caught in his path of destruction.",
	"Eclair"     : "The Eclair Knight charges into the frontlines with his trusty javelin and cracker horse! This legendary duo is sure to conquer any foe running them down and setting the tempo in any battle.",
	"Lightbulb"  : "Lightbulb needs some more words",              # Bosses
	"Vacuum"     : "Vacuum needs some more words",
	"Toaster"    : "The Burnt Apostle needs some more words",
	"Breadspawn" : "Breadspawn needs some more words",
	"Oven"       : "The Blazing Inferno needs some more words"
}

# Ability descriptions
const ABILITY_DESCRIPTION = {
	"Trashcan"   : ["Regular: Inflict damage equal to the attack power to one enemy"],               # Monster Cards
	"Pizza"      : ["Regular: Inflict damage equal to the attack power to one enemy",
					"Ability: Inflict 3 damage to one enemy (2 turns cool down)"],
	"Quesadilla" : ["Regular: Restore health equal to the attack power for one ally"],
	"Cheesecake" : ["Regular: Inflict damage equal to the attack power to one enemy"],
	"Sandwich"   : ["Regular: Inflict damage equal to the attack power to one enemy",
					"Ability: Self restore 1 health (1 turn cool down)"],
	"Taco"       : ["Regular: Inflict damage equal to the attack power to one enemy"],
	"Salad"      : ["Regular: Restore health equal to the attack power for one ally",
					"Ability: Restore 1 health for all allies (2 turns cool down)"],
	"Sushi"      : ["Regular: Restore health equal to the attack power for one ally"],
	"Donut"      : ["Regular: Inflict damage equal to the attack power to one enemy"],
	"Eclair"     : ["Regular: Inflict damage equal to the attack power to one enemy"],
	"Lightbulb"  : ["Regular: BRRRRRRRRRRR with no effect"],                                         # Bosses
	"Vacuum"     : ["Regular: Inflict damage equal to the attack power to one enemy",
					"Regular: Self restore 3 health",
					"Elimination!: Deal 10 damage to one enemy (3 turns cool down)"],
	"Toaster"    : ["Regular: Inflict damage equal to the attack power to one enemy"],
	"Breadspawn" : ["Regular: Inflict damage equal to the attack power to one enemy"],
	"Oven"       : ["Regular: Inflict damage equal to the attack power to one enemy"]
}
