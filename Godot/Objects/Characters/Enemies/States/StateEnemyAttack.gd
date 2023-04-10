extends StateEnemy
class_name StateEnemyAttack

@export var attack_state : State
@export var check_condition_state : State

@export_group("Movement")
@export var speed : int = 4

@export_group("Wait", "wait_")
@export var wait_duration : float = 0
@export var wait_animation : String = ""

var attack_timer : Timer
var attacking : bool = false


func _ready():
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.one_shot = true


func enter(_msg=[]):
	if check_condition_state:
		fsm.enter_state(check_condition_state.name)
	if attack_timer.is_connected("timeout", _on_attack_timeout) == false:
		attack_timer.connect("timeout", _on_attack_timeout)
	attacking = false
	body.speed = speed


func exit():
	if attack_timer.is_connected("timeout", _on_attack_timeout):
		attack_timer.disconnect("timeout", _on_attack_timeout)
	reset_speed()
	body.start_attack_timer()


func process(_delta):
	if check_hurt():
		fsm.enter_state("Hurt")


func physics_process(_delta):
	var distance = get_distance_to_target()
	look_at_target()
	if attacking == false:
		if distance > body.attack_range:
			body.play_animation("WalkForward")
			set_interest(-body.global_transform.basis.z)
			apply_direction()
		else:
			attacking = true
			if wait_duration > 0:
				if wait_animation:
					body.play_animation(wait_animation)
				attack_timer.start(wait_duration)
			else:
				fsm.enter_state(attack_state.name)


func _on_attack_timeout():
	fsm.enter_state(attack_state.name)
