class_name EffectAnimation
extends Effect

@export var animation_name : String = ""
@export var animation_player : AnimationPlayer

@export_group("Target")
@export var follow_position : bool = false
@export var follow_rotation : bool = false

var target
var bonus_position : Vector3 = Vector3.ZERO


func on_spawn(params={}):
	if follow_position or follow_rotation:
		target = params['target']
		if params.has("bonus_position"):
			bonus_position = params['bonus_position']
	
	animation_player.play(animation_name)
	
	await animation_player.animation_finished
	
	_destroy()


func _physics_process(_delta):
	if target:
		if follow_position:
			global_position = target.global_position + bonus_position
		if follow_rotation:
			global_rotation = target.global_rotation


func _on_kill_timeout():
	pass
