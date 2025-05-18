extends Node2D

@export var inventory = [false, false, false, false, false, false, false, false, false
				, false, false, false, false, false, false, false, false]
var itemIndex
var itemIndexRequired
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DayOneItems/DirtyLaundry/Area2D.connect("playerInteractable", ClaimItem)
	$DayOneItems/CleanLaundry/Area2D.connect("playerInteractable", ClaimItem)
	$DayOneItems/UnmarkedCalendar/Area2D.connect("playerInteractable", ClaimItem)
	$DayOneItems/"Ryan(PoF)"/Area2D.connect("playerInteractable", ClaimItem)
	
func ClaimItem(sender):
	if(inventory[sender.itemIndexRequired] || sender.itemIndexRequired == -1):
		print("You have the item required, index ", sender.itemIndexRequired, 
			" giving you item index ", sender.itemIndex)
		inventory[sender.itemIndex] = true
		sender.set_deferred("monitoring", false)
		sender.get_node("CollisionShape2D").disabled = true
	else:
		print("You don't have the item required of index ", sender.itemIndexRequired)
