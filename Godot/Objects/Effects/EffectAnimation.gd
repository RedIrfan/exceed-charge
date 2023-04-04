class_name EffectAnimation
extends Effect

@export var animation_name : String = ""
@export var animation_player : AnimationPlayer

var target
var bonus_position : Vector3


func on_spawn(params={}):
	target = params['target']
	bonus_position = params['bonus_position']
	
	animation_player.play(animation_name)
	
	await animation_player.animation_finished
	
	_destroy()


func _physics_process(delta):
	if target:
		global_position = target.global_position + bonus_position


func _on_kill_timeout():
	pass
