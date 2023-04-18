extends StateCharacter
class_name StateActionMaster

@export var exception_group : String = ""
@export var repeat_time : int = 0
@export var unstaggerable : bool = false
## The next state fsm will go to if all action ends except if comboing
@export var next_state : State
@export var unique_hurt_state : State

var actions : Array = []
var action_index : int
var repeat_index : int = 0

var can_combo : bool = false
var distance : float = 0
var whole_duration : float = 0

var process_direction : Vector2


func _ready():
	for child in get_children():
		if child is ActionData:
			actions.append(child)
			whole_duration += child.duration
	
	for action in actions:
		action.divided_to_whole_duration = whole_duration/action.duration


func enter(_msg=[]):
	if distance == 0:
		distance = whole_duration/body.SPEED
	
	body.connect_to_animation_timer(_on_animation_timeout)
	repeat_index = 0
	action_index = 0
	play_action()


func exit():
	for action in actions:
		if action.physics_collision_mask_value > 0:
			if action.physics_collision_mask_value == 2:
				body.set_collision_mask_value(action.physics_collision_mask_value, true)
				body.set_collision_layer_value(action.physics_collision_mask_value, true)
		if action.hitbox:
			action.hitbox.set_damage(0)
	reset_speed()
	body.disconnect_from_animation_timer(_on_animation_timeout)


func physics_process(_delta):
	if process_direction:
		body.direction = direction_to_global(process_direction)


func process(_delta):
	if check_hurt():
		if unique_hurt_state == null:
			var parameter = "unstaggerable" if unstaggerable else ""
			fsm.enter_state("Hurt", [parameter])
		else:
			fsm.enter_state(unique_hurt_state.name)


func _on_animation_timeout():
	action_index += 1
	if action_index < actions.size():
		play_action()
	else:
		if repeat_index < repeat_time-1:
			repeat_index += 1
			action_index = 0
			play_action()
		else:
			if next_state:
				fsm.enter_state(next_state.name)


func play_action():
	var action : ActionData = actions[action_index].get_action_data(body)
	
	if action.animation_name != "":
		body.play_animation(action.animation_name, 0, true)
	body.start_animation_timer(action.duration)
	
	if action.hitbox != null:
		set_damage(action)
	if action.projectile_scene != null:
		var projectile = action.projectile_scene.instantiate()
		projectile.spawn(body, action.projectile_spawn_position.global_transform, exception_group)
	
	can_combo = action.can_combo
	
	if action.direction != Vector2.ZERO:
		if action.process_direction:
			process_direction = action.direction
		else:
			body.direction = direction_to_global(action.direction)
	else:
		process_direction = Vector2.ZERO
		reset_direction()
		
	if action.speed > 0:
		set_move_attack_speed(action.speed)
	else:
		set_move_attack_speed(body.SPEED)
	
	if action.effect_node != null:
		action.effect_node.emitting = true
	
	if action.effect_scene != null:
		var effect = action.effect_scene.instantiate()
		var effect_parameters = {}
		for parameter in action.effect_parameters:
			var effect_parameter = action.effect_parameters[parameter]
			if effect_parameter is String:
				match effect_parameter:
					"body":
						effect_parameters[parameter] = body
					"spawn_position":
						effect_parameters[parameter] = action.effect_spawn_position.position
			else:
				effect_parameters[parameter] = action.effect_parameters[parameter]
		
		effect.spawn(action.effect_spawn_position.global_position, effect_parameters)
		
		if action.external_signal_name:
			effect.connect(action.external_signal_name, Callable(action.connect_node, action.connect_method_name))
	
	if action.physics_collision_mask_value > 0:
		body.set_collision_mask_value(action.physics_collision_mask_value, action.physics_collision_mask_mode)
		body.set_collision_layer_value(action.physics_collision_mask_value, action.physics_collision_mask_mode)
	
	action.emit_signal("action_played")


func set_damage(action):
	action.hitbox.set_damage(action.damage, action.damage_type)
