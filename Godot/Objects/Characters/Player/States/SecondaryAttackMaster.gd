extends StatePlayer


func enter(msg=[]):
	var slash : bool = true
	if msg.size() > 0 and msg[0] == "Forward":
		if body.get_total_passive_card(CardData.SUITS.DIAMOND, CardData.VALUES.ACE) or body.get_exceed_charge_suit() == CardData.SUITS.DIAMOND:
			if body.get_exceed_charge_suit() != CardData.SUITS.DIAMOND:
				body.remove_passive_cards(CardData.SUITS.DIAMOND, CardData.VALUES.ACE, 1)
			fsm.enter_state("GuardCrush")
			slash = false
	
	if slash:
		fsm.enter_state("SlashHeavy")


func exit():
	body.player_attack()
	
	look_at_mouse(1)
	body.lock_to_target()
