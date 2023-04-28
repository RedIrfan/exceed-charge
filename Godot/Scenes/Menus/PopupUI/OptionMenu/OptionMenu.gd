extends PopupUI

@onready var options_controller : Dictionary = {
	"sfx_volume" : $Panel/Inside/VSplitContainer/TabContainer/Audio/VBoxContainer/GridContainer/SfxVolumeSlider,
	"music_volume" : $Panel/Inside/VSplitContainer/TabContainer/Audio/VBoxContainer/GridContainer/MusicVolumeSlider,
}
@onready var exit_button : Button = $Panel/Inside/VSplitContainer/MarginContainer/Buttons/ExitButton


func enter():
	super.enter()
	
	exit_button.grab_focus()
	
	await animation_player.animation_finished
	exit_button.grab_focus()
	
	update_options()


func update_options(mode:int=0):
	for option_name in options_controller.keys():
		var option_controller = options_controller[option_name]
		var option_value = Global.game_data[option_name]
		
		if mode == 1:
			if option_controller is Slider:
				option_value = option_controller.value
			
			Global.call("set_"+option_name, option_value)
			if Global.current_pause == Global.PAUSES.FULL:
				Global.pause(true)
		elif mode == 2:
			option_value = Global.default_game_data[option_name]
			
		if option_controller is Slider:
			option_controller.set_value(option_value)


func _on_save_button_pressed():
	update_options(1)


func _on_default_button_pressed():
	update_options(2)


func _on_exit_button_pressed():
	exit()
