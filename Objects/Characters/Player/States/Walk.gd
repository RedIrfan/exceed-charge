extends StatePlayer


func exit():
	reset_direction()


func physics_process(_delta):
	look_at_mouse()
	
	apply_direction()
	_play_walk_animation()
	
	if get_direction() == Vector2.ZERO:
		fsm.enter_state("Idle")
	if check_dash():
		fsm.enter_state("Dash")
	if check_primary_attack():
		fsm.enter_state("AttackMaster")


func _play_walk_animation() -> void:
	var animation_name = "Walk"
	
	match get_direction_relative_to_body():
		Vector2(1, 0):
			animation_name += "Right"
		Vector2(-1, 0):
			animation_name += "Left"
		Vector2(0, 1):
			animation_name += "Forward"
		Vector2(0,-1):
			animation_name += "Backward"
	
	if animation_name != "Walk":
		body.play_animation(animation_name)
