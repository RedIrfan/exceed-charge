class_name PlayerProjectile
extends Projectile


func _on_spawn(params={}):
#	pivot.rotation_degrees.z = params['rotation_z']
	pass


func set_damage(spawner):
	hitbox.set_damage(spawner.get_attack_damage(damage))
