extends Gui
class_name PopupUI

@onready var animation_player : AnimationPlayer = $AnimationPlayer


func enter():
	super.enter()
	
	animation_player.play("Open")


func exit():
	animation_player.play_backwards("Open")
	
	await animation_player.animation_finished
	
	super.exit()
