extends StateCharacter
class_name StatePlayer


func get_direction() -> Vector2:
	var dir = Vector2.ZERO
	
	dir.x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	dir.y = int(Input.is_action_pressed("move_forward")) - int(Input.is_action_pressed("move_backward"))
	
	return dir


func get_direction_relative_to_body(direction:Vector2=Vector2.ZERO) -> Vector2:
	if direction == Vector2.ZERO:
		direction = get_direction()
	var relative_dir = Vector2(0,0)
	var rotated_dir = direction.rotated(body.rotation.y)
	
	if rotated_dir.x > 0.6 or rotated_dir.x < -0.6:
		if rotated_dir.x > 0:
			relative_dir.x = 1 # Right
		elif rotated_dir.x < 0:
			relative_dir.x = -1 #left
	elif rotated_dir.y < 0:
		relative_dir.y = 1 #forward
	elif rotated_dir.y > 0:
		relative_dir.y = -1 #backward
	
	return relative_dir


func apply_direction(direction:Vector2=Vector2.ZERO) -> void:
	if direction == Vector2.ZERO:
		direction = get_direction()
	body.direction = direction


func look_at_mouse(rotation_speed:float=0) -> void:
	var mouse3d_pos = Global.root_scene().camera.get_mouse_position3d()
	
	look_at(mouse3d_pos, rotation_speed)



func check_dash():
	return Input.is_action_just_pressed("action_dash")


func check_primary_attack():
	return Input.is_action_just_pressed("action_primary_attack")
