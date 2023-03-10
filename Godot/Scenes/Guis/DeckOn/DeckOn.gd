extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hand_ik : Marker3D = $SubViewportContainer/SubViewport/Alpha/HandIK
@onready var skeleton_ik : SkeletonIK3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/SkeletonIK3D
@onready var camera3d : Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var mouse_raycast : RayCast3D = $SubViewportContainer/SubViewport/Camera3D/MouseRaycast


func _ready():
	$SubViewportContainer/SubViewport/Alpha/AnimationPlayer.play("ActivatingCard")


func enter():
	animation_player.play("Show")
	skeleton_ik.start()
	
	await Signal(animation_player, "animation_finished")
	super.enter()


func exit():
	animation_player.play_backwards("Show")
	skeleton_ik.stop()
	
	await Signal(animation_player, "animation_finished")
	super.exit()


func physics_process(_delta):
	if Input.is_action_just_pressed("action_deck"):
		gm.enter_gui("Hud")
	
	mouse_raycast.target_position = camera3d.project_local_ray_normal(get_viewport().get_mouse_position()) * 10
	
	if mouse_raycast.get_collider():
		hand_ik.global_transform.origin = mouse_raycast.get_collision_point()
