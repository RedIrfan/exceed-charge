extends StateEnemy


func enter(_msg=[]):
	body.play_animation("Idle")


func process(_delta):
	if get_distance_to_target() < body.attack_range:
		fsm.enter_state("Slash")
	if check_hurt():
		fsm.enter_state("Hurt")
