extends EffectAttack

@onready var pivot : Node3D = $Pivot
@onready var animation : AnimationPlayer = $AnimationPlayer

var body


func on_spawn(params={}):
	body = params['body']
	animation.play("Play")
	
	super.on_spawn(params)


func _process(_delta):
	if body:
		pivot.global_position = body.global_position + Vector3(0, 0.5, 0)


func _on_hitbox_hit():
	body.health += 5
