extends Area2D

@export var itemIndexRequired = -1
@export var itemIndex = 0
@export var NPCStatus = false
@export var dayZeroDialogue = ""
@export var dayOneDialogue = ""
@export var dayTwoDialogue = ""
@export var dayThreeDialogue = ""
@export var dayFourDialogue = ""
var parent
var conversationsHad = 0

@onready var anim
@export var locationA = Vector2(0,0)
@export var locationB = Vector2(0,0)
@export var walkCycleTimer = 0.0
@export var idleTimer = 0.0
var elapsedTime = 0.0
var tempElapTime = 0.0
var cycleProgress = 0.0
var tempCycProg = 0.0
var movingToB = true
var canMove = true
var isIdle = false

@export var canBeKilled = false
@export var deathLocation = Vector2(0,0)
@export var deathWalkTimer = 0.0
@export var disappearingCoordinates = Vector2(0,0)
var House
var Player
var InteractableManager
var currentLocation = Vector2(0,0)
var deathFlag = false

signal playerInteractable(sender)
signal npcKillable(sender)

func _ready() -> void:
	House = get_node("/root/Overworld/House/HouseExterior")
	Player = get_node("/root/Overworld/Player")
	InteractableManager = get_node("/root/Overworld/InteractableManager")
	parent = get_parent()
	
	if(NPCStatus):
		anim = $AnimationPlayer

func interact():
	if(!NPCStatus):
		emit_signal("playerInteractable", self)
	
	# Make sure the item is an NPC
	if (NPCStatus):
		# If in a neutral state, freeze the NPC and start dialogue
		if(!canBeKilled && conversationsHad == 0):
			canMove = false
			isIdle = true
			anim.play("Idle")
			# Later just pause elapsed time so they can resume movement if just talking
			match InteractableManager.dayCounter:
				0:
					if(Player.canMove):
						DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayZero.dialogue"),
					dayZeroDialogue, [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
				1:
					if(Player.canMove):
						DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayOne.dialogue"),
					dayOneDialogue, [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
				2:
					if(Player.canMove):
						DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayTwo.dialogue"),
					dayTwoDialogue, [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
				3:
					if(Player.canMove):
						DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayThree.dialogue"),
	 			dayThreeDialogue, [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
				4:
					if(Player.canMove):
						DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayFour.dialogue"),
					dayFourDialogue, [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
				
			conversationsHad += 1
		elif(conversationsHad >= 1):
			if(Player.canMove):
						DialogueManager.show_example_dialogue_balloon(load("res://dialogue/DayZero.dialogue"),
					"AlreadyTalked", [{"NPC": self}, {"Player": Player}, {"IM": InteractableManager}])
		
		# Once the "kill" dialogue option has been chosen, reset movement progress
		# and walk towards deathZone
		if(canBeKilled && !deathFlag):
			elapsedTime = 0
			cycleProgress = 0
			print("Unga Bunga")
			
			currentLocation = parent.position
			isIdle = false
		
		if (deathFlag):
			emit_signal("npcKillable", self)

func _process(delta):
	if(is_in_group("VisibleItem")):
		if(House.is_visible_in_tree() || InteractableManager.inventory[itemIndex]):
			parent.hide()
		else:
			parent.show()
	
	if(is_in_group("AccessibleItem")):
		if(House.is_visible_in_tree() || InteractableManager.inventory[itemIndex]):
			parent.hide()
			set_deferred("monitoring", false)
			set_deferred("monitorable", false)
		else:
			parent.show()
			set_deferred("monitoring", true)
			set_deferred("monitorable", true)
	
	if (!NPCStatus):
		return

	# If able to move, start the time tracking from point A to B and vice-versa
	if(canMove && !canBeKilled):
		if(!isIdle):
			elapsedTime += delta
			cycleProgress = elapsedTime / walkCycleTimer
			
			if movingToB:
				anim.play("Walk Left")
				parent.position = locationA.lerp(locationB, cycleProgress)
			else:
				anim.play("Walk Right")
				parent.position = locationB.lerp(locationA, cycleProgress)
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
	
	# State for NPC moving after "yes" kill decision
	if(canBeKilled && !isIdle):
		if cycleProgress >= 1.0:
			isIdle = true
			anim.play("Idle")
			print(deathLocation.x)
			print(parent.position.x)
			print(position.x)
		
		elapsedTime += delta
		cycleProgress = elapsedTime / deathWalkTimer
		
		if(deathLocation.x < locationA.x):
			anim.play("Walk Left")
			parent.position = currentLocation.lerp(deathLocation, cycleProgress)
		else:
			anim.play("Walk Right")
			parent.position = currentLocation.lerp(deathLocation, cycleProgress)
	
	if(NPCStatus && InteractableManager.dayCounter == 4):
		parent.hide()
		deathFlag = true
		canBeKilled = false
	
	if(parent.position.x <= disappearingCoordinates.x && House.is_visible_in_tree()):
		parent.hide()
		if(parent.name != "Agatha(LE)"):
			set_deferred("monitorable", false)
	else:
		set_deferred("monitorable", true)
		parent.show()

func _on_area_entered(area: Area2D) -> void:
	if NPCStatus && canBeKilled && area.is_in_group("KillZones"):
		deathFlag = true
		Player.canMove = true
		print("Walk again, child.")
