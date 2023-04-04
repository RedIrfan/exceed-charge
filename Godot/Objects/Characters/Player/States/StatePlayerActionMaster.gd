extends StateActionMaster
class_name StatePlayerActionMaster

@export_category("Combo")
@export var primary_attack : State
@export var secondary_attack : State
@export var dash : State


func set_damage(action):
	var damage : float = 0.0
	if action.damage > 0:
		damage = body.get_attack_damage(action.damage)
	action.hitbox.set_damage(damage, action.damage_type)


func process(delta):
	super.process(delta)
	if can_combo:
		var to_state : State = null
		if Input.is_action_just_pressed("action_primary_attack"):
			to_state = primary_attack
		if Input.is_action_just_pressed("action_secondary_attack"):
			to_state = secondary_attack
		if Input.is_action_just_pressed("action_dash"):
			to_state = dash
		
		if to_state != null:
			look_at_mouse(1)
			fsm.enter_state(to_state.name)


func enter(msg=[]):
	super.enter(msg)
	body.lock_to_target()	
	
	var new_distance = distance / (body.SPEED + body.get_attack_speed_calculation())
	var new_whole_duration = whole_duration + new_distance
	for action in actions:
		action.duration = new_whole_duration / action.divided_to_whole_duration


func look_at_mouse(rotation_speed:float=0) -> void:
	var mouse3d_pos = Global.root_scene().camera.get_mouse_position3d()
	
	look_at(mouse3d_pos, rotation_speed)
