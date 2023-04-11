extends Gui

const ACTIVATED_CARD = preload("res://Objects/Effects/ActivatedCard/ActivatedCard.tscn")
const SOUND_SCAN_CARD = preload('res://Assets/SFX/Deck/ScanCard.wav')
const SOUND_SCAN_CARD_FAILED = preload('res://Assets/SFX/Deck/ScanCard.wav')

@export var model : MeshInstance3D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var cards : Control = $Cards/BoxContainer

@onready var activating_area : Panel = $ActivatingArea
@onready var drop_area : Panel = $DropArea

@onready var hand_ik : Marker3D = $SubViewportContainer/SubViewport/DeckModel/HandIK
@onready var skeleton_ik : SkeletonIK3D = $SubViewportContainer/SubViewport/DeckModel/Armature/Skeleton3D/SkeletonIK3D
@onready var camera3d : Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var mouse_raycast : RayCast3D = $SubViewportContainer/SubViewport/Camera3D/MouseRaycast
@onready var card_mesh : Sprite3D = $SubViewportContainer/SubViewport/DeckModel/Armature/Skeleton3D/BoneAttachment3D/CardMesh
@onready var hand_animation : AnimationPlayer = $SubViewportContainer/SubViewport/DeckModel/AnimationPlayer

const CARD_BUTTON = preload("res://Scenes/Guis/Deck/CardButton/CardButton.tscn")

var card_buttons : Array = []
var held_card : int = -1
var holding : bool = false
var card_used : bool = false

var camera 


func _ready():
	self.visible = false
	hand_animation.play("Deck")
	$Cards.size = Vector2(1152, 578)
	
	await Signal(Global.root_scene(), "ready")
	player = Global.root_scene().player
	camera = Global.root_scene().camera
	
	var deck : DeckData = player.deck
	
	for index in range(0, deck.DECK_MAX_AMOUNT):
		var object = CARD_BUTTON.instantiate()
		object.card_index_in_deck = index
		object.connect("held", _on_card_held)
		
		cards.add_child(object)
		
		card_buttons.append(object)
	
	player.status.connect("element_changed", _on_element_changed)


func enter():
	super.enter()
	
	card_used = false
	player.deck_on = true
	release_card()
	
	scan_cards()
	
	animation_player.play("Show")
	skeleton_ik.start()
	
	for child in cards.get_children():
		child.selected_outline.visible = false


func exit():
	player.deck_on = false
	
	animation_player.play_backwards("Show")
	for child in cards.get_children():
		child.selected_outline.visible = false
	
	await Signal(animation_player, "animation_finished")
	skeleton_ik.stop()
	super.exit()


func physics_process(_delta):
	if Input.is_action_just_pressed("action_deck") or Input.is_action_pressed("action_deck") == false and card_used:
		gm.enter_gui("Hud")
	
	if Input.is_action_just_released("action_primary_attack"):
		if holding:
			release_card()
	
	mouse_raycast.target_position = camera3d.project_local_ray_normal(get_viewport().get_mouse_position()) * 10
	
	if mouse_raycast.get_collider():
		hand_ik.global_transform.origin = mouse_raycast.get_collision_point()


func scan_cards():
	for cbutton in card_buttons:
		if cbutton.card_index_in_deck < player.deck.deck_list.size():
			cbutton.visible = true
			var card_data : CardData = player.deck.deck_list[cbutton.card_index_in_deck]
			cbutton.texture_normal = card_data.card_image
		else:
			cbutton.visible = false


func use_card():
	if player.get_exceed_charge_suit() == CardData.SUITS.NONE:
		var card_data = player.deck.get_card(held_card)
		player.remove_card(held_card, false)
		
		var effect : Effect = ACTIVATED_CARD.instantiate()
		effect.spawn(camera.camera3d.global_position)
		
		var soundfx = SoundFx.new()
		soundfx.spawn(Vector3.ZERO, {"audio" : SOUND_SCAN_CARD})
		
		card_used = true
		if Input.is_action_pressed("action_deck") == true:
			scan_cards()
		
		await effect.effect_ended	
		player.use_card(0, card_data)
	else:
		var soundfx = SoundFx.new()
		soundfx.spawn(Vector3.ZERO, {"audio" : SOUND_SCAN_CARD_FAILED})


func drop_card():
	player.remove_card(held_card)
	gm.enter_gui("Hud")


func _on_card_held(cbutton):
	holding = true
	held_card = cbutton.card_index_in_deck
	hand_animation.play("DeckHolding")
	animation_player.play("HoldingCard")
	card_mesh.visible = true
	activating_area.hold()
	drop_area.hold()


func release_card():
	holding = false
	hand_animation.play("Deck")
	animation_player.play_backwards("HoldingCard")
	activating_area.release()
	drop_area.release()
	card_mesh.visible = false


func _on_element_changed(to_element):
	var elements_material = [player.BLACK_SUIT_MATERIAL, player.FIRE_SUIT_MATERIAL, null, player.WATER_SUIT_MATERIAL]
	
	model.set_surface_override_material(0, elements_material[to_element])
