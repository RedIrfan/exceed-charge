extends Effect

@onready var particles1 : GPUParticles3D = $GPUParticles3D
@onready var particles2 : GPUParticles3D = $GPUParticles3D2
@onready var hitbox : Hitbox = $Hitbox

@export var damage : int = 7
@export var damage_active_duration : float = 0.1


func on_spawn(params={}):
	particles1.emitting = true
	particles2.emitting = true
	
	hitbox.body = params["body"]
	hitbox.set_damage(params["body"].get_attack_damage(damage), Global.DAMAGES.HEAVY)
	
	await get_tree().create_timer(damage_active_duration).timeout
	
	hitbox.set_damage(0)
