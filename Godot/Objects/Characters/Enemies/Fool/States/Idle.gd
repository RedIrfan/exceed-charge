extends StateEnemy


func enter(_msg=[]):
	body.play_animation("Idle")


func process(_delta):
	var distance_to_target = get_distance_to_target()
	if distance_to_target > body.pursue_range:
		fsm.enter_state("Pursue")
	
	if check_hurt():
		fsm.enter_state("Hurt")
