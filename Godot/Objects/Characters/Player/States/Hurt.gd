extends StateCharacterHurt


func enter_condition(_body, _fsm, params=[]):
	body = _body
	if body.get_total_passive_card(CardData.SUITS.PENTAGON, CardData.VALUES.THREE) > 0:
		hurt_data = body.hurt_data
		hurt_data.damage = hurt_data.damage * 0.5
		body.hurt_data = null
		_process_damage()
		
		body.remove_passive_cards(CardData.SUITS.PENTAGON, CardData.VALUES.THREE, 1)
	else:
		return super.enter_condition(_body, _fsm, params)
	
	return false
