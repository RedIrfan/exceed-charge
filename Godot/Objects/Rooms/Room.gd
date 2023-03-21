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

@export_group("Door Area")
@export var door_left : DoorArea
@export var door_right : DoorArea
@export var door_up : DoorArea
@export var door_down : DoorArea

var enemies : Array[EnemySpawner] = []
var talon_crystals : Dictionary = {}

var enemies_amount : int = 0
var room_cleared : bool = false
var room_entered : bool = false

var neighbour_left : Room = null : set = set_neighbour_left
var neighbour_right : Room = null : set = set_neighbour_right
var neighbour_up : Room = null : set = set_neighbour_up
var neighbour_down : Room = null : set = set_neighbour_down


func _ready():
	if room_type == TYPES.STARTING or room_type == TYPES.EXIT:
		room_cleared = true
	else:
		visible = false
	
	for child in get_children():
		if child is EnemySpawner:
			enemies_amount += 1
			enemies.append(child)
		if child is TalonCrystal and room_cleared == false:
			talon_crystals[child.name] = [child.scene_file_path, child.global_position]
			child.queue_free()


func enter():
	visible = true 


func exit():
	pass


func _on_enemy_dead():
	enemies_amount -= 1
	if enemies_amount <= 0:
		var neighbours = [neighbour_left, neighbour_right, neighbour_up, neighbour_down]
		var doors = [door_left, door_right, door_up, door_down]
		
		for i in doors.size():
			doors[i].active = true if neighbours[i] != null else false
		
		room_cleared = true
		
		for talon_crystal in talon_crystals:
			var data = talon_crystals[talon_crystal]
			
			var object = load(data[0]).instantiate()
			Global.add_child(object)
			
			object.global_position = data[1] + self.global_position


func _on_spawn_area_body_entered(body):
	if body.is_in_group("Player"):
		spawn_enemy(body)


func spawn_enemy(player):
	if room_entered == false and room_cleared == false:
		var doors = [door_left, door_right, door_up, door_down]
		room_entered = true
		for door in doors:
			door.active = false
		
		for enemy in enemies:
			enemy.spawn(player)


func enter_neighbour(neighbour_name):
	var neighbours = {
		"Left" : neighbour_right,
		"Right" : neighbour_left,
		"Up" : neighbour_down,
		"Down" : neighbour_up
	}
	
	neighbours[neighbour_name].enter()


func set_neighbour_left(new_neighbour):
	neighbour_left = new_neighbour
	set_neighbour(0)


func set_neighbour_right(new_neighbour):
	neighbour_right = new_neighbour
	set_neighbour(1)


func set_neighbour_up(new_neighbour):
	neighbour_up = new_neighbour
	set_neighbour(2)


func set_neighbour_down(new_neighbour):
	neighbour_down = new_neighbour
	set_neighbour(3)


func set_neighbour(neighbour_index:int):
	var neighbours = [neighbour_left, neighbour_right, neighbour_up, neighbour_down]
	var doors = [door_left, door_right, door_up, door_down]
	if neighbours[neighbour_index]:
		doors[neighbour_index].active = true
	else:
		doors[neighbour_index].active = false
