extends Resource
class_name Hurtdata

var attacker : Node = null
var attack_position : Vector3 = Vector3.ZERO
var damage : int = 0
var damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT


func _init(_attacker : Node = null, _attack_position : Vector3 = Vector3.ZERO, _damage : int = 0, _damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT):
	attacker = _attacker
	attack_position = _attack_position
	damage = _damage
	damage_type = _damage_type
