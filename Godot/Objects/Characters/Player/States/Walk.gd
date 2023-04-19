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
	if is_deck_on() == false:
		if check_skill() == false:
			if check_primary_attack():
				fsm.enter_state("PrimaryAttackMaster")
			if check_secondary_attack():
				fsm.enter_state("SecondaryAttackMaster", [get_relative_direction_name()])
	if check_hurt():
		if fsm.enter_state("Parry") == false:
			fsm.enter_state("Hurt")
	check_interact()


func _play_walk_animation() -> void:
	var animation_name = "Walk"
	
	animation_name += get_relative_direction_name()
	
	if animation_name != "Walk":
		body.play_animation(animation_name)
