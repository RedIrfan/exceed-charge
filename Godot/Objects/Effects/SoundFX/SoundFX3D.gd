class_name SoundFx3D
extends Effect

@onready var audio_stream_player : AudioStreamPlayer3D = $AudioStreamPlayer3D


func on_spawn(params={}):
	audio_stream_player.set_stream(params['audio'])
	audio_stream_player.play()
	
	await audio_stream_player.finished
	
	_destroy()
