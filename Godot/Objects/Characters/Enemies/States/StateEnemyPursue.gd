extends StateEnemy
class_name StateEnemyPursue


func enter(_msg=[]):
	pass


func process(_delta):
	if check_hurt():
		fsm.enter_state("Hurt")


func physics_process(_delta):
	var distance = get_distance_to_target()
	
	look_at_target()
	if distance > body.pursue_range: # move forward
		set_interest(-body.global_transform.basis.z)
	elif distance < body.flee_range: # move backward
		set_interest(body.global_transform.basis.z)
	else:
		set_interest(-body.global_transform.basis.x)
	
	apply_direction()
	
	if get_relative_direction_name() != "":
		body.play_animation("Walk"+get_relative_direction_name())
