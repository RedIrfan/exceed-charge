extends Interactable
class_name ExitArea


func _on_interact(_body):
	Global.root_scene().exit_stage()
