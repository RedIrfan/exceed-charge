extends StateCharacter
class_name StatePlayer


func get_direction() -> Vector2:
	var dir = Vector2.ZERO
	
	dir.x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	dir.y = int(Input.is_action_pressed("move_forward")) - int(Input.is_action_pressed("move_backward"))
	
	return dir


func apply_direction(direction:Vector2=Vector2.ZERO) -> void:
	if direction == Vector2.ZERO:
		direction = get_direction()
	body.direction = direction


func look_at_mouse(rotation_speed:float=0) -> void:
	if is_deck_on() == false:
		var mouse3d_pos = Global.root_scene().camera.get_mouse_position3d()
		
		look_at(mouse3d_pos, rotation_speed)


func check_dash():
	return Input.is_action_just_pressed("action_dash")


func check_primary_attack():
	return Input.is_action_just_pressed("action_primary_attack")


func check_secondary_attack():
	return Input.is_action_just_pressed("action_secondary_attack")


func check_skill():
	if Input.is_action_pressed("action_skill"):
		var mode = 0
		if check_primary_attack():
			mode = 1
		elif check_secondary_attack():
			mode = 2
		
		if mode > 0:
			fsm.enter_state("SkillMaster", [mode])


func check_interact():
	if body.interact_area.interact_list.size() > 0:
		if Input.is_action_just_pressed("action_pickup"):
			body.interact_area.interact()


func is_deck_on() -> bool:
	return body.deck_on
