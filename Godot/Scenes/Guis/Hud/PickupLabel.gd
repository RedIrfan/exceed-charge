extends Label

@export var bonus_position : Vector2 = Vector2(-20, -60)

@onready var hud = get_parent()

var pickupable : Pickupable
var camera : Camera3D


func _ready():
	await Global.root_scene().ready
	
	camera = Global.root_scene().camera.camera3d


func _process(delta):
	if pickupable:
		move_to_target_position(0.5)


func move_to_target_position(weight:float=1):
	var target_position = camera.unproject_position(pickupable.global_transform.origin)
	position = lerp(position, target_position + bonus_position, weight)
