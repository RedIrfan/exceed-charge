extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var cards : Control = $Cards/BoxContainer

@onready var activating_area : Panel = $ActivatingArea

@onready var hand_ik : Marker3D = $SubViewportContainer/SubViewport/Alpha/HandIK
@onready var skeleton_ik : SkeletonIK3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/SkeletonIK3D
@onready var camera3d : Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var mouse_raycast : RayCast3D = $SubViewportContainer/SubViewport/Camera3D/MouseRaycast
@onready var card_mesh : Sprite3D = $SubViewportContainer/SubViewport/Alpha/Armature/Skeleton3D/BoneAttachment3D/CardMesh

const CARD_BUTTON = preload("res://Scenes/Guis/Deck/CardButton/CardButton.tscn")

var card_buttons : Array = []
var holding_a_card : bool = false


func _ready():
	$SubViewportContainer/SubViewport/Alpha/AnimationPlayer.play("ActivatingCard")
	$Cards.size = Vector2(1152, 468)
	
	await Signal(Global.root_scene().player, "ready")
	var deck : DeckData = Global.root_scene().player.deck
	
	for index in range(0, deck.DECK_MAX_AMOUNT):
		var object = CARD_BUTTON.instantiate()
		object.card_index_in_deck = index
		object.connect("held", _on_card_held)
		
		cards.add_child(object)
		
		card_buttons.append(object)


func enter():
	super.enter()
	
	for cbutton in card_buttons:
		if cbutton.card_index_in_deck < player.deck.deck_list.size():
			cbutton.visible = true
			var card_data : CardData = player.deck.deck_list[cbutton.card_index_in_deck]
			cbutton.texture_normal = card_data.card_image
		else:
			cbutton.visible = false
	
	animation_player.play("Show")
	skeleton_ik.start()
	
	for child in cards.get_children():
		child.selected_outline.visible = false


func exit():
	animation_player.play_backwards("Show")
	skeleton_ik.stop()
	for child in cards.get_children():
		child.selected_outline.visible = false
	
	await Signal(animation_player, "animation_finished")
	super.exit()


func physics_process(_delta):
	if Input.is_action_just_pressed("action_deck"):
		gm.enter_gui("Hud")
	
	if Input.is_action_just_released("action_primary_attack"):
		activating_area.release()
		card_mesh.visible = false
	
	mouse_raycast.target_position = camera3d.project_local_ray_normal(get_viewport().get_mouse_position()) * 10
	
	if mouse_raycast.get_collider():
		hand_ik.global_transform.origin = mouse_raycast.get_collision_point()


func _use_card():
	gm.enter_gui("Hud")


func _on_card_held(cbutton):
	card_mesh.visible = true
	activating_area.hold()
