extends StateCharacter
class_name StateCharacterDead

@export var animation_name : String
@export var delay_before_process: float = 0


func enter(msg=[]):
	if msg.size() > 0:
		if msg[0].damage_type == Global.DAMAGES.LIGHT:
			body.play_animation("HurtLightDead")
	reset_direction()
	reset_speed()
	
	if animation_name != "":
		body.play_animation(animation_name)
	
	if delay_before_process > 0:
		await get_tree().create_timer(delay_before_process).timeout
		body._on_dead()
	else:
		body._on_dead()
