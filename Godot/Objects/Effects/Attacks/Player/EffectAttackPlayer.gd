class_name EffectAttackPlayer
extends EffectAttack


func set_damage(set_hitbox, params={}):
	set_hitbox.set_damage(params["body"].get_attack_damage(damage), damage_type, force_damage)
