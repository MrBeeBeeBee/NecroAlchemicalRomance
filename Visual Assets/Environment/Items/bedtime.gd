extends Area2D

var House
var Player
var InteractableManager

func _ready()-> void:
	House = get_node("/root/Overworld/House/HouseExterior")
	Player = get_node("/root/Overworld/Player")
	InteractableManager = get_node("/root/Overworld/InteractableManager")
# Called when the node enters the scene tree for the first time.
func interact():
	match InteractableManager.dayCounter:
		0:
			if(Player.canMove):
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayZero.dialogue"),
			"EndOfDayZeroCutscene", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
		1:
			if(Player.canMove):
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayOne.dialogue"),
			"EndOfDayOneCutscene", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
		2:
			if(Player.canMove):
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayTwo.dialogue"),
			"EndOfDayTwoCutscene", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
		3:
			if(Player.canMove):
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayThree.dialogue"),
			"EndOfDayThreeCutscene", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
		4:
			if(Player.canMove):
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayFour.dialogue"),
			"EndOfDayFourCutscene", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
		5:
			if(Player.canMove):
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayFive.dialogue"),
			"EndOfDayFiveCutscene", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
