extends Label

@export var bonus_position : Vector2 = Vector2(-20, -60)

@onready var hud = get_parent()

var interactable : Interactable
var camera : Camera3D


func _ready():
	await Global.root_scene().ready
	
	camera = Global.root_scene().camera.camera3d


func _process(delta):
	interactable = Global.root_scene().player.interact_area.get_interactable()
	if interactable:
		move_to_target_position(0.5)


func start():
	visible = true
	interactable = Global.root_scene().player.interact_area.get_interactable()
	move_to_target_position()


func move_to_target_position(weight:float=1):
	var target_position = camera.unproject_position(interactable.global_transform.origin)
	position = lerp(position, target_position + bonus_position, weight)
