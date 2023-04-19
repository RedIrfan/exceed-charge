extends Node3D
class_name Projectile

const EXPLODE_PARTICLES : PackedScene = preload("res://Objects/Effects/ExplodeParticles/ExplodeParticles.tscn")

@onready var kill_timer : Timer= $KillTimer
@onready var pivot : Node3D = $Pivot
@onready var hitbox : Hitbox = $Pivot/Hitbox

@export var damage : int = 5
@export var damage_type : Global.DAMAGES
@export var force_damage : bool = false
@export var speed : float = 10

@export_group("Physics")
@export var gravity : bool = false
@export var max_distance: float = 15
@export var destroyed_if_hit : bool = true

@export_group("Effect")
@export var explode_mesh : Mesh
@export var explode_particles_scene : PackedScene
@export var explode_particles_parameters : Dictionary = {}

var vertical_velocity : float = 0
var kill_duration : float = 0
var spawn_position : Vector3
var set_velocity : bool = false
var time : float = 0


func _ready():
	kill_duration = max_distance/speed
	kill_timer.connect("timeout", _on_kill)
	
	hitbox.connect("hit", _on_hit)
	hitbox.connect("body_entered", _on_hit_body)


func _physics_process(delta):
	if gravity and set_velocity:
		time += delta
		vertical_velocity -= Global.GRAVITY * delta
		
		pivot.global_position.y += vertical_velocity * delta
#		pivot.look_at(pivot.global_position * 2)
		if pivot.global_position.y < 0:
			_destroy()

	self.global_position += (-self.global_transform.basis.z * speed) * delta


func spawn(spawner, spawn_transform, exception_group="", parameters=[]):
	Global.add_child(self)
	
	hitbox.body = spawner
	hitbox.exception_group = exception_group
	set_damage(spawner)
	
	self.global_transform = spawn_transform
	spawn_position = self.global_position
	kill_timer.start(kill_duration)
	
	if gravity:
		var vertical_duration = kill_duration
		vertical_velocity = (((vertical_duration/2) * Global.GRAVITY) - global_position.y) + (kill_duration - 1)
		
		set_velocity = true
	
	_on_spawn(parameters)


func set_damage(_spawner):
	hitbox.set_damage(damage, damage_type, force_damage)


func _on_spawn(_parameters=[]):
	pass


func _on_kill():
	if gravity == false:
		_destroy()


func _on_hit():
	if hitbox.body != self and destroyed_if_hit:
		_destroy()


func _on_hit_body(body):
	if body != Character and set_velocity and destroyed_if_hit:
		_destroy()


func get_effect_parameters() -> Dictionary:
	for param in explode_particles_parameters:
		if explode_particles_parameters[param] is String:
			match explode_particles_parameters[param]:
				"body":
					explode_particles_parameters[param] = hitbox.body
	
	return explode_particles_parameters


func _destroy():
	var particles : Effect
	var effect_parameters
	if explode_particles_scene == null:
		particles = EXPLODE_PARTICLES.instantiate()
		effect_parameters = [self.global_rotation + Vector3(0, deg_to_rad(180), 0), explode_mesh]
	else:
		particles = explode_particles_scene.instantiate()
		effect_parameters = get_effect_parameters()
	
	particles.spawn(self.global_position, effect_parameters)
	
	queue_free()
