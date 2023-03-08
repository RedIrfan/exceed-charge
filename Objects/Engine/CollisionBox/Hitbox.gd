extends CollisionBox
class_name Hitbox

var _damage : int = 0
var _damage_type : int = 0

var hitlist : Array[Hurtbox] = []


func _ready():
	set_collision_layer_value(9, true)
	set_collision_mask_value(10, true)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func set_damage(damage, damage_type:Global.DAMAGES):
	_damage = damage
	_damage_type = damage_type


func _on_area_entered(area):
	if area is Hurtbox:
		if area.body != body:
			hitlist.append(area)


func _on_area_exited(area):
	if area is Hurtbox:
		if area in hitlist:
			hitlist.erase(area)


func process_attack():
	for hurtbox in hitlist:
		hurtbox.set_hurtdata(body, self.global_transform.origin, _damage, _damage_type)
		hitlist.erase(hurtbox)
