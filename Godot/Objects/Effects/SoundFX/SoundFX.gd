class_name SoundFx
extends Node2D

var audio_stream_player : AudioStreamPlayer


func spawn(_new_position, params={}):
	audio_stream_player = AudioStreamPlayer.new()
	Global.add_child(audio_stream_player)
	
	audio_stream_player.set_stream(params["audio"])
	audio_stream_player.play()
	audio_stream_player.set_bus("Sfx")
	audio_stream_player.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	await audio_stream_player.finished
	
	queue_free()
