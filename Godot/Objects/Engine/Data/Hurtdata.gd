extends Resource
class_name Hurtdata

var attacker : Node = null
var attack_position : Vector3 = Vector3.ZERO
var damage : float = 0
var damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT
var force_damage : bool = false


func _init(_attacker : Node = null, _attack_position : Vector3 = Vector3.ZERO, _damage : float = 0, _damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT, _force_damage:bool=false):
	attacker = _attacker
	attack_position = _attack_position
	damage = _damage
	damage_type = _damage_type
	force_damage = _force_damage
