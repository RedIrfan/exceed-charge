extends Area3D
class_name CollisionBox

@export var body : Node
@export var detect_collision_layer_1 : bool = false


func _ready():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, detect_collision_layer_1)
