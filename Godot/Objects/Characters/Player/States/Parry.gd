extends StatePlayer

var hurt_data : Hurtdata


func enter_condition(_body, _fsm, _params=[]):
	body = _body
	hurt_data = body.hurt_data
	if body.get_total_passive_card(CardData.SUITS.PENTAGON, CardData.VALUES.FOUR) and get_direction() != Vector2.ZERO:
		var attacker_direction = (hurt_data.attack_position - body.global_position).normalized()
		var body_direction = body.direction * -1
		
		if body_direction.dot(Vector2(attacker_direction.x, attacker_direction.z)) > 0:
			return true
		
	return false


func enter(_msg=[]):
	body.connect_to_animation_timer(_on_animation_timeout)
	body.hurt_data = null
	body.remove_passive_cards(CardData.SUITS.PENTAGON, CardData.VALUES.FOUR)
	
	body.play_animation("Parry", 0.625)
	look_at(hurt_data.attack_position)
	
	Global.pause(true, Global.PAUSES.CUTSCENE)
	await get_tree().create_timer(0.2).timeout
	Global.pause(false)
	
	var attack_data = Hurtdata.new(body, body.global_position, 0, Global.DAMAGES.LIGHT)
	
	hurt_data.attacker.set_hurtdata(attack_data)


func exit():
	hurt_data = null
	body.disconnect_from_animation_timer(_on_animation_timeout)


func process(_delta):
	if check_primary_attack():
		fsm.enter_state("PrimaryAttackMaster")
	if check_secondary_attack():
		fsm.enter_state("SecondaryAttackMaster")
	if check_dash():
		fsm.enter_state("Dash")


func _on_animation_timeout():
	fsm.enter_state("Idle")
