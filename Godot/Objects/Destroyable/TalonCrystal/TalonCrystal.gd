extends Destroyable
class_name TalonCrystal

@export var drop_data : CardDropData


func process_dead():
	drop_data.drop(self.global_position, hurt_data.attacker)
	super.process_dead()
