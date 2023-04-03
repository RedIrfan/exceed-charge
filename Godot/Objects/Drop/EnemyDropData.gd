extends DropData
class_name EnemyDropData

const ENEMIES : Dictionary = {
	"Fool" : preload("res://Objects/Characters/Enemies/Fool/Fool.tscn"),
	"FoolEye" : preload("res://Objects/Characters/Enemies/FoolEye/FoolEye.tscn"),
	"Magician" : preload("res://Objects/Characters/Enemies/Magician/Magician.tscn"),
	"HighPriestess" : preload('res://Objects/Characters/Enemies/HighPriestess/HighPriestess.tscn'),
}


func get_drops_scene():
	return ENEMIES
