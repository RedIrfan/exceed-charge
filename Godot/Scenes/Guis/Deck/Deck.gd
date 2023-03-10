extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var cards : Control = $Cards/BoxContainer

@onready var activating_area : Panel = $ActivatingArea
@onready var end_activating : Panel = $ActivatingArea/EndDirection

@onready var hand_ik : Marker3D = $SubViewportContainer/SubViewport/Alpha/HandIK
@onready var skeleton_ik : SkeletonIK3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/SkeletonIK3D
@onready var camera3d : Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var mouse_raycast : RayCast3D = $SubViewportContainer/SubViewport/Camera3D/MouseRaycast
@onready var card_mesh : Sprite3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/BoneAttachment3D/CardMesh

const CARD_BUTTON = preload("res://Scenes/Guis/Deck/CardButton/CardButton.tscn")

var activating : bool = false


func _ready():
	$SubViewportContainer/SubViewport/Alpha/AnimationPlayer.play("ActivatingCard")
	$Cards.size = Vector2(1152, 468)


func enter():
	super.enter()
	
	activating_area.connect("mouse_entered", _on_activate_area)
	activating_area.connect("mouse_exited", _leave_activate_area)
	
	end_activating.connect("mouse_exited", _on_activate)
	
	animation_player.play("Show")
	skeleton_ik.start()
	
	for child in cards.get_children():
		child.selected_outline.visible = false


func exit():
	activating_area.disconnect("mouse_entered", _on_activate_area)
	activating_area.disconnect("mouse_exited", _leave_activate_area)
	
	end_activating.disconnect("mouse_exited", _on_activate)
	
	animation_player.play_backwards("Show")
	skeleton_ik.stop()
	for child in cards.get_children():
		child.selected_outline.visible = false
	
	await Signal(animation_player, "animation_finished")
	super.exit()


func physics_process(_delta):
	if Input.is_action_just_pressed("action_deck"):
		gm.enter_gui("Hud")
	
	mouse_raycast.target_position = camera3d.project_local_ray_normal(get_viewport().get_mouse_position()) * 10
	
	if mouse_raycast.get_collider():
		hand_ik.global_transform.origin = mouse_raycast.get_collision_point()


func _use_card():
	gm.enter_gui("Hud")


func _on_activate_area():
	activating = true


func _leave_activate_area():
	activating = false


func _on_activate():
	if activating == false:
		_use_card()
