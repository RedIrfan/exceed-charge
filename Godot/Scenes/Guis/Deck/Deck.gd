extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var cards : Control = $Cards/BoxContainer

@onready var activating_area : Panel = $ActivatingArea
@onready var end_activating : Panel = $ActivatingArea/EndDirection
@onready var activating_timer : Timer = $ActivatingTimer

@onready var hand_ik : Marker3D = $SubViewportContainer/SubViewport/Alpha/HandIK
@onready var skeleton_ik : SkeletonIK3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/SkeletonIK3D
@onready var camera3d : Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var mouse_raycast : RayCast3D = $SubViewportContainer/SubViewport/Camera3D/MouseRaycast
@onready var card_mesh : Sprite3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/BoneAttachment3D/CardMesh

const CARD_BUTTON = preload("res://Scenes/Guis/Deck/CardButton/CardButton.tscn")

var activating : bool = false
var mouse_on_start_activate : bool = false
var mouse_on_start_before_end : bool = false
var mouse_on_end_activate : bool = false


func _ready():
	$SubViewportContainer/SubViewport/Alpha/AnimationPlayer.play("ActivatingCard")
	$Cards.size = Vector2(1152, 468)
	
	activating_timer.connect("timeout", _on_activating_timeout)


func enter():
	super.enter()
	
	activating = false
	mouse_on_start_activate = false
	mouse_on_start_before_end = false
	mouse_on_end_activate = false
	
	activating_area.connect("mouse_entered", _entered_activate_area)
	activating_area.connect("mouse_exited", _exited_activate_area)
	
	end_activating.connect("mouse_entered", _entered_end_activate)
	end_activating.connect("mouse_exited", _exited_end_activate)
	
	animation_player.play("Show")
	skeleton_ik.start()
	
	for child in cards.get_children():
		child.selected_outline.visible = false


func exit():
	activating_area.disconnect("mouse_entered", _entered_activate_area)
	activating_area.disconnect("mouse_exited", _exited_activate_area)
	
	end_activating.disconnect("mouse_entered", _entered_end_activate)
	end_activating.disconnect("mouse_exited", _exited_end_activate)
	
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


func _entered_activate_area():
	activating = false
	if mouse_on_end_activate == false:
		mouse_on_start_activate = true


func _exited_activate_area():
	await get_tree().create_timer(0.1).timeout
	
	mouse_on_start_activate = false


func _entered_end_activate():
	mouse_on_end_activate = true
	if mouse_on_start_activate:
		mouse_on_start_before_end = true


func _exited_end_activate():
	if mouse_on_start_before_end:
		activating = true
		activating_timer.start(0.1)
	
	await get_tree().create_timer(0.1).timeout
	mouse_on_end_activate = false


func _on_activating_timeout():
	if activating:
		_use_card()
