extends Character
class_name Enemy

signal context_raycast_colliding(raycast_index)

@onready var raycast_pivot : Node3D = $Pivot/ContextRaycasts
@onready var attack_timer : Timer = $AttackTimer

@export var drop_item : PackedScene 
@export var drop_items : Array[Array] = [[]]

@export_group("Behaviour")
@export var context_raycast_size : int = 8
@export var attack_interval : float = 6.0
@export var pursue_range : float = 3.0
@export var attack_range : float = 1.0
@export var flee_range : float = 2.0

var target : Character : get = get_target

var interest_array : Array[float] = []
var danger_array : Array[float] = []
var raycasts : Array[RayCast3D] = []

var dead_position : Vector3 = Vector3(0, -0.5, 0)
var dead_duration : float = 2.0

var first_start : bool = false


func _ready():
	super._ready()
	pursue_range += randf_range(0, 1)
	attack_range += randf_range(0, 1)
	flee_range += randf_range(0, 1)
	attack_interval += randf_range(0, 0.5)
	
	interest_array.resize(context_raycast_size)
	danger_array.resize(context_raycast_size)
	var raycast_angle_rotation = 360.0 / context_raycast_size
	for i in context_raycast_size:
		var angle = i * raycast_angle_rotation
		var target_direction = Vector2(0, -1).rotated(deg_to_rad(angle))
		
		var new_raycast = RayCast3D.new()
		raycast_pivot.add_child(new_raycast)
		new_raycast.target_position = Vector3(target_direction.x, 0, target_direction.y)
		
		raycasts.append(new_raycast)
	
	await Global.root_scene().ready
	
	get_target()


func get_target():
	if target == null:
		target = Global.root_scene().player
		
		start_attack_timer()
	return target


func connect_to_player_attack(method:Callable):
	if get_target().is_connected("player_attacked", method) == false:
		get_target().connect("player_attacked", method)


func disconnect_from_player_attack(method:Callable):
	if get_target().is_connected("player_attacked", method) == true:
		get_target().disconnect("player_attacked", method)


func start_attack_timer():
	var duration = attack_interval
	if first_start == false:
		first_start = true
		duration += randf_range(0, 1)
	attack_timer.start(duration)


func set_interest(target_direction:Vector3=Vector3.FORWARD) -> void:
	for i in context_raycast_size:
		var dot_value = raycasts[i].target_position.dot(target_direction)
		interest_array[i] = max(0, dot_value)


func set_danger():
	for i in context_raycast_size:
		if raycasts[i].is_colliding():
			danger_array[i] = 1.0
			emit_signal("context_raycast_colliding", i)
		else:
			danger_array[i] = 0.0


func get_context_direction():
	set_danger()
	for i in context_raycast_size:
		if danger_array[i] > 0.0:
			interest_array[i] = clamp(interest_array[i] - danger_array[i], 0, 1)
	
	direction = Vector2.ZERO
	for i in context_raycast_size:
		direction += Vector2(raycasts[i].target_position.x, raycasts[i].target_position.z) * interest_array[i]
		
	direction = direction.normalized()


func process_dead():
	if drop_item != null:
		var item = drop_item.instantiate()
		Global.add_child(item)
		
	self.set_collision_layer_value(2, false)
	self.set_collision_mask_value(2, false)
	
	var tween : Tween = create_tween()
	
	tween.tween_property(pivot, "position", dead_position, dead_duration)
	tween.tween_callback(queue_free)
