extends StateCharacter
class_name StateEnemy


func apply_direction(direction:Vector2=Vector2.ZERO)->void:
	if direction == Vector2.ZERO:
		body.get_context_direction()
	else:
		body.direction = direction


func set_interest(to_direction:Vector3):
	body.set_interest(to_direction)


func look_at_target(rotation_speed:float=0):
	if rotation_speed < 0:
		rotation_speed = body.rotation_speed
	
	look_at(body.target.global_transform.origin, rotation_speed)


func get_distance_to_target() -> float:
	return body.global_transform.origin.distance_to(body.target.global_transform.origin)


func check_attack() -> bool:
	return body.attack_timer.is_stopped()
