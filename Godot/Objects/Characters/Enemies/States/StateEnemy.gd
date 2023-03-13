extends StateCharacter
class_name StateEnemy


func apply_direction(direction:Vector2=Vector2.ZERO)->void:
	if direction == Vector2.ZERO:
		direction = body.get_context_direction()
	
	body.direction = direction


func get_distance_to_target() -> float:
	return body.global_transform.origin.distance_to(body.target.global_transform.origin)
