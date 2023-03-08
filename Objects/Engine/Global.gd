extends Node

signal paused(mode)
signal sfx_volume_changed(new_volume)
signal music_volume_changed(new_volume)

var default_game_data = { #insert the save data here
	"sfx_volume" : 0,
	"music_volume" : 0,
}

var game_data = default_game_data

var temporary_data = {}

enum PAUSES {
	NONE,
	FULL, #as in going into the pause menu
	CUTSCENE
}
var current_pause = PAUSES.NONE
var current_sfx_volume : float = 0 : set = _set_current_sfx_volume
var current_music_volume : float = -2.1 : set = _set_current_music_volume
var current_mouse_sensitivity : float = 0.05

const DEAFEN_AMOUNT : float = 1.5 #for pausing purposes
const GRAVITY : float = 10.0
enum DAMAGES{
	LIGHT,
	HEAVY
}

func root_scene():
	return get_tree().get_root().get_child(1)


func pause(mode:bool, mode_pause:int=PAUSES.FULL):
	if mode == true: 
		current_pause = mode_pause
		if mode_pause == PAUSES.FULL: #if the pause mode is full, then the volume will be deafened
			current_music_volume -= DEAFEN_AMOUNT
			current_sfx_volume -= DEAFEN_AMOUNT
	else:
		current_music_volume = get_music_volume()
		current_sfx_volume = get_sfx_volume()
		
		current_pause = PAUSES.NONE
	get_tree().paused = mode
	emit_signal("paused", current_pause)


func _reset_temporary_data():
	temporary_data = {}


func _set_temporary_data(value_name : String, value):
	temporary_data[value_name] = value


func _set_current_sfx_volume(new_volume): #this method is only for the pause function
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), new_volume)


func _set_current_music_volume(new_volume): #this method is only for the pause function
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), new_volume)


func set_sfx_volume(new_volume):
	if current_pause != PAUSES.FULL:
		_set_current_sfx_volume(new_volume)
	
	game_data["sfx_volume"] = new_volume
	emit_signal("sfx_volume_changed", new_volume)


func set_music_volume(new_volume):
	if current_pause != PAUSES.FULL:
		_set_current_music_volume(new_volume)
	
	game_data["music_volume"] = new_volume
	emit_signal("music_volume_changed", new_volume)


func get_temporary_data(value_name : String):
	if temporary_data.has(value_name):
		return temporary_data[value_name]
	return null


func get_sfx_volume():
	return game_data["sfx_volume"]


func get_music_volume():
	return game_data["music_volume"]


func change_scene(scene_path:String, with_data:Dictionary={}):
	_reset_temporary_data() #erasing the temporary data as to not interfere with the next temporary data
	if with_data.size() > 0: #checking the with data for value
		for data in with_data:
			_set_temporary_data(data, with_data[data]) #inserting the with data into the temporary data
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_path)
