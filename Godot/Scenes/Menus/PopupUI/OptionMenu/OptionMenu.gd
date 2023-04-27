extends PopupUI

@onready var exit_button : Button = $Panel/Inside/VSplitContainer/MarginContainer/Buttons/ExitButton


func enter():
	super.enter()
	
	exit_button.grab_focus()
	
	await animation_player.animation_finished
	exit_button.grab_focus()


func _on_save_button_pressed():
	exit()


func _on_exit_button_pressed():
	exit()
