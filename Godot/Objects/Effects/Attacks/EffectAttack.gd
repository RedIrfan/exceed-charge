class_name EffectAttack
extends Effect

@export var hitbox : Hitbox
@export var damage : int = 7
@export var damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT
@export var force_damage : bool = false
@export var damage_active_duration : float = 0.1

@export var var_extra_hitboxes : Array[NodePath]
@export var get_rotation_from_body : bool = false

var extra_hitboxes : Array[Hitbox]


func _ready():
	super._ready()
	for e_hitbox in var_extra_hitboxes:
		extra_hitboxes.append(get_node(e_hitbox))


func on_spawn(params={}):
	if get_rotation_from_body:
		self.global_rotation = params['body'].global_rotation
	
	hitbox.body = params["body"]
	set_damage(hitbox, params)	
	for e_hitbox in extra_hitboxes:
		e_hitbox.body = params['body']
		set_damage(e_hitbox, params)
	
	await get_tree().create_timer(damage_active_duration).timeout
	
	hitbox.set_damage(0)
	for extra_hitbox in extra_hitboxes:
		extra_hitbox.set_damage(0)


func set_damage(set_hitbox, _parameters={}):
	set_hitbox.set_damage(damage, damage_type, force_damage)
