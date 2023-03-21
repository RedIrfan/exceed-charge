extends DropData
class_name EnemyDropData

const ENEMIES : Dictionary = {
	"Fool" : preload("res://Objects/Characters/Enemies/Fool/Fool.tscn"),
	"Magician" : preload("res://Objects/Characters/Enemies/Magician/Magician.tscn"),
	
}


func get_drops_scene():
	return ENEMIES


func get_drop_scene(item):
	return ENEMIES[item].instantiate()
