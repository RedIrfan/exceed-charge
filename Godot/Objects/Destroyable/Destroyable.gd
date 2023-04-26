extends Node3D
class_name Destroyable

signal destroyed

const SOUND_HIT : AudioStreamWAV = preload('res://Assets/SFX/Game/Hit.wav')
const DAMAGE_LABEL = preload('res://Objects/Effects/DamageLabel/DamageLabel.tscn')
const HIT_PARTICLES = preload('res://Objects/Effects/HitParticles/HitParticles.tscn')

@onready var pivot : Node3D = $Pivot

@export var HEALTH : int = 50

@export_group("Shake Animation")
@export var max_shake : Vector2 = Vector2(0.3,0.3)
@export var shake_decay : float = 2

@export_group("Effects")
@export var hit_colour : Color = Color(1,1,1)
@export var hit_particle : Mesh = null
@export var destroyed_sound : AudioStreamWAV

var health : float = HEALTH
var shake_amount : float = 0.0

var hurt_data : Hurtdata


func _ready():
	health = HEALTH


func _process(delta):
	if shake_amount:
		shake(delta)


func shake(delta):
	shake_amount = max(shake_amount - shake_decay * delta, 0)
	
	var amount = pow(shake_amount, 1.5)
	pivot.position.x = max_shake.x * amount * randf_range(-1, 1)
	pivot.position.z = max_shake.y * amount * randf_range(-1, 1)


func set_hurtdata(hurtdata:Hurtdata):
	hurt_data = hurtdata
	process_damage()


func process_damage():
	health -= hurt_data.damage
	shake_amount = 1
	
	Global.play_sound(SOUND_HIT, self.global_position)
	if destroyed_sound and health <= 0:
		Global.play_sound(destroyed_sound, self.global_position)
	
	var particles = HIT_PARTICLES.instantiate()
	var new_rot = hurt_data.attacker.global_rotation
	var second_parameter = hit_colour
	if hit_particle != null:
		second_parameter = hit_particle
	particles.spawn(self.global_position, [Vector3(new_rot.x, new_rot.y + deg_to_rad(180), new_rot.z), second_parameter])
	
	var label = DAMAGE_LABEL.instantiate()
	label.spawn(self.global_position, [hurt_data.damage])
	
	Global.pause_duration(0.05, Global.PAUSES.CUTSCENE)
	
	if health <= 0:
		process_dead()


func process_dead():
	_destroy()


func _destroy():
	emit_signal("destroyed")
	queue_free()
