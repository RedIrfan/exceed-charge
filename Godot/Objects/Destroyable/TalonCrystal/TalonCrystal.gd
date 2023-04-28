extends Destroyable
class_name TalonCrystal

@export var drop_amount : int = 5
@export var drop_position_offset : Vector2 = Vector2(0, 1)
@export var drop_data : CardDropData


func process_dead():
	var rotation_angle = 360 / drop_amount
	for index in drop_amount:
		var add_position = drop_position_offset.rotated(deg_to_rad(rotation_angle * index))
		var drop_position = self.global_position + Vector3(add_position.x, 0, add_position.y)
		drop_data.drop(drop_position, hurt_data.attacker)
	
	super.process_dead()
