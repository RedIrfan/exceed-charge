extends CollisionBox
class_name Hurtbox


func _ready():
	set_collision_layer_value(10, true)
	set_collision_mask_value(9, true)


func set_hurtdata(attacker, attack_position, damage, damage_type):
	body.set_hurtdata(Hurtdata.new(attacker, attack_position, damage, damage_type))
