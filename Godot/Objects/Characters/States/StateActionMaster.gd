extends StateCharacter
class_name StateActionMaster

@export var exception_group : String = ""
@export var repeat_time : int = 0
@export var unstaggerable : bool = false
## The next state fsm will go to if all action ends except if comboing
@export var next_state : State

var actions : Array = []
var action_index : int
var repeat_index : int = 0

var can_combo : bool = false
var distance : float = 0
var whole_duration : float = 0


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
		if action.hitbox:
			action.hitbox.set_damage(0)
	reset_speed()
	body.disconnect_from_animation_timer(_on_animation_timeout)


func process(_delta):
	if check_hurt():
		var parameter = "unstaggerable" if unstaggerable else ""
		fsm.enter_state("Hurt", [parameter])


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
			fsm.enter_state(next_state.name)


func play_action():
	var action : ActionData = actions[action_index]
	
	if action.animation_name != "":
		body.play_animation(action.animation_name, 0, true)
	body.start_animation_timer(action.duration)
	
	if action.hitbox != null:
		set_damage(action)
	if action.projectile != null:
		var projectile = action.projectile.instantiate()
		projectile.spawn(body, action.projectile_spawn_position.global_transform, exception_group)
	
	can_combo = action.can_combo
	
	if action.direction != Vector2.ZERO:
		body.direction = direction_to_global(action.direction)
	else:
		reset_direction()
		
	if action.speed > 0:
		set_move_attack_speed(action.speed)
	else:
		set_move_attack_speed(body.SPEED)


func set_damage(action):
	action.hitbox.set_damage(action.damage, action.damage_type)
