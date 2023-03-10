extends StateCharacter


func enter(_msg=[]):
	body.play_animation("Idle")


func process(_delta):
	if check_hurt():
		fsm.enter_state('Hurt')
