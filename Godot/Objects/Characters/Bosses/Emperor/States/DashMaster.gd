extends StateEnemy


func enter(_msg=[]):
	var distance = get_raw_distance_to_target()
	
	await get_tree().create_timer(0.5)
	
	if distance.x < 0 :
		fsm.enter_state("DashRight")
	else:
		fsm.enter_state("DashLeft")
