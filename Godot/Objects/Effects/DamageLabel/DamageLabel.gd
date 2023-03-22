extends Effect
class_name DamageLabel

@onready var label3d : Label3D = $Label3D


func _physics_process(delta):
	self.global_position.y += 1 * delta


func on_spawn(parameters=[]):
	label3d.set_text(str(snappedf(parameters[0], 0.01)))


func _on_kill_timeout():
	var tween = get_tree().create_tween()
	
	tween.tween_property(label3d, "modulate:a", 0, 1)
	tween.parallel().tween_property(label3d, "outline_modulate:a", 0, 1)
	
	await tween.finished
	
	_destroy()
