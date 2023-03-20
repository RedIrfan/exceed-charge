extends Node3D
class_name Room

enum DIRECTIONS{
	UP,
	LEFT,
	RIGHT,
	DOWN
}

enum TYPES{
	STARTING,
	NORMAL,
	EXIT,
}

@export var room_type : TYPES = TYPES.NORMAL
@export var room_size : int = 6

var enemies : Dictionary = {}
var talon_crystals : Dictionary = {}

var enemies_amount : int = 0
var room_cleared : bool = false

var neighbour_left : Room = null
var neighbour_right : Room = null
var neighbour_up : Room = null
var neighbour_down : Room = null


func _ready():
	if room_type == TYPES.STARTING:
		room_cleared = true
	
	for child in get_children():
		if child is Enemy:
			enemies_amount += 1
			enemies[child.name] = [child, child.global_position]
			child.queue_free()
		if child is TalonCrystal:
			talon_crystals[child.name] = [child, child.global_position]
			child.queue_free()


func enter():
	if room_cleared == false:
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
		room_cleared = true
		
		for talon_crystal in talon_crystals:
			var data = talon_crystals[talon_crystal]
			
			var object = data[0].instantiate()
			object.global_position = data[1]
			
			Global.add_child(object)
