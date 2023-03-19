extends Destroyable
class_name TalonCrystal

@export var drop_data : DropData


func process_dead():
	drop_data.drop(self.global_position, hurt_data.attacker)
	_destroy()
