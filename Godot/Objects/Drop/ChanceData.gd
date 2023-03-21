extends Resource
class_name ChanceData

@export var item : String
@export var chance : int = 10


func get_chance(receiver) -> float:
	return chance
