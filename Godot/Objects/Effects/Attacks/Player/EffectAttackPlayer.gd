class_name EffectAttackPlayer
extends EffectAttack


func set_damage(params={}):
	hitbox.set_damage(params["body"].get_attack_damage(damage), Global.DAMAGES.HEAVY)
