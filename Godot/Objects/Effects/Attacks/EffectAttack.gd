class_name EffectAttack
extends Effect

@export var hitbox : Hitbox
@export var damage : int = 7
@export var damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT
@export var damage_active_duration : float = 0.1


func on_spawn(params={}):
	hitbox.body = params["body"]
	set_damage(params)
	
	await get_tree().create_timer(damage_active_duration).timeout
	
	hitbox.set_damage(0)


func set_damage(_parameters={}):
	hitbox.set_damage(damage, damage_type)
