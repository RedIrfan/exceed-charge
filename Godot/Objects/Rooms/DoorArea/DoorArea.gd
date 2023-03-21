extends Area3D
class_name DoorArea

@onready var room : Room = get_parent()
@onready var mesh : MeshInstance3D = $MeshInstance3D

@export var door_direction : Room.DIRECTIONS
@export var active : bool = false : set = set_active


func _ready():
	self.connect("body_entered", _on_body_entered)
	set_active(false)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().enter_neighbour(self.name)


func set_active(new_active:bool):
	active = new_active
	monitoring =  active 
	
	mesh.visible = ! active
	mesh.get_node("StaticBody3D").set_collision_layer_value(1, ! active)
	
	if active == false and is_connected("body_entered", _on_body_entered):
		disconnect("body_entered", _on_body_entered)
	elif is_connected("body_entered", _on_body_entered) == false:
		connect("body_entered", _on_body_entered)
