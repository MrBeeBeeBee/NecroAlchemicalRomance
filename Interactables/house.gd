extends Node2D

var left_wall_collision
var right_wall_collision
var last_interacted_node
var sibling_node
var downstairs_door_location
var upstairs_door_location
var ready_to_teleport
var overworld

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HouseExterior/FrontDoor.connect("playerInteractable", UseDoor)
	$HouseInterior/UpstairsDoor.connect("playerInteractable", UseDoor)
	$HouseInterior/DownstairsDoor.connect("playerInteractable", UseDoor)
	
	left_wall_collision = $"Left Wall/CollisionShape2D"
	right_wall_collision = $"Right Wall/CollisionShape2D"
	
	overworld = get_parent()
	sibling_node = overworld.get_node("Player")
	
	downstairs_door_location = $HouseInterior/DownstairsDoor.global_position
	
	upstairs_door_location = $HouseInterior/UpstairsDoor.global_position
	ready_to_teleport = false

func UseDoor(sender):
	if(sender.name == "FrontDoor"):
		if($HouseExterior.is_visible_in_tree()):
			$HouseExterior.hide()
			$HouseInterior/DownstairsDoor.set_deferred("monitoring", true)
			$HouseInterior/DownstairsDoor.set_deferred("monitorable", true)
			$HouseInterior/UpstairsDoor.set_deferred("monitoring", true)
			$HouseInterior/UpstairsDoor.set_deferred("monitorable", true)
			left_wall_collision.disabled = false
			right_wall_collision.disabled = false
			ready_to_teleport = true
		else:
			$HouseExterior.show()
			$HouseInterior/DownstairsDoor.set_deferred("monitoring", false)
			$HouseInterior/DownstairsDoor.set_deferred("monitorable", false)
			$HouseInterior/UpstairsDoor.set_deferred("monitoring", false)
			$HouseInterior/UpstairsDoor.set_deferred("monitorable", false)
			left_wall_collision.disabled = true
			right_wall_collision.disabled = true
			ready_to_teleport = false
	
	if(ready_to_teleport):
		if(sender.name == "DownstairsDoor"):
			sibling_node.global_position = upstairs_door_location
		
		if(sender.name == "UpstairsDoor"):
			sibling_node.global_position = downstairs_door_location
		
	print(sender.name)
