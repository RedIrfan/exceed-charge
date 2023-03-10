extends Node3D
class_name StageMaster

var camera : GameCamera : get = get_camera
var player : Character : get = get_player


func _ready():
	pass


func get_camera() -> GameCamera:
	return get_tree().get_first_node_in_group("GameCamera")


func get_player() -> Character:
	return get_tree().get_first_node_in_group("Player")
