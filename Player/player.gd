extends CharacterBody2D

var interactableObjects = []
const SPEED = 75.0
@onready var anim = get_node("AnimationPlayer")
@export() var hasDirtyLaundry = false
@export() var hasCleanLaundry = false
@export() var hasUnmarkedCalendar = false
@export() var hasBareFeet = false
var canMove = true
var dayZeroMarker = 0
var InteractableManager
var checks := []

func _ready():
	InteractableManager = get_node("/root/Overworld/InteractableManager")
	InteractableManager.connect("toggleCheck", ToggleCheckVisibility)
	
	var recipe_root = get_node("/root/Overworld/Recipe/NinePatchRect")
	for i in range(5):
		for j in range(3):
			var path = "Recipe%d/Line%d/Check" % [i + 1, j + 1]
			checks.append(recipe_root.get_node(path))

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
