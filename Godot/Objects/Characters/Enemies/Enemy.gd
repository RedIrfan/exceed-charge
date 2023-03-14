extends Character
class_name Enemy

@onready var raycast_pivot : Node3D = $Pivot/ContextRaycasts

@export var context_raycast_size : int = 4
@export var attack_range : float = 2.0

var target : Character

var interest_array : Array[float] = []
var danger_array : Array[float] = []
var raycasts : Array[RayCast3D] = []


func _ready():
	interest_array.resize(context_raycast_size)
	danger_array.resize(context_raycast_size)
	var raycast_angle_rotation = 360 / context_raycast_size
	for i in context_raycast_size:
		var angle = i * raycast_angle_rotation
		var target_direction = Vector2(0, -1).rotated(deg_to_rad(angle))
		
		var new_raycast = RayCast3D.new()
		raycast_pivot.add_child(new_raycast)
		new_raycast.target_position = Vector3(target_direction.x, 0, target_direction.y)
		
		raycasts.append(new_raycast)
	
	await Global.root_scene().ready
	
	target = Global.root_scene().player


func set_interest(target_direction:Vector3=Vector3.FORWARD) -> void:
	for i in context_raycast_size:
		var dot_value = raycasts[i].target_position.dot(target_direction)
		interest_array[i] = max(0, dot_value)


func set_danger():
	for i in context_raycast_size:
		if raycasts[i].is_colliding():
			danger_array[i] = 1.0
		else:
			danger_array[i] = 0.0


func get_context_direction():
	set_danger()
	for i in context_raycast_size:
		if danger_array[i] > 0.0:
			interest_array[i] = 0.0
	
	direction = Vector2.ZERO
	for i in context_raycast_size:
		direction += raycasts[i].target_position * interest_array[i]
	direction = direction.normalized()