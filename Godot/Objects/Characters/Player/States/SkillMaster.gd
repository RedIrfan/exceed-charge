extends StatePlayer

enum MODES{
	NONE,
	PRIMARY,
	SECONDARY
}


func enter_condition(new_body, _fsm, msg=[]):
	body = new_body
	var active_cards = [null, body.status.primary_active_card, body.status.secondary_active_card]
	
	if active_cards[msg[0]] != null:
		return true
	
	return false


func enter(msg=[]):
	var active_card : CardData
	if msg[0] == MODES.PRIMARY:
		active_card = body.status.primary_active_card
		
		match active_card.suit:
			CardData.SUITS.DIAMOND:
				fsm.enter_state("SkillGroundPound")