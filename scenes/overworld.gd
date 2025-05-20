extends Node2D

var fade
var parallax
var dayZero
var dayOne
var dayTwo
var dayThree
var dayFour
var dayFive
var InteractableManager
var Player
var UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade = $FadeToBlack
	parallax = $ParallaxBackground/FadeToBlack
	
	Player = $Player
	UI = get_node("/root/Overworld/Recipe/NinePatchRect")
	UI.visible = false
	InteractableManager = $InteractableManager
	InteractableManager.connect("changeItems", Callable(self, "do_day_transition"))
	
	if(Player.canMove):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayZero.dialogue"),
			"introCutscene", [{"Player": Player}, {"IM": InteractableManager}])
	
	for child in InteractableManager.get_children():
		print(child.name)
		if(child.name == "DayZeroItems"):
			dayZero = child
		if(child.name == "DayOneItems"):
			dayOne = child
		if(child.name == "DayTwoItems"):
			dayTwo = child
		if(child.name == "DayThreeItems"):
			dayThree = child
		if(child.name == "DayFourItems"):
			dayFour = child
		if(child.name == "DayFiveItems"):
			dayFive = child
		if(child.name != "DayZeroItems"):
			InteractableManager.remove_child(child)

func do_day_transition():
	# Fade to black over 1 second
	var tween = create_tween()
	tween.tween_property(fade, "color", Color(0, 0, 0, 1), 1.0)
	await tween.finished
	
	var tweenBG = create_tween()
	tweenBG.tween_property(parallax, "color", Color(0, 0, 0, 1), 1.0)
	await tweenBG.finished

	match InteractableManager.dayCounter:
		1:
			InteractableManager.add_child(dayOne)
			dayOne.visible = true
			UI.visible = false
			UI.get_child(0).visible = true
			UI.visible = true
			dayZero.visible = false
			InteractableManager.remove_child(dayZero)
		2:
			InteractableManager.add_child(dayTwo)
			dayTwo.visible = true
			UI.get_child(0).visible = false
			UI.get_child(1).visible = true
			dayOne.visible = false
			InteractableManager.remove_child(dayOne)
		3:
			InteractableManager.add_child(dayThree)
			dayThree.visible = true
			UI.get_child(1).visible = false
			UI.get_child(2).visible = true
			dayTwo.visible = false
			InteractableManager.remove_child(dayTwo)
		4:
			InteractableManager.add_child(dayFour)
			dayFour.visible = true
			UI.get_child(2).visible = false
			UI.get_child(3).visible = true
			dayThree.visible = false
			InteractableManager.remove_child(dayThree)
		5:
			InteractableManager.add_child(dayFive)
			dayFive.visible = true
			UI.get_child(3).visible = false
			UI.get_child(4).visible = true
			dayFour.visible = false
			InteractableManager.remove_child(dayFour)
		6:
			UI.get_child(4).visible = false
			get_tree().change_scene_to_file("res://main.tscn")
			InteractableManager.dayCounter = 0

	# Fade back to normal (white) over 1 second
	var tweenBG2 = create_tween()
	tweenBG2.tween_property(parallax, "color", Color(1, 1, 1, 1), 1.0)
	await tweenBG2.finished
	
	var tween2 = create_tween()
	tween2.tween_property(fade, "color", Color(1, 1, 1, 1), 1.0)
	await tween2.finished
