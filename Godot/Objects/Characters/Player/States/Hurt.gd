extends StateCharacterHurt


func enter_condition(_body, _fsm, params=[]):
	body = _body
	if body.get_total_passive_card(CardData.SUITS.PENTAGON, CardData.VALUES.DEUCE) > 0 and body.hurt_data.force_damage == false:
		Global.play_sound(SOUND_DEFENDED, body.global_position)
		process_shield(body)
		
		body.hurt_data = null
		_process_damage()
	else:
		if body.get_total_passive_card(CardData.SUITS.PENTAGON, CardData.VALUES.DEUCE) > 0:
			process_shield(body)
		return super.enter_condition(_body, _fsm, params)
	
	return false


func process_shield(_body):
	hurt_data = _body.hurt_data
	hurt_data.damage = hurt_data.damage * 0.5
	body.remove_passive_cards(CardData.SUITS.PENTAGON, CardData.VALUES.DEUCE, 1)
