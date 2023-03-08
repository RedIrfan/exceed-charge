extends Area3D
class_name CollisionBox

@export var body : Node


func _ready():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
