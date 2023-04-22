extends StatePlayer

const SOUND_HEAL : AudioStreamWAV = preload('res://Assets/SFX/Game/Player/Heal.wav')


func enter(_msg=[]):
	Global.play_sound(SOUND_HEAL, body.global_position)
	
	body.play_animation("Idle")
	body.health += 3
	
	fsm.enter_state("Idle")
