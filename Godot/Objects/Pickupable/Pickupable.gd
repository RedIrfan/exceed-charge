extends Area3D
class_name Pickupable

@onready var pivot : Node3D = $Pivot


func spawn(spawn_global_position, parameters=[]):
	self.global_position = spawn_global_position
	
	_on_spawn(parameters)


func _on_spawn(_parameters=[]):
	pass


func pickup(body):
	_on_pickup(body)


func _on_pickup(_body):
	_destroy()


func _destroy():
	queue_free()
