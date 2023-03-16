extends Node3D
class_name Projectile

@onready var kill_timer : Timer= $KillTimer
@onready var hitbox : Hitbox = $Hitbox

@export var max_distance: float = 15
@export var speed : float = 10
@export var damage : int = 5

var kill_duration : float = 0


func _ready():
	kill_duration = max_distance/speed
	kill_timer.connect("timeout", _on_kill)
	
	hitbox.connect("hit", _on_hit)


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


func _destroy():
	queue_free()
