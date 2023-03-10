extends Node3D
class_name GameCamera

@export var moving_speed: float = 0.2

@onready var camera3d : Camera3D = $Camera3D
@onready var mouse_raycast : RayCast3D = $Camera3D/MouseRaycast
@onready var ball : MeshInstance3D = $Camera3D/MeshInstance3D

var target : Character


func _ready():
	await Signal(Global.root_scene(), "ready")
	
	target = Global.root_scene().player


func _physics_process(_delta):
	mouse_raycast.target_position = camera3d.project_local_ray_normal(get_viewport().get_mouse_position()) * 50
	
	ball.global_transform.origin = get_mouse_position3d()
	if target:
		self.global_transform.origin = lerp(self.global_transform.origin, target.global_transform.origin, moving_speed)


func get_mouse_position3d():
	var pos = mouse_raycast.global_position + mouse_raycast.target_position
	if mouse_raycast.is_colliding():
		pos = mouse_raycast.get_collision_point()
	return pos
