extends Node3D
class_name Projectile

const EXPLODE_PARTICLES : PackedScene = preload("res://Objects/Effects/ExplodeParticles/ExplodeParticles.tscn")

@onready var kill_timer : Timer= $KillTimer
@onready var hitbox : Hitbox = $Hitbox

@export var max_distance: float = 15
@export var speed : float = 10
@export var damage : int = 5

@export var explode_mesh : Mesh
@export var explode_particles_scene : PackedScene

var kill_duration : float = 0


func _ready():
	kill_duration = max_distance/speed
	kill_timer.connect("timeout", _on_kill)
	
	hitbox.connect("hit", _on_hit)
	hitbox.connect("body_entered", _on_hit_body)


func _physics_process(delta):
	self.global_position += (-self.global_transform.basis.z * speed) * delta


func spawn(spawner, spawn_transform, exception_group="", parameters=[]):
	Global.add_child(self)
	
	hitbox.body = spawner
	hitbox.set_damage(damage)
	hitbox.exception_group = exception_group
	
	self.global_transform = spawn_transform
	kill_timer.start(kill_duration)
	
	_on_spawn(parameters)


func _on_spawn(_parameters=[]):
	pass


func _on_kill():
	_destroy()


func _on_hit():
	_destroy()


func _on_hit_body(body):
	if body != Character:
		_destroy()


func _destroy():
	var particles : Effect
	var effect_parameters
	if explode_particles_scene == null:
		particles = EXPLODE_PARTICLES.instantiate()
		effect_parameters = [self.global_rotation + Vector3(0, deg_to_rad(180), 0), explode_mesh]
	else:
		particles = explode_particles_scene.instantiate()
		effect_parameters = {}
	
	particles.spawn(self.global_position, effect_parameters)
	
	queue_free()
