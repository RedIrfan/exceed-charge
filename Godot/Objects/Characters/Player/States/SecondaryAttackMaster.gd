extends StatePlayer


func enter(msg=[]):
	var slash : bool = true
	if msg.size() > 0:
		if body.get_total_passive_card(CardData.SUITS.DIAMOND, CardData.VALUES.FOUR) and msg[0] == "Forward":
			fsm.enter_state("GuardCrush")
			slash = false
	
	if slash:
		fsm.enter_state("SlashHeavy")


func exit():
	body.player_attack()
	
	look_at_mouse(1)
	body.lock_to_target()
