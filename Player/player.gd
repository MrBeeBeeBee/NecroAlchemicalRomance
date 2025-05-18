extends CharacterBody2D

var interactableObject
const SPEED = 75.0
@onready var anim = get_node("AnimationPlayer")
@export() var hasDirtyLaundry = false
@export() var hasCleanLaundry = false
@export() var hasUnmarkedCalendar = false
@export() var hasBareFeet = false

func _physics_process(_delta: float) -> void:

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

#func _on_body_entered(body):
	#if body.has_method("interact"):
		#interactableObject = body
		#print("Can Interact")
	#else:
		#print("Can't Interact")
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("interact"):
		interactableObject = area
		$Alerted.show()
		print("Can Interact")
	else:
		print("Can't Interact")

func _process(_delta):
	if interactableObject && Input.is_action_just_pressed("interactButton"):
		print("Pressing interact button")
		interactableObject.interact()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.has_method("interact"):
		$Alerted.hide()
		print("Leaving object")
		interactableObject = null
