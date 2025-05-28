extends Node


# Level index to boss name
# Change order here to change level order
# eg. Level 1 has index of 0
const BOSS_LEVEL = {
	0: "Toaster",
	1: "Oven",
	2: "Vacuum"
}


# Stats for monster cards
const CARDS = { #attack, health
	"Quesadilla" 	: [2, 3],
	"Cheesecake" 	: [3, 4],
	"Sandwich"	 	: [4, 5],
	"Trashcan"		: [0, 3],
	"Pizza"			: [1, 2],
	"Salad"			: [1, 5],
	"Taco"			: [1, 6],
	"Bunuelos"		: [0, 4],
	"Donut"			: [3, 1],
	"Eclair"		: [5, 2],
}


# Stats for boss
const BOSS_STATS = {

	"Tutorial": {"HP": 2, "Attack": 0, "CoolDown": 0}, # Tutorial Boss
	"Vacuum": {"HP": 12, "Attack": 3, "CoolDown": 3, "Block": 3, "Elimination": 10},
	"Oven": {"HP": 999, "Attack": 999, "CoolDown": 3, "Self_dmg": 200},
	"Toaster": {"HP": 20, "Attack": 2, "CoolDown": 3, "SpawnCoolDown": 4},
	"Breadspawn": {"HP": 5, "Attack": 1, "CoolDown": 0},
}


# Path to boss scenes
const TUTORIAL_SCENE_PATH = "res://bosses/tutorial_level/tutorial_boss.tscn"
const VACUUM_SCENE_PATH = "res://bosses/vacuum/vacuum_boss.tscn"
const OVEN_SCENE_PATH = "res://bosses/oven/oven_boss.tscn"
const TOASTER_SCENE_PATH = "res://bosses/toaster/toaster_boss.tscn"
const BREADSPAWN_SCENE_PATH = "res://bosses/toaster/breadspawn_boss.tscn"
const BOSS_PATH = {
	"Tutorial"   : TUTORIAL_SCENE_PATH,
	"Vacuum"     : VACUUM_SCENE_PATH,
	"Oven"       : OVEN_SCENE_PATH,
	"Toaster"    : TOASTER_SCENE_PATH,
	"Breadspawn" : BREADSPAWN_SCENE_PATH
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
	"Tutorial"   : "Tutorial Boss",              # Bosses
	"Vacuum"     : "Vacuum Boss",
	"Toaster"    : "The Burnt Apostle",
	"Breadspawn" : "Breadspawn Zombie",
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
	"Tutorial"   : "Tutorial boss needs some more words",              # Bosses
	"Vacuum"     : "Steer clear! The Insatiable Hunger is here ready to consume all in its path!",
	"Toaster"    : "The Burnt Apostle needs some more words",
	"Breadspawn" : "Breadspawn needs some more words",
	"Oven"       : "The Blazing Inferno needs some more words"
}

# Ability descriptions
const ability_text_color_code := "[color=#505050]"
const ABILITY_DESCRIPTION = {
	"Trashcan"   : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)"],               # Monster Cards
	"Pizza"      : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)",
					"Ability: " + ability_text_color_code + "Inflict 3 damage to one enemy (2 turns CD)"],
	"Quesadilla" : ["Attack: " + ability_text_color_code + "Restore health equal to the attack power for one ally (regular)"],
	"Cheesecake" : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)"],
	"Sandwich"   : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)",
					"Ability: " + ability_text_color_code + "Self restore 1 health (1 turn CD)"],
	"Taco"       : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)"],
	"Salad"      : ["Attack: " + ability_text_color_code + "Restore health equal to the attack power for one ally (regular)",
					"Ability: " + ability_text_color_code + "Restore 1 health for all allies (2 turns CD)"],
	"Sushi"      : ["Attack: " + ability_text_color_code + "Restore health equal to the attack power for one ally (regular)"],
	"Donut"      : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)"],
	"Eclair"     : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)"],
	"Tutorial"   : ["BRRRRRRRRRRR: " + ability_text_color_code + "No effect (regular)"],                                                      # Bosses
	"Vacuum"     : ["Power Cord Whip: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)",
					"Power Surge Shield: " + ability_text_color_code + "Self restore 3 health (regular)",
					"Last Supper: " + ability_text_color_code + "Deal 10 damage to one enemy (3 turns CD)"],
	"Toaster"    : ["Breadspawn: " + ability_text_color_code + "Summons up to 2 undead toasts onto the field (4 turns CD)",
					"Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)",
					"Ritual of the Unbread: " + ability_text_color_code + "Devours one of the bread summons in exchange for health (3 turns CD)"],
	"Breadspawn" : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)"],
	"Oven"       : ["Attack: " + ability_text_color_code + "Inflict damage equal to the attack power to one enemy (regular)",
					"Multi Attack: " + ability_text_color_code + "Perform attack 3 times with monsters as prioirty",
					"Overheat: " + ability_text_color_code + "Gain high attack and health, but self damage 200 health every turn (passive)"]
}
