extends Area2D

@export var hasCondition = false
@export var interactCondition = false
@export var itemLost = ""
@export var itemGained = ""

signal playerInteractable(sender)

func interact():
	emit_signal("playerInteractable", self)
