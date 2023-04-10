extends StateEnemy
class_name StateEnemyPursue

@export var if_player_attacked_state : State

var horizontal_movement : int = 1
var right_raycast : int = 0
var left_raycast : int = 0


func _ready():
	await Global.root_scene().ready
	
	var half = get_parent().get_parent().context_raycast_size /2
	
	right_raycast = (half /2) - 1
	left_raycast = half + right_raycast


func enter(_msg=[]):
	if if_player_attacked_state != null:
		body.connect_to_player_attack(_on_player_attacked)
	body.connect('context_raycast_colliding', _on_raycast_colliding)
#	body.raycasts[(body.context_raycast_size/2)/2]


func exit():
	if if_player_attacked_state != null:
		body.disconnect_from_player_attack(_on_player_attacked)
	reset_direction()
	if body.is_connected('context_raycast_colliding', _on_raycast_colliding):
		body.disconnect('context_raycast_colliding', _on_raycast_colliding)


func process(_delta):
	if check_hurt():
		fsm.enter_state("Hurt")
	if check_attack():
		fsm.enter_state("Attack")


func physics_process(_delta):
	var distance = get_distance_to_target()
	
	look_at_target()
	if distance > body.pursue_range: # move forward
		set_interest(-body.global_transform.basis.z)
	elif distance < body.flee_range: # move backward
		set_interest(body.global_transform.basis.z)
	else:
		set_interest(body.global_transform.basis.x * horizontal_movement)
	
	apply_direction()
	
	if get_relative_direction_name() != "":
		body.play_animation("Walk"+get_relative_direction_name())


func _on_raycast_colliding(raycast_index):
	match raycast_index:
		left_raycast:
			horizontal_movement = 1
		right_raycast:
			horizontal_movement = -1


func _on_player_attacked():
	fsm.enter_state(if_player_attacked_state.name)
