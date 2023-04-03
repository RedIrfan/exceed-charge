extends StateCharacter
class_name StateCharacterDead

@export var hurt_light_animation_name : String = "HurtLightDead"
@export var dead_animation_name : String = ""
@export var delay_before_process: float = 0


func enter(msg=[]):
	if msg.size() > 0:
		if msg[0].damage_type == Global.DAMAGES.LIGHT and hurt_light_animation_name != "":
			body.play_animation(hurt_light_animation_name)
	reset_direction()
	reset_speed()
	
	if dead_animation_name != "":
		body.play_animation(dead_animation_name)
	
	if delay_before_process > 0:
		await get_tree().create_timer(delay_before_process).timeout
		body._on_dead()
	else:
		body._on_dead()
