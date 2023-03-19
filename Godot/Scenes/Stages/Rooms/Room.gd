extends Node3D
class_name Room

var enemies : Dictionary = {}
var talon_crystals : Dictionary = {}

var enemies_amount : int = 0


func _ready():
	for child in get_children():
		match child:
			Enemy:
				enemies_amount += 1
				enemies[child.name] = [child, child.global_position]
				child.queue_free()
			TalonCrystal:
				talon_crystals[child.name] = [child, child.global_position]
				child.queue_free()


func enter():
	for enemy in enemies:
		var data = enemies[enemy]
		
		var object = data[0].instantiate()
		object.global_position = data[1]
		object.connect('dead', _on_enemy_dead)
		
		Global.add_child(object)


func exit():
	pass


func _on_enemy_dead():
	enemies_amount -= 1
	if enemies_amount <= 0:
		for talon_crystal in talon_crystals:
			var data = talon_crystals[talon_crystal]
			
			var object = data[0].instantiate()
			object.global_position = data[1]
			
			Global.add_child(object)
