@tool
extends Control

const CIRCLE_ANGLE : float = -90.0

@export var offset : int = 100 : set = set_var_offset
@export var rotation_offset : float = 0.0 : set = set_var_rotation_offset
@export var rotation_separation : float = 0 : set = set_rot_sep


func _ready():
	rotate_circle()


func rotate_circle():
	var interval_angle = (CIRCLE_ANGLE/get_child_count()) + rotation_separation 
	for i in get_child_count():
		var child = get_child(i)
		var child_angle = deg_to_rad( (interval_angle * (i + 1)) + rotation_offset )
		child.position = pivot_offset + (Vector2(0, offset).rotated(child_angle) - child.pivot_offset)
		child.rotation = child_angle


func set_var_offset(new_offset:int):
	offset = new_offset
	rotate_circle()


func set_var_rotation_offset(new_rot_offset:float):
	rotation_offset = new_rot_offset
	rotate_circle()


func set_rot_sep(new_rot_sep:float):
	rotation_separation = new_rot_sep
	rotate_circle()
