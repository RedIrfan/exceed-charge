extends StatePlayer


func enter(msg=[]):
	var slash : bool = true
	if fsm.previous_state:
		if fsm.previous_state.name == "Dash" and msg.size() > 0:
			match msg[0]:
				"Forward":
					fsm.enter_state("Stab")
					slash = false
	
	if slash == true:
		fsm.enter_state("Slash")
