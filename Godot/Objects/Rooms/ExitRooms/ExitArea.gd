extends Interactable
class_name ExitArea


func _on_interact(body):
	Global.root_scene().exit_stage()
