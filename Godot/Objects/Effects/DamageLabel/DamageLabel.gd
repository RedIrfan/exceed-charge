extends Effect
class_name DamageLabel

@onready var label3d : Label3D = $Label3D


func on_spawn(parameters=[]):
	label3d.set_text(parameters[0])
