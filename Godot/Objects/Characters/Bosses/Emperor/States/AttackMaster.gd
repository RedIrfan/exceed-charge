extends StateBoss

var grunts_spawned : bool = false


func enter_condition(_body,_fsm,_msg=[]):
	body = _body
	if check_phase() == 2 and grunts_spawned == false:
		return true
	return false


func enter(_msg={}):
	grunts_spawned = true
	fsm.enter_state("Summon")


func _on_grunts_dead():
	grunts_spawned = false
