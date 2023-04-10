extends Resource
class_name CallableData

@export var node : Node
@export var method_name : String


func get_callable() -> Callable:
	return Callable(node, method_name)
