extends Node2D

var left_wall_collision
var right_wall_collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HouseExterior/FrontDoor.connect("playerInteractable", UseDoor)
	left_wall_collision = $"Left Wall/CollisionShape2D"
	right_wall_collision = $"Right Wall/CollisionShape2D"

func UseDoor():
	if($HouseExterior.is_visible_in_tree()):
		$HouseExterior.hide()
		left_wall_collision.disabled = false
		right_wall_collision.disabled = false
	else:
		$HouseExterior.show()
		left_wall_collision.disabled = true
		right_wall_collision.disabled = true
		
