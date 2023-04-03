extends StateEnemy

@export var hitbox : Hitbox
@export var damage : float = 4.0
@export var damage_type : Global.DAMAGES = Global.DAMAGES.LIGHT


func enter(_msg=[]):
	hitbox.set_damage(damage, damage_type)
	if hitbox.is_connected("hit", _on_hit) == false:
		hitbox.connect("hit", _on_hit)
	body.play_animation("Idle")


func exit():
	hitbox.set_damage(0)
	if hitbox.is_connected("hit", _on_hit):
		hitbox.disconnect("hit", _on_hit)


func physics_process(delta):
	look_at_target()
	
	apply_direction(direction_to_global(Vector2(0, 1)))


func process(delta):
	if check_hurt():
		fsm.enter_state("Hurt")


func _on_hit():
	fsm.enter_state("dead")
