extends Character

const STAND = preload('res://Objects/Characters/Dummy/Stand.tscn')


func _ready():
	await Signal(Global.root_scene(), 'ready')
	
	var object = STAND.instantiate()
	Global.root_scene().add_child(object)
	
	object.global_transform.origin = self.global_transform.origin


func set_health(health:float):
	pass	
