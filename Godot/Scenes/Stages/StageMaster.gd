extends Node3D
class_name StageMaster

@export var stage_name : String = ""
@export var max_floor : int = 4
@export var next_stage : PackedScene

@export_group("Room Generation")
@export var rooms : Array[PackedScene]
@export var max_room_amount : float = 5

var camera : GameCamera : get = get_camera
var player : Character : get = get_player

var current_floor : int = 0


func _ready():
	generate_stage()


func get_camera() -> GameCamera:
	return get_tree().get_first_node_in_group("GameCamera")


func get_player() -> Character:
	return get_tree().get_first_node_in_group("Player")


func generate_stage():
	var generated_rooms = [spawn_room(rooms[0], Vector3(0,0,0))]
	var possible_room_positions = get_possible_room_positions(generated_rooms)
	for i in max_room_amount:
		var rand_room_scene = rooms[randi_range(1, rooms.size() - 1)]
		var rand_location = select_possible_room_position(possible_room_positions)
		generated_rooms.append(spawn_room(rand_room_scene, rand_location[1], rand_location[0] ))
		possible_room_positions = get_possible_room_positions(generated_rooms)
	
	var rand_location = select_possible_room_position(possible_room_positions)
	spawn_room(rooms[1], rand_location[1], rand_location[0] )


func select_possible_room_position(possible_room_positions:Array):
	var rand_int = randi_range(0, possible_room_positions.size() - 1)
	var rand_pos = possible_room_positions[rand_int]
	possible_room_positions.remove_at(rand_int)
	
	return rand_pos


func get_possible_room_positions(generated_rooms:Array) -> Array:
	var empty_room_positions = []
	for room in generated_rooms:
		if room.neighbour_left == null:
			empty_room_positions.append( [Vector3.LEFT, room.global_position + (Vector3.LEFT * room.room_size) ])
		if room.neighbour_right == null:
			empty_room_positions.append( [Vector3.RIGHT, room.global_position + (Vector3.RIGHT * room.room_size) ])
		if room.neighbour_up == null:
			empty_room_positions.append( [Vector3.FORWARD, room.global_position + (Vector3.FORWARD * room.room_size) ])
		if room.neighbour_down == null:
			empty_room_positions.append( [Vector3.BACK, room.global_position + (Vector3.BACK * room.room_size) ])
	
	return empty_room_positions


func spawn_room(room:PackedScene, room_position:Vector3, local_pos:Vector3=Vector3.ZERO) -> Room:
	var object = room.instantiate()
	add_child(object)

	if local_pos != Vector3.ZERO:
		room_position += local_pos * object.room_size
	object.global_position = room_position
	
	return object
