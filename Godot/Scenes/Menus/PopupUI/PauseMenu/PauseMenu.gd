extends PopupUI

@onready var resume_button : Button = $Panel/Inside/VSplitContainer/MarginContainer/Buttons/ResumeButton
@onready var option_button : Button = $Panel/Inside/VSplitContainer/MarginContainer/Buttons/OptionButton
@onready var main_menu_button : Button = $Panel/Inside/VSplitContainer/MarginContainer/Buttons/MainMenuButton

@onready var option_menu : PopupUI = $OptionMenu
@onready var confirmation_menu : ConfirmationMenu = $ConfirmationMenu


func enter():
	Global.pause(true)
	
	super.enter()
	
	resume_button.grab_focus()
	
	await animation_player.animation_finished
	resume_button.grab_focus()


func exit():
	super.exit()
	
	await animation_player.animation_finished
	Global.pause(false)


func _on_resume_button_pressed():
	exit()


func _on_option_button_pressed():
	option_menu.enter()
	
	await option_menu.exited
	option_button.grab_focus()


func _on_main_menu_button_pressed():
	await confirmation_menu.set_question("Exit to Main Menu?").answered
	
	if confirmation_menu.answer == ConfirmationMenu.ANSWERS.CONFIRMED:
		Global.stage_master().exit_main_menu()
	
	main_menu_button.grab_focus()
