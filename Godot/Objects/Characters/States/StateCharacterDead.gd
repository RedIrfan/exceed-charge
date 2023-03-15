extends StateCharacter

@export var animation_name : String


func enter(msg=[]):
	if msg.size() > 0:
		if msg[0].damage_type == Global.DAMAGES.LIGHT:
			body.play_animation("HurtLightDead")
	reset_direction()
	reset_speed()
	
	if animation_name != "":
		body.play_animation(animation_name)
	body._on_dead()
