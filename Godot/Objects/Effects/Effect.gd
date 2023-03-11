extends Node3D
class_name Effect

@onready var kill_timer : Timer = $KillTimer

@export var duration : float = 0.1


func _ready():
	kill_timer.connect("timeout", _on_kill_timeout)


func spawn(spawn_position, parameters={}):
	Global.root_scene().add_child(self)
	self.global_transform.origin = spawn_position
	
	if duration > 0:
		kill_timer.start(duration)
	
	_spawn_behaviour(parameters)


func _spawn_behaviour(_parameters={}):
	pass


func _on_kill_timeout():
	_destroy()


func _destroy():
	queue_free()
