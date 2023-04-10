extends Node3D
class_name StageMaster

@export var stage_name : String = ""
@export var max_floor : int = 4
@export var next_stage : PackedScene

@export_group("Room Generation")
@export var rooms : Array[PackedScene]
@export var max_room_amount : float = 5
@export var generation_active: bool = true

var camera : GameCamera : get = get_camera
var player : Character : get = get_player

var current_floor : int = 0


func _ready():
	max_room_amount -= 2
	if generation_active:
		restart()


func _physics_process(_delta):
	if Input.is_action_just_pressed("debug_restart"):
		restart()
	if Input.is_action_just_pressed("debug_log"):
		get_tree().call_group("Room", "print_log")


func get_camera() -> GameCamera:
	return get_tree().get_first_node_in_group("GameCamera")


func get_player() -> Character:
	return get_tree().get_first_node_in_group("Player")


func restart():
	Global.pause(true)
	player.global_position = Vector3(0,0,0)
	
	await get_tree().create_timer(1).timeout
	
	get_tree().call_group("Interactable", "queue_free")
	get_tree().call_group("Enemy", "queue_free")
	get_tree().call_group("Room", "queue_free")
	
	generate_stage()
	
	get_tree().call_group("Enemy", "queuae_free")
	get_tree().call_group("Room", "restart")
	Global.pause(false)


func exit_stage():
	current_floor += 1
	restart()


func generate_stage():
	var generated_rooms = [spawn_room(rooms[0], Vector3(0,0,0))]
	var possible_room_positions = get_possible_room_positions(generated_rooms)
	for i in max_room_amount:
		var rand_room_scene = rooms[randi_range(2, rooms.size() - 1)]
		var rand_location = select_possible_room_position(possible_room_positions)
		generated_rooms.append(spawn_room(rand_room_scene, rand_location[1], rand_location[0] ))
		possible_room_positions = get_possible_room_positions(generated_rooms)
	
	var rand_location = select_possible_room_position(possible_room_positions)
	spawn_room(rooms[1], rand_location[1], rand_location[0])


func select_possible_room_position(possible_room_positions:Array):
	var rand_int = randi_range(0, possible_room_positions.size() - 1)
	var rand_pos = possible_room_positions[rand_int]
	possible_room_positions.remove_at(rand_int)
	
	return rand_pos


func get_possible_room_positions(generated_rooms:Array) -> Array:
	var empty_room_positions = []
	for room in generated_rooms:
		if room.neighbour_left == null:
			empty_room_positions.append( [room, Vector3.LEFT])
		if room.neighbour_right == null:
			empty_room_positions.append( [room, Vector3.RIGHT])
		if room.neighbour_up == null:
			empty_room_positions.append( [room ,Vector3.FORWARD])
		if room.neighbour_down == null:
			empty_room_positions.append( [room, Vector3.BACK])
	
	return empty_room_positions


func spawn_room(room:PackedScene, room_position:Vector3, adjacent_room:Room=null) -> Room:
	var object = room.instantiate()
	add_child(object)

	if adjacent_room:
		match room_position:
			Vector3.LEFT:
				object.neighbour_right = adjacent_room
				adjacent_room.neighbour_left = object
			Vector3.RIGHT:
				object.neighbour_left = adjacent_room
				adjacent_room.neighbour_right = object
			Vector3.FORWARD:
				object.neighbour_down = adjacent_room
				adjacent_room.neighbour_up = object
			Vector3.BACK:
				object.neighbour_up = adjacent_room
				adjacent_room.neighbour_down = object
		
		var object_local_pos = room_position * object.room_size
		
		room_position *= adjacent_room.room_size
		room_position += adjacent_room.global_position
		room_position += object_local_pos
	object.global_position = room_position
	return object
