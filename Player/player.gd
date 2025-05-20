extends CharacterBody2D

var interactableObjects = []
const SPEED = 75.0
@onready var anim = get_node("AnimationPlayer")
@export() var hasDirtyLaundry = false
@export() var hasCleanLaundry = false
@export() var hasUnmarkedCalendar = false
@export() var hasBareFeet = false
var canMove = true
var dayZeroMarker = 4
var InteractableManager
#var checkOne
#var checkTwo
#var checkThree
#var checkFour
#var checkFive
#var checkSix
#var checkSeven
#var checkEight
#var checkNine
#var checkTen
#var checkEleven
#var checkTwelve
#var checkThirteen
#var checkFourteen
#var checkFifteen
var checks := []

func _ready():
	InteractableManager = get_node("/root/Overworld/InteractableManager")
	InteractableManager.connect("toggleCheck", ToggleCheckVisibility)
	
	var recipe_root = get_node("/root/Overworld/Recipe/NinePatchRect")
	for i in range(5):
		for j in range(3):
			var path = "Recipe%d/Line%d/Check" % [i + 1, j + 1]
			checks.append(recipe_root.get_node(path))
	#checkOne  = get_node("/root/Overworld/Player/Recipe/RecipeOne/LineOne/Check")
	#checkTwo  = get_node("/root/Overworld/Player/Recipe/RecipeTwo/LineTwo/Check")
	#checkThree  = get_node("/root/Overworld/Player/Recipe/RecipeThree/LineThree/Check")
	#checkFour  = get_node("/root/Overworld/Player/Recipe/RecipeFour/LineFour/Check")
	#checkFive  = get_node("/root/Overworld/Player/Recipe/RecipeFive/LineFive/Check")
	#checkSix  = get_node("/root/Overworld/Player/Recipe/RecipeSix/LineSix/Check")
	#checkSeven  = get_node("/root/Overworld/Player/Recipe/RecipeSeven/LineSeven/Check")
	#checkEight  = get_node("/root/Overworld/Player/Recipe/RecipeEight/LineEight/Check")
	#checkNine  = get_node("/root/Overworld/Player/Recipe/RecipeNine/LineNine/Check")
	#checkTen  = get_node("/root/Overworld/Player/Recipe/RecipeTen/LineTen/Check")
	#checkEleven  = get_node("/root/Overworld/Player/Recipe/RecipeEleven/LineEleven/Check")
	#checkTwelve  = get_node("/root/Overworld/Player/Recipe/RecipeTwelve/LineTwelve/Check")
	#checkThirteen  = get_node("/root/Overworld/Player/Recipe/RecipeThirteen/LineThirteen/Check")
	#checkFourteen  = get_node("/root/Overworld/Player/Recipe/RecipeFourteen/LineFourteen/Check")
	#checkFifteen  = get_node("/root/Overworld/Player/Recipe/RecipeFifteen/LineFifteen/Check")

func _physics_process(_delta: float) -> void:
	if(canMove):
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if velocity.x < 0:
				anim.play("Player Walk Left")
			elif velocity.x > 0:
				anim.play("Player Walk Right")
		else:
			anim.play("Player Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()

func _on_area_2d_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.has_method("interact"):
		interactableObjects.insert(0, area)
		$Alerted.show()
		print("Can Interact")
	else:
		print("Can't Interact")

func _process(_delta):
	if !interactableObjects.is_empty() && Input.is_action_just_pressed("interactButton"):
		print("Pressing interact button")
		interactableObjects[0].interact()

func _on_area_2d_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.has_method("interact"):
		if(interactableObjects.has(area)):
			interactableObjects.erase(area)
		if(interactableObjects.is_empty()):
			$Alerted.hide()
		print("Leaving object")

func ToggleCheckVisibility(sender):
	if(sender.itemIndex - 1 >= 0):
		if(sender.itemIndex == 18):
			sender.itemIndex = 18
		else:
			checks[sender.itemIndex-1].visible = true
			print(sender.itemIndex)
