extends State
class_name StateCharacter


func reset_speed():
	body.speed = body.SPEED


func reset_direction():
	body.direction = Vector2.ZERO


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
