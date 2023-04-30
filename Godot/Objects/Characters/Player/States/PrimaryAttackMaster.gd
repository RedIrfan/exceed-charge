extends StatePlayer


func enter(msg=[]):
	var slash : bool = true
	if fsm.previous_state:
		if fsm.previous_state.name == "Dash" and msg.size() > 0:
			body.remove_passive_cards(CardData.SUITS.ARROW, CardData.VALUES.ACE)
			match msg[0]:
				"Forward":
					fsm.enter_state("Stab")
					slash = false
	
	if slash == true:
		fsm.enter_state("Slash")


func exit():
	body.player_attack()
	
	look_at_mouse(1)
	body.lock_to_target()
