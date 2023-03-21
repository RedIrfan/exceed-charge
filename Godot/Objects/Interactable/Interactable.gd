extends Area3D
class_name Interactable

@export var pivot : Node3D


func spawn(spawn_global_position, parameters=[]):
	self.global_position = spawn_global_position
	
	_on_spawn(parameters)


func _on_spawn(_parameters=[]):
	pass


func interact(body):
	_on_interact(body)


func _on_interact(_body):
	_destroy()


func _destroy():
	queue_free()
