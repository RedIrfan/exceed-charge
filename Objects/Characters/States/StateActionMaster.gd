extends StateCharacter

@export var next_state : State
var actions : Array = []
var action_index : int


func _ready():
	for child in get_children():
		if child is ActionData:
			actions.append(child)


func enter(_msg=[]):
	body.connect_to_animation_timer(_on_animation_timeout)
	action_index = 0
	play_action()


func exit():
	body.disconnect_from_animation_timer(_on_animation_timeout)


func _on_animation_timeout():
	action_index += 1
	if action_index < actions.size():
		play_action()
	else:
		fsm.enter_state(next_state.name)


func play_action():
	var action : ActionData = actions[action_index]
	
	if action.animation_name != "":
		body.play_animation(action.animation_name)
	body.start_animation_timer(action.animation_duration)
	
	if action.hitbox != null:
		action.hitbox.set_damage(action.damage, action.damage_type)
	
	if action.direction != Vector2.ZERO:
		var body_form = body.global_transform.basis
		var dir = Vector3.ZERO
		dir += body_form.x * action.direction.x
		dir += -body_form.z * action.direction.y
		body.direction = Vector2(dir.x, dir.z)
	else:
		reset_direction()
		
	if action.speed > 0:
		body.speed = action.speed
