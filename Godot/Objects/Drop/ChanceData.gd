extends Resource
class_name ChanceData

@export var item : String
@export var chance : int = 10


func get_chance(_receiver) -> int:
	return chance
