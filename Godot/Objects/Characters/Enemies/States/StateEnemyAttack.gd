extends StateEnemy
class_name StateEnemyAttack

@export var speed : int = 4
@export var attack_state : State


func enter(_msg=[]):
	body.speed = speed


func exit():
	reset_speed()
	body.start_attack_timer()


func process(_delta):
	if check_hurt():
		fsm.enter_state("Hurt")


func physics_process(_delta):
	var distance = get_distance_to_target()
	look_at_target()
	if distance > body.attack_range:
		body.play_animation("WalkForward")
		set_interest(-body.global_transform.basis.z)
		apply_direction()
	else:
		fsm.enter_state(attack_state.name)
	
