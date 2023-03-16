extends CollisionBox
class_name Hitbox

signal hit

@export var exception_group: String 
@export var attack_position : Node

var _damage : int = 0 # underscored for abstraction
var _damage_type : int = 0

var hitlist : Array[Hurtbox] = []


func _ready():
	set_collision_layer_value(9, true)
	set_collision_mask_value(10, true)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func set_damage(damage, damage_type:Global.DAMAGES=Global.DAMAGES.LIGHT):
	_damage = damage
	_damage_type = damage_type
	
	if _damage > 0:
		for hurtbox in hitlist:
			process_attack(hurtbox)


func _on_area_entered(area):
	if area is Hurtbox:
		if area.body != body:
			if ! area.body.is_in_group(exception_group):
				hitlist.append(area)
				if _damage > 0:
					process_attack(area)


func _on_area_exited(area):
	if area is Hurtbox:
		if area in hitlist:
			hitlist.erase(area)


func process_attack(hurtbox):
	var attack_pos = self.global_transform.origin
	if attack_position != null:
		attack_pos = attack_position.global_transform.origin
	
	hurtbox.set_hurtdata(body, attack_pos, _damage, _damage_type)
	
	emit_signal('hit')
