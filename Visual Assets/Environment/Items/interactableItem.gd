extends Area2D

@export var itemIndexRequired = -1
@export var itemIndex = 0
@export var NPCStatus = false
@export var locationA = Vector2(0,0)
@export var locationB = Vector2(0,0)
@export var deathLocation = Vector2(0,0)
@export var walkCycleTimer = 0.0
@export var idleTimer = 0.0
@export var deathWalkTimer = 0.0
@export var dayOneDialogue = ""
@export var dayTwoDialogue = ""
@export var dayThreeDialogue = ""
@export var dayFourDialogue = ""
@export var dayFiveDialogue = ""

@onready var anim
var elapsedTime = 0.0
var cycleProgress = 0.0
var movingToB = true
var canMove = true
var isIdle = false
@export var canBeKilled = false
var House
var currentLocation = Vector2(0,0)

signal playerInteractable(sender)

func _ready() -> void:
	if(NPCStatus):
		anim = $AnimationPlayer
		House = get_node("../../../../House/HouseExterior")

func interact():
	emit_signal("playerInteractable", self)
	
	if (NPCStatus):
		canMove = false
		anim.play("Idle")
		# Later just pause elapsed time so they can resume movement if just talking
		elapsedTime = 0
		cycleProgress = 0
		
		currentLocation = get_parent().position
		canBeKilled = true

func _process(delta):
	if not NPCStatus:
		return

	if(canMove && !canBeKilled):
		if(!isIdle):
			elapsedTime += delta
			cycleProgress = elapsedTime / walkCycleTimer
			
			if movingToB:
				anim.play("Walk Left")
				get_parent().position = locationA.lerp(locationB, cycleProgress)
			else:
				anim.play("Walk Right")
				get_parent().position = locationB.lerp(locationA, cycleProgress)
		else:
			elapsedTime += delta
			cycleProgress = elapsedTime / idleTimer
			anim.play("Idle")

		if cycleProgress >= 1.0:
			if(!isIdle):
				isIdle = true
				movingToB = !movingToB
			else:
				isIdle = false
			
			elapsedTime = 0.0
			cycleProgress = 0.0
	
	if(canBeKilled):
		elapsedTime += delta
		cycleProgress = elapsedTime / deathWalkTimer
		
		if(deathLocation.x < locationA.x):
			anim.play("Walk Left")
			get_parent().position = currentLocation.lerp(deathLocation, cycleProgress)
		else:
			anim.play("Walk Right")
			get_parent().position = currentLocation.lerp(deathLocation, cycleProgress)
			
		if(get_parent().position.x == deathLocation.x && House.is_visible_in_tree()):
			get_parent().hide()
		else:
			get_parent().show()
