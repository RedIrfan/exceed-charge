extends StatePlayer


func enter(_msg=[]):
	body.play_animation("Idle")


func process(_delta):
	look_at_mouse()
	
	if get_direction() != Vector2.ZERO:
		fsm.enter_state("Walk")
