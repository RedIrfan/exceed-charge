extends Area3D
class_name ExitArea


func _ready():
	connect("body_entered", _on_body_entered)


func _on_body_entered(body):
	pass
#	if body.is_in_group("Player"):
#		Global.root_scene().exit_stage()
