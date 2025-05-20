extends Node2D

@export var inventory = [false, false, false, false, false, false, false, false, false
				, false, false, false, false, false, true, true, true, false, false]
var itemIndex
var itemIndexRequired
@export var dayCounter = 0
signal changeItems
signal toggleCheck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$DayOneItems/DirtyLaundry/Area2D.connect("playerInteractable", ClaimItem)
	$DayOneItems/CleanLaundry/Area2D.connect("playerInteractable", ClaimItem)
	$DayOneItems/UnmarkedCalendar/Area2D.connect("playerInteractable", ClaimItem)
	$DayOneItems/"Ryan(PoF)"/Area2D.connect("npcKillable", KillNPC)
	$DayTwoItems/FamilyPhoto/Area2D.connect("playerInteractable", ClaimItem)
	$DayTwoItems/TornUpFamilyPhoto/Area2D.connect("playerInteractable", ClaimItem)
	$DayTwoItems/PeasInAPod/Area2D.connect("playerInteractable", ClaimItem)
	$DayTwoItems/"Judith(HH)"/Area2D.connect("npcKillable", KillNPC)
	$DayThreeItems/WrittenPlan/Area2D.connect("playerInteractable", ClaimItem)
	$DayThreeItems/EssenceOfExcitement/Area2D.connect("playerInteractable", ClaimItem)
	$DayThreeItems/"Chris(AE)"/Area2D.connect("npcKillable", KillNPC)
	$DayFourItems/WellWornWeddingRing/Area2D.connect("playerInteractable", ClaimItem)
	$DayFourItems/TrueWordsOfACherishedMelody/Area2D.connect("playerInteractable", ClaimItem)
	$DayFourItems/"Agatha(LE)"/Area2D.connect("npcKillable", KillNPC)
	
# Checks if you have the required item. If you do, you get the new item. If not, you don't.
# Also turns the item invisible and disables its collision detection on both sides
func ClaimItem(sender):
	if(inventory[sender.itemIndexRequired] || sender.itemIndexRequired == -1):
		print("You have the item required, index ", sender.itemIndexRequired, 
			" giving you item index ", sender.itemIndex)
		
		if(sender.is_in_group("VisibleItem")):
			sender.get_parent().hide()
		inventory[sender.itemIndex] = true
		sender.set_deferred("monitoring", false)
		sender.get_node("CollisionShape2D").disabled = true
		emit_signal("toggleCheck", sender)
	else:
		print("You don't have the item required of index ", sender.itemIndexRequired)

# Called in the event the NPC is in the death zone. Gives you the item they need
# Assumes the check for their requisite items has already passed in the dialogue
func KillNPC(sender):
	
	print("You have the item required, index ", sender.itemIndexRequired, 
		" and have killed ", sender.name, " giving you item index ", sender.itemIndex)
	
	inventory[sender.itemIndex] = true
	
	sender.set_deferred("monitoring", false)
	sender.get_node("CollisionShape2D").disabled = true
	sender.anim.play("Dead")
	emit_signal("toggleCheck", sender)
	# Play player animation
