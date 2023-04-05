extends StatePlayer


func enter(_msg=[]):
	fsm.enter_state("SlashHeavy")


func exit():
	look_at_mouse(1)
	body.lock_to_target()
