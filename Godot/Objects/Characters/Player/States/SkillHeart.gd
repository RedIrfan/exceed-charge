extends StatePlayer


func enter(_msg=[]):
	body.play_animation("Idle")
	body.health += 3
	
	fsm.enter_state("Idle")
