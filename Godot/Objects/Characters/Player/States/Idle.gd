extends StatePlayer


func enter(_msg=[]):
	body.play_animation("Idle")


func process(_delta):
	look_at_mouse()
	
	if get_direction() != Vector2.ZERO:
		fsm.enter_state("Walk")
	if is_deck_on() == false:
		if check_primary_attack():
			fsm.enter_state("AttackMaster")
