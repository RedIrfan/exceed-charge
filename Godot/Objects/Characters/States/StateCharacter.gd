extends State
class_name StateCharacter


func set_move_speed(speed:float):
	body.set_move_speed(speed)


func set_move_attack_speed(speed:float):
	body.set_move_attack_speed(speed)


func reset_speed():
	set_move_speed(body.SPEED)


func reset_direction():
	body.direction = Vector2.ZERO


func direction_to_relative(direction:Vector2) -> Vector2:
	return direction.rotated(body.rotation.y)


func direction_to_global(direction:Vector2) -> Vector2:
	var body_form = body.global_transform.basis
	var dir = Vector3.ZERO
	dir += body_form.x * direction.x
	dir += -body_form.z * direction.y
	
	return Vector2(dir.x, dir.z)


func get_relative_direction_name(direction:Vector2=Vector2.ZERO) -> String:
	if direction == Vector2.ZERO:
		direction = body.direction
	var animation_name = ""
	var rotated_dir = direction.rotated(body.rotation.y)
	
	if rotated_dir.x > 0.6 or rotated_dir.x < -0.6:
		if rotated_dir.x > 0:
			animation_name = "Right"
		elif rotated_dir.x < 0:
			animation_name = "Left"
	elif rotated_dir.y < 0:
		animation_name = "Forward"
	elif rotated_dir.y > 0:
		animation_name = "Backward"
	
	return animation_name


func look_at(target, rotation_speed):
	if rotation_speed == 0:
		rotation_speed = body.rotation_speed

	var body_pos = body.global_transform.origin
	var opposite = body_pos.z - target.z
	var adjacent = body_pos.x - target.x
	var new_rotation = (atan2(opposite, adjacent) * -1) + 1.570796 #90 degrees

	body.rotation.y = lerp_angle(body.rotation.y, new_rotation, rotation_speed)


func check_hurt() -> bool:
	return body.hurt_data != null
