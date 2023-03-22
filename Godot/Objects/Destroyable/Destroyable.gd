extends Node3D
class_name Destroyable

signal destroyed

const DAMAGE_LABEL = preload('res://Objects/Effects/DamageLabel/DamageLabel.tscn')

@onready var pivot : Node3D = $Pivot

@export var HEALTH : int = 50

@export_group("Shake Animation")
@export var max_shake : Vector2 = Vector2(0.3,0.3)
@export var shake_decay : float = 2

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
	
	Global.pause(true, Global.PAUSES.CUTSCENE)
	await get_tree().create_timer(0.05).timeout
	Global.pause(false)
	
	var label = DAMAGE_LABEL.instantiate()
	label.spawn(self.global_position, [hurt_data.damage])
	
	if health <= 0:
		process_dead()


func process_dead():
	_destroy()


func _destroy():
	emit_signal("destroyed")
	queue_free()
