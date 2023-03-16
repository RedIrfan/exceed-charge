extends StateActionMaster
class_name StateEnemyActionMaster

var look_at_target : bool = false


func process(delta):
	super.process(delta)
	
	if look_at_target:
		_look_at_target()


func play_action():
	super.play_action()
	
	if "look_at_target" in actions[action_index]:
		look_at_target = actions[action_index].look_at_target
	else:
		look_at_target = false


func _look_at_target(rotation_speed:float=0):
	if rotation_speed < 0:
		rotation_speed = body.rotation_speed
	
	look_at(body.target.global_transform.origin, rotation_speed)
