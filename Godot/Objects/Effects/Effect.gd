extends Node3D
class_name Effect

signal effect_ended

@onready var kill_timer : Timer = $KillTimer

@export var duration : float = 0.1


func _ready():
	kill_timer.connect("timeout", _on_kill_timeout)


func spawn(spawn_position, parameters={}):
	Global.root_scene().add_child(self)
	self.global_position = spawn_position
	
	if duration > 0:
		kill_timer.start(duration)
	
	on_spawn(parameters)


func on_spawn(_parameters={}):
	pass


func _on_kill_timeout():
	_destroy()


func _destroy():
	emit_signal("effect_ended")
	queue_free()
