extends StateEnemy


func enter(_msg=[]):
	var distance = get_raw_distance_to_target().rotated(Vector3.UP, body.target.rotation.y)
	
	if distance.x < 0 :
		fsm.enter_state("DashRight")
	else:
		fsm.enter_state("DashLeft")
