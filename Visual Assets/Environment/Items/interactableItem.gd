extends Area2D

@export var itemIndexRequired = -1
@export var itemIndex = 0
@export var NPCStatus = false
@export var locationA = Vector2(0,0)
@export var locationB = Vector2(0,0)
@export var walkCycleTimer = 0.0
@export var dayOneDialogue = ""
@export var dayTwoDialogue = ""
@export var dayThreeDialogue = ""
@export var dayFourDialogue = ""
@export var dayFiveDialogue = ""

signal playerInteractable(sender)

func _ready() -> void:
	if(NPCStatus):
		var tween = $Ryan.create_tween()
		tween.set_loops()  # Optional: loop the whole cycle
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)

		# Walk from A to B
		tween.tween_property($Ryan, "position", locationB, walkCycleTimer)
		tween.tween_interval(3.0)
		tween.tween_property($Ryan, "position", locationA, walkCycleTimer)
		tween.tween_interval(3.0)

func interact():
	emit_signal("playerInteractable", self)

#func _process():
	#if(NPC):
		
